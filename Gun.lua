Gun = Class{}

-- TODO inheritance? how?

function Gun:init()
    self.x = 0
    self.y = 0
    self.rotation = 0
    self.width = 0
    self.height = 0
    self.rate = 200 -- firing rate
    self.speed = 100
    self.sprite = love.graphics.newImage("gun.png")
end

function Gun:update(player)
    self.x = player.x + self.width
    self.y = player.y + self.height
    self.rotation = player.rotation
end

function Gun:render()
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, 1, 1, self.width, self.height)
end

function Player:boundingBox()
    --
end

function Gun:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y)
end