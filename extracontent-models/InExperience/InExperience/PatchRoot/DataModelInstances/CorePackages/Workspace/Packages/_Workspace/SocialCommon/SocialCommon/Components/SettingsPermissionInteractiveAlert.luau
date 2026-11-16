local parent = script:FindFirstAncestor("SocialCommon").Parent
local MessageBusService = game:GetService("MessageBusService")
local AppStorageService = game:GetService("AppStorageService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local LinkingProtocol = require(parent.LinkingProtocol)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Dash = require(parent.Dash)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol

local default = LinkingProtocol.LinkingProtocol.default
local SettingsRoute = LinkingProtocol.Enums.SettingsRoute

local Dialog = Foundation.Dialog
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableRetryForLinkingProtocolFetch = SharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local SharedFlags2 = require(parent.SharedFlags)
local FIntLinkingProtocolFetchRetries = SharedFlags2.FIntLinkingProtocolFetchRetries
local SharedFlags3 = require(parent.SharedFlags)
local FIntLinkingProtocolFetchTimeoutMS = SharedFlags3.FIntLinkingProtocolFetchTimeoutMS
local SharedFlags4 = require(parent.SharedFlags)
local FFlagQRInSearchScanner = SharedFlags4.FFlagQRInSearchScanner

local SharedFlags5 = require(parent.SharedFlags)
local v = SharedFlags5.FFlagRegisterQRCodeKeyInEngine and "ProfileQrCodeCameraSettingsModalSeen"
	or "ScreenshotEventTracking"

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local eventStream = {
	SettingsPermissionInteractiveAlertButtonClick = {
		context = "settingsPermissionInteractiveAlert",
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { settingsRoute = Dash.identity, btn = Dash.identity }
	},
	SettingsPermissionInteractiveAlertImpression = {
		context = "settingsPermissionInteractiveAlert",
		eventType = EventTypes.SettingsPermissionInteractiveAlertImpression,
		formatRulesForAdditionalInfo = {
			settingsRoute = Dash.identity,
			settingsAppAvailable = Dash.identity
		}
	}
}

local v2 = {
	[SettingsRoute.Camera] = permissionsProtocol.Permissions.CAMERA_ACCESS,
	[SettingsRoute.Contacts] = permissionsProtocol.Permissions.CONTACTS_ACCESS
}

local function SettingsPermissionInteractiveAlert(props)
	local v3 = useDispatch()

	local settingsRoute = props.settingsRoute or props.navigation and props.navigation.getParam("settingsRoute")
	local source = props.source or props.navigation and props.navigation.getParam("source")

	local v4 = React.useCallback(function()
		if props.closeCentralOverlayThunk then
			return (v3(props.closeCentralOverlayThunk()))
		end

		return props.navigation and props.navigation.pop()
	end, { v3, props.closeCentralOverlayThunk, props.navigation })

	local v5 = React.useMemo(function()
		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = { EventStream = eventStream },
			analyticsImpl = { EventStream = DefaultAnalyticsService.EventStream },
			staticInfoForAllEvents = FFlagQRInSearchScanner and { source = source } or nil
		})()
	end)

	local v6 = false
	local v7 = nil
	local settingsAppAvailable = nil

	if settingsAppAvailable == nil then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function()
					v6, v7 = default:supportsSwitchToSettingsApp(settingsRoute):await()
				end)
				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if v7 ~= nil then
					break
				end
			end
		else
			v6, v7 = default:supportsSwitchToSettingsApp(settingsRoute):await()
		end

		settingsAppAvailable = v6 and v7
	end

	React.useEffect(function()
		v5.fireAnalyticsEvent("SettingsPermissionInteractiveAlertImpression", {
			settingsRoute = settingsRoute,
			settingsAppAvailable = settingsAppAvailable
		})

		AppStorageService:SetItem(v, "true")
		AppStorageService:Flush()

		local connection = MessageBusService:Subscribe(messageId, function()
			permissionsProtocol.default:hasPermissions({ v2[settingsRoute] }):andThen(function(p)
				if p and p.status == permissionsProtocol.Status.AUTHORIZED then
					v4()
				end
			end)
		end, false, true)
		return function()
			connection:Disconnect()
		end
	end, {})

	local v8 = useAppPolicy(function(p)
		return p.getShouldShowSettingsPermissionsAdditionalInstructions()
	end)

	local v9 = useLocalization({
		notNow = settingsAppAvailable and "CommonUI.Controls.Action.Cancel" or "Feature.SettingsHub.Action.NotNow",
		ok = "Feature.SettingsHub.Action.Ok",
		openSettings = settingsAppAvailable and "Feature.SettingsHub.Action.AllowInSettings" or "Feature.SettingsHub.Action.OpenSettings",
		titleCamera = settingsAppAvailable and "Feature.SettingsHub.Prompt.AllowAccessToCamera" or "Feature.SettingsHub.Prompt.NeedCameraAccess",
		titleContacts = settingsAppAvailable and "Feature.SettingsHub.Prompt.AllowAccessToContacts" or "Feature.SettingsHub.Prompt.NeedContactsAccess",
		bodyTextCamera = settingsAppAvailable and "Feature.SettingsHub.Description.CameraPermissionRequestQRCode" or "Feature.SettingsHub.Description.QRCodeCameraPermissionIOS",
		bodyTextContacts = settingsAppAvailable and "Feature.SettingsHub.Description.ContactsPermissionRequest" or "Feature.SettingsHub.Description.ContactsPermissionIOS",
		additionalInstructionsContactsDeeplinkSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroid",
		additionalInstructionsContactsDeeplinkNotSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroidDeeplinkNotSupported",
		additionalInstructionsCameraDeeplinkSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroid",
		additionalInstructionsCameraDeeplinkNotSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroidDeeplinkNotSupported"
	})

	local v10 = {
		[SettingsRoute.Camera] = v9.titleCamera,
		[SettingsRoute.Contacts] = v9.titleContacts
	}

	local v11 = {
		[SettingsRoute.Camera] = v9.bodyTextCamera,
		[SettingsRoute.Contacts] = v9.bodyTextContacts
	}

	local v12 = {
		[SettingsRoute.Contacts] = {
			deepLinkSupported = v9.additionalInstructionsContactsDeeplinkSupported,
			deepLinkNotSupported = v9.additionalInstructionsContactsDeeplinkNotSupported
		},
		[SettingsRoute.Camera] = {
			deepLinkSupported = v9.additionalInstructionsCameraDeeplinkSupported,
			deepLinkNotSupported = v9.additionalInstructionsCameraDeeplinkNotSupported
		}
	}

	local onActivated = React.useCallback(function()
		v5.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute,
			btn = "notNow"
		})

		return v4()
	end, { props.navigation })

	local onActivated2 = React.useCallback(function()
		v5.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute,
			btn = "ok"
		})

		return v4()
	end, { props.navigation })

	local onActivated3 = React.useCallback(function()
		v5.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			settingsRoute = settingsRoute,
			btn = "openSettings"
		})

		return default:switchToSettingsApp(settingsRoute)
	end, { props.navigation })
	local actions

	if settingsAppAvailable then
		actions = {
			{ text = v9.openSettings, variant = ButtonVariant.Emphasis, onActivated = onActivated3 },
			{ text = v9.notNow, variant = ButtonVariant.Standard, onActivated = onActivated }
		}
	else
		actions = {
			{ text = v9.ok, variant = ButtonVariant.Emphasis, onActivated = onActivated2 }
		}
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v13 = { size = DialogSize.Small, hasBackdrop = false, disablePortal = true }

	local children = {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v10[settingsRoute]
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement

	local v14 = {
		BodyText = React.createElement(Dialog.Text, { LayoutOrder = 1, Text = v11[settingsRoute] }),
		AdditionalInstructions = 0
	}
	local additionalInstructions

	if v8 then
		additionalInstructions = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v12[settingsRoute][settingsAppAvailable and "deepLinkSupported" or "deepLinkNotSupported"],
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
		})
	end

	v14.AdditionalInstructions = additionalInstructions
	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(View, { tag = "col gap-small size-full-0 auto-y" }, v14)
	})

	children.DialogActions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		orientation = Orientation.Vertical,
		actions = actions
	})
	return createElement(root, v13, children)
end

return SettingsPermissionInteractiveAlert
