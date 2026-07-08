game:GetService("CoreGui"):WaitForChild("RobloxGui")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D

Color3.new(0.2, 0.2, 0.2)

local _ = Enum.FontSize.Size36

Color3.new(1, 1, 1)

local v7 = CFrame.new(0, 0, -7) * CFrame.Angles(0, 3.141592653589793, 0)

Create("ImageLabel")({
	Name = "EmptySelectionImage",
	Image = "",
	BackgroundTransparency = 1,
	ImageTransparency = 1
})

local v8 = Panel3D.Get("Dialog")

v8:SetType(Panel3D.Type.Fixed)
v8.localCF = v7
v8:SetCanFade(true)

local n1 = 0
local t1 = {}
local u11 = false
local n2 = 0

local function positionDialogPanel(p1) -- line: 46
	-- upvalues: n1 (ref), UserInputService (copy), v8 (copy), v7 (copy)
	n1 = p1

	local p = UserInputService:GetUserCFrame(Enum.UserCFrame.Head).p

	v8.localCF = CFrame.new(p) * CFrame.Angles(0, p1, 0) * v7
end

function v8.CalculateTransparency(_) -- line: 53
	-- upvalues: UserInputService (copy), n2 (ref), n1 (ref), u11 (ref)
	local UserCFrame = UserInputService:GetUserCFrame(Enum.UserCFrame.Head)
	local v25 = UserCFrame.lookVector * Vector3.new(1, 0, 1)
	local v26 = math.asin(UserCFrame.lookVector.Y)
	local vector3 = Vector3.new(math.cos(n2 + n1 + 1.5707963267948966), 0, -math.sin(n2 + n1 + 1.5707963267948966))

	if math.abs(v26) > 0.767944870877505 then
		u11 = true
	end

	return (math.min(math.max(0, (math.acos((v25:Dot(vector3))) - 0.6544984694978736) / 0.11344640137963136), 1))
end

local function updatePanelPosition() -- line: 69
	-- upvalues: UserInputService (copy), n2 (ref), u11 (ref), n1 (ref), v8 (copy), v7 (copy)
	local v28 = UserInputService:GetUserCFrame(Enum.UserCFrame.Head).lookVector * Vector3.new(1, 0, 1)
	local v29 = (math.atan2(-v28.Z, v28.X) - 1.5707963267948966) % 6.283185307179586
	local v30 = n2 + math.floor(v29 / 1.5707963267948966 + 0.5) * 1.5707963267948966

	if u11 then
		u11 = false
		n2 = v29
	end

	n1 = v30

	local p = UserInputService:GetUserCFrame(Enum.UserCFrame.Head).p

	v8.localCF = CFrame.new(p) * CFrame.Angles(0, v30, 0) * v7
end

function dialogPanelRenderUpdate() -- line: 84
	-- upvalues: v8 (copy), u11 (ref), updatePanelPosition (copy), t1 (ref)
	if v8.transparency == 1 or u11 then
		updatePanelPosition()
	end

	local v32 = 1 - v8.transparency

	for k, v in pairs(t1) do
		local v35 = 1 - v * v32

		if k:IsA("TextLabel") or k:IsA("TextButton") then
			k.TextTransparency = v35
		elseif k:IsA("ImageLabel") or k:IsA("ImageButton") then
			k.ImageTransparency = v35
		elseif k:IsA("Frame") then
			k.BackgroundTransparency = v35
		end
	end
end

local t2 = {}
local u16 = nil
local u17 = nil

local function updatePanel() -- line: 107
	-- upvalues: t2 (copy), u17 (ref), v8 (copy), t1 (ref), u16 (ref), u11 (ref), updatePanelPosition (copy)
	local v36 = t2[1]

	if u17 and u17.content then
		u17.content.Parent = nil
	end

	if not v36 or not v36.content then
		v8:SetVisible(false)
		t1 = {}

		if u16 then
			u16:disconnect()
			u16 = nil

			return
		end
	else
		v36.content.Parent = v8:GetGUI()
		u17 = v36

		local AbsoluteSize = v36.content.AbsoluteSize

		v8:ResizePixels(AbsoluteSize.X, AbsoluteSize.Y, 100)
		u11 = true
		updatePanelPosition()
		v8:SetVisible(true)
		t1 = {}

		local function search(p3) -- line: 131
			-- upvalues: t1 (ref), search (copy)
			if p3:IsA("ImageLabel") or p3:IsA("ImageButton") then
				t1[p3] = 1 - p3.ImageTransparency
			elseif p3:IsA("TextLabel") or p3:IsA("TextButton") then
				t1[p3] = 1 - p3.TextTransparency
			elseif p3:IsA("Frame") then
				t1[p3] = 1 - p3.BackgroundTransparency
			end

			for _, child in pairs(p3:GetChildren()) do
				search(child)
			end
		end

		search(v8:GetGUI())

		if u16 then
			u16:disconnect()
			u16 = nil
		end

		u16 = v8:GetGUI().DescendantAdded:connect(function(p4) -- line: 148
			-- upvalues: search (copy)
			search(p4)
		end)
	end
end

local t3 = {}

t3.__index = t3

function t3.new(p5) -- line: 160
	-- upvalues: t3 (copy)
	local self = setmetatable({}, t3)

	self.content = p5

	return self
end
function t3.SetContent(p6, p7) -- line: 166
	if not p7 and p6.content then
		p6.content.Parent = nil
	end

	p6.content = p7
end

local u20 = false

function t3.Show(p8, p9) -- line: 174
	-- upvalues: u20 (ref), RunService (copy), t2 (copy), updatePanel (copy)
	if not u20 then
		u20 = true
		RunService:BindToRenderStep("DialogPanel", Enum.RenderPriority.First.Value, dialogPanelRenderUpdate)
	end

	if p9 then
		table.insert(t2, 1, p8)
	else
		table.insert(t2, p8)
	end

	updatePanel()
end
function t3.Close(p10) -- line: 187
	-- upvalues: t2 (copy), u20 (ref), RunService (copy), updatePanel (copy)
	for k, v in pairs(t2) do
		if v == p10 then
			table.remove(t2, k)

			break
		end
	end

	if u20 and #t2 == 0 then
		u20 = false
		RunService:UnbindFromRenderStep("DialogPanel")
	end

	updatePanel()
end

return t3
