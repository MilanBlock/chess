local Game = Object:extend()
local Screen = require "screen"
local Sprite = require "sprite"
local Figure = require "figure"

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


    -- Initialize screen figures
    self.figures = Screen(DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite, DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite,
        SPRITEMAP.size_sprite * DEFAULT_BOARD.size, SPRITEMAP.size_sprite * DEFAULT_BOARD.size)

    -- Position figures
    self.positions = {}
    for y = 1, DEFAULT_BOARD.size do
        self.positions[y] = {}
        for x = 1, DEFAULT_BOARD.size do
            if DEFAULT_BOARD.figures[y][x] ~= nil then
                self.positions[y][x] = Figure(x, y, DEFAULT_BOARD.figures[y][x])
                self.figures:addObject(self.positions[y][x])
            else
                -- Nil caused errors when iterating over all positions
                self.positions[y][x] = "nil"
            end
        end
    end
end

function Game:mousepressed(x, y, button)
    self.background:mousepressed(x - self.background.x, y - self.background.y, button)
    self.figures:mousepressed(x - self.figures.x, y - self.figures.y, button)
    self:createMovesScreen(self:getFigureShowMovesTrue())
end

function Game:update(dt)
    self.background:update(dt)
    self.figures:update(dt)
    if self.moves ~= nil then
        self.moves:update(dt)
    end
end

function Game:draw()
    self.background:draw(0, 0)
    self.figures:draw(0, 0)
    if self.moves ~= nil then
        self.moves:draw(0, 0)
    end
end

-- Returns table with .x .y .figure
function Game:getFigureShowMovesTrue()
    for y, _ in ipairs(self.positions) do
        for x, figure in ipairs(self.positions[y]) do
            if figure.show_moves then
                return {
                    x = x,
                    y = y,
                    figure = figure
                }
            end
        end
    end
    return nil
end

function Game:createMovesScreen(figure_showing_moves)
    if figure_showing_moves == nil then
        self.moves = nil
        self.posible_positions = nil
        return
    end

    self.moves = Screen(DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite, DEFAULT_BOARD.spacing + SPRITEMAP.size_sprite,
        SPRITEMAP.size_sprite * DEFAULT_BOARD.size, SPRITEMAP.size_sprite * DEFAULT_BOARD.size)

    self.posible_positions = {
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
        { "nil", "nil", "nil", "nil", "nil", "nil", "nil", "nil" },
    }

    self.inputMoves[figure_showing_moves.figure.piece](self, figure_showing_moves.figure, figure_showing_moves.x,
        figure_showing_moves.y)
end

Game.inputMoves = {}

function Game.inputMoves.step(game, figure, x, y)
    if game:isValidMovingSquare(x, y, figure.player) then
        game.posible_positions[y][x] = Figure(x, y, figure.player .. "_dot")
        game.moves:addObject(game.posible_positions[y][x])
        if game.positions[y][x] == "nil" then
            return true
        end
    end
    return false
end

function Game.inputMoves.direction(game, figure, x, y, direction_x, direction_y)
    local current_x = x + direction_x
    local current_y = y + direction_y
    while game:isOnBoard(current_x, current_y) do
        local continue = game.inputMoves.step(game, figure, current_x, current_y)
        if not continue then
            break
        end
        current_x = current_x + direction_x
        current_y = current_y + direction_y
    end
end

function Game.inputMoves.king(game, figure, x, y)
    for direction_y = -1, 1 do
        for direction_x = -1, 1 do
            if direction_y ~= 0 or direction_x ~= 0 then
                game.inputMoves.step(game, figure, direction_x + x, direction_y + y)
            end
        end
    end
end

function Game.inputMoves.queen(game, figure, x, y)
    for direction_y = -1, 1 do
        for direction_x = -1, 1 do
            if direction_y ~= 0 or direction_x ~= 0 then
                game.inputMoves.direction(game, figure, x, y, direction_x, direction_y)
            end
        end
    end
end

function Game.inputMoves.rook(game, figure, x, y)
    for direction_y = -1, 1 do
        if direction_y ~= 0 then
            game.inputMoves.direction(game, figure, x, y, 0, direction_y)
        end
    end

    for direction_x = -1, 1 do
        if direction_x ~= 0 then
            game.inputMoves.direction(game, figure, x, y, direction_x, 0)
        end
    end
end

function Game.inputMoves.bishop(game, figure, x, y)
    for direction_y = -1, 1 do
        for direction_x = -1, 1 do
            if direction_y ~= 0 and direction_x ~= 0 then
                game.inputMoves.direction(game, figure, x, y, direction_x, direction_y)
            end
        end
    end
end

function Game.inputMoves.knight(game, figure, x, y)
    game.inputMoves.step(game, figure, -2 + x, -1 + y)
    game.inputMoves.step(game, figure, -2 + x, 1 + y)
    game.inputMoves.step(game, figure, -1 + x, -2 + y)
    game.inputMoves.step(game, figure, -1 + x, 2 + y)
    game.inputMoves.step(game, figure, 1 + x, -2 + y)
    game.inputMoves.step(game, figure, 1 + x, 2 + y)
    game.inputMoves.step(game, figure, 2 + x, -1 + y)
    game.inputMoves.step(game, figure, 2 + x, 1 + y)
end

function Game.inputMoves.pawn(game, figure, x, y)
    local direction_y = -1
    local start_y = 7
    if figure.player == "black" then
        direction_y = 1
        start_y = 2
    end

    if game.positions[y + direction_y][x] == "nil" then
        if y == start_y and game.positions[y + direction_y * 2][x] == "nil" then
            game.inputMoves.step(game, figure, x, y + direction_y * 2)
        end
        game.inputMoves.step(game, figure, x, y + direction_y)
    end

    if game:isOnBoard(x - 1, y + direction_y) then
        if game.positions[y + direction_y][x - 1] ~= "nil" then
            game.inputMoves.step(game, figure, x - 1, y + direction_y)
        end
    end

    if game:isOnBoard(x + 1, y + direction_y) then
        if game.positions[y + direction_y][x + 1] ~= "nil" then
            game.inputMoves.step(game, figure, x + 1, y + direction_y)
        end
    end
end

function Game:isValidMovingSquare(x, y, player)
    if not self:isOnBoard(x, y) then
        return false
    end

    if self.positions[y][x] == "nil" then
        return true
    end
    if self.positions[y][x].player == player then
        return false
    end
    return true
end

function Game:isOnBoard(x, y)
    if x > DEFAULT_BOARD.size or y > DEFAULT_BOARD.size or x < 1 or y < 1 then
        return false
    end
    return true
end

return Game
