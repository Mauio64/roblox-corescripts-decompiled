local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local SendNotificationInfo = CoreGui:WaitForChild("RobloxGui"):WaitForChild("SendNotificationInfo")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local PlayerGui = nil

local function LocalizedGetString(p1, p2) -- line: 18
	-- upvalues: RobloxTranslator (copy)
	pcall(function() -- line: 19
		-- upvalues: p2 (ref), RobloxTranslator (copy), p1 (copy)
		p2 = RobloxTranslator:FormatByKey(p1)
	end)

	return p2
end
local function ScrollSelectedElement(_, p4, p5) -- line: 25
	-- upvalues: GuiService (copy)
	if p4 ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	local SelectedObject = GuiService.SelectedObject

	if SelectedObject == nil then
		return Enum.ContextActionResult.Pass
	end

	local v21 = nil

	if SelectedObject.ClassName == "ScrollingFrame" then
		v21 = SelectedObject
	else
		local ScrollingFrame = SelectedObject:FindFirstAncestorOfClass("ScrollingFrame")

		if ScrollingFrame ~= nil then
			v21 = ScrollingFrame
		end
	end

	if v21 == nil then
		return Enum.ContextActionResult.Pass
	end

	local n1 = 0

	if p5.KeyCode == Enum.KeyCode.PageUp or p5.KeyCode == Enum.KeyCode.Home then
		n1 = -100
	elseif p5.KeyCode == Enum.KeyCode.PageDown or p5.KeyCode == Enum.KeyCode.End then
		n1 = 100
	end

	local CanvasPositionX = v21.CanvasPosition.X
	local CanvasPositionY = v21.CanvasPosition.Y

	if p5.KeyCode == Enum.KeyCode.PageUp or p5.KeyCode == Enum.KeyCode.PageDown then
		CanvasPositionY = math.max(0, (math.min(CanvasPositionY + n1, v21.AbsoluteCanvasSize.Y)))
	elseif p5.KeyCode == Enum.KeyCode.Home or p5.KeyCode == Enum.KeyCode.End then
		CanvasPositionX = math.max(0, (math.min(CanvasPositionX + n1, v21.AbsoluteCanvasSize.X)))
	end

	v21.CanvasPosition = Vector2.new(CanvasPositionX, CanvasPositionY)

	return Enum.ContextActionResult.Pass
end
local function EnableKeyboardNavigation(_, p7, _) -- line: 73
	-- upvalues: GameSettings (copy), GuiService (copy), PlayerGui (ref), Players (copy), RobloxTranslator (copy), SendNotificationInfo (copy)
	if not GameSettings.UiNavigationKeyBindEnabled then
		return Enum.ContextActionResult.Pass
	end

	if p7 ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	if not GuiService.AutoSelectGuiEnabled then
		return Enum.ContextActionResult.Pass
	end

	if GuiService.SelectedObject then
		GuiService.SelectedObject = nil

		return Enum.ContextActionResult.Sink
	end

	if PlayerGui == nil then
		PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	GuiService:Select(PlayerGui)

	if GuiService.SelectedObject then
		local u29 = nil
		local s1 = "InGame.NotificationScript2.UINavigation.Title"

		pcall(function() -- line: 19
			-- upvalues: u29 (ref), RobloxTranslator (copy), s1 (copy)
			u29 = RobloxTranslator:FormatByKey(s1)
		end)

		local v31 = u29
		local u32 = nil
		local s2 = "InGame.NotificationScript2.UINavigation.Text"

		pcall(function() -- line: 19
			-- upvalues: u32 (ref), RobloxTranslator (copy), s2 (copy)
			u32 = RobloxTranslator:FormatByKey(s2)
		end)

		local v34 = u32

		SendNotificationInfo:Fire({
			Duration = 3,
			Title = v31,
			Text = v34
		})
	end

	return Enum.ContextActionResult.Sink
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 116
	-- upvalues: t1 (copy), ContextActionService (copy), EnableKeyboardNavigation (copy), ScrollSelectedElement (copy), GameSettings (copy), GuiService (copy)
	local self = setmetatable({}, t1)

	ContextActionService:BindAction("EnableKeyboardUINavigation", EnableKeyboardNavigation, false, Enum.KeyCode.BackSlash)
	ContextActionService:BindAction("ScrollSelectedElement", ScrollSelectedElement, false, Enum.KeyCode.PageUp, Enum.KeyCode.PageDown, Enum.KeyCode.Home, Enum.KeyCode.End)
	GameSettings:GetPropertyChangedSignal("UiNavigationKeyBindEnabled"):Connect(function() -- line: 121
		-- upvalues: GameSettings (copy), GuiService (copy)
		if not GameSettings.UiNavigationKeyBindEnabled then
			GuiService.SelectedObject = nil
		end
	end)

	return self
end

return t1.new()
