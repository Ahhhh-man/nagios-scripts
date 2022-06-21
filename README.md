# Nagios Plugin Scripts
Nagios scripts for automated active monitoring using nrpe.

<table>
    <tr>
        <th width="15%">Name</th>
        <th width="15%">Type</th>
        <th>Description</th>
    </tr>
    <tr>
        <td width="15%" valign="top">check_ntp</td>
        <td width="15%" valign="top">active</td>
        <td valign="top">Check ntpd service is running; is connected to the right ntp server; and checks delay.</td>
    </tr>
    <tr>
        <td width="15%" valign="top">check_temp</td>
        <td width="15%" valign="top">active</td>
        <td valign="top">Check temperature of hardware using lm-sensors.</td>
    </tr>
    <!-- <tr>
        <td width="15%" valign="top">check_containers</td>
        <td width="15%" valign="top">active</td>
        <td valign="top">Check docker container are running as expected; warn when unexpected container is running.</td>
    </tr> -->
    <!-- <tr>
        <td width="15%" valign="top">check_cpu</td>
        <td width="15%" valign="top">active</td>
        <td valign="top">Check CPU usage.</td>
    </tr> -->
    <!-- <tr>
        <td width="15%" valign="top">check_docker</td>
        <td width="15%" valign="top">active</td>
        <td valign="top">Check docker engine is running.</td>
    </tr> -->
</table>