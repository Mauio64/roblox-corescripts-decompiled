local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Localization")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/RobloxAppEnums")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/UniversalAppPolicy")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/UrlBuilder").UrlBuilder

local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization

local appPage = RobloxAppEnums.AppPage
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local dialogSize = Foundation.Enums.DialogSize

local function useUpdatePlaytestSettingsUpsell()
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v8 = useLocalization({
		title = "Feature.Build.Action.Settings",
		body = "Feature.Build.Message.UpdateSettingsToPlaytest",
		updateSettings = "Feature.Build.Action.OpenSettings",
		cancel = "Feature.Build.Action.Cancel",
		ok = "CommonUI.Controls.Action.OK"
	})

	return (React.useCallback(function()
		local confirmationDialog = centralOverlayType.ConfirmationDialog
		local v11 = {
			title = v8.title,
			body = v8.body,
			confirmButtonText = v8.updateSettings,
			cancelButtonText = 0,
			hideConfirmButton = 0,
			size = 0,
			orientButtonsVertically = true,
			showCloseButton = false,
			onConfirm = 0,
			onCancel = 0
		}

		local v12 = if v7 then v8.cancel else v8.ok
		v11.cancelButtonText = v12
		v11.hideConfirmButton = not v7
		v11.size = dialogSize.Small

		function v11.onConfirm()
			v5(closeCentralOverlay())

			if v6 ~= nil then
				v6.push(appPage.GenericWebPage, {
					detail = urlBuilder.static.settings.account(),
					extraProps = { title = v8.updateSettings }
				})
			end
		end
		function v11.onCancel()
			v5(closeCentralOverlay())
		end

		v5(setCentralOverlay(confirmationDialog, v11))
	end, { v5, v6, v7, v8.title, v8.body, v8.updateSettings, v8.cancel, v8.ok }))
end

return useUpdatePlaytestSettingsUpsell
