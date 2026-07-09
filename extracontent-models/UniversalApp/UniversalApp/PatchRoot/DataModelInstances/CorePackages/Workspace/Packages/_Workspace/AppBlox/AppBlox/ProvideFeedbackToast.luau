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
local v19 = game:DefineFastFlag("FixProvideFeedbackToastPositioning", false)
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast

local function ProvideFeedbackToast(t1: {[any]: any}) -- line: 56
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), SnackbarWrapper (copy), v19 (copy), useSelector (copy), Toast (copy)
	local v23 = useDispatch()
	local v24 = useTokens()
	local v25 = useLocalization({
		giveFeedback = "Feature.GameDetails.Action.GiveFeedback",
		helpUsImprove = "Feature.GameDetails.Message.HelpImproveExperience"
	})
	local v26 = React.useCallback(function() -- line: 64
		-- upvalues: t1 (copy), v23 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if t1.onToastActivated then
			task.spawn(t1.onToastActivated)
		end

		v23(SetCentralOverlay(CentralOverlayType.CheckboxFeedbackFormModal, t1.feedbackFormProps))
	end, {
		t1.onToastActivated,
		v23,
		t1.feedbackFormProps
	})
	local v27 = React.useCallback(function() -- line: 71
		-- upvalues: t1 (copy), v23 (copy), CloseCentralOverlay (copy)
		if t1.onToastDismissed then
			task.spawn(t1.onToastDismissed)
		end

		v23(CloseCentralOverlay())
	end, {
		t1.onToastDismissed,
		v23
	})

	if FFlagLuaAppUseSnackbarForProvideFeedbackToast then
		return React.createElement(SnackbarWrapper, {
			autoDismissDelaySeconds = 5,
			titleText = t1.toastTitle or v25.helpUsImprove,
			icon = t1.toastIcon,
			buttonText = t1.toastButtonText or v25.giveFeedback,
			onButtonActivated = v26,
			closeSnackbar = v27
		})
	end

	local t2 = {
		Color = v24.Inverse.Surface.Surface_0.Color3,
		Transparency = v24.Inverse.Surface.Surface_0.Transparency
	}
	local uDim2 = nil

	if v19 then
		local v30 = useSelector(function(p1) -- line: 96
			return p1.GlobalGuiInset or {
				left = 0,
				top = 0,
				right = 0,
				bottom = 0
			}
		end)
		local v31 = useSelector(function(p2) -- line: 105
			return p2.TopBar.statusBarHeight
		end)

		uDim2 = UDim2.new(0.5, 0, 0, v30.top + 20 + v31)
	end

	return React.createElement(Toast, {
		duration = 5,
		position = if not v19 then nil else uDim2,
		toastContent = {
			swipeUpDismiss = true,
			buttonText = t1.toastButtonText or v25.giveFeedback,
			iconColorStyle = t2,
			iconImage = t1.toastIcon,
			onActivated = v26,
			onAppeared = t1.onToastAppeared,
			onDismissed = v27,
			toastTitle = t1.toastTitle or v25.helpUsImprove,
			toastSubtitle = t1.toastSubtitle
		}
	})
end

return React.memo(ProvideFeedbackToast)
