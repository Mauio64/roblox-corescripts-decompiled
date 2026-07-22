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
local FFlagSduiPinShortcutAction = require(ServerDrivenUiParent.SharedFlags).FFlagSduiPinShortcutAction

local function registerDiscoveryActions() -- line: 35
	-- upvalues: SduiActionType (copy), ServerDrivenUi (copy), FFlagRobloxPlusFAEFreeTrial (copy), FFlagSduiActionsUpdateFiresOwnTelemetry (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), FFlagSduiOpenSearchResultsTabAction (copy), FFlagLuaAppSduiOpenSearchResultsWithQueryAction (copy), FFlagLuaAppUnlockUpsellSupport (copy), FFlagLuaAppSduiVerificationUpsellActions (copy), FFlagSduiAiOverviewEnabled (copy), FFlagLuaAppSduiUpdateUserSettingsAction (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiLaunchExperienceAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiDevStoreSeeAllSupport (copy), FFlagSduiGenreSelector (copy), FFlagSduiPinShortcutAction (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.DismissDialog] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 38
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissDialogAction)
			end
		},
		[SduiActionType.Link] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 44
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiLinkAction)
			end
		},
		[SduiActionType.OpenFaeTrialUpsell] = if not FFlagRobloxPlusFAEFreeTrial then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 51
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenFaeTrialUpsellAction)
			end
		},
		[SduiActionType.OpenAbuseReport] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 58
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenAbuseReportAction)
			end
		},
		[SduiActionType.OpenGameDetails] = {
			lazyHandler = function() -- line: 64
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameDetailsAction)
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenBadgeDetails] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 70
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenBadgeDetailsAction)
			end
		},
		[SduiActionType.OpenBadgesSeeAll] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 77
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenBadgesSeeAllAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 81
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenExperienceStoreSeeAll] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 89
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenExperienceStoreSeeAllAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 93
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		[SduiActionType.OpenProfile] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 100
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenProfileAction)
			end
		},
		[SduiActionType.OpenJoinFriends] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 106
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenJoinFriendsAction)
			end
		},
		[SduiActionType.OpenSeeAll] = {
			lazyHandler = function() -- line: 112
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSeeAllAction)
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenSearchResultsTab] = if not FFlagSduiOpenSearchResultsTabAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 119
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsTabAction)
			end
		},
		[SduiActionType.OpenSearchResultsWithQuery] = if not FFlagLuaAppSduiOpenSearchResultsWithQueryAction then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 127
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSearchResultsWithQueryAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 131
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiOpenSearchResultsWithQueryTelemetryHandler)
			end
		},
		[SduiActionType.OpenSocialLink] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 142
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSocialLinkAction)
			end,
			lazyTelemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else function() -- line: 146
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.TelemetryHandlers.SduiLeavingRobloxTelemetryHandler)
			end
		},
		[SduiActionType.OpenSongDetail] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 155
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSongDetailAction)
			end
		},
		[SduiActionType.OpenAmpWizard] = if not FFlagLuaAppUnlockUpsellSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 163
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenAmpWizardAction)
			end
		},
		[SduiActionType.OpenPhoneUpsellModal] = if not FFlagLuaAppSduiVerificationUpsellActions then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 171
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenPhoneUpsellModalAction)
			end
		},
		[SduiActionType.OpenEmailUpsellModal] = if not FFlagLuaAppSduiVerificationUpsellActions then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 179
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenEmailUpsellModalAction)
			end
		},
		[SduiActionType.ToggleExperienceFavorite] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 187
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFavoriteAction)
			end
		},
		[SduiActionType.ToggleExperienceFollow] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 194
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceFollowAction)
			end
		},
		[SduiActionType.ToggleExperienceVote] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 201
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiToggleExperienceVoteAction)
			end
		},
		[SduiActionType.DismissGameFeedback] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 208
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissGameFeedbackAction)
			end
		},
		[SduiActionType.OpenGameFeedbackForm] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 215
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameFeedbackFormAction)
			end
		},
		[SduiActionType.AiOverviewFeedback] = if not FFlagSduiAiOverviewEnabled then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 222
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiAiOverviewFeedbackAction)
			end
		},
		[SduiActionType.OpenSponsoredTooltip] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 229
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSponsoredTooltipAction)
			end
		},
		[SduiActionType.OpenMarketplaceTryOn] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 235
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenMarketplaceTryOnAction)
			end
		},
		[SduiActionType.UpdateUserSettings] = if not FFlagLuaAppSduiUpdateUserSettingsAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 242
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiUpdateUserSettingsAction)
			end
		},
		[SduiActionType.PlayButtonClick] = {
			lazyHandler = function() -- line: 249
				return nil
			end,
			skipUnifiedLogging = not not FFlagSduiActionsUpdateFiresOwnTelemetry
		},
		[SduiActionType.OpenTooltip] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 255
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenTooltipAction)
			end
		},
		[SduiActionType.RemoveBadgeFromInventory] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 261
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRemoveBadgeFromInventoryAction)
			end
		},
		[SduiActionType.RsvpToEvent] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 268
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRsvpToEventAction)
			end
		},
		[SduiActionType.OpenEventDetails] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 276
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenEventDetailsAction)
			end
		},
		[SduiActionType.OpenGameInvite] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 284
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenGameInviteAction)
			end
		},
		[SduiActionType.LaunchExperience] = if not FFlagSduiLaunchExperienceAction then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 292
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiLaunchExperienceAction)
			end
		},
		[SduiActionType.OpenChartsSortDetail] = if not FFlagSduiChartsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 300
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenChartsSortDetailAction)
			end
		},
		[SduiActionType.OpenPurchasePrompt] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else {
			lazyHandler = function() -- line: 309
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.OpenPurchasePrompt.SduiOpenPurchasePromptAction)
			end
		},
		[SduiActionType.OpenSubscriptionPurchasePage] = if not FFlagSduiDevStoreSeeAllSupport then nil else {
			lazyHandler = function() -- line: 316
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSubscriptionPurchasePageAction)
			end
		},
		[SduiActionType.OpenSduiOverlay] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else {
			firesOwnTelemetry = false,
			lazyHandler = function() -- line: 323
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiOpenSduiOverlayAction)
			end
		},
		[SduiActionType.ApplyChartsFilter] = if not FFlagSduiChartsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 331
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiApplyChartsFilterAction)
			end
		},
		[SduiActionType.RefreshGamePasses] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 339
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshGamePassesAction)
			end
		},
		[SduiActionType.RefreshPlayability] = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 346
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshPlayabilityAction)
			end
		},
		[SduiActionType.EnableEventNotifications] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 354
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiEnableEventNotificationsAction)
			end
		},
		[SduiActionType.DismissEventNotificationsModal] = if not FFlagSduiEventDetailsSupport and not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 363
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiDismissEventNotificationsModalAction)
			end
		},
		[SduiActionType.ReportSurfaceLoadTimeMilestone] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 371
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiReportSurfaceLoadTimeMilestoneAction)
			end
		},
		[SduiActionType.RefreshOmniRecommendationFeedItem] = if not FFlagSduiGenreSelector then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 379
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiRefreshOmniRecommendationFeedItemAction)
			end
		},
		[SduiActionType.PinExperienceShortcut] = if not FFlagSduiPinShortcutAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 387
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Actions.SduiPinShortcutAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end

return registerDiscoveryActions
