local Sprite = require "sprite"
local Figure = Sprite:extend()

-- x and y according to game.positions[y][x]
function Figure:new(x, y, figure_name)
    Figure.super.new(self, (x - 1) * SPRITEMAP.size_sprite, (y - 1) * SPRITEMAP.size_sprite, figure_name)
    self.show_moves = false

    -- Extract piece information from figure_name
    local piece_information = {}
    for value in string.gmatch(figure_name, "%a+") do
        table.insert(piece_information, value)
    end
    self.player = piece_information[1]
    self.piece = piece_information[2]
end

function Figure:mousepressed(x, y, button)
    if button == 1 then
        if x >= 0 and x < self.width and y >= 0 and y < self.height then
            self.show_moves = not self.show_moves
        else
            self.show_moves = false
        end
    end
end



return Figure
