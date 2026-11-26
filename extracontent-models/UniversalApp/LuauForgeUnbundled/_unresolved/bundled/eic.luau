local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dKz")
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local permissionsProtocol = require("@luauforge/bundled/bZh").PermissionsProtocol
local module2 = require("@luauforge/bundled/cye")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)

local module3 = require("@luauforge/bundled/dFu")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module5 = require("@luauforge/bundled/ehB")
local module6 = require("@luauforge/bundled/ehl")
local robloxEventReceiver = require("@luauforge/bundled/ehP").RobloxEventReceiver
local module7 = require("@luauforge/bundled/ehm")
local settingsRoute = require("@luauforge/bundled/bZe").Enums.SettingsRoute
local setTabBarVisible = require("@luauforge/bundled/dzQ").Actions.SetTabBarVisible

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavBarPlacement = module.useNavBarPlacement
local module8 = require("@luauforge/bundled/eie")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local fFlagQRCodeScannerDeeplinkEnabledForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRCodeScannerDeeplinkEnabledForAll
local fFlagQRInSearchScanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchScanner
local fFlagQRInSearchProfileQR = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchProfileQR

local fFlagAXFixTabBarOverrideForWrapperPages = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixTabBarOverrideForWrapperPages

local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialCarouselShareQREnabled
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

return function(p2)
	local v5 = useDispatch()
	local v6 = module8(appNotificationService)
	local v7 = React.useMemo(function()
		return robloxEventReceiver.new(v6)
	end, { v6 })

	if fFlagAXFixTabBarOverrideForWrapperPages or fFlagQRInSearchScanner or fFlagQRInSearchProfileQR then
		if fFlagAXFixTabBarOverrideForWrapperPages then
			local v8 = useNavBarPlacement() == module.Placement.Left
			React.useEffect(function()
				v5(setTabBarVisible(v8))
			end, { v5, v8 })
		else
			React.useEffect(function()
				v5(setTabBarVisible(false))
			end, { v5 })
		end
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagSocialCarouselShareQREnabled and p2.onClose then
			p2.onClose()
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v5(RobloxAppToastsRodux(true))
		end
	end
	local onClose = if fFlagSocialCarouselShareQREnabled then p2.onClose else nil
	local v10 = useCallback(fn, { onClose, if fFlagSocialCarouselShareQREnabled then v5 else nil })
	local v11

	if fFlagQRCodeScannerDeeplinkEnabledForAll then
		v11 = nil
	else
		v11 = useUserExperiment({ appUserLayers.ProfileQRCodeScannerLayer }, function(p3)
			return (p3[appUserLayers.ProfileQRCodeScannerLayer] or {}).systemSettingsDeeplinkEnabled
		end, false)
	end

	local v12 = React.useCallback(function()
		permissionsProtocol.default:checkOrRequestPermissions({ permissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(p3)
			if p3 == permissionsProtocol.Status.AUTHORIZED then
				local v13 = { name = module3.ScanQrCode }

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v13))
				else
					v5(module5(v13))
				end
			elseif fFlagQRCodeScannerDeeplinkEnabledForAll or v11 then
				v5(module7(module6.SettingsPermissionInteractiveAlert, {
					settingsRoute = settingsRoute.Camera
				}))
			else
				v5(module7(module6.CameraPermissionPrompt))
			end
		end)
	end, { v11 })

	return Roact.createElement(module2.ProfileQRCodeEntryPoint, {
		robloxEventReceiver = v7,
		source = p2.source,
		onClose = v10,
		openQrCodeScanner = v12
	})
end
