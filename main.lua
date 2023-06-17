function createSignal()
    sinaleiro = {}
    sinaleiro.name = "sinaleiro"
    sinaleiro.open = false
    sinaleiro.x = 500
    sinaleiro.y = 300
end

function createCar(x, y, aceleracao, maxVelx, freio, observer, directionAxis, isInverted)
    local car = {}
    car.name = "car"
    car.x = x
    car.y = y
    car.vel = 0
    car.maxVel = maxVelx
    car.aceleracao = aceleracao
    car.freio = freio
    car.observer = observer
    car.direction = directionAxis
    car.acelerar = function(dt)
        if car.vel < maxVelx then
            car.vel = car.vel + car.aceleracao * dt
        end
    end

    car.freiar = function(dt)
        if car.vel > 0 then
            car.vel = car.vel - car.freio * dt
        else
            car.vel = 0
        end
    end

    car.main = function(dt)
        if car.direction == "x" then
            car.x = car.x + car.vel * dt
        elseif car.direction == "y" then
            car.y = car.y + car.vel * dt
        end
        if car.observer == nil then
            car.acelerar(dt)
        else
            if car.observer.x - car.x > car.vel + 20 then
                car.acelerar(dt)
            elseif car.observer.name == "sinaleiro" and car.observer.open == true then
                car.acelerar(dt)
            else
                car.freiar(dt)
            end
        end
    end

    return car
end

function love.load()
    createSignal()
    listOfCars = { createCar(10, 200, 100, 100, 200, sinaleiro, "x") }
    openTime = 0
    count = 0 
end

function love.update(dt)
    if listOfCars[#listOfCars].x > 20 then
        table.insert(listOfCars, createCar(10, 200, 100, 300, 200, listOfCars[#listOfCars], "x"))
    end
    if love.keyboard.isDown("space") then
        sinaleiro.open = true
    else
        sinaleiro.open = false
        if count ~= 0 then
            count = 0
            openTime = 0
        end
    end
    if sinaleiro.open  == true then        
        openTime = openTime + dt
    end
    for index, value in ipairs(listOfCars) do
        value.main(dt)

        if value.x > sinaleiro.x and value.observer ~= nil then
            count = count + 1
            listOfCars[index + 1].observer = sinaleiro
            value.observer = nil
        end
        if value.x > love.graphics.getWidth() then
            table.remove(listOfCars, index)
        end
    end
    carsPerSecond = count / openTime
end

function love.draw()
    for index, value in ipairs(listOfCars) do
        love.graphics.rectangle("fill", value.x, value.y, 10, 10)
    end

    if sinaleiro.open then
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", sinaleiro.x, sinaleiro.y, 10, 10)
    else
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", sinaleiro.x, sinaleiro.y, 10, 10)
    end

    love.graphics.setColor(255, 255, 255)
    
    love.graphics.print(carsPerSecond .. " cars per second")
end
