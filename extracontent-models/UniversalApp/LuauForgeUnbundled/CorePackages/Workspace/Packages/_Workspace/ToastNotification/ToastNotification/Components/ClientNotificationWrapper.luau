local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/RoactUtils")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactUtils")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Cryo")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")
local toast = Foundation.Toast
local keyLabel = Foundation.KeyLabel
local view = Foundation.View
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local controlState = Foundation.Enums.ControlState

local inputTypeConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/InputType").InputTypeConstants
local useInputType = RoactUtils.Hooks.useInputType
local eventConnection = ReactUtils.EventConnection

local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactFocusNavigation").useFocusGuiObject

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")

local function ClientNotificationWrapper(props, p2)
	local ref = React.useRef(nil)
	local v5, v6 = React.useBinding(false)
	local v7, v8 = React.useBinding(Enum.SelectionBehavior.Escape)

	local v9 = useInputType()
	local v10 = useFocusGuiObject()
	local v11

	if props.onHover then
		v11 = React.useCallback(function(p3)
			props.onHover(p3 == controlState.Hover or p3 == controlState.Pressed or p3 == controlState.SelectedPressed)
		end, { props.onHover })
	end

	local jsonDecode = HttpService:JSONDecode(props.notificationInfo)
	local v12 = {}

	if jsonDecode.Buttons then
		for i, button in ipairs(jsonDecode.Buttons) do
			table.insert(v12, {
				text = button.Text,
				variant = button.ButtonType,
				onActivated = function()
					GuiService:OnNotificationInteraction(props.notificationId, i - 1)
				end
			})
		end
	end

	local createElement = React.createElement

	local v15 = if props.transparency ~= nil then props.transparency else nil
	local v14 = {
		tag = "auto-xy",
		GroupTransparency = v15,
		onStateChanged = v11,
		stateLayer = { affordance = stateLayerAffordance.None },
		SelectionGroup = v5,
		SelectionBehaviorUp = v7,
		SelectionBehaviorDown = v7,
		SelectionBehaviorLeft = v7,
		SelectionBehaviorRight = v7,
		ref = ref
	}

	local join = Cryo.Dictionary.join
	local children = props.children or {}
	local v16 = {
		Toast = React.createElement(toast, {
			title = jsonDecode.Title,
			text = jsonDecode.Text,
			icon = jsonDecode.Icon,
			actions = v12,
			width = props.width
		}),
		KeyLabelView = 0
	}
	local v17

	if v9 == inputTypeConstants.Gamepad and #v12 > 0 then
		v17 = React.createElement(
			view,
			{
				tag = "size-1400-1400 padding-medium anchor-top-right position-top-right"
			},
			{
				EventConnection = React.createElement(eventConnection, {
					event = UserInputService.InputBegan,
					callback = function(p3)
						if p3.KeyCode == Enum.KeyCode.ButtonB then
							v10(nil)
							props.onPause(false)
						end
					end
				}),
				KeyLabel = React.createElement(keyLabel, {
					Size = UDim2.fromScale(1, 1),
					keyCode = Enum.KeyCode.ButtonStart,
					holdBehavior = {
						holdTime = constants.MenuButtonPressHoldTime,
						resetTime = constants.MenuButtonPressResetTime,
						onBeginHold = function()
							props.onPause(true)
						end,
						onEndHold = function(p3)
							if not p3 then
								props.onPause(false)
							elseif #v12 == 1 then
								props.onPause(false)
								v12[1].onActivated()
							else
								v6(true)
								v8(Enum.SelectionBehavior.Stop)
								v10(ref.current)
							end
						end
					}
				})
			}
		)
	end

	v16.KeyLabelView = v17
	return createElement(view, v14, join(children, v16))
end

return React.memo(React.forwardRef(ClientNotificationWrapper))
