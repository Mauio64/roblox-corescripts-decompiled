local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")

local modules = require("@luauforge/bundled/dpZ").Modules
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

local module2 = require("@luauforge/bundled/hYi")
local module3 = require("@luauforge/bundled/hYj")

local getFFlagLuaAppChallengeDialogEventReceiverEnabled = require("@luauforge/bundled/dFS").GetFFlagLuaAppChallengeDialogEventReceiverEnabled
local module4 = require("@luauforge/bundled/hYk")
local module5 = require("@luauforge/bundled/hYl")

local getFFlagEnableParentalControlsScreentimeEnforcement = require("@luauforge/bundled/hYm").GetFFlagEnableParentalControlsScreentimeEnforcement
local getFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local fFlagLuaAppBirthdayComplianceGate = SharedFlags.FFlagLuaAppBirthdayComplianceGate

local magicLoginApprovePopupEventReceiver = require("@luauforge/bundled/fCe").MagicLoginApprovePopupEventReceiver

local systemThemeEnabled = require("@luauforge/bundled/fyV").GetSystemThemeEnabled()

local v5 = systemThemeEnabled and require("@luauforge/bundled/hYx") or nil

local module6 = require("@luauforge/bundled/hYA")
local module7 = require("@luauforge/bundled/hYC")
local module8 = require("@luauforge/bundled/hYD")
local module9 = require("@luauforge/bundled/hYH")
local module10 = require("@luauforge/bundled/hYJ")
local module11 = require("@luauforge/bundled/hYO")

local module12 = require("@luauforge/bundled/hYS")

local adConsentHybridEventReceiver = require("@luauforge/bundled/hYU").AdConsentHybridEventReceiver
local module13 = require("@luauforge/bundled/hZb")
local module14 = require("@luauforge/bundled/hZc")

local module15 = require("@luauforge/bundled/iaV")
local module16 = require("@luauforge/bundled/iaX")
local module17 = require("@luauforge/bundled/iaZ")
local module18 = require("@luauforge/bundled/iba")

local module19 = require("@luauforge/bundled/ibc")
local module20 = require("@luauforge/bundled/ibd")
local module21 = require("@luauforge/bundled/ibe")
local module22 = require("@luauforge/bundled/ibg")
local module23 = require("@luauforge/bundled/ibh")
local module24 = require("@luauforge/bundled/ibr")
local onGameLeaveReceiver = modules.LuaApp.Components.EventReceivers.OnGameLeaveReceiver
local module25 = require("@luauforge/bundled/ibs")
local module26 = require("@luauforge/bundled/ibt")

local v6 = if fFlagFriendsCallingClientGate_DEV then require("@luauforge/bundled/ibP") else nil

local module27 = require("@luauforge/bundled/ibU")

local v7 = if require("@luauforge/bundled/ibV") then require("@luauforge/bundled/ibW") else nil

local challengeDialogEventReceiver = require("@luauforge/bundled/dFS").ChallengeDialogEventReceiver
local module28 = require("@luauforge/bundled/ibX")
local module29 = require("@luauforge/bundled/ibY")

local module30 = require("@luauforge/bundled/ica")

local module31 = require("@luauforge/bundled/icg")
local appRatingPromptEventReceiver

if fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua then
	appRatingPromptEventReceiver = require("@luauforge/bundled/ict").AppRatingPromptEventReceiver or nil
else
	appRatingPromptEventReceiver = nil
end

local inAppInterventionEventReceiver = require("@luauforge/bundled/hPa").InAppInterventionEventReceiver

local v8 = if fFlagAppNavMyStatsTab then require("@luauforge/bundled/icJ") else nil

local module32 = require("@luauforge/bundled/icK")
local module33 = require("@luauforge/bundled/icN")
local module34 = require("@luauforge/bundled/icO")
local ampWizardLaunchReceiver = require("@luauforge/bundled/eeI").AmpWizardLaunchReceiver

local module35 = require("@luauforge/bundled/icR")
local v9 = if getFFlagEnableVREnvironmentSetting() then require("@luauforge/bundled/icT") else nil

local v10 = if getFFlagEnableSkyStyle() then require("@luauforge/bundled/icU") else nil

local robloxEventReceiver = require("@luauforge/bundled/ees").RobloxEventReceiver
local module36 = require("@luauforge/bundled/icV")
local module37 = require("@luauforge/bundled/icW")

local module38 = require("@luauforge/bundled/icX")
local module39 = require("@luauforge/bundled/icY")
local fFlagEnableSettingsTelemetry = SharedFlags.FFlagEnableSettingsTelemetry

local module40 = require("@luauforge/bundled/ida")

return function()
	local v11 = React.useMemo(function()
		return robloxEventReceiver.new(NotificationService)
	end, {})

	local v12 = React.useMemo(function()
		local v15 = if fFlagRouteStandaloneAmpThroughUniversalApp then ampWizardLaunchReceiver else nil
		local v17

		if fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua then
			v17 = appRatingPromptEventReceiver
		end

		local v19 = if getFFlagIsSquadEnabled() then module25 else nil
		local v22

		if getFFlagLuaAppChallengeDialogEventReceiverEnabled() then
			v22 = challengeDialogEventReceiver
		end

		local v23 = if module2() then module31 else nil
		local v13 = {
			module34,
			v15,
			module26,
			v17,
			v8,
			v19,
			module11,
			module6,
			v22,
			v23,
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
			nil
		}
		local v27 = if fFlagLuaAppSduiHomeFriendCarousel then module19 else nil
		local v28 = if fFlagLuaAppSduiHomePageSupport then module20 else nil
		local v31 = if fFlagEnableUserAccessServiceIntegration then module29 else nil
		local v38 = if getFFlagEnableParentalControlsScreentimeEnforcement() then module30 else nil

		local v42 = if module4() then module24 else nil
		v13[17], v13[18], v13[19], v13[20], v13[21], v13[22], v13[23], v13[24], v13[25], v13[26], v13[27], v13[28], v13[29], v13[30], v13[31], v13[32] = v27, v28, module16, inAppInterventionEventReceiver, v31, module15, module22, module10, onGameLeaveReceiver, module27, v7, v38, module33, module23, module28, v42
		local v45 = if fFlagEnableSettingsTelemetry then module39 else nil
		local v46 = if module3 or module5 then module32 else nil
		local v49

		if fFlagEnableAdConsentUserSettingsPublish and fFlagMoveAdConsentReceiverToAccountManagement then
			v49 = adConsentHybridEventReceiver
		end

		local v50 = if fFlagFriendsCallingClientGate_DEV then v6 else nil
		local v51 = if getFFlagEnablePlatformRestrictedEventReceiver() then module38 else nil
		local v52 = if fFlagLuaAppBirthdayComplianceGate then module40 else nil
		local v53 = if fFlagEnableMagicLogin then magicLoginApprovePopupEventReceiver else nil
		local v55 = if fFlagEnableRobloxSubscriptionEventListener then module35 else nil
		local v56 = if getFFlagEnableSkyStyle() then v10 else v9
		v13[33], v13[34], v13[35], v13[36], v13[37], v13[38], v13[39], v13[40], v13[41], v13[42], v13[43], v13[44], v13[45], v13[46] = module7, module21, v45, v46, module13, module12, v49, v50, v51, v52, v53, module9, v55, v56

		return v13
	end, {})

	return React.createElement(module36, {
		RobloxEventReceiver = v11,
		receiverComponents = v12
	})
end
