-- spritemap will be saved left to right, top to bottom
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

function love.load()
    -- Load SYSL-Pixel
    _G.gscreen = require("lib.pixel")
    gscreen.load(4)
    gscreen.toggle_cursor()

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
end

function love.update(dt)
    -- Updating Pixel
    gscreen.update(dt)
end

function love.draw()
    -- Start scaling of pixelart
    gscreen.start()

    local layer = 0
    local counter = 0
    for _, sprite in ipairs(SPRITEMAP.positions) do
        love.graphics.draw(SPRITEMAP.image, SPRITEMAP.quads[sprite], 10 + counter * SPRITEMAP.size_sprite,
            10 + layer * SPRITEMAP.size_sprite)
        counter = counter + 1
        if counter > 5 then
            counter = 0
            layer = layer + 1
        end
    end
    
    -- End scaling of pixelart
    gscreen.stop()
end