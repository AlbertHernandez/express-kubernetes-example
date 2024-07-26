#!/bin/bash

convert_yaml_data_to_base64() {
    local yaml_content="$1"

    # Convertir los valores de `data` en base64
    local base64_content
    base64_content=$(echo "$yaml_content" | yq eval '
        .data |= with_entries(
            .value = (.value | @base64)
        )
    ')

    echo "$base64_content"
}

# Ejemplo de uso

main() {
    local file="./kubernetes/apps/express-kubernetes-example/conf/secrets.yaml"
    local decrypted_file=$(sops decrypt "$file" --output-type yaml)
    echo "DECRYPTED FILE: $decrypted_file"

    local yaml_result=$(convert_yaml_data_to_base64 "$decrypted_file")

    echo "RESULT: $yaml_result"

    kubectl apply -f - -n development <<< "$yaml_result"
}

main
