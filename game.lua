local Game = Object:extend()
local Screen = require "screen"
local Sprite = require "sprite"

function Game:new()
    -- Initialize screen background
    self.background = Screen(DEFAULT_BOARD.spacing, DEFAULT_BOARD.spacing,
        SPRITEMAP.size_sprite * (DEFAULT_BOARD.size + 2),
        SPRITEMAP.size_sprite * (DEFAULT_BOARD.size + 2))

    -- Position background squares
    for y = 1, DEFAULT_BOARD.size do
        for x = 1, DEFAULT_BOARD.size do
            if (x + y) % 2 == 0 then
                self.background:addObject(Sprite(x * SPRITEMAP.size_sprite, y * SPRITEMAP.size_sprite, "tile_blue"))
            else
                self.background:addObject(Sprite(x * SPRITEMAP.size_sprite, y * SPRITEMAP.size_sprite, "tile_orange"))
            end
        end
    end

    -- Position background corners
    local corner_position = SPRITEMAP.size_sprite * (DEFAULT_BOARD.size + 1)
    self.background:addObject(Sprite(0, 0, "top_left_corner"))
    self.background:addObject(Sprite(corner_position, 0, "top_right_corner"))
    self.background:addObject(Sprite(0, corner_position, "bottom_left_corner"))
    self.background:addObject(Sprite(corner_position, corner_position, "bottom_right_corner"))

    -- Position background edges
    local order = { "a", "b", "c", "d", "e", "f", "g", "h" }

    -- Top
    for x = 1, DEFAULT_BOARD.size do
        self.background:addObject(Sprite(x * SPRITEMAP.size_sprite, 0, "top_" .. order[x]))
    end

    -- Bottom
    for x = 1, DEFAULT_BOARD.size do
        self.background:addObject(Sprite(x * SPRITEMAP.size_sprite, corner_position, "bottom_" .. order[x]))
    end

    -- Left
    for y = 1, DEFAULT_BOARD.size do
        self.background:addObject(Sprite(0, y * SPRITEMAP.size_sprite, "left_" .. (DEFAULT_BOARD.size - y + 1)))
    end

    -- Right
    for y = 1, DEFAULT_BOARD.size do
        self.background:addObject(Sprite(corner_position, y * SPRITEMAP.size_sprite,
            "right_" .. (DEFAULT_BOARD.size - y + 1)))
    end


    -- Initialize screen board
    self.board = Screen(DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite, DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite,
        SPRITEMAP.size_sprite * DEFAULT_BOARD.size,
        SPRITEMAP.size_sprite * DEFAULT_BOARD.size)

    -- Position figures
    for y = 1, DEFAULT_BOARD.size do
        for x = 1, DEFAULT_BOARD.size do
            self.board:addObject(Sprite((x - 1) * SPRITEMAP.size_sprite, (y - 1) * SPRITEMAP.size_sprite,
            DEFAULT_BOARD.figures[y][x]))
            print(DEFAULT_BOARD.figures[y][x])
        end
    end
end

function Game:update(dt)
    self.background:update(dt)
    self.board:update(dt)
end

function Game:draw()
    self.background:draw(0, 0)
    self.board:draw(0, 0)
end

return Game
