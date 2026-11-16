local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local gameSettings = UserSettings().GameSettings

local sendNotificationInfo = CoreGui:WaitForChild("RobloxGui"):WaitForChild("SendNotificationInfo")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local playerGui = nil

local function LocalizedGetString(p, p2)
	pcall(function()
		p2 = RobloxTranslator:FormatByKey(p)
	end)
	return p2
end

local function ScrollSelectedElement(_, p, p2)
	if p ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	local selectedObject = GuiService.SelectedObject

	if selectedObject == nil then
		return Enum.ContextActionResult.Pass
	end

	local v = nil

	if selectedObject.ClassName == "ScrollingFrame" then
		v = selectedObject
	else
		local scrollingFrame = selectedObject:FindFirstAncestorOfClass("ScrollingFrame")

		if scrollingFrame ~= nil then
			v = scrollingFrame
		end
	end

	if v == nil then
		return Enum.ContextActionResult.Pass
	end

	local v2 = (p2.KeyCode == Enum.KeyCode.PageUp or p2.KeyCode == Enum.KeyCode.Home) and -100
		or (p2.KeyCode == Enum.KeyCode.PageDown or p2.KeyCode == Enum.KeyCode.End) and 100
		or 0

	local v3 = v.CanvasPosition.X
	local v4 = v.CanvasPosition.Y

	if p2.KeyCode == Enum.KeyCode.PageUp or p2.KeyCode == Enum.KeyCode.PageDown then
		v4 = math.max(0, (math.min(v4 + v2, v.AbsoluteCanvasSize.Y)))
	elseif p2.KeyCode == Enum.KeyCode.Home or p2.KeyCode == Enum.KeyCode.End then
		v3 = math.max(0, (math.min(v3 + v2, v.AbsoluteCanvasSize.X)))
	end

	v.CanvasPosition = Vector2.new(v3, v4)

	return Enum.ContextActionResult.Pass
end

local function EnableKeyboardNavigation(_, p, _)
	if not (gameSettings.UiNavigationKeyBindEnabled and p == Enum.UserInputState.Begin and GuiService.AutoSelectGuiEnabled) then
		return Enum.ContextActionResult.Pass
	end

	if GuiService.SelectedObject then
		GuiService.SelectedObject = nil
		return Enum.ContextActionResult.Sink
	end

	if playerGui == nil then
		playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	GuiService:Select(playerGui)

	if not GuiService.SelectedObject then
		return Enum.ContextActionResult.Sink
	end

	local v = nil
	local v2 = "InGame.NotificationScript2.UINavigation.Title"
	pcall(function()
		v = RobloxTranslator:FormatByKey(v2)
	end)
	local title = v

	local text = nil
	local v3 = "InGame.NotificationScript2.UINavigation.Text"
	pcall(function()
		text = RobloxTranslator:FormatByKey(v3)
	end)

	sendNotificationInfo:Fire({ Title = title, Text = text, Duration = 3 })

	return Enum.ContextActionResult.Sink
end

local class = {}
class.__index = class
function class.new()
	local self = setmetatable({}, class)
	ContextActionService:BindAction(
		"EnableKeyboardUINavigation",
		EnableKeyboardNavigation,
		false,
		Enum.KeyCode.BackSlash
	)
	ContextActionService:BindAction(
		"ScrollSelectedElement",
		ScrollSelectedElement,
		false,
		Enum.KeyCode.PageUp,
		Enum.KeyCode.PageDown,
		Enum.KeyCode.Home,
		Enum.KeyCode.End
	)

	gameSettings:GetPropertyChangedSignal("UiNavigationKeyBindEnabled"):Connect(function()
		if not gameSettings.UiNavigationKeyBindEnabled then
			GuiService.SelectedObject = nil
		end
	end)
	return self
end

return class.new()
