local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol
local ProfileQRCode = require(CorePackages.Workspace.Packages.ProfileQRCode)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local RobloxEventReceiver = require(CorePackages.Workspace.Packages.RealtimeDelivery).RobloxEventReceiver
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local SettingsRoute = require(CorePackages.Workspace.Packages.LinkingProtocol).Enums.SettingsRoute
local SetTabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Actions.SetTabBarVisible
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local FFlagQRCodeScannerDeeplinkEnabledForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRCodeScannerDeeplinkEnabledForAll
local FFlagQRInSearchScanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchScanner
local FFlagQRInSearchProfileQR = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchProfileQR
local FFlagSocialCarouselShareQREnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSocialCarouselShareQREnabled
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(t1: {[any]: any}) -- line: 44
	-- upvalues: useDispatch (copy), useRoactService (copy), AppNotificationService (copy), React (copy), RobloxEventReceiver (copy), FFlagQRInSearchScanner (copy), FFlagQRInSearchProfileQR (copy), SetTabBarVisible (copy), FFlagSocialCarouselShareQREnabled (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateBack (copy), FFlagQRCodeScannerDeeplinkEnabledForAll (copy), useUserExperiment (copy), AppUserLayers (copy), PermissionsProtocol (copy), AppPage (copy), NavigateDown (copy), SetCentralOverlay (copy), OverlayType (copy), SettingsRoute (copy), Roact (copy), ProfileQRCode (copy)
	local v27 = useDispatch()
	local v28 = useRoactService(AppNotificationService)
	local v29 = React.useMemo(function() -- line: 47
		-- upvalues: RobloxEventReceiver (copy), v28 (copy)
		return RobloxEventReceiver.new(v28)
	end, { v28 })

	if FFlagQRInSearchScanner or FFlagQRInSearchProfileQR then
		React.useEffect(function() -- line: 52
			-- upvalues: v27 (copy), SetTabBarVisible (copy)
			v27(SetTabBarVisible(false))
		end, { v27 })
	end

	local v30 = React.useCallback(function() -- line: 57
		-- upvalues: FFlagSocialCarouselShareQREnabled (copy), t1 (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v27 (copy), NavigateBack (copy)
		if FFlagSocialCarouselShareQREnabled and t1.onClose then
			t1.onClose()

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v25.back(true)

			return
		end

		v27(NavigateBack(true))
	end, {
		if not FFlagSocialCarouselShareQREnabled then nil else t1.onClose,
		if not FFlagSocialCarouselShareQREnabled then nil else v27
	})
	local v31 = if FFlagQRCodeScannerDeeplinkEnabledForAll then nil else useUserExperiment({ AppUserLayers.ProfileQRCodeScannerLayer }, function(p1) -- line: 74
		-- upvalues: AppUserLayers (copy)
		return (p1[AppUserLayers.ProfileQRCodeScannerLayer] or {}).systemSettingsDeeplinkEnabled
	end, false)
	local v32 = React.useCallback(function() -- line: 80
		-- upvalues: PermissionsProtocol (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v27 (copy), NavigateDown (copy), FFlagQRCodeScannerDeeplinkEnabledForAll (copy), v31 (copy), SetCentralOverlay (copy), OverlayType (copy), SettingsRoute (copy)
		PermissionsProtocol.default:checkOrRequestPermissions({ PermissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(p2) -- line: 85
			-- upvalues: PermissionsProtocol (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v27 (copy), NavigateDown (copy), FFlagQRCodeScannerDeeplinkEnabledForAll (copy), v31 (copy), SetCentralOverlay (copy), OverlayType (copy), SettingsRoute (copy)
			if p2 == PermissionsProtocol.Status.AUTHORIZED then
				local t2 = {
					name = AppPage.ScanQrCode
				}

				if FFlagSignalsNavP3Dispatch then
					v25.down(v25.fromLegacyPage(t2))

					return
				end

				v27(NavigateDown(t2))

				return
			end

			if FFlagQRCodeScannerDeeplinkEnabledForAll or v31 then
				v27(SetCentralOverlay(OverlayType.SettingsPermissionInteractiveAlert, {
					settingsRoute = SettingsRoute.Camera
				}))

				return
			end

			v27(SetCentralOverlay(OverlayType.CameraPermissionPrompt))
		end)
	end, { v31 })

	return Roact.createElement(ProfileQRCode.ProfileQRCodeEntryPoint, {
		robloxEventReceiver = v29,
		source = t1.source,
		onClose = v30,
		openQrCodeScanner = v32
	})
end
