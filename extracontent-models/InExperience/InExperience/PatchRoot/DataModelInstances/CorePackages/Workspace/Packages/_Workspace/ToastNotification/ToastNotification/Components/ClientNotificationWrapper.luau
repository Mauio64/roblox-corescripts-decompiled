local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local ReactUtils = require(parent2.ReactUtils)
local Cryo = require(parent2.Cryo)

local Foundation = require(parent2.Foundation)
local Toast = Foundation.Toast
local KeyLabel = Foundation.KeyLabel
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ControlState = Foundation.Enums.ControlState

local InputType = require(parent2.InputType)
local InputTypeConstants = InputType.InputTypeConstants
local useInputType = RoactUtils.Hooks.useInputType
local EventConnection = ReactUtils.EventConnection

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local constants = require(parent.constants)

local function ClientNotificationWrapper(props, _)
	local ref = React.useRef(nil)
	local selectionGroup, v = React.useBinding(false)
	local v2, v3 = React.useBinding(Enum.SelectionBehavior.Escape)

	local v4 = useInputType()
	local v5 = useFocusGuiObject()
	local onStateChanged

	if props.onHover then
		onStateChanged = React.useCallback(function(p)
			props.onHover(p == ControlState.Hover or p == ControlState.Pressed or p == ControlState.SelectedPressed)
		end, { props.onHover })
	end

	local jsonDecode = HttpService:JSONDecode(props.notificationInfo)
	local actions = {}

	if jsonDecode.Buttons then
		for i, button in ipairs(jsonDecode.Buttons) do
			table.insert(actions, {
				text = button.Text,
				variant = button.ButtonType,
				onActivated = function()
					GuiService:OnNotificationInteraction(props.notificationId, i - 1)
				end
			})
		end
	end

	local createElement = React.createElement
	local groupTransparency

	if props.transparency ~= nil then
		groupTransparency = props.transparency
	end

	local v6 = {
		tag = "auto-xy",
		GroupTransparency = groupTransparency,
		onStateChanged = onStateChanged,
		stateLayer = { affordance = StateLayerAffordance.None },
		SelectionGroup = selectionGroup,
		SelectionBehaviorUp = v2,
		SelectionBehaviorDown = v2,
		SelectionBehaviorLeft = v2,
		SelectionBehaviorRight = v2,
		ref = ref
	}

	local join = Cryo.Dictionary.join
	local children = props.children or {}
	local v7 = {
		Toast = React.createElement(Toast, {
			title = jsonDecode.Title,
			text = jsonDecode.Text,
			icon = jsonDecode.Icon,
			actions = actions,
			width = props.width
		}),
		KeyLabelView = 0
	}
	local keyLabelView

	if v4 == InputTypeConstants.Gamepad and #actions > 0 then
		keyLabelView = React.createElement(
			View,
			{ tag = "size-1400-1400 padding-medium anchor-top-right position-top-right" },
			{
				EventConnection = React.createElement(EventConnection, {
					event = UserInputService.InputBegan,
					callback = function(p)
						if p.KeyCode == Enum.KeyCode.ButtonB then
							v5(nil)
							props.onPause(false)
						end
					end
				}),
				KeyLabel = React.createElement(KeyLabel, {
					Size = UDim2.fromScale(1, 1),
					keyCode = Enum.KeyCode.ButtonStart,
					holdBehavior = {
						holdTime = constants.MenuButtonPressHoldTime,
						resetTime = constants.MenuButtonPressResetTime,
						onBeginHold = function()
							props.onPause(true)
						end,
						onEndHold = function(flag: boolean)
							if not flag then
								props.onPause(false)
							elseif #actions == 1 then
								props.onPause(false)
								actions[1].onActivated()
							else
								v(true)
								v3(Enum.SelectionBehavior.Stop)
								v5(ref.current)
							end
						end
					}
				})
			}
		)
	end

	v7.KeyLabelView = keyLabelView
	return createElement(View, v6, join(children, v7))
end

return React.memo(React.forwardRef(ClientNotificationWrapper))
