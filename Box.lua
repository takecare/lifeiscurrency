Box = Class{}

function Box:init(x, y, width, height, rotation)
    self.x = x
    self.y = y

    self.rotation = rotation ~= nil and rotation or 0
    self.width = width ~= nil and width or 10
    self.height = height ~= nil and height or 10

    self.sprite = love.graphics.newImage("box.png")
    local realWidth, realHeight = self.sprite:getDimensions()
    self.scaleX = self.width / realWidth
    self.scaleY = self.height / realHeight
end

function Box:update(dt)
    --
end

function Box:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.width, self.height)
end

function Box:boundingBox()
    return self.x, self.y, self.x + self.width, self.y + self.height
end

function Box:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y)
end
