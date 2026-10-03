local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local P, R, LP = game:GetService("Players"), game:GetService("RunService"), game:GetService("Players").LocalPlayer
local Win = Rayfield:CreateWindow({Name = "MM2 Fling", LoadingTitle = "Loading...", ConfigurationSaving = {Enabled = false}})
local Tab, TargetName, Dropdown = Win:CreateTab("Fling"), ""

local function GetList()
    local t = {}
    for _, v in pairs(P:GetPlayers()) do if v ~= LP then table.insert(t, v.DisplayName.." (@"..v.Name..")") end end
    return #t > 0 and t or {"ไม่มีผู้เล่น"}
end

Dropdown = Tab:CreateDropdown({Name = "เลือกเป้าหมาย", Options = GetList(), CurrentOption = GetList()[1] or "", Callback = function(v) TargetName = type(v) == "table" and v[1] or v end})
Tab:CreateButton({Name = "🔄 รีเฟรชชื่อ", Callback = function() Dropdown:Refresh(GetList(), true) end})

Tab:CreateButton({Name = "💥 เริ่มเตะคนปลิว", Callback = function()
    local tgt = nil
    for _, v in pairs(P:GetPlayers()) do
        if v ~= LP and (v.DisplayName.." (@"..v.Name..")" == TargetName or v.Name == TargetName) then tgt = v break end
    end
    if not (tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")) then return end

    local HRP, Hum, THRP = LP.Character.HumanoidRootPart, LP.Character.Humanoid, tgt.Character.HumanoidRootPart
    local OrigCF, StartPos = CFrame.new(HRP.Position) * CFrame.Angles(0, select(2, HRP.CFrame:ToOrientation()), 0), THRP.Position

    HRP.CFrame = THRP.CFrame * CFrame.new(5, 0, 0); task.wait(0.05)
    HRP.CFrame = THRP.CFrame; task.wait(0.05)

    local Conn, St = R.Heartbeat:Connect(function()
        HRP.Velocity, HRP.RotVelocity = Vector3.new(20000,20000,20000), Vector3.new(20000,0,0)
        HRP.CFrame = THRP.CFrame * ((math.floor(tick()*60)%2==0) and CFrame.new(1.5, 3, 0)*CFrame.Angles(math.rad(90),0,0) or CFrame.new(1.5, -3, 0)*CFrame.Angles(math.rad(-90),0,0))
    end), tick()

    repeat task.wait(0.05) until (THRP.Position - StartPos).Magnitude > 50 or (tick() - St) > 1.5
    if Conn then Conn:Disconnect() end

    HRP.Velocity, HRP.RotVelocity = Vector3.zero, Vector3.zero
    HRP.CFrame = OrigCF
    Hum:ChangeState(Enum.HumanoidStateType.Landed)
    task.wait(0.02)
    HRP.Velocity, HRP.RotVelocity = Vector3.zero, Vector3.zero
    Hum:ChangeState(Enum.HumanoidStateType.Running)
end})

P.PlayerAdded:Connect(function() task.wait(1) Dropdown:Refresh(GetList(), false) end)
P.PlayerRemoving:Connect(function() task.wait(1) Dropdown:Refresh(GetList(), false) end)
