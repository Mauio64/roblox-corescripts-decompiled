local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableAppRatingPromptLua = SharedFlags.FFlagEnableAppRatingPromptLua
local FFlagEnableAndroidAppRatingPromptLua = SharedFlags.FFlagEnableAndroidAppRatingPromptLua
local FFlagEnableUserAccessServiceIntegration = SharedFlags.FFlagEnableUserAccessServiceIntegration
local FFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagEnableAuthDeepLinkReceiver = SharedFlags.FFlagEnableAuthDeepLinkReceiver
local FFlagTCStreamNotifEventReceiver = SharedFlags.FFlagTCStreamNotifEventReceiver
local FFlagEnableRobloxSubscriptionEventListener = SharedFlags.FFlagEnableRobloxSubscriptionEventListener
local GetFFlagEnableVREnvironmentSetting = SharedFlags.GetFFlagEnableVREnvironmentSetting
local GetFFlagEnableSkyStyle = SharedFlags.GetFFlagEnableSkyStyle
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local IsCsatSurveyInterceptEnabled = require(Modules.LuaApp.Components.OnPlatformSurveys.IsCsatSurveyInterceptEnabled)
local FFlagLuobuCJVMorePageShowTencentNotice = require(Modules.Luobu.Flags.FFlagLuobuCJVMorePageShowTencentNotice)
local GetFFlagLuaAppChallengeDialogEventReceiverEnabled = require(CorePackages.Workspace.Packages.ChallengeDialog).GetFFlagLuaAppChallengeDialogEventReceiverEnabled
local GetFFlagLuaAppReturnFromGame = require(Modules.LuaApp.Flags.GetFFlagLuaAppReturnFromGame)
local FFlagLuobuShowTencentNoticePopup = require(Modules.Luobu.Flags.FFlagLuobuShowTencentNoticePopup)
local GetFFlagEnableParentalControlsScreentimeEnforcement = require(CorePackages.Workspace.Packages.ScreenTime).GetFFlagEnableParentalControlsScreentimeEnforcement
local GetFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local MagicLoginApprovePopupEventReceiver = require(CorePackages.Workspace.Packages.LoginV2.Thunks).MagicLoginApprovePopupEventReceiver
local v26 = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature).GetSystemThemeEnabled()
local v27 = v26 and require(Modules.LuaApp.Components.EventReceivers.DeviceLevelThemeChangeEventReceiver) or nil
local BadgeEventReceiver = require(Modules.LuaApp.Components.EventReceivers.BadgeEventReceiver)
local RobuxEventReceiver = require(Modules.LuaApp.Components.EventReceivers.RobuxEventReceiver)
local FriendshipEventReceiver = require(Modules.LuaApp.Components.EventReceivers.FriendshipEventReceiver)
local TrustedConnectionEventReceiver = require(Modules.LuaApp.Components.EventReceivers.TrustedConnectionEventReceiver)
local NavigationEventReceiver = require(Modules.LuaApp.Components.EventReceivers.NavigationEventReceiver)
local EventReceiver = require(Modules.AvatarExperience.AvatarEditor.Components.EventReceivers.EventReceiver)
local UniversalAppRobloxHybridEventReceiver = require(Modules.LuaApp.Components.EventReceivers.UniversalAppRobloxHybridEventReceiver)
local ThemeChangeEventReceiver = require(Modules.LuaApp.Components.EventReceivers.ThemeChangeEventReceiver)
local DeepLinkEventReceiver = require(Modules.LuaApp.Components.EventReceivers.DeepLinkEventReceiver)
local MarketplaceServiceEventReciever = require(Modules.LuaApp.Components.EventReceivers.MarketplaceServiceEventReciever)
local FullscreenEventReceiver = require(Modules.LuaApp.Components.EventReceivers.FullscreenEventReceiver)
local DisplayNameEventReceiver = require(Modules.LuaApp.Components.EventReceivers.DisplayNameEventReceiver)
local FriendRequestsEventReceiver = require(Modules.LuaApp.Components.EventReceivers.FriendRequestsEventReceiver)
local ScreenTimeEventReceiver = require(Modules.LuaApp.Components.EventReceivers.ScreenTimeEventReceiver)
local ModerationEventReceiverV2 = require(Modules.LuaApp.Components.EventReceivers.ModerationEventReceiverV2)
local PresenceEventReceiver = require(Modules.LuaApp.Components.EventReceivers.PresenceEventReceiver)
local ReturnFromGameReceiver = require(Modules.LuaApp.Components.EventReceivers.ReturnFromGameReceiver)
local OnGameLeaveReceiver = Modules2.LuaApp.Components.EventReceivers.OnGameLeaveReceiver
local AppSquadEventReceiver = require(CorePackages.Workspace.Packages.Squads.AppSquadEventReceiver)
local PersistentEventReceivers = require(CorePackages.Workspace.Packages.AppChat.PersistentEventReceivers)
local v48 = if not require(Modules.LuaApp.Flags.FFlagEnableDeeplinkResolutionEventReceiver) then nil else require(Modules.LuaApp.Components.EventReceivers.DeeplinkResolutionEventReceiver)
local v49 = if not require(Modules.LuaApp.Flags.FFlagEnableAttributionContextEventReceiver) then nil else require(Modules.LuaApp.Components.EventReceivers.AttributionContextEventReceiver)
local ChallengeDialogEventReceiver = require(CorePackages.Workspace.Packages.ChallengeDialog).ChallengeDialogEventReceiver
local PurchaseProcessedEventReceiver = require(Modules.LuaApp.Components.EventReceivers.PurchaseProcessedEventReceiver)
local LocaleRestrictionEventReceiver = require(Modules.LuaApp.Components.EventReceivers.LocaleRestrictionEventReceiver)
local ParentalControlsScreentimeEventReceiver = require(Modules.LuaApp.Components.EventReceivers.ParentalControlsScreentimeEventReceiver)
local CsatSurveyInterceptEventReceiver = require(Modules.LuaApp.Components.OnPlatformSurveys.CsatSurveyInterceptEventReceiver)
local v55 = not (not FFlagEnableAppRatingPromptLua and not FFlagEnableAndroidAppRatingPromptLua) and require(CorePackages.Workspace.Packages.AppRatingPrompt).AppRatingPromptEventReceiver or nil
local InAppInterventionEventReceiver = require(CorePackages.Workspace.Packages.InAppIntervention).InAppInterventionEventReceiver
local v57 = if not FFlagAppNavMyStatsTab then nil else require(CorePackages.Workspace.Packages.BuildExperience)
local TencentNoticeEventReceiver = require(Modules.Luobu.Components.EventReceivers.TencentNoticeEventReceiver)
local PerfInsights = require(Modules.LuaApp.Experiment.PerfInsights)
local AccountLockEventReceiver = require(Modules.LuaApp.Components.EventReceivers.AccountLockEventReceiver)
local RobloxSubscriptionEventReceiver = require(Modules.LuaApp.Components.EventReceivers.RobloxSubscriptionEventReceiver)
local v62 = if not GetFFlagEnableVREnvironmentSetting() then nil else require(Modules.LuaApp.Components.EventReceivers.VREnvironmentSettingEventReceiver)
local v63 = if not GetFFlagEnableSkyStyle() then nil else require(Modules.LuaApp.Components.EventReceivers.SkyStyleEventReceiver)
local RobloxEventReceiver = require(CorePackages.Workspace.Packages.RealtimeDelivery).RobloxEventReceiver
local EventReceiverLifecycleAdapter = require(Modules.LuaApp.Components.EventReceiverLifecycleAdapter)
local AuthDeeplinkEventReceiverMonoWrapper = require(Modules.LuaApp.Components.Authentication.AuthDeeplinkEventReceiverMonoWrapper)
local PlatformRestrictedEventReceiver = require(Modules.LuaApp.Components.EventReceivers.PlatformRestrictedEventReceiver)

return function() -- line: 105
	-- upvalues: React (copy), RobloxEventReceiver (copy), NotificationService (copy), AccountLockEventReceiver (copy), PersistentEventReceivers (copy), FFlagEnableAppRatingPromptLua (copy), FFlagEnableAndroidAppRatingPromptLua (copy), v55 (copy), v57 (copy), GetFFlagIsSquadEnabled (copy), AppSquadEventReceiver (copy), EventReceiver (copy), BadgeEventReceiver (copy), GetFFlagLuaAppChallengeDialogEventReceiverEnabled (copy), ChallengeDialogEventReceiver (copy), IsCsatSurveyInterceptEnabled (copy), CsatSurveyInterceptEventReceiver (copy), FFlagEnableAuthDeepLinkReceiver (copy), AuthDeeplinkEventReceiverMonoWrapper (copy), DeepLinkEventReceiver (copy), v26 (copy), v27 (copy), DisplayNameEventReceiver (copy), FriendRequestsEventReceiver (copy), FriendshipEventReceiver (copy), FullscreenEventReceiver (copy), InAppInterventionEventReceiver (copy), FFlagEnableUserAccessServiceIntegration (copy), LocaleRestrictionEventReceiver (copy), MarketplaceServiceEventReciever (copy), ModerationEventReceiverV2 (copy), NavigationEventReceiver (copy), OnGameLeaveReceiver (copy), v48 (copy), v49 (copy), GetFFlagEnableParentalControlsScreentimeEnforcement (copy), ParentalControlsScreentimeEventReceiver (copy), PerfInsights (copy), PresenceEventReceiver (copy), PurchaseProcessedEventReceiver (copy), GetFFlagLuaAppReturnFromGame (copy), ReturnFromGameReceiver (copy), RobuxEventReceiver (copy), ScreenTimeEventReceiver (copy), FFlagLuobuCJVMorePageShowTencentNotice (copy), FFlagLuobuShowTencentNoticePopup (copy), TencentNoticeEventReceiver (copy), ThemeChangeEventReceiver (copy), UniversalAppRobloxHybridEventReceiver (copy), GetFFlagEnablePlatformRestrictedEventReceiver (copy), PlatformRestrictedEventReceiver (copy), FFlagEnableMagicLogin (copy), MagicLoginApprovePopupEventReceiver (copy), FFlagTCStreamNotifEventReceiver (copy), TrustedConnectionEventReceiver (copy), FFlagEnableRobloxSubscriptionEventListener (copy), RobloxSubscriptionEventReceiver (copy), GetFFlagEnableSkyStyle (copy), v63 (copy), v62 (copy), EventReceiverLifecycleAdapter (copy)
	local v68 = React.useMemo(function() -- line: 106
		-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
		return RobloxEventReceiver.new(NotificationService)
	end, {})
	local v69 = React.useMemo(function() -- line: 110
		-- upvalues: AccountLockEventReceiver (copy), PersistentEventReceivers (copy), FFlagEnableAppRatingPromptLua (copy), FFlagEnableAndroidAppRatingPromptLua (copy), v55 (copy), v57 (copy), GetFFlagIsSquadEnabled (copy), AppSquadEventReceiver (copy), EventReceiver (copy), BadgeEventReceiver (copy), GetFFlagLuaAppChallengeDialogEventReceiverEnabled (copy), ChallengeDialogEventReceiver (copy), IsCsatSurveyInterceptEnabled (copy), CsatSurveyInterceptEventReceiver (copy), FFlagEnableAuthDeepLinkReceiver (copy), AuthDeeplinkEventReceiverMonoWrapper (copy), DeepLinkEventReceiver (copy), v26 (copy), v27 (copy), DisplayNameEventReceiver (copy), FriendRequestsEventReceiver (copy), FriendshipEventReceiver (copy), FullscreenEventReceiver (copy), InAppInterventionEventReceiver (copy), FFlagEnableUserAccessServiceIntegration (copy), LocaleRestrictionEventReceiver (copy), MarketplaceServiceEventReciever (copy), ModerationEventReceiverV2 (copy), NavigationEventReceiver (copy), OnGameLeaveReceiver (copy), v48 (copy), v49 (copy), GetFFlagEnableParentalControlsScreentimeEnforcement (copy), ParentalControlsScreentimeEventReceiver (copy), PerfInsights (copy), PresenceEventReceiver (copy), PurchaseProcessedEventReceiver (copy), GetFFlagLuaAppReturnFromGame (copy), ReturnFromGameReceiver (copy), RobuxEventReceiver (copy), ScreenTimeEventReceiver (copy), FFlagLuobuCJVMorePageShowTencentNotice (copy), FFlagLuobuShowTencentNoticePopup (copy), TencentNoticeEventReceiver (copy), ThemeChangeEventReceiver (copy), UniversalAppRobloxHybridEventReceiver (copy), GetFFlagEnablePlatformRestrictedEventReceiver (copy), PlatformRestrictedEventReceiver (copy), FFlagEnableMagicLogin (copy), MagicLoginApprovePopupEventReceiver (copy), FFlagTCStreamNotifEventReceiver (copy), TrustedConnectionEventReceiver (copy), FFlagEnableRobloxSubscriptionEventListener (copy), RobloxSubscriptionEventReceiver (copy), GetFFlagEnableSkyStyle (copy), v63 (copy), v62 (copy)
		return {
			AccountLockEventReceiver,
			PersistentEventReceivers,
			if not FFlagEnableAppRatingPromptLua and not FFlagEnableAndroidAppRatingPromptLua then nil else v55,
			if not v57 then nil else v57.BuildEventReceiver,
			if not GetFFlagIsSquadEnabled() then nil else AppSquadEventReceiver,
			EventReceiver,
			BadgeEventReceiver,
			if not GetFFlagLuaAppChallengeDialogEventReceiverEnabled() then nil else ChallengeDialogEventReceiver,
			if not IsCsatSurveyInterceptEnabled() then nil else CsatSurveyInterceptEventReceiver,
			if not FFlagEnableAuthDeepLinkReceiver then nil else AuthDeeplinkEventReceiverMonoWrapper,
			DeepLinkEventReceiver,
			if not v26 then nil else v27,
			DisplayNameEventReceiver,
			FriendRequestsEventReceiver,
			FriendshipEventReceiver,
			FullscreenEventReceiver,
			InAppInterventionEventReceiver,
			if not FFlagEnableUserAccessServiceIntegration then nil else LocaleRestrictionEventReceiver,
			MarketplaceServiceEventReciever,
			ModerationEventReceiverV2,
			NavigationEventReceiver,
			OnGameLeaveReceiver,
			v48,
			v49,
			if not GetFFlagEnableParentalControlsScreentimeEnforcement() then nil else ParentalControlsScreentimeEventReceiver,
			PerfInsights,
			PresenceEventReceiver,
			PurchaseProcessedEventReceiver,
			if not GetFFlagLuaAppReturnFromGame() then nil else ReturnFromGameReceiver,
			RobuxEventReceiver,
			ScreenTimeEventReceiver,
			if not FFlagLuobuCJVMorePageShowTencentNotice and not FFlagLuobuShowTencentNoticePopup then nil else TencentNoticeEventReceiver,
			ThemeChangeEventReceiver,
			UniversalAppRobloxHybridEventReceiver,
			if not GetFFlagEnablePlatformRestrictedEventReceiver() then nil else PlatformRestrictedEventReceiver,
			if not FFlagEnableMagicLogin then nil else MagicLoginApprovePopupEventReceiver,
			if not FFlagTCStreamNotifEventReceiver then nil else TrustedConnectionEventReceiver,
			if not FFlagEnableRobloxSubscriptionEventListener then nil else RobloxSubscriptionEventReceiver,
			if not GetFFlagEnableSkyStyle() then v62 else v63
		}
	end, {})

	return React.createElement(EventReceiverLifecycleAdapter, {
		RobloxEventReceiver = v68,
		receiverComponents = v69
	})
end
