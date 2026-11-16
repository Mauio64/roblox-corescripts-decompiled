local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local React = require(parent.React)
local useState = React.useState
local memo = React.memo
local useMemo = React.useMemo

local UIBlox = require(parent.UIBlox)
local ControlState = UIBlox.Core.Control.Enum.ControlState
local v = memo(UIBlox.Core.Control.Interactable)

local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

require(AppChat.types)

local v2 = {
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

local function BaseCell(p)
	local joined = Cryo.Dictionary.join(v2, p)
	local state, setState = useState(ControlState.Initialize)

	local onStateChanged = React.useCallback(function(_, p2)
		if not joined.isDisabled then
			setState(p2)
		end
	end, { joined.isDisabled })

	local v3 = React.useCallback(function()
		if not joined.isDisabled then
			joined.onActivated()
		end
	end, { joined.isDisabled, joined.onActivated })

	local overlay = useMemo(function()
		if state == ControlState.Pressed then
			return (React.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = joined.onPressedBackgroundTransparency,
				BackgroundColor3 = joined.onPressedBackground3,
				BorderSizePixel = 0
			}))
		end

		return nil
	end, { state, joined.onPressedBackground3, joined.onPressedBackgroundTransparency })
	local divider = useMemo(function()
		if joined.showDivider then
			return (React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			}, {
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
			}))
		end

		return nil
	end, {
		joined.showDivider,
		joined.dividerTransparency,
		joined.dividerColor3,
		joined.avatarCircleCellWidth
	})

	local v4 = useMemo(function()
		return Cryo.Dictionary.join(joined.children or {}, { overlay = overlay, divider = divider })
	end, { joined.children, overlay, divider })

	local selectionImageObject = useCursor(Foundation.Enums.CursorType.RoundedSlot)
	local createElement = React.createElement
	local v5 = {
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		["onStateChanged"] = nil,
		onStateChanged = onStateChanged,
		[React.Event.Activated] = v3
	}
	local tag = React.Tag
	local v6

	if FFlagDebugAppChatEnableDomLocators and joined.testId ~= nil then
		v6 = `data-testid={joined.testId}`
	end

	v5[tag] = v6

	v5.AutoButtonColor = false
	v5.Selectable = joined.Selectable
	v5.SelectionImageObject = selectionImageObject
	v5.Size = joined.Size
	v5.AutomaticSize = joined.AutomaticSize
	v5.BackgroundColor3 = joined.BackgroundColor3
	v5.BackgroundTransparency = joined.BackgroundTransparency
	v5.LayoutOrder = joined.LayoutOrder
	v5.BorderSizePixel = 0
	return createElement(v, v5, v4)
end

return memo(BaseCell)
