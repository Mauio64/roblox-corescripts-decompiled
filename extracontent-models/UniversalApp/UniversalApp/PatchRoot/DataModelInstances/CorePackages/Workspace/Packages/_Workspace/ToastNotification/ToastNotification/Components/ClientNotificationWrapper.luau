local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local ReactUtils = require(ParentParentParent.ReactUtils)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local Toast = Foundation.Toast
local KeyLabel = Foundation.KeyLabel
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ControlState = Foundation.Enums.ControlState
local InputTypeConstants = require(ParentParentParent.InputType).InputTypeConstants
local useInputType = RoactUtils.Hooks.useInputType
local EventConnection = ReactUtils.EventConnection
local useFocusGuiObject = require(ParentParentParent.ReactFocusNavigation).useFocusGuiObject
local constants = require(ParentParent.constants)

local function ClientNotificationWrapper(t1: {[any]: any}, _) -- line: 39
	-- upvalues: React (copy), useInputType (copy), useFocusGuiObject (copy), ControlState (copy), HttpService (copy), GuiService (copy), View (copy), StateLayerAffordance (copy), Cryo (copy), Toast (copy), InputTypeConstants (copy), EventConnection (copy), UserInputService (copy), KeyLabel (copy), constants (copy)
	local v24 = React.useRef(nil)
	local v25, v26 = React.useBinding(false)
	local v27, v28 = React.useBinding(Enum.SelectionBehavior.Escape)
	local v29 = useInputType()
	local v30 = useFocusGuiObject()
	local v31 = if not t1.onHover then nil else React.useCallback(function(p2) -- line: 48
		-- upvalues: t1 (copy), ControlState (copy)
		t1.onHover(p2 == ControlState.Hover or (p2 == ControlState.Pressed or p2 == ControlState.SelectedPressed))
	end, { t1.onHover })
	local data = HttpService:JSONDecode(t1.notificationInfo)
	local t2 = {}

	if data.Buttons then
		for i, v in ipairs(data.Buttons) do
			table.insert(t2, {
				text = v.Text,
				variant = v.ButtonType,
				onActivated = function() -- line: 64
					-- upvalues: GuiService (copy), t1 (copy), i (copy)
					GuiService:OnNotificationInteraction(t1.notificationId, i - 1)
				end
			})
		end
	end

	return React.createElement(View, {
		tag = "auto-xy",
		GroupTransparency = if t1.transparency == nil then nil else t1.transparency,
		onStateChanged = v31,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		SelectionGroup = v25,
		SelectionBehaviorUp = v27,
		SelectionBehaviorDown = v27,
		SelectionBehaviorLeft = v27,
		SelectionBehaviorRight = v27,
		ref = v24
	}, Cryo.Dictionary.join(t1.children or {}, {
		Toast = React.createElement(Toast, {
			title = data.Title,
			text = data.Text,
			icon = data.Icon,
			actions = t2,
			width = t1.width
		}),
		KeyLabelView = if v29 ~= InputTypeConstants.Gamepad or not (#t2 > 0) then nil else React.createElement(View, {
			tag = "size-1400-1400 padding-medium anchor-top-right position-top-right"
		}, {
			EventConnection = React.createElement(EventConnection, {
				event = UserInputService.InputBegan,
				callback = function(p3) -- line: 101
					-- upvalues: v30 (copy), t1 (copy)
					if p3.KeyCode == Enum.KeyCode.ButtonB then
						v30(nil)
						t1.onPause(false)
					end
				end
			}),
			KeyLabel = React.createElement(KeyLabel, {
				Size = UDim2.fromScale(1, 1),
				keyCode = Enum.KeyCode.ButtonStart,
				holdBehavior = {
					holdTime = constants.MenuButtonPressHoldTime,
					resetTime = constants.MenuButtonPressResetTime,
					onBeginHold = function() -- line: 114
						-- upvalues: t1 (copy)
						t1.onPause(true)
					end,
					onEndHold = function(b1: boolean) -- line: 117
						-- upvalues: t2 (copy), t1 (copy), v26 (copy), v28 (copy), v30 (copy), v24 (copy)
						if b1 then
							if #t2 == 1 then
								t1.onPause(false)
								t2[1].onActivated()

								return
							end

							v26(true)
							v28(Enum.SelectionBehavior.Stop)
							v30(v24.current)

							return
						end

						t1.onPause(false)
					end
				}
			})
		})
	}))
end

return React.memo(React.forwardRef(ClientNotificationWrapper))
