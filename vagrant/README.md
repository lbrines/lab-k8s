# README para Vagrantfile

Este archivo `Vagrantfile` es una configuración para crear una red privada de máquinas virtuales (VM) utilizando VirtualBox. Las máquinas virtuales se ejecutan en el sistema operativo host y están configuradas para ejecutar Kubernetes, un sistema de orquestación de contenedores.

## Requerimientos

Para utilizar este archivo `Vagrantfile`, se requieren los siguientes componentes:

- Vagrant
- VirtualBox

## Configuración

El archivo `Vagrantfile` define la cantidad de nodos maestros y nodos trabajadores. El número de nodos maestros y trabajadores se puede cambiar definiendo `NUM_MASTER_NODE` y `NUM_WORKER_NODE`, respectivamente.

Además, hay que tener en cuenta que si se cambia el número de nodos, es necesario actualizar el script `setup-hosts.sh` con los detalles de IP de los nuevos hosts en el archivo `/etc/hosts` de cada VM.

La dirección IP de la red privada está configurada como `192.168.56.`. Los nodos maestros comenzarán desde la dirección IP 10, mientras que los nodos trabajadores comenzarán desde la dirección IP 20.

El archivo `Vagrantfile` ejecuta los siguientes pasos de aprovisionamiento para cada nodo:

1. Configura los parámetros del kernel, los módulos y los ajustes.
2. Reinicia la VM.
3. Configura el archivo `/etc/hosts` y la resolución de DNS.

Para el primer nodo maestro (`master-1`), también se instalan las siguientes configuraciones opcionales:

- Configuraciones para `vim` y `tmux`.
- Archivos de configuración de Kubernetes.
- Script de instalación para el nodo maestro.

Para el primer nodo trabajador (`worker-1`), se instalan las siguientes configuraciones opcionales:

- Configuraciones para `vim` y `tmux`.
- Script de instalación para el nodo trabajador.

## Ejecución

Para ejecutar la configuración de Vagrant, simplemente ejecute el siguiente comando en el directorio donde se encuentra el archivo `Vagrantfile`:

```vagrant up```

Esto creará y configurará todas las máquinas virtuales especificadas en el archivo `Vagrantfile`.

Una vez que se han creado las VM, se puede acceder a ellas a través de ssh. Por ejemplo, para acceder al nodo maestro `master-1`, ejecute el siguiente comando:

```vagrant ssh master-1```


## Referencias

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)

