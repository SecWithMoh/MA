get_ip_ranges() {
    # Initialize variables
    SHOW_INFO=false
    ASN=""
    # Default to RADB for backward compatibility and broad coverage
    WHOIS_SERVER="whois.radb.net"

    # Process arguments
    for arg in "$@"; do
        case "$arg" in
            -info)
                SHOW_INFO=true
                ;;
            -ripe)
                WHOIS_SERVER="whois.ripe.net"
                ;;
            -arin)
                WHOIS_SERVER="whois.arin.net"
                ;;
            *)
                ASN=$arg
                ;;
        esac
    done

    # Check if ASN is empty, implying input might come from a pipe
    if [ -z "$ASN" ]; then
        if [ ! -t 0 ]; then
            # Read the ASN from the pipe
            read ASN
        fi
    fi

    # Fetch and echo IP ranges
    IP_RANGES=$(whois -h $WHOIS_SERVER -- "-i origin $ASN" | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}/[0-9]{1,2}")
    echo "$IP_RANGES"
    echo "-----------------"
    
    # If -info flag is set, fetch and echo ASN owner info
    if $SHOW_INFO; then
        ASN_INFO=$(whois -h $WHOIS_SERVER $ASN)
        
        # Different registries might use slightly different field names, so adjust the search pattern accordingly.
        if [[ $WHOIS_SERVER == "whois.arin.net" ]]; then
            # ARIN's format often includes OrgName for the organization name
            echo "$ASN_INFO" | awk 'BEGIN{IGNORECASE=1} /OrgName:/ {print; flag=1; next} /^[^ ]/ {flag=0} flag {print}'
        else
            # Common for RIPE and RADB, looking for 'descr:' and 'as-name:'
            echo "$ASN_INFO" | awk 'BEGIN{IGNORECASE=1} /as-name:/ {print; flag=1; next} /^[^ ]/ {flag=0} flag {print}'
            echo "-----------------------"
            echo "$ASN_INFO" | awk 'BEGIN{IGNORECASE=1} /descr:/ {print; flag=1; next} /^[^ ]/ {flag=0} flag {print}'
        fi
    fi
}
