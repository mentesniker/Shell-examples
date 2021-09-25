#Para ejecutar el programa se debe de mandar a llamar desde la terminal. Se pediran los
#passwords por la linea de comandos y en caso de que uno no se valido, se volvera pedir que se
#vuelva a ingresar.
{
num_passwords=0
echo "cuantos passwords quieres validar?"
read num_passwords
contador=0
declare -a pass_correctos
while [ $contador -lt $num_passwords ]
do
	echo "Introduce el password" $(( contador + 1 ))
	password=""
	read password
	longitud=${#password}
	validacion=$(echo "$password" | grep -e "[A-Z]\{1\}")
	if ! [ $validacion ]
		then
			echo "Tu password no es correcto. Le hace falta al menos una mayuscula"
			echo "vuelve a ingresar otro password"
			continue
	fi
	validacion=$(echo "$password" | grep -e "[a-z]\{1\}")
        if ! [ $validacion ]
                then
                        echo "Tu password no es correcto. Le hace falta al menos una minuscula"
			echo "vuelve a ingresar otro password"
                        continue
        fi
	validacion=$(echo "$password" | grep -e "[0-9]\{1\}")
	if ! [ $validacion ]
                then
                        echo "Tu password no es correcto. Le hace falta al menos un numero"
                        echo "vuelve a ingresar otro password"
                        continue
        fi
	validacion=$(echo "$password" | grep -e "[&%$#.-_+=@]\{1\}")
        if ! [ $validacion ]
                then
                        echo "Tu password no es correcto. Le hace falta al menos un caracter especial(&%$#.-_+=@)"
                        echo "vuelve a ingresar otro password"
                        continue
        fi
	validacion=$(echo "$password" | egrep -e "(.)\1+")
        if [ $validacion ]
                then
                        echo "Tu password no es correcto. Ningun caracter puede estar repetido consecutivamente."
                        echo "vuelve a ingresar otro password"
                        continue
        fi
        if [ $longitud -lt 15 ]
                then
                        echo "Tu password no es correcto. Tu password debe de tener 15 caracteres."
                        echo "vuelve a ingresar otro password"
                        continue
        fi
	echo "tu password es correcto"
	pass_correctos+=($password)
	contador=$(( contador + 1  ))
done
echo "Tus passwords validos fueron ${pass_correctos[@]}"
} 2> error.log
