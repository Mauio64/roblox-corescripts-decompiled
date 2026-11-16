local parent = script.Parent.Parent
local context = parent.context
local hooks = parent.Hooks
local utils = parent.utils
local dependencies = require(parent.dependencies)
local uiBlox = dependencies.UIBlox
local Foundation = require(parent.Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useLocalization = dependencies.Localization.Hooks.useLocalization
local kind = require(parent.type)
local buttonStack = uiBlox.App.Button.ButtonStack
local buttonType = uiBlox.App.Button.Enum.ButtonType
local constants = require(parent.constants)
local defaultContentPadding = constants.DefaultContentPadding
local defaultButtonHeight = constants.DefaultButtonHeight

local parent2 = parent.Parent
local React = require(parent2.React)
local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local toastNotificationHelper = require(utils.toastNotificationHelper)
local getTimerFromCardData = toastNotificationHelper.getTimerFromCardData

local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)
local useTimeRemainingMap = require(hooks.useTimeRemainingMap)

local function fn(buttonStyle) -- 1 equivalent call inferred from this helper
	if buttonStyle == kind.SENDERButtonStyleEnum.Growth then
		return buttonType.PrimaryContextual
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Primary then
		return buttonType.PrimarySystem
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Secondary then
		return buttonType.Secondary
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Alert then
		return buttonType.Alert
	end

	return buttonType.Secondary
end

local function fn2(list, p, handleActions, ref)
	local v

	if FoundationFontFaceMigration then
		v = useTokens()
	end

	local v2 = useNotificationCardData()

	local v3 = {}

	for _, item in ipairs(list) do
		if item.timer and item.timer.showTimeOnElement then
			v3[item.timer.showTimeOnElement] = getTimerFromCardData(v2, item.timer.showTimeOnElement)
		end
	end

	local v4 = useTimeRemainingMap(v3, v2)

	local result = {}

	if not list then
		return result
	end

	for _, item in ipairs(list) do
		local text

		if item and item.timer and item.timer.showTimeOnElement then
			text = `{item.label.text} ({v4[item.timer.showTimeOnElement]}{p.secondsAbbreviated})`
		else
			text = item and item.label and item.label.text or ""
		end

		local buttonType2 = fn(item.buttonStyle) -- inferred equivalent call
		local fontStyle

		if FoundationFontFaceMigration then
			fontStyle = v.Typography.TitleLarge
		end

		local props = {
			text = text,
			fontStyle = fontStyle,
			onActivated = function()
				if handleActions then
					handleActions(item)
				end
			end,
			buttonRef = 0
		}
		local buttonRef

		if buttonType2 == buttonType.PrimaryContextual then
			buttonRef = ref
		end

		props.buttonRef = buttonRef
		table.insert(result, { buttonType = buttonType2, props = props })
	end

	return result
end

return function(p)
	local v = useNotificationCardState("button")
	local handleActions = useNotificationCardData().handleActions

	local v2 = useLocalization({
		secondsAbbreviated = "Feature.Notifications.Label.SecondsAbbreviated"
	})

	local shouldAutoFocus = p.shouldAutoFocus
	local ref = React.useRef(nil)
	local v3 = useFocusGuiObject()

	React.useEffect(function()
		if not shouldAutoFocus then
			return
		end

		local current = ref.current

		if not current then
			return
		end

		v3(current)

		return function()
			v3(nil)
		end
	end, { shouldAutoFocus, v3 })

	local buttons = fn2(v, v2, handleActions, ref)

	if #buttons > 0 then
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
					FocusRoot,
					{
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
						isIsolated = true,
						isFocusable = shouldAutoFocus,
						isAutoFocusRoot = shouldAutoFocus
					},
					{
						ActionButtons = buttons and React.createElement(buttonStack, {
							buttonHeight = defaultButtonHeight,
							buttons = buttons,
							marginBetween = defaultContentPadding
						})
					}
				)
			}
		))
	end

	return nil
end
