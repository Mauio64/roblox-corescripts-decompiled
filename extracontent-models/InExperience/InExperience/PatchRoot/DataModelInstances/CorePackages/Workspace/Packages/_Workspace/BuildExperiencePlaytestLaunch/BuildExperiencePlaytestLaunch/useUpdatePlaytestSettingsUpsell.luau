local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent
local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization

local AppPage = RobloxAppEnums.AppPage
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local DialogSize = Foundation.Enums.DialogSize

local function useUpdatePlaytestSettingsUpsell()
	local v = useDispatch()
	local v2 = useNavigation()

	local v3 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v4 = useLocalization({
		title = "Feature.Build.Action.Settings",
		body = "Feature.Build.Message.UpdateSettingsToPlaytest",
		updateSettings = "Feature.Build.Action.OpenSettings",
		cancel = "Feature.Build.Action.Cancel",
		ok = "CommonUI.Controls.Action.OK"
	})

	return (React.useCallback(function()
		local confirmationDialog = CentralOverlayType.ConfirmationDialog
		local v5 = {
			title = v4.title,
			body = v4.body,
			confirmButtonText = v4.updateSettings,
			cancelButtonText = 0,
			hideConfirmButton = 0,
			size = 0,
			orientButtonsVertically = true,
			showCloseButton = false,
			onConfirm = 0,
			onCancel = 0
		}

		local cancelButtonText = if v3 then v4.cancel else v4.ok
		v5.cancelButtonText = cancelButtonText
		v5.hideConfirmButton = not v3
		v5.size = DialogSize.Small

		function v5.onConfirm()
			v(CloseCentralOverlay())

			if v2 ~= nil then
				v2.push(AppPage.GenericWebPage, {
					detail = urlBuilder.static.settings.account(),
					extraProps = { title = v4.updateSettings }
				})
			end
		end
		function v5.onCancel()
			v(CloseCentralOverlay())
		end

		v(SetCentralOverlay(confirmationDialog, v5))
	end, { v, v2, v3, v4.title, v4.body, v4.updateSettings, v4.cancel, v4.ok }))
end

return useUpdatePlaytestSettingsUpsell
