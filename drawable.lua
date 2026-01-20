local Drawable = Object:extend()

function Drawable:new(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 10
    self.height = height or 10
end

function Drawable:mousepressed(x, y, button)
    
end

function Drawable:update(dt)
end

function Drawable:draw()
end

return Drawable