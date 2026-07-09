local Parent = script:FindFirstAncestor("SocialCommon").Parent
local MessageBusService = game:GetService("MessageBusService")
local AppStorageService = game:GetService("AppStorageService")
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local LinkingProtocol = require(Parent.LinkingProtocol)
local Text = require(Parent.AppCommonLib).Text
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local Dash = require(Parent.Dash)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local PermissionsProtocol = require(Parent.PermissionsProtocol).PermissionsProtocol
local default = LinkingProtocol.LinkingProtocol.default
local SettingsRoute = LinkingProtocol.Enums.SettingsRoute
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local FFlagEnableRetryForLinkingProtocolFetch = require(Parent.SharedFlags).FFlagEnableRetryForLinkingProtocolFetch
local FIntLinkingProtocolFetchRetries = require(Parent.SharedFlags).FIntLinkingProtocolFetchRetries
local FIntLinkingProtocolFetchTimeoutMS = require(Parent.SharedFlags).FIntLinkingProtocolFetchTimeoutMS
local FFlagQRInSearchScanner = require(Parent.SharedFlags).FFlagQRInSearchScanner
local v29 = not require(Parent.SharedFlags).FFlagRegisterQRCodeKeyInEngine and "ScreenshotEventTracking" or "ProfileQrCodeCameraSettingsModalSeen"
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")
local t1 = {
	SettingsPermissionInteractiveAlertButtonClick = {
		context = "settingsPermissionInteractiveAlert",
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			settingsRoute = Dash.identity,
			btn = Dash.identity
		}
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
local t2 = {
	[SettingsRoute.Camera] = PermissionsProtocol.Permissions.CAMERA_ACCESS,
	[SettingsRoute.Contacts] = PermissionsProtocol.Permissions.CONTACTS_ACCESS
}

local function SettingsPermissionInteractiveAlert(t3: {[any]: any}) -- line: 86
	-- upvalues: useScreenSize (copy), useDispatch (copy), useStyle (copy), React (copy), AnalyticsFactory (copy), t1 (copy), DefaultAnalyticsService (copy), FFlagQRInSearchScanner (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default (copy), FIntLinkingProtocolFetchTimeoutMS (copy), AppStorageService (copy), v29 (copy), MessageBusService (copy), MessageId (copy), PermissionsProtocol (copy), t2 (copy), useAppPolicy (copy), useLocalization (copy), SettingsRoute (copy), Images (copy), ButtonType (copy), StyledTextLabel (copy), Text (copy), InteractiveAlert (copy)
	local v35 = useScreenSize()
	local v36 = useDispatch()
	local v37 = useStyle()
	local v38 = t3.settingsRoute or t3.navigation and t3.navigation.getParam("settingsRoute")
	local v39 = t3.source or t3.navigation and t3.navigation.getParam("source")
	local v40 = React.useCallback(function() -- line: 95
		-- upvalues: t3 (copy), v36 (copy)
		if t3.closeCentralOverlayThunk then
			return (v36(t3.closeCentralOverlayThunk()))
		end

		return t3.navigation and t3.navigation.pop()
	end, {
		v36,
		t3.closeCentralOverlayThunk,
		t3.navigation
	})
	local v41 = React.useMemo(function() -- line: 102
		-- upvalues: AnalyticsFactory (copy), t1 (copy), DefaultAnalyticsService (copy), FFlagQRInSearchScanner (copy), v39 (copy)
		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = {
				EventStream = t1
			},
			analyticsImpl = {
				EventStream = DefaultAnalyticsService.EventStream
			},
			staticInfoForAllEvents = if not FFlagQRInSearchScanner then nil else {
				source = v39
			}
		})()
	end)
	local u42 = false
	local u43 = nil
	local u44 = nil

	if u44 == nil then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function() -- line: 132
					-- upvalues: u42 (ref), u43 (ref), default (copy), v38 (copy)
					local v63, v64 = default:supportsSwitchToSettingsApp(v38):await()

					u42 = v63
					u43 = v64
				end)

				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if u43 ~= nil then
					break
				end
			end
		else
			local v47, v48 = default:supportsSwitchToSettingsApp(v38):await()

			u42 = v47
			u43 = v48
		end

		u44 = u42 and u43
	end

	React.useEffect(function() -- line: 149
		-- upvalues: v41 (copy), v38 (copy), u44 (ref), AppStorageService (copy), v29 (copy), MessageBusService (copy), MessageId (copy), PermissionsProtocol (copy), t2 (copy), v40 (copy)
		v41.fireAnalyticsEvent("SettingsPermissionInteractiveAlertImpression", {
			settingsRoute = v38,
			settingsAppAvailable = u44
		})
		AppStorageService:SetItem(v29, "true")
		AppStorageService:Flush()

		local v65 = MessageBusService:Subscribe(MessageId, function() -- line: 158
			-- upvalues: PermissionsProtocol (copy), t2 (copy), v38 (copy), v40 (copy)
			PermissionsProtocol.default:hasPermissions({ t2[v38] }):andThen(function(p1) -- line: 163
				-- upvalues: PermissionsProtocol (copy), v40 (copy)
				if p1 and p1.status == PermissionsProtocol.Status.AUTHORIZED then
					v40()
				end
			end)
		end, false, true)

		return function() -- line: 170
			-- upvalues: v65 (copy)
			v65:Disconnect()
		end
	end, {})

	local v49 = useAppPolicy(function(p2) -- line: 175
		return p2.getShouldShowSettingsPermissionsAdditionalInstructions()
	end)
	local v50 = useLocalization({
		notNow = "Feature.SettingsHub.Action.NotNow",
		ok = "Feature.SettingsHub.Action.Ok",
		openSettings = "Feature.SettingsHub.Action.OpenSettings",
		titleCamera = "Feature.SettingsHub.Prompt.NeedCameraAccess",
		titleContacts = "Feature.SettingsHub.Prompt.NeedContactsAccess",
		bodyTextCamera = "Feature.SettingsHub.Description.QRCodeCameraPermissionIOS",
		bodyTextContacts = "Feature.SettingsHub.Description.ContactsPermissionIOS",
		additionalInstructionsContactsDeeplinkSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroid",
		additionalInstructionsContactsDeeplinkNotSupported = "Feature.SettingsHub.Description.ContactsPermissionAndroidDeeplinkNotSupported",
		additionalInstructionsCameraDeeplinkSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroid",
		additionalInstructionsCameraDeeplinkNotSupported = "Feature.SettingsHub.Description.QRCodeCameraPermissionAndroidDeeplinkNotSupported"
	})
	local t4 = {
		[SettingsRoute.Camera] = Images["icons/controls/cameraOff"],
		[SettingsRoute.Contacts] = Images["icons/menu/contacts_large"]
	}
	local t5 = {
		[SettingsRoute.Camera] = v50.titleCamera,
		[SettingsRoute.Contacts] = v50.titleContacts
	}
	local t6 = {
		[SettingsRoute.Camera] = v50.bodyTextCamera,
		[SettingsRoute.Contacts] = v50.bodyTextContacts
	}
	local v54 = "<b>" .. ({
		[SettingsRoute.Contacts] = {
			deepLinkSupported = v50.additionalInstructionsContactsDeeplinkSupported,
			deepLinkNotSupported = v50.additionalInstructionsContactsDeeplinkNotSupported
		},
		[SettingsRoute.Camera] = {
			deepLinkSupported = v50.additionalInstructionsCameraDeeplinkSupported,
			deepLinkNotSupported = v50.additionalInstructionsCameraDeeplinkNotSupported
		}
	})[v38][not u44 and "deepLinkNotSupported" or "deepLinkSupported"] .. "</b>"
	local v55 = React.useCallback(function() -- line: 225
		-- upvalues: v41 (copy), v38 (copy), v40 (copy)
		v41.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			btn = "notNow",
			settingsRoute = v38
		})

		return v40()
	end, { t3.navigation })
	local t7 = {
		buttonType = ButtonType.Secondary,
		props = {
			onActivated = v55,
			text = v50.notNow
		}
	}
	local v57 = React.useCallback(function() -- line: 240
		-- upvalues: v41 (copy), v38 (copy), v40 (copy)
		v41.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			btn = "ok",
			settingsRoute = v38
		})

		return v40()
	end, { t3.navigation })
	local t8 = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = v57,
			text = v50.ok
		}
	}
	local v59 = React.useCallback(function() -- line: 255
		-- upvalues: v41 (copy), v38 (copy), default (copy)
		v41.fireAnalyticsEvent("SettingsPermissionInteractiveAlertButtonClick", {
			btn = "openSettings",
			settingsRoute = v38
		})

		return default:switchToSettingsApp(v38)
	end, { t3.navigation })
	local t9 = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = v59,
			text = v50.openSettings
		}
	}
	local t10 = {
		buttons = if not u44 then { t8 } else {
			t7,
			t9
		}
	}
	local v62 = React.useCallback(function() -- line: 275
		-- upvalues: React (copy), StyledTextLabel (copy), v37 (copy), t6 (copy), v38 (copy), v49 (copy), Text (copy), v54 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			DeepLinkInstructions = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				fluidSizing = false,
				layoutOrder = 1,
				automaticSize = Enum.AutomaticSize.Y,
				fontStyle = v37.Font.Body,
				colorStyle = v37.Theme.TextDefault,
				size = UDim2.fromScale(1, 0),
				text = t6[v38]
			}),
			additionalInstructionsFrame = if not v49 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, Text.GetTextHeight("", v37.Font.Body.Font, v37.Font.BaseSize * v37.Font.Body.RelativeSize)),
					PaddingLeft = UDim.new(0, 5)
				}),
				AdditionalInstructions = React.createElement(StyledTextLabel, {
					fluidSizing = false,
					lineHeight = 1,
					automaticSize = Enum.AutomaticSize.Y,
					fontStyle = v37.Font.Body,
					colorStyle = v37.Theme.TextDefault,
					size = UDim2.fromScale(1, 0),
					text = v54
				})
			})
		})
	end, { t3.navigation })

	return React.createElement(InteractiveAlert, {
		richText = true,
		screenSize = v35,
		title = t5[v38],
		titleIcon = t4[v38],
		middleContent = v62,
		buttonStackInfo = t10
	})
end

return SettingsPermissionInteractiveAlert
