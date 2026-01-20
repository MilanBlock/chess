local Drawable = require "drawable"
local Screen = Drawable:extend()

function Screen:new(x, y, width, heigth)
    Screen.super.new(self, x, y, width, heigth)
    self.content = {}
end

function Screen:addObject(object)
    if object ~= nil then
        table.insert(self.content, object)
    end
end

function Screen:removeObject(object)
    local index = helper.findInTable(self.content, object)
    if index ~= nil then
        table.remove(self.content, index)
    end
end

function Screen:mousepressed(x, y, button)
    for _, object in ipairs(self.content) do
        object:mousepressed(x - object.x, y - object.y, button)
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