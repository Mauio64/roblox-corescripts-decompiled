local color = Color3.new(228 / 255, 236 / 255, 246 / 255)
local color2 = Color3.new(1, 28 / 255, 0)
local color3 = Color3.new(250 / 255, 235 / 255, 0)
local color4 = Color3.new(27 / 255, 252 / 255, 107 / 255)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local healthbarContainer = Instance.new("Frame")
healthbarContainer.Name = "HealthbarContainer"
healthbarContainer.BackgroundTransparency = 1
healthbarContainer.Size = UDim2.new(1, 0, 1, 0)

local healthbarBack = Instance.new("ImageLabel")
healthbarBack.ImageColor3 = color
healthbarBack.BackgroundTransparency = 1
healthbarBack.ScaleType = Enum.ScaleType.Slice
healthbarBack.SliceCenter = Rect.new(10, 10, 10, 10)
healthbarBack.Name = "HealthbarBack"
healthbarBack.Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png"
healthbarBack.Size = UDim2.new(1, 0, 0.3, 0)
healthbarBack.Position = UDim2.new(0, 0, 0.7, 0)
healthbarBack.Parent = healthbarContainer

local healthbarFill = Instance.new("ImageLabel")
healthbarFill.ImageColor3 = color4
healthbarFill.BackgroundTransparency = 1
healthbarFill.ScaleType = Enum.ScaleType.Slice
healthbarFill.SliceCenter = Rect.new(10, 10, 10, 10)
healthbarFill.Size = UDim2.new(1, 0, 1, 0)
healthbarFill.Position = UDim2.new(0, 0, 0, 0)
healthbarFill.Name = "HealthbarFill"
healthbarFill.Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png"
healthbarFill.Parent = healthbarBack

local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.BackgroundTransparency = 1
playerName.TextColor3 = Color3.new(1, 1, 1)
playerName.Text = ""
playerName.Font = Enum.Font.SourceSansBold
playerName.FontSize = Enum.FontSize.Size24
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Size = UDim2.new(1, 0, 0, 14)
playerName.Parent = healthbarContainer

local function Color3ToVec3(color5) -- 3 equivalent calls inferred from this helper
	return (Vector3.new(color5.r, color5.g, color5.b))
end

local function FindChildOfType(instance, className)
	for _, child in pairs(instance:GetChildren()) do
		if child:IsA(className) then
			return child
		end
	end
end

local v = {
	[Color3ToVec3(color2)] = 0.1, -- inferred equivalent call
	[Color3ToVec3(color3)] = 0.5, -- inferred equivalent call
	[Color3ToVec3(color4)] = 0.8 -- inferred equivalent call
}

local function HealthbarColorTransferFunction(p)
	if p <= 0.1 then
		return color2
	end

	if p >= 0.8 then
		return color4
	end

	local total = Vector3.new(0, 0, 0)
	local total2 = 0

	for k, v2 in pairs(v) do
		local v3 = p - v2

		if v3 == 0 then
			return Color3.new(k.x, k.y, k.z)
		end

		local v4 = 1 / (v3 * v3)
		total += v4 * k
		total2 += v4
	end

	local v2 = total / total2
	return Color3.new(v2.x, v2.y, v2.z)
end

local function UpdateHealth(instance) -- 2 equivalent calls inferred from this helper
	local v2 = instance.Health / instance.MaxHealth
	local v3 = v2 ~= v2 and 1 or v2
	healthbarFill.ImageColor3 = HealthbarColorTransferFunction(v3)
	healthbarFill.Size = UDim2.new(v3, 0, 1, 0)
end

local healthChangedConnection = nil
local ancestryChangedConnection = nil
local function RegisterHumanoid(instance)
	if ancestryChangedConnection then
		ancestryChangedConnection:disconnect()
		ancestryChangedConnection = nil
	end

	if healthChangedConnection then
		healthChangedConnection:disconnect()
		healthChangedConnection = nil
	end

	if instance then
		ancestryChangedConnection = instance.AncestryChanged:connect(function(p, p2)
			local localPlayer = Players.LocalPlayer

			if p == instance and (not localPlayer or p2 ~= localPlayer.Character) then
				RegisterHumanoid(nil)
			end
		end)
		healthChangedConnection = instance.HealthChanged:connect(function()
			UpdateHealth(instance) -- inferred equivalent call
		end)
		UpdateHealth(instance) -- inferred equivalent call
	end
end

local function OnCharacterChildAdded(humanoid)
	local localPlayer = Players.LocalPlayer

	if localPlayer and humanoid.Parent == localPlayer.Character and humanoid:IsA("Humanoid") then
		RegisterHumanoid(humanoid)
	end
end

local childAddedConnection = nil
local function OnCharacterAdded(character) -- 1 equivalent call inferred from this helper
	local childOfType = FindChildOfType(character, "Humanoid")

	if childOfType then
		RegisterHumanoid(childOfType)
	end

	if childAddedConnection then
		childAddedConnection:disconnect()
		childAddedConnection = nil
	end

	childAddedConnection = character.ChildAdded:connect(OnCharacterChildAdded)
end

local function OnPlayerAdded(localPlayer) -- 2 equivalent calls inferred from this helper
	playerName.Text = localPlayer.Name

	localPlayer.CharacterAdded:connect(OnCharacterAdded)

	if localPlayer.Character then
		OnCharacterAdded(localPlayer.Character) -- inferred equivalent call
	end
end

if Players.LocalPlayer then
	OnPlayerAdded(Players.LocalPlayer) -- inferred equivalent call
else
	spawn(function()
		while not Players.LocalPlayer do
			Players.ChildAdded:wait()
		end

		OnPlayerAdded(Players.LocalPlayer) -- inferred equivalent call
	end)
end

local Healthbar3D = {
	ModuleName = "Healthbar",
	KeepVRTopbarOpen = false,
	VRIsExclusive = false,
	VRClosesNonExclusive = false
}

local coreGuiChangedSignalConnection = nil
local eventConnection = nil
local eventConnection2 = nil
local function OnVREnabled(p)
	if p == "VREnabled" then
		if UserInputService.VREnabled then
			local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
			local vrHub = VrCommon.VRHub
			local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
			local panel3D = VrCommon2.Panel3D

			local healthbar = panel3D.Get("Healthbar")
			healthbar:ResizeStuds(1.5, 0.25, 128)
			healthbar:SetType(panel3D.Type.Fixed, { CFrame = CFrame.new(0, 0, -5) })
			healthbar:SetVisible(true)

			function healthbar:PreUpdate(_, _, _, _)
				local backpack = panel3D.Get("Backpack") or panel3D.Get("Topbar3D")
				local topbar3D = panel3D.Get("Topbar3D")

				if backpack and topbar3D then
					self.localCF = (backpack.localCF or CFrame.new()) * CFrame.new(
						math.max(topbar3D.width, backpack.width) / 2 - healthbar.width / 2 - 0.11,
						0.25,
						0.1
					)
				end
			end

			function healthbar:CalculateTransparency()
				local backpack = panel3D.Get("Backpack")
				local topbar3D = panel3D.Get("Topbar3D")
				local transparency = math.min(
					backpack and backpack:IsVisible() and backpack:CalculateTransparency() or 1,
					topbar3D and topbar3D:IsVisible() and topbar3D:CalculateTransparency() or 1
				)

				healthbarBack.ImageTransparency = transparency
				healthbarFill.ImageTransparency = transparency
				playerName.TextTransparency = transparency

				return transparency
			end

			local v2 = false
			local function UpdateExclusivePanelOpen()
				for _, v3 in pairs(vrHub:GetOpenedModules()) do
					if v3.VRIsExclusive then
						v2 = true
						return
					end
				end

				v2 = false
			end

			local function CalculateVisibility() -- 4 equivalent calls inferred from this helper
				return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not v2
			end

			coreGuiChangedSignalConnection = StarterGui.CoreGuiChangedSignal:connect(function()
				healthbar:SetVisible(CalculateVisibility()) -- inferred equivalent call
			end)

			eventConnection = vrHub.ModuleOpened.Event:connect(function(_)
				local flag = true

				for _, v3 in pairs(vrHub:GetOpenedModules()) do
					if v3.VRIsExclusive then
						v2 = true
						flag = false
						break
					end
				end

				if flag then
					v2 = false
				end

				healthbar:SetVisible(CalculateVisibility()) -- inferred equivalent call
			end)
			eventConnection2 = vrHub.ModuleClosed.Event:connect(function(_)
				local flag = true

				for _, v3 in pairs(vrHub:GetOpenedModules()) do
					if v3.VRIsExclusive then
						v2 = true
						flag = false
						break
					end
				end

				if flag then
					v2 = false
				end

				healthbar:SetVisible(CalculateVisibility()) -- inferred equivalent call
			end)
			local flag = true

			for _, v3 in pairs(vrHub:GetOpenedModules()) do
				if v3.VRIsExclusive then
					v2 = true
					flag = false
					break
				end
			end

			if flag then
				v2 = false
			end

			healthbar:SetVisible(CalculateVisibility()) -- inferred equivalent call
			healthbarContainer.Parent = healthbar:GetGUI()

			vrHub:RegisterModule(Healthbar3D)
		else
			if coreGuiChangedSignalConnection then
				coreGuiChangedSignalConnection:disconnect()
				coreGuiChangedSignalConnection = nil
			end

			if eventConnection then
				eventConnection:disconnect()
				eventConnection = nil
			end

			if eventConnection2 then
				eventConnection2:disconnect()
				eventConnection2 = nil
			end

			healthbarContainer.Parent = nil
		end
	end
end

UserInputService.Changed:connect(OnVREnabled)

if UserInputService.VREnabled then
	OnVREnabled("VREnabled")
end

return Healthbar3D
