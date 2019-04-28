Player = Class{}

function Player:init(x, y)
    self.x = x ~= nil and x or 25
    self.y = y ~= nil and y or 25
    self.rotation = 0
    self.width = 8
    self.height = 8

    self.dy = 0
    self.dx = 0
    self.speed = 45
    self.backwardsSpeed = 30
    self.colliding = false

    self.sprite = love.graphics.newImage("player.png")

    self.life = 10
    self.bullets = {}
    self.firingCooldown = 0 -- move from here to Gun?
    self.gun = Gun()

    --
    self.collisions = ''
end

function Player:update(dt)

    -- self.x = self.x + self.dx * dt
    -- self.y = self.y + self.dy * dt
    self:updatePosition(dt)
    self:updateRotation()

    for i,bullet in ipairs(self.bullets) do
        if bullet:isDead() then
            table.remove(self.bullets, i)
        end
        bullet:update(dt)
    end

    self.firingCooldown = self.firingCooldown - self.gun.rate * dt
    
    self.gun:update(self)
end

function Player:updatePosition(dt)
    local collidingLeft = string.match(self.collisions, 'L')
    local collidingRight = string.match(self.collisions, 'R')
    local collidingTop = string.match(self.collisions, 'T')
    local collidingBottom = string.match(self.collisions, 'B')

    if self.dx < 0 then
        if not collidingLeft then
            self.x = self.x + self.dx * dt
        end
    elseif self.dx > 0 then
        if not collidingRight then
            self.x = self.x + self.dx * dt
        end
    end

    if self.dy > 0 then
        if not collidingBottom then
            self.y = self.y + self.dy * dt
        end
    elseif self.dy < 0 then
        if not collidingTop then
            self.y = self.y + self.dy * dt
        end
    end
end

function Player:updateRotation()
    local mouseX, mouseY = mousePos()
    local x, y = self.x, self.y
    local hypotenuse = distance(mouseX, mouseY, x, y)
    local opposite = distance(x, y, x, mouseY)
    local angle = math.asin(opposite / hypotenuse)
    
    if (mouseX > x and mouseY > y) then 
        self.rotation = angle
    elseif (mouseX < x and mouseY > y) then
        self.rotation = math.rad(180) - angle
    elseif (mouseX < x and mouseY < y) then
        self.rotation = math.rad(180) + angle
    elseif (mouseX > x and mouseY < y) then
        self.rotation = - angle
    end
end

function mousePos()
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    return mouseX ~= nil and mouseX or 0, mouseY ~= nil and mouseY or 0
end

function distance(x0, y0, x1, y1)
    return math.sqrt(math.pow(x1 - x0, 2) + math.pow(y1 - y0, 2))
end

function Player:render()
    setPlayerColor()
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, 1, 1, self.width, self.height)

    for i,bullet in ipairs(self.bullets) do
        bullet:render()
    end

    self.gun:render()

    self:debugPoint()
    self:debugBoundingBox()
end

function setPlayerColor()
    love.graphics.setColor(1, 1, 1)
end

function Player:debugPoint()
    love.graphics.setColor(1, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, 3, 3)
end

function Player:debugBoundingBox()
    local x, y, w, h = self:boundingBox()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('line', x, y, w, h)
end

function Player:handleInput()
    if love.keyboard.isDown("w") then
        self.dy = - self.speed
    elseif love.keyboard.isDown("s") then
        self.dy = self.speed
    else
        self.dy = 0
    end

    if love.keyboard.isDown("a") then
        self.dx = - self.speed
    elseif love.keyboard.isDown("d") then
        self.dx = self.speed
    else
        self.dx = 0
    end

    if love.mouse.isDown(1) then
        -- TODO cooldown period (depending on Gun)
        self:firing()
    end
end

function Player:firing()
    if self.firingCooldown >= 0 then
        return
    end

    self.firingCooldown = 20

    local targetX, targetY = mousePos()
    local bullet = Bullet(self.gun.x, self.gun.y, targetX, targetY, self.gun.speed)
    table.insert(self.bullets, bullet)
end

function Player:collidesWith(other)
    local minX, minY, width, height = self:boundingBox()
    local maxX, maxY = minX + width, minY + height
    local otherMinX, otherMinY, otherWidth, otherHeight = other:boundingBox()
    local otherMaxX, otherMaxY = otherMinX + otherWidth, otherMinY + otherHeight

    self.collisions = ''
    
    local collidesRight = (maxX > otherMinX and minX <= otherMaxX) 
                            and (maxY > otherMinY and minY <= otherMaxY)
                            and (maxX < otherMaxX)
    local collidesLeft = (minX < otherMaxX and maxX >= otherMaxX) 
                            and (maxY > otherMinY and minY <= otherMaxY)
                            and (minX > otherMinX)
    local collidesBottom = (maxY > otherMinY and minY <= otherMinY)
                            and (
                                (maxX > otherMinX and minX <= otherMaxX) 
                                or (minX < otherMaxX and maxX >= otherMaxX)
                            )
    local collidesTop = (minY < otherMaxY and maxY >= otherMaxY)
                            and (
                                (maxX > otherMinX and minX <= otherMaxX) 
                                or (minX < otherMaxX and maxX >= otherMaxX)
                            )

    if collidesLeft then
        self.collisions = self.collisions .. 'L'
    elseif collidesRight then
        self.collisions = self.collisions .. 'R'
    end
    
    if collidesTop then
        self.collisions = self.collisions .. 'T'
    elseif collidesBottom then
        self.collisions = self.collisions .. 'B'
    end

    return collisions ~= ''
end

function Player:f()
    return 0, 0, 0, 0
end

function Player:boundingBox()
    return self.x - self.width, self.y - self.height, self.width * 2, self.height * 2
end

function Player:debugInfo()
    local xy = math.ceil(self.x) .. ',' .. math.ceil(self.y)
    return xy .. ' ' .. self.collisions .. '\n' .. #self.bullets
end
