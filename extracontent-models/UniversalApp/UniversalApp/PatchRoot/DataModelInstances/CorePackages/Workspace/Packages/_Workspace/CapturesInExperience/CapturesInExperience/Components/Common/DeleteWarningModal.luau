local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local Checkbox = require(ParentParentParent.Foundation).Checkbox
local DeleteWarningModalClosed = require(ParentParent.Actions.DeleteWarningModalClosed)
local recordDeleteWarningModalOptOut = require(ParentParent.Utils.recordDeleteWarningModalOptOut)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

return function(t1: {[any]: any}) -- line: 37
	-- upvalues: useScreenSize (copy), useStyle (copy), useAnalytics (copy), useDispatch (copy), useLocalization (copy), useSelector (copy), Constants (copy), useState (copy), useEffect (copy), useCallback (copy), DeleteWarningModalClosed (copy), EventNames (copy), recordDeleteWarningModalOptOut (copy), React (copy), InteractiveAlert (copy), ButtonType (copy), Checkbox (copy)
	local v25 = useScreenSize()
	local v26 = useStyle()
	local v27 = useAnalytics()
	local v28 = useDispatch()
	local v29 = useLocalization({
		alertBody = "Feature.Captures.Label.DeleteCaptureInfo",
		alertBodyPlural = "Feature.Captures.Label.DeleteCapturesWarning",
		alertTitle = "Feature.Captures.Title.DeleteCaptureWarning",
		alertTitlePlural = "Feature.Captures.Title.DeleteMultipleCapturesWarning",
		cancelCTA = "Feature.Captures.Action.DeleteCaptureWarningCancel",
		deleteCTA = "Feature.Captures.Action.DeleteCaptureWarningConfirm",
		optOutText = "Feature.Captures.Label.DeleteCaptureWarningOptOut"
	})
	local Theme = v26.Theme
	local v31 = useSelector(function(p1) -- line: 56
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].Carousel.IsDeleteWarningModalOpen
	end)
	local v32 = useSelector(function(p2) -- line: 60
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)
	local v33, v34 = useState(false)

	useEffect(function() -- line: 66
		-- upvalues: v31 (copy), v34 (copy)
		if v31 then
			v34(false)
		end
	end, {
		v31,
		v34
	})

	local v35 = useCallback(function() -- line: 72
		-- upvalues: v28 (copy), DeleteWarningModalClosed (copy), v27 (copy), EventNames (copy)
		v28(DeleteWarningModalClosed())
		v27.fireEvent(EventNames.CapturesDeleteWarningModalCancelPressed)
	end, {})
	local v36 = useCallback(function() -- line: 77
		-- upvalues: t1 (copy), v33 (copy), recordDeleteWarningModalOptOut (copy), v27 (copy), EventNames (copy), v28 (copy), DeleteWarningModalClosed (copy)
		t1.deleteItem()

		if v33 then
			recordDeleteWarningModalOptOut(v27)
		end

		v27.fireEvent(EventNames.CapturesDeleteWarningModalDeletePressed)
		v28(DeleteWarningModalClosed())
	end, {
		v27,
		v33,
		t1.deleteItem
	})

	return React.createElement("TextButton", {
		Active = true,
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		Size = UDim2.fromScale(1, 1),
		Visible = v31,
		ZIndex = t1.zIndex
	}, {
		Alert = React.createElement(InteractiveAlert, {
			isMiddleContentFocusable = false,
			bodyText = if not (#v32 > 1) then v29.alertBody else v29.alertBodyPlural,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = v35,
							text = v29.cancelCTA
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v36,
							text = v29.deleteCTA
						}
					}
				}
			},
			middleContent = function() -- line: 118
				-- upvalues: React (copy), Checkbox (copy), v29 (copy), v33 (copy), v34 (copy)
				return React.createElement(Checkbox, {
					isDisabled = false,
					label = v29.optOutText,
					isChecked = v33,
					onActivated = function() -- line: 123
						-- upvalues: v34 (copy), v33 (copy)
						v34(not v33)
					end
				})
			end,
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v25,
			title = if not (#v32 > 1) then v29.alertTitle else v29.alertTitlePlural
		})
	})
end
