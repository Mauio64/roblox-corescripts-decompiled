local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Dash")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SocialLuaAnalytics").Analytics.Enums

local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")

return {
	[EventNames.EnterSquadButtonPressed] = {
		context = contexts.Squads,
		eventType = eventTypes.EnterSquadButtonPressed,
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			partyAttemptId = Dash.identity,
			squadButtonSource = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			userIntention = Dash.identity
		}
	},
	[EventNames.MultiInviteMenuActionStatus] = {
		context = contexts.Squads,
		eventType = eventTypes.MultiInviteMenuActionStatus,
		formatRulesForAdditionalInfo = {
			actionLocation = Dash.identity,
			actionType = Dash.identity,
			activeFriendsPresences = Dash.identity,
			activeFriendsUserIds = Dash.identity,
			clientTimeStamp = Dash.identity,
			numActiveFriends = Dash.identity,
			numSelectedFriends = Dash.identity,
			partyAttemptId = Dash.identity,
			selectedFriendsPresences = Dash.identity,
			selectedFriendsUserIds = Dash.identity,
			selectionPageType = Dash.identity,
			squadId = Dash.identity
		}
	},
	[EventNames.NoResponseInviteAgainOrAddOthers] = {
		context = contexts.Squads,
		eventType = eventTypes.NoResponseInviteAgainOrAddOthers,
		formatRulesForAdditionalInfo = {
			actionType = Dash.identity,
			conversationId = Dash.identity,
			button = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.PartySheetAction] = {
		context = contexts.Squads,
		eventType = eventTypes.PartySheetAction,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			actionType = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			isFtuxTooltipShown = Dash.identity,
			voiceStatus = Dash.identity
		}
	},
	[EventNames.PartyCoplay] = {
		context = contexts.Squads,
		eventType = eventTypes.PartyCoplay,
		formatRulesForAdditionalInfo = {
			partyCoplayEvent = Dash.identity,
			partyId = Dash.identity,
			partyPlayersInGameInstanceCount = Dash.identity,
			partyPlayersInGameInstanceUserIds = Dash.identity,
			partyTotalSize = Dash.identity,
			partyTotalSizeUserIds = Dash.identity
		}
	},
	[EventNames.SquadInvitePageNavSource] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadInvitePageNavSource,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			inviteNavSource = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.SquadExperienceInviteStateChange] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadExperienceInviteStateChange,
		formatRulesForAdditionalInfo = {
			experienceInviteId = Dash.identity,
			invitationGameInstanceId = Dash.identity,
			invitationPlaceId = Dash.identity,
			inviterId = Dash.identity,
			inviteState = Dash.identity,
			parentChannelId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			joinAttemptId = Dash.identity
		}
	},
	[EventNames.SquadExperienceInviteApiCall] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadExperienceInviteApiCall,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			errorMessage = Dash.identity,
			errorType = Dash.identity,
			experienceInviteId = Dash.identity,
			invitationPlaceId = Dash.identity,
			isSuccess = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			squadMembers = Dash.identity,
			squadMembersCount = Dash.identity
		}
	},
	[EventNames.SquadInvite] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadInvite,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			errorMessage = Dash.identity,
			errorType = Dash.identity,
			inviteeCount = Dash.identity,
			inviteeUserIds = Dash.identity,
			isSuccess = Dash.identity,
			source = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			userId = Dash.identity
		}
	},
	[EventNames.SquadVoteApiCall] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadVoteApiCall,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			errorMessage = Dash.identity,
			errorType = Dash.identity,
			experienceInviteId = Dash.identity,
			isSuccess = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			voteType = Dash.identity
		}
	},
	[EventNames.SquadToastActions] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadToastActions,
		formatRulesForAdditionalInfo = {
			experienceInviteId = Dash.identity,
			parentChannelId = Dash.identity,
			partyAttemptId = Dash.identity,
			nudgeId = Dash.identity,
			nudgeType = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			toastAction = Dash.identity,
			toastType = Dash.identity
		}
	},
	[EventNames.SquadTopBannerClicked] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadTopBannerClicked,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			squadId = Dash.identity,
			squadMembers = Dash.identity,
			timePassedSinceLastStateUpdatedInSec = Dash.identity
		}
	},
	[EventNames.SquadCreateOrJoinFromRCC] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadCreateOrJoinFromRCC,
		formatRulesForAdditionalInfo = {
			partySourceType = Dash.identity,
			nudgeId = Dash.identity,
			nudgeType = Dash.identity,
			partyAttemptId = Dash.identity,
			inviteeUserIds = Dash.identity
		}
	},
	[EventNames.SquadPromptResponded] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadPromptResponded,
		formatRulesForAdditionalInfo = {
			promptType = Dash.identity,
			responseType = Dash.identity,
			scheduledSquadId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.ScheduledSquadAction] = {
		context = contexts.Squads,
		eventType = eventTypes.ScheduledSquadAction,
		formatRulesForAdditionalInfo = {
			actionType = Dash.identity,
			conversationId = Dash.identity,
			scheduledSquadId = Dash.identity,
			source = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.SquadRegroupButtonClicked] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadRegroupButtonClicked,
		formatRulesForAdditionalInfo = {
			clientTimestamp = Dash.identity,
			squadId = Dash.identity,
			initiatorId = Dash.identity,
			gameInstanceId = Dash.identity,
			rootPlaceId = Dash.identity,
			placeId = Dash.identity,
			universeId = Dash.identity,
			playSessionId = Dash.identity,
			experienceInviteId = Dash.identity,
			button = Dash.identity,
			entryPoint = Dash.identity
		}
	},
	[EventNames.SquadRegroupPromptShown] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadRegroupPromptShown,
		formatRulesForAdditionalInfo = {
			clientTimestamp = Dash.identity,
			squadId = Dash.identity,
			initiatorId = Dash.identity,
			gameInstanceId = Dash.identity,
			rootPlaceId = Dash.identity,
			placeId = Dash.identity,
			universeId = Dash.identity,
			playSessionId = Dash.identity,
			experienceInviteId = Dash.identity,
			button = Dash.identity,
			entryPoint = Dash.identity
		}
	},
	[EventNames.SquadRegroupPromptClicked] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadRegroupPromptClicked,
		formatRulesForAdditionalInfo = {
			clientTimestamp = Dash.identity,
			squadId = Dash.identity,
			initiatorId = Dash.identity,
			gameInstanceId = Dash.identity,
			rootPlaceId = Dash.identity,
			placeId = Dash.identity,
			universeId = Dash.identity,
			playSessionId = Dash.identity,
			experienceInviteId = Dash.identity,
			button = Dash.identity,
			entryPoint = Dash.identity
		}
	},
	[EventNames.SquadExperienceInviteImpression] = {
		context = contexts.Squads,
		eventType = eventTypes.SquadExperienceInviteImpression,
		formatRulesForAdditionalInfo = {
			experienceInviteId = Dash.identity,
			notificationId = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationRowImpression] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationRowImpression,
		formatRulesForAdditionalInfo = {
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationInvoked] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationInvoked,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			squadMemberCount = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationRevealShown] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationRevealShown,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			pickRequestId = Dash.identity,
			universeId = Dash.identity,
			revealType = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationRerolled] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationRerolled,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			pickRequestId = Dash.identity,
			revealType = Dash.identity,
			phaseAtReroll = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationJoinTapped] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationJoinTapped,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			pickRequestId = Dash.identity,
			revealType = Dash.identity,
			rootPlaceId = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationErrorShown] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationErrorShown,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			errorType = Dash.identity,
			pickRequestId = Dash.identity,
			revealType = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationDismissed] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationDismissed,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			pickRequestId = Dash.identity,
			revealType = Dash.identity,
			phaseAtDismiss = Dash.identity,
			clientTimestamp = Dash.identity
		}
	},
	[EventNames.LuckyRecommendationExperienceInviteCreated] = {
		context = contexts.Squads,
		eventType = eventTypes.LuckyRecommendationExperienceInviteCreated,
		formatRulesForAdditionalInfo = {
			luckyRecommendationSessionId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity,
			localUserId = Dash.identity,
			pickRequestId = Dash.identity,
			revealType = Dash.identity,
			rootPlaceId = Dash.identity,
			experienceInviteId = Dash.identity,
			clientTimestamp = Dash.identity
		}
	}
}
