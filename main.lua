function createSignal()
    sinaleiro = {}
    sinaleiro.name = "sinaleiro"
    sinaleiro.open = false
    sinaleiro.x = 500
    sinaleiro.y = 300
end

function createCar(x, y, aceleracao, maxVelx, freio, observer, sinaleiro )
    local car = {}
    car.name = "car"
    car.x = x
    car.y = y
    car.vel = 0
    car.maxVel = maxVelx
    car.aceleracao = aceleracao
    car.freio = freio
    car.observer = observer
    car.sinaleiro = sinaleiro

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
-- TODO repensar isso, talvez separar em outro objeto e fazer com que um carro não passe por cima um do outro...
-- talvez fazer algo como uma velocidade constante que todos os carros tentam atingir
    car.mainIA = function(dt)
        car.x = car.x + car.vel * dt
        if car.observer == nil then
            car.acelerar(dt)
        else
            if car.sinaleiro.open == true then
                car.acelerar(dt)
            
            elseif car.observer.x - car.x > car.vel + 20 then
                car.acelerar(dt)
            else
                car.freiar(dt)
                
            end
        end
    end
    return car
end


function insertCarOnTable(_table, minDistance)
    if _table[#_table].x > minDistance then
        table.insert(_table, createCar(10, 200, 100, 300, 200, _table[#_table], sinaleiro))
    end
end

function drawAllCarsInTable(_table)
    for index, value in ipairs(_table) do
        love.graphics.rectangle("fill", value.x, value.y, 10, 10)
    end
end

function drawTrafficLight()
end

function changeSignalOfTrafficLight()
end

function love.load()
    createSignal()
    listOfCars = { createCar(10, 200, 100, 100, 200, sinaleiro, sinaleiro) }
    openTime = 0
    carCount = 0
end

function love.update(dt)
    insertCarOnTable(listOfCars, 22)

    
    if love.keyboard.isDown("space") then
        sinaleiro.open = true
    else
        sinaleiro.open = false
        if carCount ~= 0 then
            carCount = 0
            openTime = 0
        end
    end

    if sinaleiro.open == true then        
        openTime = openTime + dt
    end

    for index, car in ipairs(listOfCars) do
        car.mainIA(dt)
        
        if car.x > sinaleiro.x and car.observer ~= nil then
            carCount = carCount + 1
            listOfCars[index + 1].observer = sinaleiro
            car.observer = nil
        end
        if car.x > love.graphics.getWidth() then
            table.remove(listOfCars, index)
        end
    end

    carsPerSecond = carCount / openTime
end

function love.draw()

    love.graphics.setColor(255, 255 , 255)
    drawAllCarsInTable(listOfCars)

    if sinaleiro.open then
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", sinaleiro.x, sinaleiro.y, 10, 10)
    else
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", sinaleiro.x, sinaleiro.y, 10, 10)
    end

    love.graphics.setColor(255, 255, 255)
    
    love.graphics.print(carsPerSecond .. " cars per second")
    love.graphics.print("\ntotal de carros passados: " .. carCount)
end
