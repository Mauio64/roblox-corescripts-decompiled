local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local uiBlox = dependencies.UIBlox
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation").Hooks.useTokens
local useLocalization = dependencies.Localization.Hooks.useLocalization
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local buttonStack = uiBlox.App.Button.ButtonStack
local buttonType = uiBlox.App.Button.Enum.ButtonType
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local defaultContentPadding = constants.DefaultContentPadding
local defaultButtonHeight = constants.DefaultButtonHeight

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactFocusNavigation").useFocusGuiObject
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local getTimerFromCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper").getTimerFromCardData

local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardState")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardData")
local useTimeRemainingMap = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Hooks/useTimeRemainingMap")

local function fn(list, p2, handleActions, ref)
	local v5 = useTokens()
	local v6 = useNotificationCardData()

	local v7 = {}

	for i, item in ipairs(list) do
		if item.timer and item.timer.showTimeOnElement then
			v7[item.timer.showTimeOnElement] = getTimerFromCardData(v6, item.timer.showTimeOnElement)
		end
	end

	local v8 = useTimeRemainingMap(v7, v6)

	local result = {}

	if not list then
		return result
	end

	for i, item in ipairs(list) do
		local v9

		if item and item.timer and item.timer.showTimeOnElement then
			v9 = `{item.label.text} ({v8[item.timer.showTimeOnElement]}{p2.secondsAbbreviated})`
		else
			v9 = item and item.label and item.label.text or ""
		end

		local buttonStyle = item.buttonStyle
		local v10

		if buttonStyle == module2.SENDERButtonStyleEnum.Growth then
			v10 = buttonType.PrimaryContextual
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Primary then
			v10 = buttonType.PrimarySystem
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Secondary then
			v10 = buttonType.Secondary
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Alert then
			v10 = buttonType.Alert
		else
			v10 = buttonType.Secondary
		end

		local v12 = {
			text = v9,
			fontStyle = v5.Typography.TitleLarge,
			onActivated = function()
				if handleActions then
					handleActions(item)
				end
			end,
			buttonRef = 0
		}
		local v13 = if v10 == buttonType.PrimaryContextual then ref else nil
		v12.buttonRef = v13
		table.insert(result, { buttonType = v10, props = v12 })
	end

	return result
end

return function(p2)
	local v5 = useNotificationCardState("button")
	local handleActions = useNotificationCardData().handleActions

	local v6 = useLocalization({
		secondsAbbreviated = "Feature.Notifications.Label.SecondsAbbreviated"
	})

	local shouldAutoFocus = p2.shouldAutoFocus
	local ref = React.useRef(nil)
	local v7 = useFocusGuiObject()

	React.useEffect(function()
		if not shouldAutoFocus then
			return
		end

		local current = ref.current

		if not current then
			return
		end

		v7(current)

		return function()
			v7(nil)
		end
	end, { shouldAutoFocus, v7 })

	local v8 = fn(v5, v6, handleActions, ref)

	if #v8 > 0 then
		return (React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				FocusRoot = React.createElement(
					focusRoot,
					{
						surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
						isIsolated = true,
						isFocusable = shouldAutoFocus,
						isAutoFocusRoot = shouldAutoFocus
					},
					{
						ActionButtons = v8 and React.createElement(buttonStack, {
							buttonHeight = defaultButtonHeight,
							buttons = v8,
							marginBetween = defaultContentPadding
						})
					}
				)
			}
		))
	end

	return nil
end
