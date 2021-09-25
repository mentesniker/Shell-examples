#!/bin/bash

#Funcion para manejar procesos. La funcion
#ejecuta las tareas relacionadas listar la tabla de procesos,
#listar la tabla de procesos de un usuario, matar a un proceso,
#y a contar el numero de procesos corriendo en el sistema
manejo_procesos(){
	while true
		do
			clear
			echo ""
			echo "BIENVENIDO AL MENU DE PROCESOS"
			echo ""
			echo "Ingrese el numero de la opcion que desee"
			echo "1.-Listar la tabla de procesos"
			echo "2.-Listar la tabla de procesos de un usuario"
			echo "3.-Matar a un proceso"
			echo "4.-Numero de procesos totales corriendo en el sistema"
			echo "5.-Regresar al menu principal"
			opcion=""
			read opcion
			if [ $opcion = 1 ]
				then
					usuario=$( id | cut -d " " -f1,2 )
					echo $usuario $( date ) $( date +%s ) "El usuario listo la tabla de procesos" >> bitacora.log
					ps -e | less
				fi
			if [ $opcion = 2 ]
					then
						echo ""
						echo "Por favor introduzca el nombre del usuario del que quiere saber sus procesos."
						echo ""
						usuario=""
						read usuario
						usuarioValido=$(cat /etc/passwd | grep -c $usuario)
						if [ $usuarioValido = 0 ]
							then
								echo "el usuario no esta registrado. Por favor introduzca un usuario valido."
								echo "Presione enter para continuar"
								read -p "" 
							else
								usuario_bitacora=$( id | cut -d " " -f1,2 )
								echo $usuario_bitacora $( date ) $( date +%s ) "El usuario listo la tabla de procesos de un usuario" >> bitacora.log
								echo ""
								ps -eu $usuario
								echo "Presione enter para continuar"
								read -p "" 
						fi
			fi
			if [ $opcion = 3 ]
					then
						echo ""
						echo "Por favor introduzca el PID del proceso que quiere matar."
						echo ""
						pid=""
						read pid
						pidValido=$(ps -e | grep -c $pid)
						if [ $pidValido = 0 ]
							then
								echo "El pid que ingreso no existe. Por favor introduzca uno valido."
								echo "Presione enter para continuar"
								read -p "" 
							else
								usuario=$( id | cut -d " " -f1,2 )
								echo $usuario $( date ) $( date +%s ) "El usuario mato a un proceso " >> bitacora.log
								echo ""
								kill -9 $pid
								echo "Proceso eliminado con exito. Presione enter para continuar"
								read -p "" 
						fi
			fi
			if [ $opcion = 4 ]
					then
						echo ""
						usuario=$( id | cut -d " " -f1,2 )
						echo $usuario $( date ) $( date +%s ) "El usuario conto los procesos corriendo en el sistema " >> bitacora.log
						numero=$( ps -e | wc -l )
						echo "Hay en el sistema " $(( $numero - 2 )) " procesos corriendo en este momento."
						echo ""
						echo "Presione enter para continuar"
						read -p "" 
			fi
			if [ $opcion = 5 ]
				then
					return
			fi
		done

} 2>> error.log

#Funcion que muestra la informacion del sistema.
#muestra el hostname, el sistema operativo y la arquitectura.
informacion_sistema() {
	clear
	info=$(uname -a)
	name=$(echo $info | cut -d " " -f2)
	so=$(echo $info | cut -d " " -f15)
	arq=$(echo $info | cut -d " " -f12)
	echo ""
	echo "INFORMACION DEL SISTEMA"
	echo ""
	echo "Hostname: " $name
	echo "Sistema Operativo: " $so
	echo "Arquitectura del sistema: " $arq
	echo ""
	usuario=$( id | cut -d " " -f1,2 )
	echo $usuario $( date ) $( date +%s ) "El usuario mostro la informacion del sistema " >> bitacora.log
	echo "Presione enter para regresar al menu principal"
	read -p "" 
} 2>> error.log

#Funcion para manejar archivos. 
#La funcion muestra la informacion de un archivo
#y da la oportunidad de borrar el archivo y de cambiar su modo.
manejo_archivos() {
	clear
	echo ""
	echo "Por favor introduzca el archivo que desea visualizar, incluyendo la ruta de este."
	echo ""
	archivo=""
	read archivo
	if [ ! -s $archivo ]
		then
			echo "El archivo que ingreso no existe. Por favor introduzca uno valido."
			echo "Presione enter para continuar"
			read -p "" 
			manejo_archivos
		else
			linea=""
			if [ -d $archivo ]
				then
					linea=$( ls -li $archivo | sed -n "2p" )
					echo $linea
					ruta=$archivo
					nombre=$archivo
				else
					linea=$( ls -li $archivo )
					ruta=$( dirname $archivo )
					nombre=$( basename $archivo )
			fi
			clear
			echo "MENU DEL ARCHIVO " $nombre
			echo ""
			inodo=$( echo $linea | cut -f1 -d " " )
			tipo=$( echo $linea | cut -f2 -d " " | cut -c 1 )
			ligas=$( echo $linea | cut -f3 -d " " )
			dueno=$( echo $linea | cut -f4 -d " " )
			grupo=$( echo $linea | cut -f5 -d " " )
			tamano=$( echo $linea | cut -f6 -d " " )
			ua=$( stat $archivo | sed -n '5p' | cut -d " " -f2 )
			mt=$( stat $archivo | sed -n '6p' | cut -d " " -f2 )
			mi=$( stat $archivo | sed -n '7p' | cut -d " " -f2 )
			pu=$( echo $linea | cut -d " " -f2 | cut -c 2-4 )
			pg=$( echo $linea | cut -d " " -f2 | cut -c 5-7 )
			po=$( echo $linea | cut -d " " -f2 | cut -c 8-10 )
			echo "Nombre del Archivo: " $nombre
			echo "Numero de i-nodo: " $inodo
			case $tipo in
			"-")
				echo "Tipo de archivo: ordinario" 
			;;
			"d")
				echo "Tipo de archivo: directorio" 
			;;
			"l")
				echo "Tipo de archivo: liga simbolica" 
			;;
			"b")
				echo "Tipo de archivo: bloque especial" 
			;;
			"n")
				echo "Tipo de archivo: red" 
			;;
			"s")
				echo "Tipo de archivo: socket" 
			;;
			"p")
				echo "Tipo de archivo: fifo" 
			;;
			esac
			echo "Numero de ligas duras: " $ligas
			echo "Dueno: " $dueno
			echo "Grupo: " $grupo
			echo "Tamano en bytes: " $tamano
			echo "Marcas de tiempo"
			echo "Fecha de ultimo acceso: " $ua
			echo "Fecha de ultima modificacion: " $mt
			echo "Fecha de ultima modificacion del i-nodo: " $mi
			echo "Permisos"
			ejecucionUsuario=""
			ejecucionGrupo=""
			ejecucionOtros=""
			if [ $( echo $pu | cut -c3 )  = "x" ] 
				then
					ejecucionUsuario=' ejecucion.'
			fi
			if [ $( echo $pu | cut -c3 )  = "s" ] 
				then
					ejecucionUsuario=' ejecucion y permiso especial de ejecucion para el usuario.'
			fi
			if [ $( echo $pu | cut -c3 )  = "S" ] 
				then
					ejecucionUsuario=' permiso especial de ejecucion para el usuario.'
			fi
			if [ $( echo $pg | cut -c3 )  = "x" ] 
				then
					ejecucionGrupo=' ejecucion.'
			fi
			if [ $( echo $pg | cut -c3 )  = "s" ] 
				then
					ejecucionGrupo=' ejecucion y permiso especial de ejecucion para el grupo.'
			fi
			if [ $( echo $pg | cut -c3 )  = "S" ] 
				then
					ejecucionGrupo=' permiso especial de ejecucion para el grupo.'
			fi
			if [ $( echo $po | cut -c3 )  = "x" ] 
				then
					ejecucionOtros=' ejecucion.'
			fi
			if [ $( echo $po | cut -c3 )  = "t" ] 
				then
					ejecucionOtros=' ejecucion y permiso especial de sticky bit.'
			fi
			if [ $( echo $po | cut -c3 )  = "T" ] 
				then
					ejecucionOtros=' permiso especial de sticky bit.'
			fi
			echo "Para el usuario: " $( if [ $( echo $pu | cut -c1 )  = "r" ]; then echo ' lectura,'; fi ) $( if [ $( echo $pu | cut -c2 )  = "w" ]; then echo ' escritura,'; fi ) $ejecucionUsuario
			echo "Para el grupo: " $( if [ $( echo $pg | cut -c1 )  = "r" ]; then echo ' lectura,'; fi ) $( if [ $( echo $pg | cut -c2 )  = "w" ]; then echo ' escritura,'; fi ) $ejecucionGrupo
			echo "Para otro: " $( if [ $( echo $po | cut -c1 )  = "r" ]; then echo ' lectura,'; fi ) $( if [ $( echo $po | cut -c2 )  = "w" ]; then echo ' escritura,'; fi ) $ejecucionOtros
			echo ""
			usuario=$( id | cut -d " " -f1,2 )
			echo $usuario $( date ) $( date +%s ) "El usuario mostro la informacion  de un archivo " >> bitacora.log
			echo "Ingrese el numero de la opcion que desee"
			echo "1.-Modificar los Permisos del archivo (modo octal)."
			echo "2. Borrar el archivo"
			echo "3.-Regresar al menu principal"
			opcion=""
			read opcion
			if [ $opcion = 1 ]
				then
					permisos=""
					echo "Introduce los permisos del archivo con 4 numeros (modo octal)"
					read permisos
					size=${#permisos}
					if [ $size = 4 ]
						then
							chmod $permisos $archivo
						else
							echo "Introduzca los permisos en modo octal usando cuatro numeros"
							echo "Presione enter para regresar al menu principal"
							read -p "" 
							return
					fi
					echo ""
					usuario=$( id | cut -d " " -f1,2 )
					echo $usuario $( date ) $( date +%s ) "El usuario modifico los permisos de un archivo " >> bitacora.log
					echo "Los permisos se cambiaron correctamente. Presione enter para regresar al menu principal"
					read -p "" 
			fi
			if [ $opcion = 2 ]
				then
					rm -rf $archivo
					usuario=$( id | cut -d " " -f1,2 )
					echo $usuario $( date ) $( date +%s ) "El usuario borro un archivo " >> bitacora.log
					echo "El archivo se ha borrado con exito. Presione enter para regresar al menu principal"
					read -p "" 
			fi
			if [ $opcion = 3 ]
				then
					return
			fi
	fi
} 2>> error.log

#Funcion para manejar usuarios.
#La funcion muestra la informacion de un usuario y cuantos usuarios logueados
#hay en el sistema.
manejo_usuarios() {
		clear
		echo "MENU DE LOS USUARIOS"
		echo ""
		echo "Por favor introduzca el login o el uid de un usuario que desea visualizar."
		echo ""
		usuario=""
		read usuario
		usuarioExistente=$( grep -ce $usuario /etc/passwd )
		if [ $usuarioExistente = 0 ]
		then
			echo "El usuario que ingreso no existe. Por favor introduzca uno valido."
			echo "Presione enter para continuar"
			read -p "" 
			manejo_usuarios
		else
			clear
			datos=$( grep -e $usuario /etc/passwd )
			echo "MENU DE LOS USUARIOS"
			echo "Login: " $( echo $datos | cut -d ":" -f1 )
			echo "UID: " $( echo $datos | cut -d ":" -f3 )
			guid=$( echo $datos | cut -d ":" -f4 )
			echo "Grupo: " $( grep -e $guid /etc/group | cut -d ":" -f1 )
			echo "Nombre: " $( echo $datos | cut -d ":" -f5 )
		    echo "HOME: " $( echo $datos | cut -d ":" -f6 )
			echo "SHELL: " $( echo $datos | cut -d ":" -f7 )
			echo "Actualmente existen " $( wc -l /etc/passwd | cut -d " " -f1 ) " usuarios en el sistema"
			echo "Actualmente existen " $( wc -l /etc/group | cut -d " " -f1 ) " grupos en el sistema"
			usuario_act=$( id | cut -d " " -f1,2 )
			echo $usuario_act $( date ) $( date +%s ) "El usuario mostro la informacion de un usuario " >> bitacora.log
			usuarios=$(  w | sed -n '3,$p' | uniq -u  | wc -l )
			if [ $usuarios = 0 ]
				then
					echo "Actualmente hay 0 usuarios logueados en el sistema."
				else
					echo "Actualmente hay "  $(  w | sed -n '3,$p' | uniq -u  | wc -l ) " usuarios logueados en el sistema y sus logins son: "
					echo $(  w | sed -n '2,$p' | uniq -u | cut -d " " -f1 )
			fi
			if [ $usuarios = 0 ]
				then
					echo "Actualmente hay 0 usuarios logueados en el sistema que estan ejecutando procesos."
				else
					echo "Actualmente hay "  $( w | sed -n '3,$p' | uniq -u | wc -l ) " usuarios ejecutando procesos en el sistema y sus logins son: "
					echo $(  w | sed -n '2,$p' )
			fi
			echo "Presione enter para regresar al menu principal"
			read -p "" 
		fi
} 2>> error.log

#operaciones principales del script. 
#Desde aqui se mandan a llamar los distintos metodos declarados arriba.
while true
do
	clear
	opcion=""
	echo ""
	echo "BIENVENIDO AL MENU PRINCIPAL"
	echo ""
	echo "Ingrese el numero de la opcion que desee"
	echo "1.-Manejo de Archivos"
	echo "2.-Monitore de Procesos"
	echo "3.-Monitoreo de Usuarios"
	echo "4.-Informacion del Sistema"
	echo "5.-Salir"
	read opcion
	if [ $opcion = 5 ]
	then
		break
	fi
	if [ $opcion = 4 ]
		then
				informacion_sistema
		fi
	if [ $opcion = 3 ]
        then
                manejo_usuarios
        fi
	if [ $opcion = 2 ]
        then
                manejo_procesos
        fi
	if [ $opcion = 1 ]
        then
                manejo_archivos
        fi
done
