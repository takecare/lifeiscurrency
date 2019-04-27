Bullet = Class{}

function Bullet:init(startX, startY, targetX, targetY, speed)
    self.x = startX
    self.y = startY

    local angle = math.atan2((targetY - startY), (targetX - startX))
    self.dx = speed * math.cos(angle)
    self.dy = speed * math.sin(angle)

    self.rotation = 0
    self.width = 4
    self.height = 4

    self.ttl = 200
    self.ttlSpeed = 25
    self.alive = true

    self.sprite = love.graphics.newImage("bullet.png")
end

function Bullet:update(dt)
    -- TODO die if out of bounds
    -- TODO die if has hit target (how?)

    if (self.ttl <= 0) then
        self.alive = false
        return
    end

    self.ttl = self.ttl - self.ttlSpeed * dt

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bullet:render()
    if (self:isDead()) then 
        return
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, 1, 1, self.width, self.height)
end

function Bullet:kill()
    self.alive = false
end

function Bullet:isDead()
    return not self.alive
end

function Bullet:collidesWith(other)
    local minX, minY = self.x, self.y
    local maxX, maxY = self.x + self.width, self.y + self.height
    local otherMinX, otherMinY, otherMaxX, otherMaxY = other:boundingBox()
    local collides = (minX <= otherMaxX and maxX >= otherMinX) and (minY <= otherMaxY and maxY >= otherMinY)

    if collides then
        self:kill()
    end

    return collides
end

function Bullet:boundingBox()
    return self.x, self.y, self.x + self.width, self.y + self.height
end

function Bullet:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y)
end
