local Drawable = require "drawable"
local Screen = Drawable:extend()

function Screen:new(x, y, width, heigth)
    Screen.super.new(self, x, y, width, heigth)
    self.content = {}
end

function Screen:addObject(object)
    table.insert(self.content, object)
end

function Screen:removeObject(object)
    local index = helper.findInTable(self.content, object)
    if index ~= nil then
        table.remove(self.content, index)
    end
end

function Screen:update(dt)
    for _, object in ipairs(self.content) do
        object:update(dt)
    end
end

function Screen:draw(shift_x, shift_y)
    for _, object in ipairs(self.content) do
        object:draw(shift_x + self.x, shift_y + self.y)
    end
end

return Screen