local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local u8 = false
local t1 = {
	ModuleName = "Recenter",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = false
}

VRHub:RegisterModule(t1)

local v10 = Panel3D.Get("RecenterCountdown")

v10:SetType(Panel3D.Type.HorizontalFollow)
v10:ResizeStuds(5, 3, 128)
v10:SetCanFade(false)

local v11 = Create("TextLabel")({
	BackgroundTransparency = 0.9,
	Text = "",
	TextScaled = true,
	Visible = true,
	Parent = v10:GetGUI(),
	Position = UDim2.new(0.5, -64, 0.5, -64),
	Size = UDim2.new(0, 128, 0, 128),
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.SourceSansBold
})

Create("ImageLabel")({
	BackgroundTransparency = 1,
	Image = "rbxasset://textures/ui/VR/recenterFrame.png",
	Parent = v10:GetGUI(),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0)
})
v10:SetVisible(false)

local u12 = false

local function cancelCountdown() -- line: 55
	-- upvalues: u12 (ref), v10 (copy)
	u12 = false
	v10:SetVisible(false)
end

VRHub.ModuleOpened.Event:connect(function(p1) -- line: 60
	-- upvalues: t1 (copy), VRHub (copy), u12 (ref), v10 (copy)
	if p1 ~= t1.ModuleName and VRHub:GetModule(p1).VRIsExclusive then
		u12 = false
		v10:SetVisible(false)
	end
end)

function t1.SetVisible(_, p3) -- line: 69
	-- upvalues: u8 (ref), u12 (ref), v10 (copy), VRHub (copy), t1 (copy), ContextActionService (copy), v11 (copy), UserInputService (copy)
	u8 = p3

	if u8 then
		if u12 then
			u12 = false
			v10:SetVisible(false)
			VRHub:FireModuleClosed(t1.ModuleName)

			return
		end

		VRHub:FireModuleOpened(t1.ModuleName)
		spawn(function() -- line: 81
			-- upvalues: u12 (ref), v10 (copy), ContextActionService (copy), v11 (copy), UserInputService (copy), VRHub (copy), t1 (copy)
			u12 = true
			v10:SetVisible(true)
			ContextActionService:BindCoreAction("CancelRecenterShortcut", function(_, p5, _) -- line: 85
				-- upvalues: u12 (ref), v10 (copy)
				if p5 == Enum.UserInputState.Begin then
					u12 = false
					v10:SetVisible(false)
				end
			end, false, Enum.KeyCode.ButtonB)

			if u12 then
				v11.Text = tostring(3)
				wait(1)
			end

			if u12 then
				v11.Text = tostring(2)
				wait(1)
			end

			if u12 then
				v11.Text = tostring(1)
				wait(1)
			end

			if u12 then
				UserInputService:RecenterUserHeadCFrame()
			end

			v10:SetVisible(false)
			u12 = false
			ContextActionService:UnbindCoreAction("CancelRecenterShortcut")
			VRHub:FireModuleClosed(t1.ModuleName)
		end)

		return
	end

	u12 = false
	v10:SetVisible(false)
	VRHub:FireModuleClosed(t1.ModuleName)
end
function t1.IsVisible(_) -- line: 115
	-- upvalues: u8 (ref)
	return u8
end

return t1
