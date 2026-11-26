local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")

local modules = require("@luauforge/bundled/dtb").Modules
local React = require(CorePackages.Packages.React)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableAppRatingPromptLua = SharedFlags.FFlagEnableAppRatingPromptLua
local fFlagEnableAndroidAppRatingPromptLua = SharedFlags.FFlagEnableAndroidAppRatingPromptLua
local fFlagEnableUserAccessServiceIntegration = SharedFlags.FFlagEnableUserAccessServiceIntegration
local fFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local fFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local fFlagEnableRobloxSubscriptionEventListener = SharedFlags.FFlagEnableRobloxSubscriptionEventListener
local getFFlagEnableVREnvironmentSetting = SharedFlags.GetFFlagEnableVREnvironmentSetting
local getFFlagEnableSkyStyle = SharedFlags.GetFFlagEnableSkyStyle
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagLuaAppSduiHomeFriendCarousel = SharedFlags.FFlagLuaAppSduiHomeFriendCarousel
local fFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport
local fFlagEnableAdConsentUserSettingsPublish = SharedFlags.FFlagEnableAdConsentUserSettingsPublish
local fFlagMoveAdConsentReceiverToAccountManagement = SharedFlags.FFlagMoveAdConsentReceiverToAccountManagement
local fFlagRouteStandaloneAmpThroughUniversalApp = SharedFlags.FFlagRouteStandaloneAmpThroughUniversalApp
local fFlagMomentsHidePostStatusToastEverywhere = SharedFlags.FFlagMomentsHidePostStatusToastEverywhere

local module2 = require("@luauforge/bundled/iii")
local module3 = require("@luauforge/bundled/iij")

local getFFlagLuaAppChallengeDialogEventReceiverEnabled = require("@luauforge/bundled/dIX").GetFFlagLuaAppChallengeDialogEventReceiverEnabled
local module4 = require("@luauforge/bundled/iik")
local module5 = require("@luauforge/bundled/iil")

local getFFlagEnableParentalControlsScreentimeEnforcement = require("@luauforge/bundled/iim").GetFFlagEnableParentalControlsScreentimeEnforcement
local getFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local fFlagLuaAppBirthdayComplianceGate = SharedFlags.FFlagLuaAppBirthdayComplianceGate

local magicLoginApprovePopupEventReceiver = require("@luauforge/bundled/ggx").MagicLoginApprovePopupEventReceiver

local systemThemeEnabled = require("@luauforge/bundled/fGL").GetSystemThemeEnabled()

local v5 = systemThemeEnabled and require("@luauforge/bundled/iix") or nil

local module6 = require("@luauforge/bundled/iiA")
local module7 = require("@luauforge/bundled/iiC")
local module8 = require("@luauforge/bundled/iiD")
local module9 = require("@luauforge/bundled/iiH")
local module10 = require("@luauforge/bundled/iiJ")
local module11 = require("@luauforge/bundled/iiO")

local module12 = require("@luauforge/bundled/iiS")

local adConsentHybridEventReceiver = require("@luauforge/bundled/iiT").AdConsentHybridEventReceiver
local module13 = require("@luauforge/bundled/ija")
local module14 = require("@luauforge/bundled/ijb")

local module15 = require("@luauforge/bundled/ijl")
local module16 = require("@luauforge/bundled/ijn")
local module17 = require("@luauforge/bundled/ijp")
local module18 = require("@luauforge/bundled/ijq")

local module19 = require("@luauforge/bundled/ijs")
local module20 = require("@luauforge/bundled/ijt")
local module21 = require("@luauforge/bundled/iju")
local module22 = require("@luauforge/bundled/ijw")
local module23 = require("@luauforge/bundled/ijx")
local module24 = require("@luauforge/bundled/ijF")
local onGameLeaveReceiver = modules.LuaApp.Components.EventReceivers.OnGameLeaveReceiver
local module25 = require("@luauforge/bundled/ijK")
local module26 = require("@luauforge/bundled/ijL")

local v6 = if fFlagMomentsHidePostStatusToastEverywhere then require("@luauforge/bundled/ikh") else nil

local v7 = if fFlagFriendsCallingClientGate_DEV then require("@luauforge/bundled/ikj") else nil

local module27 = require("@luauforge/bundled/iko")

local v8 = if require("@luauforge/bundled/ikp") then require("@luauforge/bundled/ikq") else nil

local challengeDialogEventReceiver = require("@luauforge/bundled/dIX").ChallengeDialogEventReceiver
local module28 = require("@luauforge/bundled/ikr")
local module29 = require("@luauforge/bundled/iks")

local module30 = require("@luauforge/bundled/iku")

local module31 = require("@luauforge/bundled/ikA")
local appRatingPromptEventReceiver

if fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua then
	appRatingPromptEventReceiver = require("@luauforge/bundled/ikN").AppRatingPromptEventReceiver or nil
else
	appRatingPromptEventReceiver = nil
end

local inAppInterventionEventReceiver = require("@luauforge/bundled/hZH").InAppInterventionEventReceiver

local v9 = if fFlagAppNavMyStatsTab then require("@luauforge/bundled/ild") else nil

local module32 = require("@luauforge/bundled/ile")
local module33 = require("@luauforge/bundled/ilh")
local module34 = require("@luauforge/bundled/ili")
local ampWizardLaunchReceiver = require("@luauforge/bundled/eif").AmpWizardLaunchReceiver

local module35 = require("@luauforge/bundled/ill")
local v10 = if getFFlagEnableVREnvironmentSetting() then require("@luauforge/bundled/iln") else nil

local v11 = if getFFlagEnableSkyStyle() then require("@luauforge/bundled/ilo") else nil

local robloxEventReceiver = require("@luauforge/bundled/ehP").RobloxEventReceiver
local module36 = require("@luauforge/bundled/ilp")
local module37 = require("@luauforge/bundled/ilq")

local module38 = require("@luauforge/bundled/ilr")
local module39 = require("@luauforge/bundled/ils")
local fFlagEnableSettingsTelemetry = SharedFlags.FFlagEnableSettingsTelemetry

local module40 = require("@luauforge/bundled/ilv")

return function()
	local v12 = React.useMemo(function()
		return robloxEventReceiver.new(NotificationService)
	end, {})

	local v13 = React.useMemo(function()
		local v16 = if fFlagRouteStandaloneAmpThroughUniversalApp then ampWizardLaunchReceiver else nil
		local v18

		if fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua then
			v18 = appRatingPromptEventReceiver
		end

		local v20 = if getFFlagIsSquadEnabled() then module25 else nil
		local v23

		if getFFlagLuaAppChallengeDialogEventReceiverEnabled() then
			v23 = challengeDialogEventReceiver
		end

		local v24 = if module2() then module31 else nil
		local v14 = {
			module34,
			v16,
			module26,
			v18,
			v9,
			v20,
			module11,
			module6,
			v23,
			v24,
			module37,
			module14,
			if systemThemeEnabled then v5 else nil,
			module17,
			module18,
			module8,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		}
		local v28 = if fFlagLuaAppSduiHomeFriendCarousel then module19 else nil
		local v29 = if fFlagLuaAppSduiHomePageSupport then module20 else nil
		local v32 = if fFlagEnableUserAccessServiceIntegration then module29 else nil
		local v39 = if getFFlagEnableParentalControlsScreentimeEnforcement() then module30 else nil

		v14[17], v14[18], v14[19], v14[20], v14[21], v14[22], v14[23], v14[24], v14[25], v14[26], v14[27], v14[28], v14[29], v14[30], v14[31], v14[32] = v28, v29, module16, inAppInterventionEventReceiver, v32, module15, module22, module10, onGameLeaveReceiver, module27, v8, v39, module33, if fFlagMomentsHidePostStatusToastEverywhere then v6 else nil, module23, module28
		local v42 = if module4() then module24 else nil
		local v45 = if fFlagEnableSettingsTelemetry then module39 else nil
		local v46 = if module3 or module5 then module32 else nil
		local v49

		if fFlagEnableAdConsentUserSettingsPublish and fFlagMoveAdConsentReceiverToAccountManagement then
			v49 = adConsentHybridEventReceiver
		end

		local v50 = if fFlagFriendsCallingClientGate_DEV then v7 else nil
		local v51 = if getFFlagEnablePlatformRestrictedEventReceiver() then module38 else nil
		local v52 = if fFlagLuaAppBirthdayComplianceGate then module40 else nil
		local v53 = if fFlagEnableMagicLogin then magicLoginApprovePopupEventReceiver else nil
		local v55 = if fFlagEnableRobloxSubscriptionEventListener then module35 else nil
		local v56 = if getFFlagEnableSkyStyle() then v11 else v10
		v14[33], v14[34], v14[35], v14[36], v14[37], v14[38], v14[39], v14[40], v14[41], v14[42], v14[43], v14[44], v14[45], v14[46], v14[47] = v42, module7, module21, v45, v46, module13, module12, v49, v50, v51, v52, v53, module9, v55, v56

		return v14
	end, {})

	return React.createElement(module36, {
		RobloxEventReceiver = v12,
		receiverComponents = v13
	})
end
