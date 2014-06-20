exports.parseHeader = (headers) ->
    contacts = {}
    for header in headers
        do (header) ->
            from = header.from[0]
            begin = from.lastIndexOf '<'
            email = (from.substring begin+1, from.length-1).replace /\ /g, ''
            name = ((from.substring 0, begin).replace /\"/g,'').replace /\ /g, ''
            if not contacts[email]
                contacts[email] = name
    contactArray = for email,name of contacts
        email: email
        name: name
    return contactArray
