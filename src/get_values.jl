function get_MouseID(filepath::String)
    x = match(r"[a-zA-Z]{2}\d{3}",filepath)
    if isempty(x.match)
        return "ERROR in MouseID"
    else
        return String(x.match)
    end
end

function get_Date(filepath::String)
    x = match(r"\d{6}",filepath)
    if isempty(x.match)
        return 000000
    else
        return parse(Int64,x.match)
    end
end

function get_SessionCounter(filepath::String)
    x = match(r"\d{6}[a-z]{1}",filepath)
    if isempty(x.match)
        return "Z"
    else
        return x.match[end]
    end
end
