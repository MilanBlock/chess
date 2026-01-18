local Drawable = require "drawable"
local Sprite = Drawable:extend()

function Sprite:new(x, y, quad_name)
    Sprite.super.new(self, x, y, SPRITEMAP.size_sprite, SPRITEMAP.size_sprite)
    self.quad_name = quad_name or nil
end

function Sprite:update(dt)
end

function Sprite:draw(shift_x, shift_y)
    if self.quad_name ~= nil then
        love.graphics.draw(SPRITEMAP.image, SPRITEMAP.quads[self.quad_name], self.x + shift_x, self.y + shift_y)
    end
end

return Sprite
