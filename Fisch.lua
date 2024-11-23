local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

OrionLib:MakeNotification({
	Name = "Welcome!",
	Content = "Thanks for using this script!",
	Image = "rbxassetid://4483345998",
	Time = 2
})


local Window = OrionLib:MakeWindow({Name = "Fer Modz Fisch", HidePremium = false, SaveConfig = true, ConfigFolder = ".Fer-Fischer-Modz"})

local main = Window:MakeTab({
    Name = "Main";
    Icon = "rbxassetid://9204970314";
    PremiumOnly = false;
  })

local Section = main:AddSection({
	Name = "Farm"
})

local teleportSpots = {}

local itemSpots = {
    Bait_Crate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
    Carbon_Rod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
    Crab_Cage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
    Fast_Rod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
    Flimsy_Rod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
    GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
    Long_Rod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
    Lucky_Rod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
    Plastic_Rod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
    Training_Rod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998)
}

local fisktable = {}

-- Services

local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Locals

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local ActiveFolder = Workspace:FindFirstChild("active")
local FishingZonesFolder = Workspace:FindFirstChild("zones"):WaitForChild("fishing")
local TpSpotsFolder = Workspace:FindFirstChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
local NpcFolder = Workspace:FindFirstChild("world"):WaitForChild("npcs")
local PlayerGUI = LocalPlayer:FindFirstChildOfClass("PlayerGui")
local RenderStepped = RunService.RenderStepped
local WaitForSomeone = RenderStepped.Wait
local Debug = function()
    print(debug.info(2, "l"))
end

-- Varbiables

local autoShake = false
local autoShakeDelay = 0
local autoShakeMethod = "ClickEvent"
local autoShakeClickOffsetX = 0
local autoShakeClickOffsetY = 0
local autoReel = false
local autoReelDelay = 0
local autoCast = false
local autoCastMode = "Rage"
local autoCastDelay = 0.4
local Noclip = false
local AntiDrown = true
local CollarPlayer = false
local Target
local FreezeChar = false

local SafeZone = Instance.new("Part")
SafeZone.Parent = Workspace
SafeZone.Size = Vector3.new(50, 2, 50)
SafeZone.CFrame = CFrame.new(9999, 9999, 9999)
SafeZone.Anchored = true

for i, v in pairs(FishingZonesFolder:GetChildren()) do
    if table.find(fisktable, v.Name) == nil then
        table.insert(fisktable, v.Name)
    end
end

FishingZonesFolder.ChildAdded:Connect(function(child)
    if table.find(fisktable, child.Name) == nil then
        table.insert(fisktable, child.Name)
    end
end)

for i, v in pairs(TpSpotsFolder:GetChildren()) do
    if table.find(teleportSpots, v.Name) == nil then
        table.insert(teleportSpots, v.Name)
    end
end

autoreel = PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") and GUI.Name == "reel" then
        if autoReel == true and ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished") ~= nil then
            repeat task.wait(autoReelDelay) ReplicatedStorage.events.reelfinished:FireServer(100, false) until GUI == nil
        end
    end
end)

autoshake = PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
        if GUI:FindFirstChild("safezone") ~= nil then
            GUI.safezone.ChildAdded:Connect(function(child)
                if child:IsA("ImageButton") and child.Name == "button" then
                    if autoShake == true then
                        task.wait(autoShakeDelay)
                        if child.Visible == true then
                            if autoShakeMethod == "ClickEvent" then
                                local pos = child.AbsolutePosition
                                local size = child.AbsoluteSize
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, LocalPlayer, 0)
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, LocalPlayer, 0)
                            --[[elseif autoShakeMethod == "firesignal" then
                                firesignal(child.MouseButton1Click)]]
                            elseif autoShakeMethod == "KeyCodeEvent" then
                                while WaitForSomeone(RenderStepped) do
                                    if autoShake and GUI.safezone:FindFirstChild(child.Name) ~= nil then
                                        task.wait()
                                        pcall(function()
                                            GuiService.SelectedObject = child
                                            if GuiService.SelectedObject == child then
                                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                            end
                                        end)
                                    else
                                        GuiService.SelectedObject = nil
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

main:AddTextbox({
	Name = "Auto Reel Delay",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		if Value > 2 then
        Value = 2
    end
      autoReelDelay = Value
	end	  
})


main:AddToggle({
	Name = "Auto Reel",
	Default = false,
	Callback = function(Value)
		autoReel = Value
	end    
})

main:AddDropdown({
	Name = "Auto Shake Method",
	Default = "ClickEvent",
	Options = {"ClickEvent", "KeyCodeEvent"},
	Callback = function(Value)
		autoShakeMethod = Value
	end    
})

main:AddTextbox({
	Name = "Auto Shake Delay",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		if Value > 1 then
        Value = 1
    end
      autoShakeDelay = Value
	end	  
})

main:AddToggle({
	Name = "Auto Shake",
	Default = false,
	Callback = function(Value)
		autoShake = Value
	end    
})

local rodequiped = false

autoCastConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil and autoCast == true then
			rodequiped = true
	task.spawn(function()
					while task.wait(autoCastDelay) and rodequiped == true do
					child.events.cast:FireServer(100)
					end
	end)
    end
end)

autoCastConnection2 = LocalCharacter.ChildRemoved:Connect(function(child)
if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil then
			rodequiped = false
		end
	end)

main:AddToggle({
    Name = "Auto Cast",
    Default = false,
    Callback = function(Value)
      autoCast = Value
    end
})

local tptab = Window:MakeTab({
    Name = "Teleport";
    Icon = "rbxassetid://12941020168";
    PremiumOnly = false;
  })

local tplace = ""

tptab:AddDropdown({
    Name = "Places",
	Default = "",
	Options = teleportSpots,
	Callback = function(Value)
		tplace = tostring(Value)
	end    
})

tptab:AddButton({
    Name = "Teleport to place";
    Callback = function()
      if teleportSpots ~= nil and HumanoidRootPart ~= nil then
            HumanoidRootPart.CFrame = TpSpotsFolder:FindFirstChild(Value).CFrame + Vector3.new(0, 5, 0)
        end
    end
  })
    

local lpc = Window:MakeTab({
    Name = "Misc";
    Icon = "rbxassetid://1402032193";
    PremiumOnly = false;
})


lpc:AddToggle({
    Name = "Inf Oxygen";
    Default = false;
    Callback = function(Value)
      AntiDrown = Value
        if AntiDrown == true then
            if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true then	
                LocalCharacter.client.oxygen.Enabled = false	
            end	
            CharAddedAntiDrownCon = LocalPlayer.CharacterAdded:Connect(function()	
                if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true and AntiDrown == true then	
                    LocalCharacter.client.oxygen.Enabled = false	
                end	
            end)
        else	
            if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == false then	
                LocalCharacter.client.oxygen.Enabled = true	
            end	
        end
    end
  })

local idkwhattoputheresoiputthislol = false

lpc:AddToggle({
    Name = "Anti-AFK";
    Default = false;
    Callback = function(Value)
      idkwhattoputheresoiputthislol = Value
    end
  })

OrionLib:Init()

while idkwhattoputheresoiputthislol == true do
  VirtualUser:CaptureController()
  VirtualUser:ClickButton2(Vector2.new())
  wait(60)
end
