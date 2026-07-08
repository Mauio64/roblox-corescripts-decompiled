local color3 = Color3.new(0.8941176470588236, 0.9254901960784314, 0.9647058823529412)
local color3_2 = Color3.new(1, 0.10980392156862745, 0)
local color3_3 = Color3.new(0.9803921568627451, 0.9215686274509803, 0)
local color3_4 = Color3.new(0.10588235294117647, 0.9882352941176471, 0.4196078431372549)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Frame = Instance.new("Frame")

Frame.Name = "HealthbarContainer"
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.new(1, 0, 1, 0)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.ImageColor3 = color3
ImageLabel.BackgroundTransparency = 1
ImageLabel.ScaleType = Enum.ScaleType.Slice
ImageLabel.SliceCenter = Rect.new(10, 10, 10, 10)
ImageLabel.Name = "HealthbarBack"
ImageLabel.Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png"
ImageLabel.Size = UDim2.new(1, 0, 0.3, 0)
ImageLabel.Position = UDim2.new(0, 0, 0.7, 0)
ImageLabel.Parent = Frame

local ImageLabel2 = Instance.new("ImageLabel")

ImageLabel2.ImageColor3 = color3_4
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.ScaleType = Enum.ScaleType.Slice
ImageLabel2.SliceCenter = Rect.new(10, 10, 10, 10)
ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
ImageLabel2.Position = UDim2.new(0, 0, 0, 0)
ImageLabel2.Name = "HealthbarFill"
ImageLabel2.Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png"
ImageLabel2.Parent = ImageLabel

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "PlayerName"
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Text = ""
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.FontSize = Enum.FontSize.Size24
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Size = UDim2.new(1, 0, 0, 14)
TextLabel.Parent = Frame

local function Color3ToVec3(p1) -- line: 67
	return (Vector3.new(p1.r, p1.g, p1.b))
end
local function FindChildOfType(p2, p3) -- line: 71
	for _, child in pairs(p2:GetChildren()) do
		if child:IsA(p3) then
			return child
		end
	end
end

local t1 = {
	[Vector3.new(color3_2.r, color3_2.g, color3_2.b)] = 0.1,
	[Vector3.new(color3_3.r, color3_3.g, color3_3.b)] = 0.5,
	[Vector3.new(color3_4.r, color3_4.g, color3_4.b)] = 0.8
}

local function HealthbarColorTransferFunction(p4) -- line: 87
	-- upvalues: color3_2 (copy), color3_4 (copy), t1 (copy)
	if p4 <= 0.1 then
		return color3_2
	end

	if p4 >= 0.8 then
		return color3_4
	end

	local vector3 = Vector3.new(0, 0, 0)
	local n1 = 0

	for k, v in pairs(t1) do
		local v44 = p4 - v

		if v44 == 0 then
			return Color3.new(k.x, k.y, k.z)
		end

		local v45 = 1 / (v44 * v44)

		vector3 += v45 * k
		n1 += v45
	end

	local v46 = vector3 / n1

	return Color3.new(v46.x, v46.y, v46.z)
end
local function UpdateHealth(p5) -- line: 113
	-- upvalues: ImageLabel2 (copy), HealthbarColorTransferFunction (copy)
	local v48 = p5.Health / p5.MaxHealth

	if v48 ~= v48 then
		v48 = 1
	end

	ImageLabel2.ImageColor3 = HealthbarColorTransferFunction(v48)
	ImageLabel2.Size = UDim2.new(v48, 0, 1, 0)
end

local u19 = nil
local u20 = nil

local function RegisterHumanoid(p6) -- line: 124
	-- upvalues: u20 (ref), u19 (ref), Players (copy), RegisterHumanoid (copy), ImageLabel2 (copy), HealthbarColorTransferFunction (copy)
	if u20 then
		u20:disconnect()
		u20 = nil
	end

	if u19 then
		u19:disconnect()
		u19 = nil
	end

	if p6 then
		u20 = p6.AncestryChanged:connect(function(p7, p8) -- line: 135
			-- upvalues: Players (copy), p6 (copy), RegisterHumanoid (copy)
			local LocalPlayer = Players.LocalPlayer

			if p7 == p6 and (not LocalPlayer or p8 ~= LocalPlayer.Character) then
				RegisterHumanoid(nil)
			end
		end)
		u19 = p6.HealthChanged:connect(function() -- line: 141
			-- upvalues: p6 (copy), ImageLabel2 (copy), HealthbarColorTransferFunction (copy)
			local v74 = p6
			local v75 = v74.Health / v74.MaxHealth

			if v75 ~= v75 then
				v75 = 1
			end

			ImageLabel2.ImageColor3 = HealthbarColorTransferFunction(v75)
			ImageLabel2.Size = UDim2.new(v75, 0, 1, 0)
		end)

		local v50 = p6.Health / p6.MaxHealth

		if v50 ~= v50 then
			v50 = 1
		end

		ImageLabel2.ImageColor3 = HealthbarColorTransferFunction(v50)
		ImageLabel2.Size = UDim2.new(v50, 0, 1, 0)
	end
end
local function OnCharacterChildAdded(p9) -- line: 146
	-- upvalues: Players (copy), RegisterHumanoid (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer and (p9.Parent == LocalPlayer.Character and p9:IsA("Humanoid")) then
		RegisterHumanoid(p9)
	end
end

local u23 = nil

local function OnCharacterAdded(p10) -- line: 154
	-- upvalues: FindChildOfType (copy), RegisterHumanoid (copy), u23 (ref), OnCharacterChildAdded (copy)
	local v54 = FindChildOfType(p10, "Humanoid")

	if v54 then
		RegisterHumanoid(v54)
	end

	if u23 then
		u23:disconnect()
		u23 = nil
	end

	u23 = p10.ChildAdded:connect(OnCharacterChildAdded)
end
local function OnPlayerAdded(p11) -- line: 167
	-- upvalues: TextLabel (copy), OnCharacterAdded (copy), FindChildOfType (copy), RegisterHumanoid (copy), u23 (ref), OnCharacterChildAdded (copy)
	TextLabel.Text = p11.Name
	p11.CharacterAdded:connect(OnCharacterAdded)

	if p11.Character then
		local Character = p11.Character
		local v57 = FindChildOfType(Character, "Humanoid")

		if v57 then
			RegisterHumanoid(v57)
		end

		if u23 then
			u23:disconnect()
			u23 = nil
		end

		u23 = Character.ChildAdded:connect(OnCharacterChildAdded)
	end
end

if Players.LocalPlayer then
	local LocalPlayer = Players.LocalPlayer

	TextLabel.Text = LocalPlayer.Name
	LocalPlayer.CharacterAdded:connect(OnCharacterAdded)

	if LocalPlayer.Character then
		local Character = LocalPlayer.Character
		local v28 = FindChildOfType(Character, "Humanoid")

		if v28 then
			RegisterHumanoid(v28)
		end

		if u23 then
			u23:disconnect()
			u23 = nil
		end

		u23 = Character.ChildAdded:connect(OnCharacterChildAdded)
	end
else
	spawn(function() -- line: 179
		-- upvalues: Players (copy), TextLabel (copy), OnCharacterAdded (copy), FindChildOfType (copy), RegisterHumanoid (copy), u23 (ref), OnCharacterChildAdded (copy)
		while not Players.LocalPlayer do
			Players.ChildAdded:wait()
		end

		local LocalPlayer = Players.LocalPlayer

		TextLabel.Text = LocalPlayer.Name
		LocalPlayer.CharacterAdded:connect(OnCharacterAdded)

		if LocalPlayer.Character then
			local Character = LocalPlayer.Character
			local v60 = FindChildOfType(Character, "Humanoid")

			if v60 then
				RegisterHumanoid(v60)
			end

			if u23 then
				u23:disconnect()
				u23 = nil
			end

			u23 = Character.ChildAdded:connect(OnCharacterChildAdded)
		end
	end)
end

local t2 = {
	ModuleName = "Healthbar",
	KeepVRTopbarOpen = false,
	VRIsExclusive = false,
	VRClosesNonExclusive = false
}
local u30 = nil
local u31 = nil
local u32 = nil

local function OnVREnabled(p12) -- line: 195
	-- upvalues: UserInputService (copy), CorePackages (copy), ImageLabel (copy), ImageLabel2 (copy), TextLabel (copy), StarterGui (copy), u30 (ref), u31 (ref), u32 (ref), Frame (copy), t2 (copy)
	if p12 == "VREnabled" then
		if UserInputService.VREnabled then
			local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
			local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
			local v64 = Panel3D.Get("Healthbar")

			v64:ResizeStuds(1.5, 0.25, 128)
			v64:SetType(Panel3D.Type.Fixed, {
				CFrame = CFrame.new(0, 0, -5)
			})
			v64:SetVisible(true)

			function v64.PreUpdate(p13, _, _, _, _) -- line: 207
				-- upvalues: Panel3D (copy), v64 (copy)
				local v81 = Panel3D.Get("Backpack") or Panel3D.Get("Topbar3D")
				local v82 = Panel3D.Get("Topbar3D")

				if v81 and v82 then
					p13.localCF = (v81.localCF or CFrame.new()) * CFrame.new(math.max(v82.width, v81.width) / 2 - v64.width / 2 - 0.11, 0.25, 0.1)
				end
			end
			function v64.CalculateTransparency(_) -- line: 217
				-- upvalues: Panel3D (copy), ImageLabel (copy), ImageLabel2 (copy), TextLabel (copy)
				local v84 = Panel3D.Get("Backpack")
				local v85 = Panel3D.Get("Topbar3D")
				local v86 = math.min(v84 and (not not v84:IsVisible() and v84:CalculateTransparency()) or 1, v85 and (not not v85:IsVisible() and v85:CalculateTransparency()) or 1)

				ImageLabel.ImageTransparency = v86
				ImageLabel2.ImageTransparency = v86
				TextLabel.TextTransparency = v86

				return v86
			end

			local u65 = false

			local function UpdateExclusivePanelOpen() -- line: 232
				-- upvalues: VRHub (copy), u65 (ref)
				for _, v in pairs(VRHub:GetOpenedModules()) do
					if v.VRIsExclusive then
						u65 = true

						return
					end
				end

				u65 = false
			end
			local function CalculateVisibility() -- line: 242
				-- upvalues: StarterGui (copy), u65 (ref)
				return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not u65
			end

			u30 = StarterGui.CoreGuiChangedSignal:connect(function() -- line: 248
				-- upvalues: v64 (copy), StarterGui (copy), u65 (ref)
				v64:SetVisible(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not u65)
			end)
			u31 = VRHub.ModuleOpened.Event:connect(function(_) -- line: 252
				-- upvalues: VRHub (copy), u65 (ref), v64 (copy), StarterGui (copy)
				local g92 = nil

				for _, v in pairs(VRHub:GetOpenedModules()) do
					if v.VRIsExclusive then
						u65 = true
						g92 = true
					end

					if g92 then
						break
					end
				end

				if not g92 then
					u65 = false
				end

				g92 = false
				v64:SetVisible(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not u65)
			end)
			u32 = VRHub.ModuleClosed.Event:connect(function(_) -- line: 256
				-- upvalues: VRHub (copy), u65 (ref), v64 (copy), StarterGui (copy)
				local g96 = nil

				for _, v in pairs(VRHub:GetOpenedModules()) do
					if v.VRIsExclusive then
						u65 = true
						g96 = true
					end

					if g96 then
						break
					end
				end

				if not g96 then
					u65 = false
				end

				g96 = false
				v64:SetVisible(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not u65)
			end)

			local g70 = nil

			for _, v in pairs(VRHub:GetOpenedModules()) do
				if v.VRIsExclusive then
					u65 = true
					g70 = true
				end

				if g70 then
					break
				end
			end

			if not g70 then
				u65 = false
			end

			g70 = false
			v64:SetVisible(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) and not u65)
			Frame.Parent = v64:GetGUI()
			VRHub:RegisterModule(t2)

			return
		end

		if u30 then
			u30:disconnect()
			u30 = nil
		end

		if u31 then
			u31:disconnect()
			u31 = nil
		end

		if u32 then
			u32:disconnect()
			u32 = nil
		end

		Frame.Parent = nil
	end
end

UserInputService.Changed:connect(OnVREnabled)

if UserInputService.VREnabled then
	OnVREnabled("VREnabled")
end

return t2
