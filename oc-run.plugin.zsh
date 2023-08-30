if [ -f $HOME/.openshift_domain ]; then
    if [ -f $HOME/.openshift_user ]; then
        for i in os-cts os-dts-global os-global os-pci-global os-pci-prod os-pci-restricted os-prod os-restricted os-sandbox; do
            unalias oc-${i} 2>/dev/null
            source /dev/stdin <<EOF
            function oc-${i} () {
                oc \$@ --context=default/api-${i}-\$(cat $HOME/.openshift_domain | sed 's/\./-/g'):6443/\$(cat $HOME/.openshift_user)
            }
EOF
            if [[ $(type -w compdef) == "builtin" ]]; then
                compdef __start_oc oc-${i}
            else
                compdef __start_oc oc-${i}
            fi
        done
    else
        echo "Add your email-address to $HOME/.openshift_user to get oc-<env> functions, e.g. 'user.name@organization.com'"
    fi
else
    echo "Add the _domain_ part to $HOME/.openshift_domain to get oc-<env> functions, e.g. 'hostname.com'"
fi

