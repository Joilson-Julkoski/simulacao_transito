function createCar(x, y, aceleracao, maxVelx, freio, observer)
    local car = {}
    car.name = "car"
    car.x = x
    car.y = y
    car.vel = 0
    car.maxVel = maxVelx
    car.aceleracao = aceleracao
    car.freio = freio
    car.observer = observer
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
        car.x = car.x + car.vel * dt
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
    sinaleiro = {}
    sinaleiro.name = "sinaleiro"
    sinaleiro.open = false
    sinaleiro.x = 500
    sinaleiro.y = 100
    listOfCars = { createCar(10, 200, 100, 100, 200, sinaleiro) }

    for i = 1, 10, 1 do
        table.insert(listOfCars, createCar(10, 200, 100, 300, 500, listOfCars[i]))
    end
end

function love.update(dt)
    if love.keyboard.isDown("space") then
        sinaleiro.open = true
    else
        sinaleiro.open = false
    end

    for index, value in ipairs(listOfCars) do
        value.main(dt)

        if value.x > sinaleiro.x and value.observer ~= nil then
            listOfCars[index + 1].observer = sinaleiro
            value.observer = nil
        end
    end
end

function love.draw()
    for index, value in ipairs(listOfCars) do
        love.graphics.rectangle("fill", value.x, 100, 10, 10)
    end

    if sinaleiro.open then
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", sinaleiro.x, 100, 10, 10)
    else
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", sinaleiro.x, 100, 10, 10)
    end

    love.graphics.setColor(255, 255, 255)
end
