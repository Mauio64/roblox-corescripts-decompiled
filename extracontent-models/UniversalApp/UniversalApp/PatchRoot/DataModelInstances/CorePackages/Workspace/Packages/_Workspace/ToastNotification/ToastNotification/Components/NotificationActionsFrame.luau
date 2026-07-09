local ParentParent = script.Parent.Parent
local context = ParentParent.context
local Hooks = ParentParent.Hooks
local utils = ParentParent.utils
local dependencies = require(ParentParent.dependencies)
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.Localization.Hooks.useLocalization
local type = require(ParentParent.type)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local constants = require(ParentParent.constants)
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultButtonHeight = constants.DefaultButtonHeight
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useFocusGuiObject = require(ParentParentParent.ReactFocusNavigation).useFocusGuiObject
local FocusNavigationUtils = require(ParentParentParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local getTimerFromCardData = require(utils.toastNotificationHelper).getTimerFromCardData
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)
local useTimeRemainingMap = require(Hooks.useTimeRemainingMap)

local function v24(p1, t1: {[any]: any}, p2, p3) -- line: 46
	-- upvalues: useNotificationCardData (copy), getTimerFromCardData (copy), useTimeRemainingMap (copy), type (copy), ButtonType (copy)
	local v30 = useNotificationCardData()
	local t2 = {}

	for _, v in ipairs(p1) do
		if v.timer and v.timer.showTimeOnElement then
			t2[v.timer.showTimeOnElement] = getTimerFromCardData(v30, v.timer.showTimeOnElement)
		end
	end

	local v34 = useTimeRemainingMap(t2, v30)
	local t3 = {}

	if p1 then
		for _, v in ipairs(p1) do
			local v38 = if not v or (not v.timer or not v.timer.showTimeOnElement) then v and (not not v.label and v.label.text) or "" else `{ v.label.text } ({ v34[v.timer.showTimeOnElement] }{ t1.secondsAbbreviated })`
			local buttonStyle = v.buttonStyle
			local v40 = if buttonStyle ~= type.SENDERButtonStyleEnum.Growth then if buttonStyle ~= type.SENDERButtonStyleEnum.Primary then if buttonStyle ~= type.SENDERButtonStyleEnum.Secondary then if buttonStyle ~= type.SENDERButtonStyleEnum.Alert then ButtonType.Secondary else ButtonType.Alert else ButtonType.Secondary else ButtonType.PrimarySystem else ButtonType.PrimaryContextual

			table.insert(t3, {
				buttonType = v40,
				props = {
					text = v38,
					onActivated = function() -- line: 80
						-- upvalues: p2 (copy), v (copy)
						if p2 then
							p2(v)
						end
					end,
					buttonRef = if v40 ~= ButtonType.PrimaryContextual then nil else p3
				}
			})
		end
	end

	return t3
end

return function(t4: {[any]: any}) -- line: 98
	-- upvalues: useNotificationCardState (copy), useNotificationCardData (copy), useLocalization (copy), React (copy), useFocusGuiObject (copy), v24 (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ButtonStack (copy), DefaultButtonHeight (copy), DefaultContentPadding (copy)
	local v42 = useNotificationCardState("button")
	local handleActions = useNotificationCardData().handleActions
	local v44 = useLocalization({
		secondsAbbreviated = "Feature.Notifications.Label.SecondsAbbreviated"
	})
	local shouldAutoFocus = t4.shouldAutoFocus
	local v46 = React.useRef(nil)
	local v47 = useFocusGuiObject()

	React.useEffect(function() -- line: 111
		-- upvalues: shouldAutoFocus (copy), v46 (copy), v47 (copy)
		if not shouldAutoFocus then
			return
		end

		local current = v46.current

		if not current then
			return
		end

		v47(current)

		return function() -- line: 123
			-- upvalues: v47 (copy)
			v47(nil)
		end
	end, {
		shouldAutoFocus,
		v47
	})

	local v48 = v24(v42, v44, handleActions, v46)

	if #v48 > 0 then
		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			FocusRoot = React.createElement(FocusRoot, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isFocusable = shouldAutoFocus,
				isAutoFocusRoot = shouldAutoFocus
			}, {
				ActionButtons = v48 and React.createElement(ButtonStack, {
					buttonHeight = DefaultButtonHeight,
					buttons = v48,
					marginBetween = DefaultContentPadding
				})
			})
		}))
	end

	return nil
end
