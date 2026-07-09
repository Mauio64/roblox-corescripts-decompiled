local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local useEffect = React.useEffect
local RoactRodux = dependencies.RoactRodux
local useLocalization = dependencies.Localization.Hooks.useLocalization
local CloseCentralOverlay = dependencies.CentralOverlay.Thunks.CloseCentralOverlay
local UIBlox = dependencies.UIBlox
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Constants = UIBlox.App.Style.Constants
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local Foundation = dependencies.Foundation
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local GetFFlagEnableAccountSwitcherFoundationDesign = require(ParentParentParent.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign
local UiModeStyleProvider = require(ParentParentParent.Style).UiModeStyleProvider
local RoactAppExperiment = require(ParentParentParent.RoactAppExperiment)
local AppBtidLayers = require(ParentParentParent.ExperimentLayers).AppBtidLayers
local GetFFlagEnableAccountSwitcherRedesignIXP = require(ParentParentParent.SharedFlags).GetFFlagEnableAccountSwitcherRedesignIXP
local GetFFlagFixAccountSwitcherOverlayBackgroundTap = require(ParentParentParent.SharedFlags).GetFFlagFixAccountSwitcherOverlayBackgroundTap

return (RoactRodux.connect(nil, function(p1) -- line: 215
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeCentralOverlay = function() -- line: 217
			-- upvalues: p1 (copy), CloseCentralOverlay (copy)
			return p1(CloseCentralOverlay())
		end
	}
end)(function(t1: {[any]: any}) -- line: 46
	-- upvalues: GetFFlagEnableAccountSwitcherRedesignIXP (copy), RoactAppExperiment (copy), AppBtidLayers (copy), AnalyticsEvents (copy), EventConstants (copy), GetFFlagFixAccountSwitcherOverlayBackgroundTap (copy), useLocalization (copy), ButtonType (copy), useEffect (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), React (copy), Dialog (copy), DialogSize (copy), Foundation (copy), EnumsOrientation (copy), ButtonVariant (copy), withStyle (copy), InteractiveAlert (copy), UiModeStyleProvider (copy), Constants (copy)
	local v28 = not GetFFlagEnableAccountSwitcherRedesignIXP() or RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AccountSwitcherLayer }, function(p2) -- line: 50
		-- upvalues: AppBtidLayers (copy)
		return (p2[AppBtidLayers.AccountSwitcherLayer] or {}).enableAccountSwitcherFoundationDesign == true
	end)
	local v29 = t1.primaryButtonTextKey ~= nil and (t1.primaryButtonTextKey ~= "" and t1.primaryButtonCallback ~= nil)
	local v30 = nil

	if v29 then
		function v30() -- line: 62
			-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy)
			AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherConfirmation, EventConstants.btn.primaryButton, t1.errorType)
			t1.primaryButtonCallback()
		end
	end

	local v31 = t1.secondaryButtonTextKey ~= nil and (t1.secondaryButtonTextKey ~= "" and t1.secondaryButtonCallback ~= nil)
	local u32 = nil

	if v31 then
		function u32() -- line: 78
			-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy)
			AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherConfirmation, EventConstants.btn.secondaryButton, t1.errorType)
			t1.secondaryButtonCallback()
		end
	end

	local function v33() -- line: 92
		-- upvalues: GetFFlagFixAccountSwitcherOverlayBackgroundTap (copy), u32 (ref), t1 (copy)
		if GetFFlagFixAccountSwitcherOverlayBackgroundTap() and u32 then
			u32()

			return
		end

		t1.closeCentralOverlay()
	end

	local v34 = useLocalization({
		titleText = t1.titleTextKey,
		bodyTextKey = t1.bodyTextKey,
		primaryButtonTextKey = t1.primaryButtonTextKey,
		secondaryButtonTextKey = t1.secondaryButtonTextKey
	})
	local bodyTextKey = v34.bodyTextKey

	if t1.bodyUsername then
		bodyTextKey = string.gsub(bodyTextKey, "{username}", t1.bodyUsername)
	end

	local t2 = {}

	if v31 then
		table.insert(t2, {
			buttonType = ButtonType.Secondary,
			props = {
				text = v34.secondaryButtonTextKey,
				onActivated = u32
			}
		})
	end

	if v29 then
		table.insert(t2, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				text = v34.primaryButtonTextKey,
				onActivated = v30
			}
		})
	end

	useEffect(function() -- line: 133
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy)
		AnalyticsEvents.sendModalShownEvent(EventConstants.ctx.accountSwitcherConfirmation, t1.errorType)
	end, {})

	local v37 = if not GetFFlagEnableAccountSwitcherFoundationDesign() or not v28 then withStyle(function(p3) -- line: 175
		-- upvalues: React (copy), v33 (copy), InteractiveAlert (copy), v34 (copy), t2 (copy)
		return React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = p3.Theme.Overlay.Color,
			AutoButtonColor = false,
			BackgroundTransparency = p3.Theme.Overlay.Transparency,
			Visible = true,
			[React.Event.Activated] = v33
		}, {
			Alert = React.createElement(InteractiveAlert, {
				title = v34.titleText,
				bodyText = v34.bodyTextKey,
				buttonStackInfo = {
					buttons = t2
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = Vector2.new(400, nil)
			})
		})
	end) else React.createElement(Dialog.Root, {
		hasBackdrop = true,
		closeOnClickOutside = true,
		size = DialogSize.Small,
		onClose = v33
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v34.titleText
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(Foundation.View, {
				tag = "col fill auto-xy items-start"
			}, {
				DialogText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = bodyTextKey
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Vertical,
			actions = {
				v29 and {
					text = v34.primaryButtonTextKey,
					variant = ButtonVariant.Alert,
					onActivated = v30
				} or nil,
				v31 and {
					text = v34.secondaryButtonTextKey,
					variant = ButtonVariant.Standard,
					onActivated = u32
				} or nil
			}
		})
	})

	if t1.forceDarkTheme then
		return React.createElement(UiModeStyleProvider, {
			style = {
				themeName = Constants.ThemeName.Dark,
				fontName = Constants.FontName.Gotham
			}
		}, {
			Child = v37
		})
	end

	return v37
end))
