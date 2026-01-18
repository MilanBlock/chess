local helper = {}

function helper.findInTable(table, item)
    for index, value in ipairs(table) do
        if value == item then
            return index
        end
    end
    return nil
end

return helper