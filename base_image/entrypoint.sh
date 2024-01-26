#!/bin/bash
CONTAINER_USER=${HOST_USER:-vitis}
CONTAINER_UID=${HOST_UID:-1000}
CONTAINER_GROUP=${HOST_GROUP:-vitis}
CONTAINER_GID=${HOST_GID:-1000}
echo "Starting with USER: ${CONTAINER_USER}, UID: ${CONTAINER_UID}, GROUP: ${CONTAINER_GROUP}, GID: ${CONTAINER_GID}"

cleanup () {
	kill -s SIGTERM $PID_SUB
	kill -s SIGTERM $!
	if [ $PORT ];
	then
		echo $PORT >> /usr/local/etc/port_pool
	fi
	rm /home/${CONTAINER_USER}/.Xauthority /home/${CONTAINER_USER}/.bashrc /home/${CONTAINER_USER}/.profile /home/${CONTAINER_USER}/.bash_logout
	rm -rf /home/${CONTAINER_USER}/.jupyter
	rm -rf /data/.snapshot
	mv /home/${CONTAINER_USER} /data/.snapshot
	exit 0
}

trap cleanup SIGINT SIGTERM

if [ $PORT ]; then
	echo "c.NotebookApp.port=$PORT" >> /root/.jupyter/jupyter_notebook_config.py
 	echo "c.NotebookApp.port=$PORT" >> /etc/skel/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.port=$PORT" >> /root/.jupyter/jupyter_lab_config.py
 	echo "c.ServerApp.port=$PORT" >> /etc/skel/.jupyter/jupyter_lab_config.py
fi

getent passwd ${CONTAINER_USER} 2>&1 > /dev/null
USER_EXISTS=$?
getent passwd ${CONTAINER_UID} 2>&1 > /dev/null
UID_EXISTS=$?
getent group ${CONTAINER_GROUP} 2>&1 > /dev/null
GROUP_EXISTS=$?
getent group ${CONTAINER_GID} 2>&1 > /dev/null
GID_EXISTS=$?

if [[ ${GROUP_EXISTS} -ne 0 && ${GID_EXISTS} -ne 0 ]]; then
    groupadd \
        --gid ${CONTAINER_GID} \
        ${CONTAINER_GROUP}
fi

if [[ ${USER_EXISTS} -ne 0 && ${UID_EXISTS} -ne 0 ]]; then
    useradd \
        --uid ${CONTAINER_UID} \
        --gid ${CONTAINER_GID} \
        --create-home \
        --home-dir /home/${CONTAINER_USER} \
        --shell /bin/bash \
        ${CONTAINER_USER}
    usermod -aG sudo ${CONTAINER_USER}
    echo ${CONTAINER_USER}:${CONTAINER_USER} | chpasswd
fi

chown ${CONTAINER_USER} $(tty)

mv /data/.snapshot/* /home/${CONTAINER_USER}

/usr/sbin/gosu "${CONTAINER_USER}" jupyter lab 2>&1 &
PID_SUB=$!

/usr/sbin/gosu "${CONTAINER_USER}" "$@" &

wait $PID_SUB
wait $!

if [ $PORT ];
then
	echo $PORT >> /usr/local/etc/port_pool
fi

rm /home/${CONTAINER_USER}/.Xauthority /home/${CONTAINER_USER}/.bashrc /home/${CONTAINER_USER}/.profile /home/${CONTAINER_USER}/.bash_logout
rm -rf /home/${CONTAINER_USER}/.jupyter
rm -rf /data/.snapshot
mv /home/${CONTAINER_USER} /data/.snapshot
