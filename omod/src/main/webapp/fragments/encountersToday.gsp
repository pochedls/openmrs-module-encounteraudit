<%
    ui.includeJavascript("encounteraudit", "jquery.js")

    def id = config.id
    def start = config.start
    def props = config.properties ?: ["encounterType", "encounterDatetime", "location", "provider"]
%>
<script>
    jq = jQuery;

    jq(function() {
        jq('#${ id }_button').click(function() {
            jq.getJSON('${ ui.actionLink("getEncounters") }',
                    {
                        'start': '${ ui.dateToString(start) }',
                        'end': '${ ui.dateToString(end) }',
                        'properties': [ <%= props.collect { "'${it}'" }.join(",") %> ]
                    })
                    .success(function(data) {
                        jq('#${ id } > tbody > tr').remove();
                        var tbody = jq('#${ id } > tbody');
                        for (index in data) {
                            var item = data[index];
                            var row = '<tr>';
                            <% props.each { %>
                            row += '<td>' + item.${ it } + '</td>';
                            <% } %>
                            row += '</tr>';
                            tbody.append(row);
                        }
                    })
                    .error(function(xhr, status, err) {
                        alert('AJAX error ' + err);
                    })
        });
    });
</script>

<input id="${ id }_button" type="button" value="Refresh"/>

<table id="${ id }">
    <thead>
    <tr>
        <% props.each { %>
        <th>${ ui.message("Encounter." + it) }</th>
        <% } %>
    </tr>
    </thead>
    <tbody>
    <% if (encounters) { %>
    <% encounters.each { enc -> %>
    <tr>
        <% props.each { prop -> %>
        <td><%= ui.format(enc."${prop}") %></td>
        <% } %>
    </tr>
    <% } %>
    <% } else { %>
    <tr>
        <td colspan="4">${ ui.message("general.none") }</td>
    </tr>
    <% } %>
    </tbody>
</table>