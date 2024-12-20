#!/bin/bash

intervalo=$1
diretorio=$2
log_file="dirSensors.log"

> "$log_file"
antes=$(ls -A1 "$diretorio" | sort)

while true; do
    sleep "$intervalo"
    agora=$(ls -A1 "$diretorio" | sort)

    if [ "$antes" != "$agora" ]; then
        adicionados=$(echo "$agora" | grep -v -x -f <(echo "$antes") | tr '\n' ',' | sed 's/,$//')
        removidos=$(echo "$antes" | grep -v -x -f <(echo "$agora") | tr '\n' ',' | sed 's/,$//')

        data=$(date "+%d-%m-%Y %H:%M:%S")
        mensagem="[$data] Alteração! $(echo "$antes" | grep -v '^$' | wc -l)->$(echo "$agora" | grep -v '^$' | wc -l)."

        [ -n "$adicionados" ] && mensagem+=" Adicionados: $adicionados."
        [ -n "$removidos" ] && mensagem+=" Removidos: $removidos."

        echo "$mensagem" | tee -a "$log_file"
        antes="$agora"
    fi
done

