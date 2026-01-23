-- Spritemap will be saved left to right, top to bottom
-- Figure names must be formated as [player]_[piece]
SPRITEMAP = {
    positions = {
        "tile_blue",
        "tile_orange",
        "left_1",
        "right_1",
        "white_king",
        "black_king",
        "top_a",
        "bottom_a",
        "left_2",
        "right_2",
        "white_queen",
        "black_queen",
        "top_b",
        "bottom_b",
        "left_3",
        "right_3",
        "white_rook",
        "black_rook",
        "top_c",
        "bottom_c",
        "left_4",
        "right_4",
        "white_bishop",
        "black_bishop",
        "top_d",
        "bottom_d",
        "left_5",
        "right_5",
        "white_knight",
        "black_knight",
        "top_e",
        "bottom_e",
        "left_6",
        "right_6",
        "white_pawn",
        "black_pawn",
        "top_f",
        "bottom_f",
        "left_7",
        "right_7",
        "bottom_right_corner",
        "top_right_corner",
        "top_g",
        "bottom_g",
        "left_8",
        "right_8",
        "bottom_left_corner",
        "top_left_corner",
        "top_h",
        "bottom_h",
        "white_hover",
        "black_hover",
        "white_dot",
        "black_dot"
    },
    size_sprite = 16
}

DEFAULT_BOARD = {
    spacing = 3,
    size = 8,
    figurestest1 = {
        { nil, nil, nil,           nil,            nil,           nil,            nil, nil },
        { nil, nil, "black_rook",  nil,            nil,           nil,            nil, nil },
        { nil, nil, nil,           nil,            nil,           nil,            nil, nil },
        { nil, nil, nil,           "white_knight", "white_queen", nil,            nil, nil },
        { nil, nil, nil,           "white_king",   nil,           "black_bishop", nil, nil },
        { nil, nil, "black_queen", nil,            "white_rook",  nil,            nil, nil },
        { nil, nil, nil,           nil,            nil,           nil,            nil, nil },
        { nil, nil, nil,           "white_bishop", nil,           "black_knight", nil, nil },
    },
    figurestest2 = {
        { nil, nil,          nil,            nil,            nil,            nil,          nil, nil },
        { nil, nil,          nil,            "black_pawn",   "black_pawn",   "black_pawn", nil, nil },
        { nil, "black_pawn", "black_pawn",   nil,            "white_queen",  nil,          nil, nil },
        { nil, nil,          nil,            "black_knight", nil,            nil,          nil, nil },
        { nil, nil,          "white_bishop", nil,            "white_knight", nil,          nil, nil },
        { nil, nil,          nil,            "black_bishop", "white_pawn",   "white_pawn", nil, nil },
        { nil, "white_pawn", "white_pawn",   "white_pawn",   nil,            nil,          nil, nil },
        { nil, nil,          nil,            nil,            nil,            nil,          nil, nil },
    },
    figures = {
        { "black_rook", "black_knight", "black_bishop", "black_queen", "black_king", "black_bishop", "black_knight", "black_rook" },
        { "black_pawn", "black_pawn",   "black_pawn",   "black_pawn",  "black_pawn", "black_pawn",   "black_pawn",   "black_pawn" },
        { nil,          nil,            nil,            nil,           nil,          nil,            nil,            nil },
        { nil,          nil,            nil,            nil,           nil,          nil,            nil,            nil },
        { nil,          nil,            nil,            nil,           nil,          nil,            nil,            nil },
        { nil,          nil,            nil,            nil,           nil,          nil,            nil,            nil },
        { "white_pawn", "white_pawn",   "white_pawn",   "white_pawn",  "white_pawn", "white_pawn",   "white_pawn",   "white_pawn" },
        { "white_rook", "white_knight", "white_bishop", "white_queen", "white_king", "white_bishop", "white_knight", "white_rook" },
    },
}

SCALE = 4

local game

function love.load()
    -- Load classic
    Object = require "lib.classic"

    -- Load SYSL-Pixel
    _G.gscreen = require "lib.pixel"
    gscreen.load(SCALE)
    gscreen.toggle_cursor()

    -- Load helper-functions
    _G.helper = require "helper"

    -- Load classes
    Game = require "game"

    -- Load spritemap
    SPRITEMAP.image = love.graphics.newImage("assets/spritemap.png")

    SPRITEMAP.width = SPRITEMAP.image:getWidth()
    SPRITEMAP.height = SPRITEMAP.image:getHeight()

    SPRITEMAP.sprites_x = SPRITEMAP.width / (SPRITEMAP.size_sprite + 1)
    SPRITEMAP.sprites_y = SPRITEMAP.height / (SPRITEMAP.size_sprite + 1)

    -- Create map of quads
    SPRITEMAP.quads = {}
    for y = 1, SPRITEMAP.sprites_y do
        for x = 1, SPRITEMAP.sprites_x do
            SPRITEMAP.quads[SPRITEMAP.positions[x + (y - 1) * SPRITEMAP.sprites_x]] = love.graphics.newQuad(
                (x - 1) * (SPRITEMAP.size_sprite + 1),
                (y - 1) * (SPRITEMAP.size_sprite + 1),
                SPRITEMAP.size_sprite,
                SPRITEMAP.size_sprite,
                SPRITEMAP.width,
                SPRITEMAP.height)
        end
    end

    -- Create game
    game = Game()
end

function love.mousepressed(x, y, button)
    game:mousepressed(x / SCALE, y / SCALE, button)
end

function love.update(dt)
    -- Updating Pixel
    gscreen.update(dt)

    -- Update Game
    game:update(dt)
end

function love.draw()
    -- Start scaling of pixelart
    gscreen.start()

    -- TEMPORARY to confirm correct loading of sprites
    -- local layer = 0
    -- local counter = 0
    -- for _, sprite in ipairs(SPRITEMAP.positions) do
    --     love.graphics.draw(SPRITEMAP.image, SPRITEMAP.quads[sprite], 10 + counter * SPRITEMAP.size_sprite,
    --         10 + layer * SPRITEMAP.size_sprite)
    --     counter = counter + 1
    --     if counter > 5 then
    --         counter = 0
    --         layer = layer + 1
    --     end
    -- end

    -- Draw game
    game:draw()

    -- End scaling of pixelart
    gscreen.stop()
end
