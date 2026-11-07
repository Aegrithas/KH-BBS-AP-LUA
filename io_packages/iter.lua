local exports = {}

function exports.collect(iterator)
    t = {}
    for item in iterator do
        table.insert(t, item)
    end
    return t
end

function exports.unpack(iterator)
    return table.unpack(iter.collect(iterator))
end

return exports
