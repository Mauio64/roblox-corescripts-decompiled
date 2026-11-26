local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useCursor = Foundation.Hooks.useCursor
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useState = React.useState
local memo = React.memo
local useMemo = React.useMemo

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local controlState = UIBlox.Core.Control.Enum.ControlState
local v5 = memo(UIBlox.Core.Control.Interactable)

local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local v6 = {
	Size = UDim2.new(1, 0, 0, 48),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0,
	onPressedBackgroundColor3 = Color3.fromRGB(242, 242, 242),
	onPressedBackgroundTransparency = 1,
	LayoutOrder = 0,
	isDisabled = false,
	onActivated = function()
		print("BaseCell onActivated")
	end,
	showDivider = true,
	dividerTransparency = 0,
	dividerColor3 = Color3.fromRGB(227, 227, 227),
	avatarCircleCellWidth = 60
}

local function BaseCell(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local state, setState = useState(controlState.Initialize)

	local v7 = React.useCallback(function(p3, p4)
		if not joined.isDisabled then
			setState(p4)
		end
	end, { joined.isDisabled })

	local v8 = React.useCallback(function()
		if not joined.isDisabled then
			joined.onActivated()
		end
	end, { joined.isDisabled, joined.onActivated })

	local v9 = useMemo(function()
		if state == controlState.Pressed then
			return (React.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = joined.onPressedBackgroundTransparency,
				BackgroundColor3 = joined.onPressedBackground3,
				BorderSizePixel = 0
			}))
		end

		return nil
	end, { state, joined.onPressedBackground3, joined.onPressedBackgroundTransparency })
	local v10 = useMemo(function()
		if joined.showDivider then
			return (React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				{
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						HorizontalAlignment = Enum.HorizontalAlignment.Right
					}),
					divider = React.createElement("Frame", {
						BackgroundTransparency = joined.dividerTransparency,
						BackgroundColor3 = joined.dividerColor3,
						BorderSizePixel = 0,
						Size = UDim2.new(1, -joined.avatarCircleCellWidth, 0, 1)
					})
				}
			))
		end

		return nil
	end, {
		joined.showDivider,
		joined.dividerTransparency,
		joined.dividerColor3,
		joined.avatarCircleCellWidth
	})

	local v11 = useMemo(function()
		return Cryo.Dictionary.join(joined.children or {}, {
			overlay = v9,
			divider = v10
		})
	end, { joined.children, v9, v10 })

	local v12 = useCursor(Foundation.Enums.CursorType.RoundedSlot)
	local createElement = React.createElement
	local v14 = {
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		onStateChanged = v7,
		[React.Event.Activated] = v8
	}
	local tag = React.Tag
	local v15 = if FFlagDebugAppChatEnableDomLocators and joined.testId ~= nil then `data-testid={joined.testId}` else nil
	v14[tag] = v15

	v14.AutoButtonColor = false
	v14.Selectable = joined.Selectable
	v14.SelectionImageObject = v12
	v14.Size = joined.Size
	v14.AutomaticSize = joined.AutomaticSize
	v14.BackgroundColor3 = joined.BackgroundColor3
	v14.BackgroundTransparency = joined.BackgroundTransparency
	v14.LayoutOrder = joined.LayoutOrder
	v14.BorderSizePixel = 0
	return createElement(v5, v14, v11)
end

return memo(BaseCell)
