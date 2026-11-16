local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local Panel3D = VrCommon.Panel3D

Color3.new(0.2, 0.2, 0.2)

local Size36 = Enum.FontSize.Size36

Color3.new(1, 1, 1)

local localCF = CFrame.new(0, 0, -7) * CFrame.Angles(0, 3.141592653589793, 0)

Create("ImageLabel")({
	Name = "EmptySelectionImage",
	Image = "",
	BackgroundTransparency = 1,
	ImageTransparency = 1
})

local dialog = Panel3D.Get("Dialog")
dialog:SetType(Panel3D.Type.Fixed)
dialog.localCF = localCF
dialog:SetCanFade(true)

local v = 0
local v2 = {}
local flag = false
local v3 = 0

local function positionDialogPanel(p) -- 1 equivalent call inferred from this helper
	v = p
	local p2 = UserInputService:GetUserCFrame(Enum.UserCFrame.Head).p
	dialog.localCF = CFrame.new(p2) * CFrame.Angles(0, p, 0) * localCF
end

function dialog.CalculateTransparency(_)
	local userCFrame = UserInputService:GetUserCFrame(Enum.UserCFrame.Head)
	local vector = userCFrame.lookVector * Vector3.new(1, 0, 1)
	local v4 = math.asin(userCFrame.lookVector.Y)
	local vector3 = Vector3.new(math.cos(v3 + v + 1.5707963267948966), 0, -math.sin(v3 + v + 1.5707963267948966))

	if math.abs(v4) > 0.767944870877505 then
		flag = true
	end

	return (math.min(math.max(0, (math.acos((vector:Dot(vector3))) - 0.6544984694978736) / 0.11344640137963136), 1))
end

local function updatePanelPosition()
	local v4 = UserInputService:GetUserCFrame(Enum.UserCFrame.Head).lookVector * Vector3.new(1, 0, 1)
	local v5 = (math.atan2(-v4.Z, v4.X) - 1.5707963267948966) % 6.283185307179586
	local v6 = v3 + math.floor(v5 / 1.5707963267948966 + 0.5) * 1.5707963267948966

	if flag then
		flag = false
		v3 = v5
	end

	positionDialogPanel(v6) -- inferred equivalent call
end

function dialogPanelRenderUpdate()
	if dialog.transparency == 1 or flag then
		updatePanelPosition()
	end

	local v4 = 1 - dialog.transparency

	for guiObject, v5 in pairs(v2) do
		local v6 = 1 - v5 * v4

		if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
			guiObject.TextTransparency = v6
		elseif guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
			guiObject.ImageTransparency = v6
		elseif guiObject:IsA("Frame") then
			guiObject.BackgroundTransparency = v6
		end
	end
end

local v4 = {}

local descendantAddedConnection = nil
local v5 = nil
local function updatePanel()
	local v6 = v4[1]

	if v5 and v5.content then
		v5.content.Parent = nil
	end

	if v6 and v6.content then
		v6.content.Parent = dialog:GetGUI()
		v5 = v6

		local absoluteSize = v6.content.AbsoluteSize
		dialog:ResizePixels(absoluteSize.X, absoluteSize.Y, 100)

		flag = true
		updatePanelPosition()
		dialog:SetVisible(true)

		v2 = {}
		local function search(guiObject)
			if guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
				v2[guiObject] = 1 - guiObject.ImageTransparency
			elseif guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
				v2[guiObject] = 1 - guiObject.TextTransparency
			elseif guiObject:IsA("Frame") then
				v2[guiObject] = 1 - guiObject.BackgroundTransparency
			end

			for _, child in pairs(guiObject:GetChildren()) do
				search(child)
			end
		end
		search(dialog:GetGUI())

		if descendantAddedConnection then
			descendantAddedConnection:disconnect()
			descendantAddedConnection = nil
		end

		descendantAddedConnection = dialog:GetGUI().DescendantAdded:connect(function(p)
			search(p)
		end)
	else
		dialog:SetVisible(false)
		v2 = {}

		if descendantAddedConnection then
			descendantAddedConnection:disconnect()
			descendantAddedConnection = nil
		end
	end
end

local Dialog = {}
Dialog.__index = Dialog
function Dialog.new(content)
	local self = setmetatable({}, Dialog)
	self.content = content
	return self
end

function Dialog:SetContent(content)
	if not content and self.content then
		self.content.Parent = nil
	end

	self.content = content
end

local v6 = false
function Dialog.Show(p, p2)
	if not v6 then
		v6 = true
		RunService:BindToRenderStep("DialogPanel", Enum.RenderPriority.First.Value, dialogPanelRenderUpdate)
	end

	if p2 then
		table.insert(v4, 1, p)
	else
		table.insert(v4, p)
	end

	updatePanel()
end

function Dialog.Close(p)
	for k, v7 in pairs(v4) do
		if v7 == p then
			table.remove(v4, k)
			break
		end
	end

	if v6 and #v4 == 0 then
		v6 = false
		RunService:UnbindFromRenderStep("DialogPanel")
	end

	updatePanel()
end

return Dialog
