local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local v = {
	UDim2.new(0, 123, 0, 70),
	UDim2.new(0, 30, 0, 60),
	UDim2.new(0, 180, 0, 160),
	UDim2.new(0, 85, 0, -25),
	UDim2.new(0, 185, 0, -25),
	UDim2.new(0, 185, 0, 260),
	(UDim2.new(0, 216, 0, 65))
}

local count = #v

local ContentProvider = game:GetService("ContentProvider")
ContentProvider:Preload("https://www.roblox.com/asset/?id=97166756")
local ContentProvider2 = game:GetService("ContentProvider")
ContentProvider2:Preload("https://www.roblox.com/asset/?id=97166444")

local CoreGui = game:GetService("CoreGui")
game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local CoreUtility = require(RobloxGui.Modules.CoreUtility)

local LocalPlayer = Players.LocalPlayer
local contextActionGui = nil
local contextButtonFrame = nil
local v2 = {}
local v3 = {}

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local parent = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerGui")

function createContextActionGui()
	if not contextActionGui then
		contextActionGui = Instance.new("ScreenGui")
		contextActionGui.Name = "ContextActionGui"
		contextActionGui.ResetOnSpawn = false

		contextButtonFrame = Instance.new("Frame")
		contextButtonFrame.BackgroundTransparency = 1
		contextButtonFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
		contextButtonFrame.Position = UDim2.new(0.7, 0, 0.5, 0)
		contextButtonFrame.Name = "ContextButtonFrame"
		contextButtonFrame.Parent = contextActionGui
		local function fn() -- 1 equivalent call inferred from this helper
			contextButtonFrame.Visible = UserInputService.PreferredInput == Enum.PreferredInput.Touch
				and GuiService.TouchControlsEnabled
		end

		GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(fn)
		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(fn)
		fn() -- inferred equivalent call
	end
end

function setButtonSizeAndPosition(p)
	local CoreGui2 = game:GetService("CoreGui")
	local v4 = not (CoreGui2.RobloxGui.AbsoluteSize.X < 600) and 85 or 55

	p.Size = UDim2.new(0, v4, 0, v4)
end

function contextActionButtonDown(p, p2, p3)
	p.Image = "https://www.roblox.com/asset/?id=97166756"
	ContextActionService:CallFunction(p3, Enum.UserInputState.Begin, p2)
end

function contextActionButtonMoved(p, p2, p3)
	p.Image = "https://www.roblox.com/asset/?id=97166756"
	ContextActionService:CallFunction(p3, Enum.UserInputState.Change, p2)
end

function contextActionButtonUp(p, p2, p3)
	p.Image = "https://www.roblox.com/asset/?id=97166444"
	ContextActionService:CallFunction(p3, Enum.UserInputState.End, p2)
end

function contextActionButtonCancel(p, p2, p3)
	p.Image = "https://www.roblox.com/asset/?id=97166444"
	ContextActionService:CallFunction(p3, Enum.UserInputState.Cancel, p2)
end

function isSmallScreenDevice(): boolean
	local GuiService2 = game:GetService("GuiService")
	return GuiService2:GetScreenResolution().Y <= 320
end

function createNewButton(p, p2)
	local contextActionButton = Instance.new("ImageButton")
	contextActionButton.Name = "ContextActionButton"
	contextActionButton.BackgroundTransparency = 1
	contextActionButton.Size = UDim2.new(0, 45, 0, 45)
	contextActionButton.Active = true

	if isSmallScreenDevice() then
		contextActionButton.Size = UDim2.new(0, 35, 0, 35)
	end

	contextActionButton.Image = "https://www.roblox.com/asset/?id=97166444"
	contextActionButton.Parent = contextButtonFrame

	local v4 = nil
	local v5 = false

	UserInputService.InputEnded:connect(function(p3)
		if not (p3.UserInputType == Enum.UserInputType.Touch and v4 == p3) then
			return
		end

		if p3.UserInputState == Enum.UserInputState.End and v5 then
			contextActionButtonCancel(contextActionButton, p3, p)
		end

		v4 = nil
		v5 = false
	end)

	contextActionButton.InputBegan:connect(function(p3)
		if p3.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p3.UserInputState == Enum.UserInputState.Begin then
			v4 = p3
			v5 = false
			contextActionButtonDown(contextActionButton, p3, p)
		elseif p3.UserInputState == Enum.UserInputState.Change then
			if v4 ~= p3 then
				return
			end

			v5 = false
		end
	end)

	contextActionButton.InputEnded:connect(function(p3)
		if not (p3.UserInputType == Enum.UserInputType.Touch and v4 == p3) then
			return
		end

		if p3.UserInputState == Enum.UserInputState.End then
			v4 = nil
			v5 = false
			contextActionButtonUp(contextActionButton, p3, p)
		elseif p3.UserInputState == Enum.UserInputState.Change then
			v5 = true
		end
	end)

	contextActionButton.InputChanged:connect(function(p3)
		if not (p3.UserInputType == Enum.UserInputType.Touch and v4 == p3) then
			return
		end

		contextActionButtonMoved(contextActionButton, p3, p)
	end)

	local actionIcon = Instance.new("ImageLabel")
	actionIcon.Name = "ActionIcon"
	actionIcon.Position = UDim2.new(0.175, 0, 0.175, 0)
	actionIcon.Size = UDim2.new(0.65, 0, 0.65, 0)
	actionIcon.BackgroundTransparency = 1

	if p2.image and type(p2.image) == "string" then
		actionIcon.Image = p2.image
	end

	actionIcon.Parent = contextActionButton

	local actionTitle = Instance.new("TextLabel")
	actionTitle.Name = "ActionTitle"
	actionTitle.Size = UDim2.new(1, 0, 1, 0)
	actionTitle.BackgroundTransparency = 1
	actionTitle.Font = Enum.Font.SourceSansBold
	actionTitle.TextColor3 = Color3.new(1, 1, 1)
	actionTitle.TextStrokeTransparency = 0
	actionTitle.FontSize = Enum.FontSize.Size18
	actionTitle.TextWrapped = true
	actionTitle.Text = ""

	if p2.title and type(p2.title) == "string" then
		actionTitle.Text = p2.title
	end

	actionTitle.Parent = contextActionButton

	return contextActionButton
end

function createButton(p, p2)
	local v4 = nil

	for i = 1, #v2 do
		if v2[i] == "empty" then
			v4 = i
			break
		end
	end

	local v5 = v4 or #v2 + 1

	if count < v5 then
		warn("Maximum of 7 allowed touch buttons, new touch button not created for " .. p .. ".")
		return
	end

	local newButton = createNewButton(p, p2)

	v2[v5] = newButton
	v3[p].button = newButton

	newButton.Position = v[v5]
	newButton.Parent = contextButtonFrame

	if contextActionGui and contextActionGui.Parent == nil then
		contextActionGui.Parent = parent

		if not contextButtonFrame.Parent then
			contextButtonFrame.Parent = contextActionGui
		end
	end
end

function removeAction(p)
	if not v3[p] then
		return
	end

	local button = v3[p].button

	if button then
		button.Parent = nil

		for i = 1, #v2 do
			if v2[i] == button then
				v2[i] = "empty"
				break
			end
		end

		button:Destroy()
	end

	v3[p] = nil
end

function addAction(p, p2, p3)
	if v3[p] then
		removeAction(p)
	end

	v3[p] = { p3 }

	if p2 then
		createContextActionGui()
		createButton(p, p3)
	end
end

ContextActionService.BoundActionChanged:connect(function(p, p2, p3)
	if v3[p] and p3 then
		local button = v3[p].button
		local v4 = p3[p2]
		local v5 = not v4 and (p2 == "image" or p2 == "title" or p2 == "description") and "" or v4

		if button then
			if p2 == "image" then
				button.ActionIcon.Image = v5
				return
			elseif p2 == "title" then
				button.ActionTitle.Text = v5
				return
			elseif p2 == "description" then
				return
			end

			if p2 == "position" then
				button.Position = v5
			end
		end
	end
end)

ContextActionService.BoundActionAdded:connect(function(p, p2, p3)
	addAction(p, p2, p3)
end)

ContextActionService.BoundActionRemoved:connect(function(p, _)
	removeAction(p)
end)

ContextActionService.GetActionButtonEvent:connect(function(p)
	if v3[p] then
		ContextActionService:FireActionButtonFoundSignal(p, v3[p].button)
	end
end)

local allBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

for k, v4 in pairs(allBoundActionInfo) do
	addAction(k, v4.createTouchButton, v4)

	if v3[k] and v3[k].button then
		ContextActionService:FireActionButtonFoundSignal(k, v3[k].button)
	end
end
