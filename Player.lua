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
    
    self.sprite = love.graphics.newImage("player.png")

    self.life = 10
    self.bullets = {}
    self.firingCooldown = 0 -- move from here to Gun?
    self.gun = Gun()
end

function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
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

    debugPoint(self.x, self.y)
end

function setPlayerColor()
    love.graphics.setColor(1, 1, 1)
end

function debugPoint(x, y, size)
    local size = size == nil and 3 or size
    love.graphics.setColor(1, 0, 1)
    love.graphics.rectangle('fill', x, y, size, size)
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
    local bullet = Bullet(self.x, self.y, targetX, targetY, self.gun.speed)
    table.insert(self.bullets, bullet)
end

function Player:boundingBox()
    return self.x, self.y, self.x + self.width, self.y + self.height
end

function Player:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y) .. '\n' .. #self.bullets
end
