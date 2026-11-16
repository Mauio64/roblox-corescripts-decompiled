local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
CoreGui:WaitForChild("RobloxGui")
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local Panel3D = VrCommon.Panel3D
local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon2.VRHub
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local v = false

local Recenter = {
	["ModuleName"] = nil,
	ModuleName = "Recenter",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = false
}

VRHub:RegisterModule(Recenter)

local recenterCountdown = Panel3D.Get("RecenterCountdown")
recenterCountdown:SetType(Panel3D.Type.HorizontalFollow)
recenterCountdown:ResizeStuds(5, 3, 128)
recenterCountdown:SetCanFade(false)

local v2 = Create("TextLabel")({
	Parent = recenterCountdown:GetGUI(),
	Position = UDim2.new(0.5, -64, 0.5, -64),
	Size = UDim2.new(0, 128, 0, 128),
	BackgroundTransparency = 0.9,
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	TextColor3 = Color3.new(1, 1, 1),
	Text = "",
	TextScaled = true,
	Font = Enum.Font.SourceSansBold,
	Visible = true
})

Create("ImageLabel")({
	Parent = recenterCountdown:GetGUI(),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Image = "rbxasset://textures/ui/VR/recenterFrame.png"
})

recenterCountdown:SetVisible(false)

local flag = false
local function cancelCountdown() -- 3 equivalent calls inferred from this helper
	flag = false
	recenterCountdown:SetVisible(false)
end

VRHub.ModuleOpened.Event:connect(function(p)
	if p ~= Recenter.ModuleName and VRHub:GetModule(p).VRIsExclusive then
		cancelCountdown() -- inferred equivalent call
	end
end)

function Recenter:SetVisible(p)
	v = p

	if v then
		if flag then
			cancelCountdown() -- inferred equivalent call
			VRHub:FireModuleClosed(Recenter.ModuleName)
		else
			VRHub:FireModuleOpened(Recenter.ModuleName)

			spawn(function()
				flag = true
				recenterCountdown:SetVisible(true)

				ContextActionService:BindCoreAction("CancelRecenterShortcut", function(_, p2, _)
					if p2 == Enum.UserInputState.Begin then
						flag = false
						recenterCountdown:SetVisible(false)
					end
				end, false, Enum.KeyCode.ButtonB)

				if flag then
					v2.Text = tostring(3)
					wait(1)
				end

				if flag then
					v2.Text = tostring(2)
					wait(1)
				end

				if flag then
					v2.Text = tostring(1)
					wait(1)
				end

				if flag then
					UserInputService:RecenterUserHeadCFrame()
				end

				recenterCountdown:SetVisible(false)
				flag = false

				ContextActionService:UnbindCoreAction("CancelRecenterShortcut")

				VRHub:FireModuleClosed(Recenter.ModuleName)
			end)
		end
	else
		cancelCountdown() -- inferred equivalent call
		VRHub:FireModuleClosed(Recenter.ModuleName)
	end
end

function Recenter.IsVisible(_)
	return v
end

return Recenter
