local player = game.Players.LocalPlayer
local myUserId = tostring(player.UserId)

_G.destroyRunning = false
_G.lockEquip = false

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getChar()
    return char:WaitForChild("Humanoid", 5)
end

local function getHead()
    local char = getChar()
    return char:WaitForChild("Head", 5)
end

local function getBat()
    local char = getChar()
    local backpack = player:WaitForChild("Backpack")
    
    local bat = char:FindFirstChild("Bat") or backpack:FindFirstChild("Bat")
    if bat and bat:IsA("Tool") then
        return bat
    end
    return nil
end

local function unequipAllTools()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid:UnequipTools()
    end
end

local function equipBat()
    local bat = getBat()
    if not bat then
        return false
    end

    unequipAllTools()

    local humanoid = getHumanoid()
    if humanoid and bat.Parent ~= getChar() then
        humanoid:EquipTool(bat)
    end

    return getChar():FindFirstChild("Bat") ~= nil
end

local function clickBat(times)
    times = times or 5
    local bat = getChar():FindFirstChild("Bat")
    if not bat then return end

    for i = 1, times do
        if not _G.destroyRunning then break end
        bat:Activate()
        task.wait(0.05)
    end
end

local function teleportAndAttack(part, head)
    if not part or not head then return false end

    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            child:Destroy()
        end
    end

    part.Anchored = false
    part.CanCollide = false
    part.Transparency = 0
    part.Velocity = Vector3.zero
    part.RotVelocity = Vector3.zero
    part.CFrame = CFrame.new(head.Position)
    part.Anchored = true

    local stopForcing = false
    task.spawn(function()
        while not stopForcing and _G.destroyRunning do
            if part and part.Parent then
                part.CFrame = CFrame.new(head.Position)
            end
            task.wait(0.025)
        end
    end)

    clickBat(5)
    stopForcing = true

    return true
end

-- Background equip lock loop (uses _G vars)
task.spawn(function()
    while true do
        task.wait(0.015)

        local char = getChar()

        if _G.destroyRunning and _G.lockEquip and char and not char:FindFirstChild("Bat") then
            equipBat()
        end
    end
end)

-- GLOBAL FUNCTIONS via _G
_G.startDestroy = function()
    if _G.destroyRunning then return end
    _G.destroyRunning = true
    _G.lockEquip = false

    task.spawn(function()
        while _G.destroyRunning do
            local char = getChar()
            if not char or not char.Parent then
                task.wait(0.1)
                continue
            end

            local head = getHead()
            local humanoid = getHumanoid()
            if not head or not humanoid then
                task.wait(0.1)
                continue
            end

            local foundSentry = false

            for _, part in ipairs(workspace:GetDescendants()) do
                if not _G.destroyRunning then break end

                if part:IsA("BasePart")
                    and part.Name:find("Sentry_")
                    and not part.Name:find(myUserId)
                    and part:FindFirstChildOfClass("TouchTransmitter") then

                    foundSentry = true
                    teleportAndAttack(part, head)
                end
            end

            if foundSentry then
                _G.lockEquip = true
            else
                if _G.lockEquip then
                    unequipAllTools()
                    _G.lockEquip = false
                end
            end

            task.wait(0.185)
        end
        _G.lockEquip = false
    end)
end

_G.stopDestroy = function()
    _G.destroyRunning = false
    _G.lockEquip = false
    unequipAllTools()
end

-- Optional: print ready message
print("Sentry destroyer loaded! Use startDestroy() and stopDestroy() in console.")end

local function equipBat()
    local bat = getBat()
    if not bat then
        return false
    end

    unequipAllTools()

    local humanoid = getHumanoid()
    if humanoid and bat.Parent ~= getChar() then
        humanoid:EquipTool(bat)
    end

    return getChar():FindFirstChild("Bat") ~= nil
end

local function clickBat(times)
    times = times or 5
    local bat = getChar():FindFirstChild("Bat")
    if not bat then return end

    for i = 1, times do
        if not destroyRunning then break end
        bat:Activate()
        task.wait(0.05)
    end
end

local function teleportAndAttack(part, head)
    if not part or not head then return false end

    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            child:Destroy()
        end
    end

    part.Anchored = false
    part.CanCollide = false
    part.Transparency = 0
    part.Velocity = Vector3.zero
    part.RotVelocity = Vector3.zero
    part.CFrame = CFrame.new(head.Position)
    part.Anchored = true

    local stopForcing = false
    task.spawn(function()
        while not stopForcing and destroyRunning do
            if part and part.Parent then
                part.CFrame = CFrame.new(head.Position)
            end
            task.wait(0.025)
        end
    end)

    clickBat(5)
    stopForcing = true

    return true
end

task.spawn(function()
    while true do
        task.wait(0.015) 

        local char = getChar()

        if destroyRunning and lockEquip and char and not char:FindFirstChild("Bat") then
            equipBat()
        end
    end
end)

local function startDestroy()
    if destroyRunning then return end
    destroyRunning = true
    lockEquip = false

    task.spawn(function()
        while destroyRunning do
            local char = getChar()
            if not char or not char.Parent then
                task.wait(0.1)
                continue
            end

            local head = getHead()
            local humanoid = getHumanoid()
            if not head or not humanoid then
                task.wait(0.1)
                continue
            end

            local foundSentry = false

            for _, part in ipairs(workspace:GetDescendants()) do
                if not destroyRunning then break end

                if part:IsA("BasePart")
                    and part.Name:find("Sentry_")
                    and not part.Name:find(myUserId)
                    and part:FindFirstChildOfClass("TouchTransmitter") then

                    foundSentry = true
                    teleportAndAttack(part, head)
                end
            end

            if foundSentry then
                lockEquip = true 
            else
                if lockEquip then
                    unequipAllTools()
                    lockEquip = false 
                end
            end

            task.wait(0.185)
        end
        lockEquip = false
    end)
end

local function stopDestroy()
    destroyRunning = false
    lockEquip = false
    unequipAllTools()
end
