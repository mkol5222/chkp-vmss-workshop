#!/bin/bash


while true; do
    CPMAN_IP=$(az vm list-ip-addresses -g  58-cpman   -o json | jq -r '.[] | select(.virtualMachine.name == "cpman") | .virtualMachine.network.publicIpAddresses[0].ipAddress')
    echo "CPMAN IP: $CPMAN_IP"
 
    echo "Checking if VM is ready"
    if [ -z "$CPMAN_IP" ]; then
        echo "CPMAN IP not found"
        # echo "Try again later once the VM is created"
        echo "Retrying in 5 seconds"
    else 
        echo "CPMAN IP found"    
        break;
    fi
    sleep 5
done


while true; do
    echo "Checking if API is ready"
    RES=$(echo "Welcome@Home#1984" | sshpass ssh  -o ConnectTimeout=10  -o "StrictHostKeyChecking no" admin@$CPMAN_IP 'api status' 2>/dev/null | grep 'API readiness' | grep -Po '(?<=API readiness test )(SUCCESSFUL)')
    if [ "$RES" == "SUCCESSFUL" ]; then
        echo "API is ready"
        break;
    else
        echo "$(date): API is not ready"
        echo "Retrying in 5 seconds"
        sleep 5
    fi
done

echo "Connecting"
sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$CPMAN_IP
