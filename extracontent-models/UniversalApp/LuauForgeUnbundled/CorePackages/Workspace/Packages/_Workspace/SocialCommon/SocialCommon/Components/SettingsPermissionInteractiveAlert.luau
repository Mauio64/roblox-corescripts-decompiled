local MessageBusService = game:GetService("MessageBusService")
local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/RoactUtils").Hooks.RoactRodux.useDispatch

local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/LinkingProtocol")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialLuaAnalytics")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Dash")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UniversalAppPolicy").useAppPolicy
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/PermissionsProtocol").PermissionsProtocol

local default = LinkingProtocol.LinkingProtocol.default
local settingsRoute = LinkingProtocol.Enums.SettingsRoute

local dialog = Foundation.Dialog
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes

local fFlagEnableRetryForLinkingProtocolFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagEnableRetryForLinkingProtocolFetch
local fIntLinkingProtocolFetchRetries = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FIntLinkingProtocolFetchRetries
local fIntLinkingProtocolFetchTimeoutMS = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FIntLinkingProtocolFetchTimeoutMS
local fFlagQRInSearchScanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagQRInSearchScanner

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagRegisterQRCodeKeyInEngine and "ProfileQrCodeCameraSettingsModalSeen"
	or "ScreenshotEventTracking"

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local v6 = {
	SettingsPermissionInteractiveAlertButtonClick = {
		context = "settingsPermissionInteractiveAlert",
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			settingsRoute = Dash.identity,
			btn = Dash.identity
		}
	},
	SettingsPermissionInteractiveAlertImpression = {
		context = "settingsPermissionInteractiveAlert",
		eventType = eventTypes.SettingsPermissionInteractiveAlertImpression,
		formatRulesForAdditionalInfo = {
			settingsRoute = Dash.identity,
			settingsAppAvailable = Dash.identity
		}
	}
}

local v7 = {
	[settingsRoute.Camera] = permissionsProtocol.Permissions.CAMERA_ACCESS,
	[settingsRoute.Contacts] = permissionsProtocol.Permissions.CONTACTS_ACCESS
}

local function SettingsPermissionInteractiveAlert(props)
	local v8 = useDispatch()

	local settingsRoute2 = props.settingsRoute
		or props.navigation and props.navigation.getParam("settingsRoute")
	local source = props.source or props.navigation and props.navigation.getParam("source")

	local v9 = React.useCallback(function()
		if props.closeCentralOverlayThunk then
			return (v8(props.closeCentralOverlayThunk()))
		end

		return props.navigation and props.navigation.pop()
	end, { v8, props.closeCentralOverlayThunk, props.navigation })

	local v10 = React.useMemo(function()
		return analyticsFactory.setUpAnalyticsFactory({
			eventLists = { EventStream = v6 },
			analyticsImpl = { EventStream = defaultAnalyticsService.EventStream },
			staticInfoForAllEvents = fFlagQRInSearchScanner and { source = source } or nil
		})()
	end)

	local v11 = false
	local v12 = nil
	local v13 = nil

	if v13 == nil then
		if fFlagEnableRetryForLinkingProtocolFetch then
			for i = 0, fIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function()
					v11, v12 = default:supportsSwitchToSettingsApp(settingsRoute2):await()
				end)
				task.wait(fIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if v12 ~= nil then
					break
				end
			end
		else
			v11, v12 = default:supportsSwitchToSettingsApp(settingsRoute2):await()
		end

		v13 = v11 and v12
	end

	React.useEffect(function()
		v10.fireAnalyticsEvent("SettingsPermissionInteractiveAlertImpression", {
			settingsRoute = settingsRoute2,
			settingsAppAvailable = v13
		})

		AppStorageService:SetItem(v5, "true")
		AppStorageService:Flush()

		local connection = MessageBusService:Subscribe(messageId, function()
			permissionsProtocol.default:hasPermissions({ v7[settingsRoute2] }):andThen(function(p2)
				if p2 and p2.status == permissionsProtocol.Status.AUTHORIZED then
					v9()
				end
			end)
		end, false, true)
		return function()
			connection:Disconnect()
		end
	end, {})

	local v14 = useAppPolicy(function(p2)
		return p2.getShouldShowSettingsPermissionsAdditionalInstructions()
	end)

	local v16 = useLocalization({
		notNow = v13 and "CommonUI.Controls.Action.Cancel" or "Feature.SettingsHub.Action.NotNow",
		ok = "Feature.SettingsHub.Action.Ok",
		openSettings = v13 and "Feature.SettingsHub.Action.AllowInSettings" or "Feature.SettingsHub.Action.OpenSettings",
		titleCamera = v13 and "Feature.SettingsHub.Prompt.AllowAccessToCamera" or "Feature.SettingsHub.Prompt.NeedCameraAccess",
		titleContacts = v13 and "Feature.SettingsHub.Prompt.AllowAccessToContacts" or "Feature.SettingsHub.Prompt.NeedContactsAccess",
		bodyTextCamera = v13 and "Feature.SettingsHub.Description.CameraPermissionRequestQRCode" or "Feature.SettingsHub.Description.QRCodeCameraPermissionIOS",
		bodyTextContacts = v13 and "Feature.SettingsHub.Description.ContactsPermissionRequest" or "Feature.SettingsHub.Description.ContactsPermissionIOS",
		additionalInstructionsContactsDeeplinkSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroid",
		additionalInstructionsContactsDeeplinkNotSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroidDeeplinkNotSupported",
		additionalInstructionsCameraDeeplinkSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroid",
		additionalInstructionsCameraDeeplinkNotSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroidDeeplinkNotSupported"
	})

	local v17 = {
		[settingsRoute.Camera] = v16.titleCamera,
		[settingsRoute.Contacts] = v16.titleContacts
	}

	local v18 = {
		[settingsRoute.Camera] = v16.bodyTextCamera,
		[settingsRoute.Contacts] = v16.bodyTextContacts
	}

	local v19 = {
		[settingsRoute.Contacts] = {
			deepLinkSupported = v16.additionalInstructionsContactsDeeplinkSupported,
			deepLinkNotSupported = v16.additionalInstructionsContactsDeeplinkNotSupported
		},
		[settingsRoute.Camera] = {
			deepLinkSupported = v16.additionalInstructionsCameraDeeplinkSupported,
			deepLinkNotSupported = v16.additionalInstructionsCameraDeeplinkNotSupported
		}
	}

	local v20 = React.useCallback(function()
		v10.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute2,
			btn = "notNow"
		})

		return v9()
	end, { props.navigation })

	local v21 = React.useCallback(function()
		v10.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute2,
			btn = "ok"
		})

		return v9()
	end, { props.navigation })

	local v22 = React.useCallback(function()
		v10.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute2,
			btn = "openSettings"
		})

		return default:switchToSettingsApp(settingsRoute2)
	end, { props.navigation })
	local v23

	if v13 then
		v23 = {
			{
				text = v16.openSettings,
				variant = buttonVariant.Emphasis,
				onActivated = v22
			},
			{ text = v16.notNow, variant = buttonVariant.Standard, onActivated = v20 }
		}
	else
		v23 = {
			{ text = v16.ok, variant = buttonVariant.Emphasis, onActivated = v21 }
		}
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v24 = { size = dialogSize.Small, hasBackdrop = false, disablePortal = true }

	local children = {
		DialogTitle = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = v17[settingsRoute2]
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement

	local v29 = {
		BodyText = React.createElement(dialog.Text, {
			LayoutOrder = 1,
			Text = v18[settingsRoute2]
		}),
		AdditionalInstructions = 0
	}

	local v30 = if v14 then React.createElement(text, {
		LayoutOrder = 2,
		Text = v19[settingsRoute2][v13 and "deepLinkSupported" or "deepLinkNotSupported"],
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
	}) else nil
	v29.AdditionalInstructions = v30
	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(view, { tag = "col gap-small size-full-0 auto-y" }, v29)
	})

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		orientation = orientation.Vertical,
		actions = v23
	})
	return createElement(root, v24, children)
end

return SettingsPermissionInteractiveAlert
