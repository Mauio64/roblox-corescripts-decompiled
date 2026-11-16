local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local Checkbox = Foundation.Checkbox

local DeleteWarningModalClosed = require(parent.Actions.DeleteWarningModalClosed)
local recordDeleteWarningModalOptOut = require(parent.Utils.recordDeleteWarningModalOptOut)

local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle

local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local useAnalytics = require(parent.Analytics.useAnalytics)

local ButtonType = UIBlox.App.Button.Enum.ButtonType

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

return function(p)
	local screenSize = useScreenSize()
	local v = useStyle()

	local v2 = useAnalytics()
	local v3 = useDispatch()

	local v4 = useLocalization({
		alertBody = "Feature.Captures.Label.DeleteCaptureInfo",
		alertBodyPlural = "Feature.Captures.Label.DeleteCapturesWarning",
		alertTitle = "Feature.Captures.Title.DeleteCaptureWarning",
		alertTitlePlural = "Feature.Captures.Title.DeleteMultipleCapturesWarning",
		cancelCTA = "Feature.Captures.Action.DeleteCaptureWarningCancel",
		deleteCTA = "Feature.Captures.Action.DeleteCaptureWarningConfirm",
		optOutText = "Feature.Captures.Label.DeleteCaptureWarningOptOut"
	})

	local theme = v.Theme

	local visible = useSelector(function(p2)
		return p2[Constants.RoduxKey].Carousel.IsDeleteWarningModalOpen
	end)

	local v5 = useSelector(function(p2)
		return p2[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)

	local state, setState = useState(false)

	useEffect(function()
		if visible then
			setState(false)
		end
	end, { visible, setState })

	local onActivated = useCallback(function()
		v3(DeleteWarningModalClosed())
		v2.fireEvent(EventNames.CapturesDeleteWarningModalCancelPressed)
	end, {})

	local onActivated2 = useCallback(function()
		p.deleteItem()

		if state then
			recordDeleteWarningModalOptOut(v2)
		end

		v2.fireEvent(EventNames.CapturesDeleteWarningModalDeletePressed)
		v3(DeleteWarningModalClosed())
	end, { v2, state, p.deleteItem })

	local createElement = React.createElement
	local v6 = {
		Active = true,
		AutoButtonColor = false,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		Size = UDim2.fromScale(1, 1),
		Visible = visible,
		ZIndex = p.zIndex
	}

	local createElement2 = React.createElement
	local bodyText

	if #v5 > 1 then
		bodyText = v4.alertBodyPlural
	else
		bodyText = v4.alertBody
	end

	local v7 = {
		bodyText = bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onActivated, text = v4.cancelCTA }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated2, text = v4.deleteCTA }
				}
			}
		},
		isMiddleContentFocusable = false,
		middleContent = function()
			return React.createElement(Checkbox, {
				label = v4.optOutText,
				isChecked = state,
				isDisabled = false,
				onActivated = function()
					setState(not state)
				end
			})
		end,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		title = 0
	}

	local title = if #v5 > 1 then v4.alertTitlePlural else v4.alertTitle
	v7.title = title
	return createElement("TextButton", v6, {
		Alert = createElement2(InteractiveAlert, v7)
	})
end
