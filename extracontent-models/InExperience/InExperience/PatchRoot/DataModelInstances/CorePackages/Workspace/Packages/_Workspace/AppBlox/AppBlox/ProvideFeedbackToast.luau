local Parent = script:FindFirstAncestor("AppBlox").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local UIBlox = require(Parent.UIBlox)
local SharedFlags = require(Parent.SharedFlags)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local Toast = UIBlox.App.Dialog.Toast

require(script.Parent.CheckboxFeedbackFormModal)

local SnackbarWrapper = require(script.Parent.SnackbarWrapper)
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast

local function ProvideFeedbackToast(t1: {[any]: any}) -- line: 55
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), SnackbarWrapper (copy), useSelector (copy), Toast (copy)
	local v22 = useDispatch()
	local v23 = useTokens()
	local v24 = useLocalization({
		giveFeedback = "Feature.GameDetails.Action.GiveFeedback",
		helpUsImprove = "Feature.GameDetails.Message.HelpImproveExperience"
	})
	local v25 = React.useCallback(function() -- line: 63
		-- upvalues: t1 (copy), v22 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if t1.onToastActivated then
			task.spawn(t1.onToastActivated)
		end

		v22(SetCentralOverlay(CentralOverlayType.CheckboxFeedbackFormModal, t1.feedbackFormProps))
	end, {
		t1.onToastActivated,
		v22,
		t1.feedbackFormProps
	})
	local v26 = React.useCallback(function() -- line: 70
		-- upvalues: t1 (copy), v22 (copy), CloseCentralOverlay (copy)
		if t1.onToastDismissed then
			task.spawn(t1.onToastDismissed)
		end

		v22(CloseCentralOverlay())
	end, {
		t1.onToastDismissed,
		v22
	})

	if FFlagLuaAppUseSnackbarForProvideFeedbackToast then
		return React.createElement(SnackbarWrapper, {
			autoDismissDelaySeconds = 5,
			titleText = t1.toastTitle or v24.helpUsImprove,
			icon = t1.toastIcon,
			buttonText = t1.toastButtonText or v24.giveFeedback,
			onButtonActivated = v25,
			closeSnackbar = v26
		})
	end

	local t2 = {
		Color = v23.Inverse.Surface.Surface_0.Color3,
		Transparency = v23.Inverse.Surface.Surface_0.Transparency
	}
	local v28 = useSelector(function(p1) -- line: 93
		return p1.GlobalGuiInset or {
			left = 0,
			top = 0,
			right = 0,
			bottom = 0
		}
	end)
	local v29 = useSelector(function(p2) -- line: 102
		return p2.TopBar.statusBarHeight
	end)
	local uDim2 = UDim2.new(0.5, 0, 0, v28.top + 20 + v29)

	return React.createElement(Toast, {
		duration = 5,
		position = uDim2,
		toastContent = {
			swipeUpDismiss = true,
			buttonText = t1.toastButtonText or v24.giveFeedback,
			iconColorStyle = t2,
			iconImage = t1.toastIcon,
			onActivated = v25,
			onAppeared = t1.onToastAppeared,
			onDismissed = v26,
			toastTitle = t1.toastTitle or v24.helpUsImprove,
			toastSubtitle = t1.toastSubtitle
		}
	})
end

return React.memo(ProvideFeedbackToast)
