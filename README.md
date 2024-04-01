The `get_ip_ranges` function is a versatile Bash shell utility designed for network administrators, security researchers, or anyone interested in obtaining information about IP address ranges associated with a specific Autonomous System Number (ASN). This function queries WHOIS databases to fetch IP ranges and, optionally, detailed information about the ASN's owner.

### Key Features:

- **Multiple Registry Support**: By default, the function queries the RADB WHOIS server, known for its broad coverage. However, it can be configured to query specific registries like RIPE (for European networks) and ARIN (for North American networks) by using `-ripe` and `-arin` flags, respectively.
- **Flexible Input Handling**: It accepts an ASN directly as an argument or via standard input (stdin), making it adaptable for use in scripts or pipelines.
- **Optional Detailed Information Retrieval**: With the `-info` flag, the function not only fetches the IP ranges but also provides detailed ownership information. For ARIN queries, it focuses on `OrgName` to identify the organization name. For RIPE and RADB queries, it looks for `as-name` and `descr` fields, offering insights into the ASN's description and related metadata.
- **Case-Insensitive Pattern Matching**: Utilizes `awk` with case-insensitive pattern matching to ensure reliable extraction of information, regardless of how the WHOIS data is formatted.

### Usage Examples:

- To fetch IP ranges for ASN 10695 from the default RADB registry:
  ```bash
  get_ip_ranges AS10695
  ```
- To fetch IP ranges and detailed info for ASN 3333 from the RIPE registry:
  ```bash
  get_ip_ranges AS3333 -ripe -info
  ```
- To fetch IP ranges and organization name for ASN 7922 from the ARIN registry:
  ```bash
  get_ip_ranges AS7922 -arin -info
  ```

### Implementation Details:

- The function dynamically adjusts the WHOIS server endpoint based on user input, allowing for targeted queries across different regional internet registries.
- It intelligently processes command-line arguments to handle various options (`-info`, `-ripe`, `-arin`) and the ASN.
- The use of `grep` and `awk` for data extraction makes it robust in parsing and presenting WHOIS data, even when formats vary across registries.

This function is a powerful tool for anyone needing quick access to ASN-related information without navigating through different WHOIS web interfaces or manually parsing registry data.
