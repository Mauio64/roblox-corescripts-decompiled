local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local FFlagLuaAppSduiUpdateUserSettingsAction = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiUpdateUserSettingsAction
local FFlagSduiOpenSearchResultsTabAction = require(ServerDrivenUiParent.SharedFlags).FFlagSduiOpenSearchResultsTabAction
local FFlagLuaAppSduiOpenSearchResultsWithQueryAction = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiOpenSearchResultsWithQueryAction
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
local FFlagSduiActionsUpdateFiresOwnTelemetry = require(ServerDrivenUiParent.SharedFlags).FFlagSduiActionsUpdateFiresOwnTelemetry
local FFlagSduiActionTelemetryHandler = require(ServerDrivenUiParent.SharedFlags).FFlagSduiActionTelemetryHandler
local FFlagSduiChartsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiExperienceDetailsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiDevStoreSeeAllSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiDevStoreSeeAllSupport
local FFlagSduiEventDetailsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiLaunchExperienceAction = require(ServerDrivenUiParent.SharedFlags).FFlagSduiLaunchExperienceAction
local FFlagLuaAppUnlockUpsellSupport = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppUnlockUpsellSupport
local FFlagLuaAppSduiVerificationUpsellActions = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiVerificationUpsellActions
local FFlagRobloxPlusFAEFreeTrial = require(ServerDrivenUiParent.SharedFlags).FFlagRobloxPlusFAEFreeTrial
local FFlagSduiGenreSelector = require(ServerDrivenUiParent.SharedFlags).FFlagSduiGenreSelector
local FFlagSduiAiOverviewEnabled = require(ServerDrivenUiParent.SharedFlags).FFlagSduiAiOverviewEnabled

local function registerDiscoveryActions() -- line: 34
	-- upvalues: SduiActionType (copy), ServerDrivenUi (copy), FFlagRobloxPlusFAEFreeTrial (copy), FFlagSduiActionsUpdateFiresOwnTelemetry (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), FFlagSduiOpenSearchResultsTabAction (copy), FFlagLuaAppSduiOpenSearchResultsWithQueryAction (copy), FFlagLuaAppUnlockUpsellSupport (copy), FFlagLuaAppSduiVerificationUpsellActions (copy), FFlagSduiAiOverviewEnabled (copy), FFlagLuaAppSduiUpdateUserSettingsAction (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiLaunchExperienceAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiDevStoreSeeAllSupport (copy), FFlagSduiGenreSelector (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.DismissDialog] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 37
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissDialogAction)
			end
		},
		[SduiActionType.Link] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 43
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiLinkAction)
			end
		},
		[SduiActionType.OpenFaeTrialUpsell] = if not FFlagRobloxPlusFAEFreeTrial then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 50
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenFaeTrialUpsellAction)
			end
		},
		[SduiActionType.OpenAbuseReport] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 57
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenAbuseReportAction)
			end
		},
		[SduiActionType.OpenGameDetails] = {
			lazyHandler = function() -- line: 63
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameDetailsAction)
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenBadgeDetails] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 69
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenBadgeDetailsAction)
			end
		},
		[SduiActionType.OpenBadgesSeeAll] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 76
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenBadgesSeeAllAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 80
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenExperienceStoreSeeAll] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 88
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenExperienceStoreSeeAllAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 92
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenProfile] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 99
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenProfileAction)
			end
		},
		[SduiActionType.OpenJoinFriends] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 105
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenJoinFriendsAction)
			end
		},
		[SduiActionType.OpenSeeAll] = {
			lazyHandler = function() -- line: 111
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSeeAllAction)
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenSearchResultsTab] = if not FFlagSduiOpenSearchResultsTabAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 118
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsTabAction)
			end
		},
		[SduiActionType.OpenSearchResultsWithQuery] = if not FFlagLuaAppSduiOpenSearchResultsWithQueryAction then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 126
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsWithQueryAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 130
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiOpenSearchResultsWithQueryTelemetryHandler)
			end
		},
		[SduiActionType.OpenSocialLink] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 141
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSocialLinkAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 145
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiLeavingRobloxTelemetryHandler)
			end
		},
		[SduiActionType.OpenSongDetail] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 154
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSongDetailAction)
			end
		},
		[SduiActionType.OpenAmpWizard] = if not FFlagLuaAppUnlockUpsellSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 162
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenAmpWizardAction)
			end
		},
		[SduiActionType.OpenPhoneUpsellModal] = if not FFlagLuaAppSduiVerificationUpsellActions then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 170
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenPhoneUpsellModalAction)
			end
		},
		[SduiActionType.OpenEmailUpsellModal] = if not FFlagLuaAppSduiVerificationUpsellActions then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 178
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenEmailUpsellModalAction)
			end
		},
		[SduiActionType.ToggleExperienceFavorite] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 186
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFavoriteAction)
			end
		},
		[SduiActionType.ToggleExperienceFollow] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 193
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFollowAction)
			end
		},
		[SduiActionType.ToggleExperienceVote] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 200
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceVoteAction)
			end
		},
		[SduiActionType.DismissGameFeedback] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 207
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissGameFeedbackAction)
			end
		},
		[SduiActionType.OpenGameFeedbackForm] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 214
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameFeedbackFormAction)
			end
		},
		[SduiActionType.AiOverviewFeedback] = if not FFlagSduiAiOverviewEnabled then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 221
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiAiOverviewFeedbackAction)
			end
		},
		[SduiActionType.OpenSponsoredTooltip] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 228
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSponsoredTooltipAction)
			end
		},
		[SduiActionType.OpenMarketplaceTryOn] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 234
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenMarketplaceTryOnAction)
			end
		},
		[SduiActionType.UpdateUserSettings] = if not FFlagLuaAppSduiUpdateUserSettingsAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 241
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiUpdateUserSettingsAction)
			end
		},
		[SduiActionType.PlayButtonClick] = {
			lazyHandler = function() -- line: 248
				return nil
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenTooltip] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 254
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenTooltipAction)
			end
		},
		[SduiActionType.RemoveBadgeFromInventory] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 260
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRemoveBadgeFromInventoryAction)
			end
		},
		[SduiActionType.RsvpToEvent] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 267
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRsvpToEventAction)
			end
		},
		[SduiActionType.OpenEventDetails] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 275
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenEventDetailsAction)
			end
		},
		[SduiActionType.OpenGameInvite] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 283
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameInviteAction)
			end
		},
		[SduiActionType.LaunchExperience] = if not FFlagSduiLaunchExperienceAction then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 291
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiLaunchExperienceAction)
			end
		},
		[SduiActionType.OpenChartsSortDetail] = if not FFlagSduiChartsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 299
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenChartsSortDetailAction)
			end
		},
		[SduiActionType.OpenPurchasePrompt] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else {
			lazyHandler = function() -- line: 308
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.OpenPurchasePrompt.SduiOpenPurchasePromptAction)
			end
		},
		[SduiActionType.OpenSubscriptionPurchasePage] = if not FFlagSduiDevStoreSeeAllSupport then nil else {
			lazyHandler = function() -- line: 315
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSubscriptionPurchasePageAction)
			end
		},
		[SduiActionType.OpenSduiOverlay] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 322
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSduiOverlayAction)
			end
		},
		[SduiActionType.ApplyChartsFilter] = if not FFlagSduiChartsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 330
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiApplyChartsFilterAction)
			end
		},
		[SduiActionType.RefreshGamePasses] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 338
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshGamePassesAction)
			end
		},
		[SduiActionType.RefreshPlayability] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 345
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshPlayabilityAction)
			end
		},
		[SduiActionType.EnableEventNotifications] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 353
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiEnableEventNotificationsAction)
			end
		},
		[SduiActionType.DismissEventNotificationsModal] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 362
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissEventNotificationsModalAction)
			end
		},
		[SduiActionType.ReportSurfaceLoadTimeMilestone] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 370
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiReportSurfaceLoadTimeMilestoneAction)
			end
		},
		[SduiActionType.RefreshOmniRecommendationFeedItem] = if not FFlagSduiGenreSelector then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 378
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshOmniRecommendationFeedItemAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end

return registerDiscoveryActions
