Bullet = Class{}

function Bullet:init(startX, startY, targetX, targetY)
    self.x = startX
    self.y = startY
    self.targetX = targetX
    self.targetY = targetY
    self.rotation = 0
    self.size = 4

    self.speed = 100

    self.sprite = love.graphics.newImage("bullet.png")
end

function Bullet:update(dt)
    -- TODO die if out of bounds
    -- TODO die if has hit target (how?)
    -- TODO safe bet: die after time
end

function Bullet:render()
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, 1, 1, self.size, self.size)
end

function Bullet:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y)
end