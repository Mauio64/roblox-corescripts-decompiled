local Parent = script:FindFirstAncestor("SquadsCore").Parent
local Dash = require(Parent.Dash)
local Enums = require(Parent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.EnterSquadButtonPressed] = {
		context = Contexts.Squads,
		eventType = EventTypes.EnterSquadButtonPressed,
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
		context = Contexts.Squads,
		eventType = EventTypes.MultiInviteMenuActionStatus,
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
		context = Contexts.Squads,
		eventType = EventTypes.NoResponseInviteAgainOrAddOthers,
		formatRulesForAdditionalInfo = {
			actionType = Dash.identity,
			conversationId = Dash.identity,
			button = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.PartySheetAction] = {
		context = Contexts.Squads,
		eventType = EventTypes.PartySheetAction,
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
		context = Contexts.Squads,
		eventType = EventTypes.PartyCoplay,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadInvitePageNavSource,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			inviteNavSource = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.SquadExperienceInviteStateChange] = {
		context = Contexts.Squads,
		eventType = EventTypes.SquadExperienceInviteStateChange,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadExperienceInviteApiCall,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadInvite,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadVoteApiCall,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadToastActions,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadTopBannerClicked,
		formatRulesForAdditionalInfo = {
			parentChannelId = Dash.identity,
			squadId = Dash.identity,
			squadMembers = Dash.identity,
			timePassedSinceLastStateUpdatedInSec = Dash.identity
		}
	},
	[EventNames.SquadCreateOrJoinFromRCC] = {
		context = Contexts.Squads,
		eventType = EventTypes.SquadCreateOrJoinFromRCC,
		formatRulesForAdditionalInfo = {
			partySourceType = Dash.identity,
			nudgeId = Dash.identity,
			nudgeType = Dash.identity,
			partyAttemptId = Dash.identity,
			inviteeUserIds = Dash.identity
		}
	},
	[EventNames.SquadPromptResponded] = {
		context = Contexts.Squads,
		eventType = EventTypes.SquadPromptResponded,
		formatRulesForAdditionalInfo = {
			promptType = Dash.identity,
			responseType = Dash.identity,
			scheduledSquadId = Dash.identity,
			squadId = Dash.identity,
			squadLocation = Dash.identity
		}
	},
	[EventNames.ScheduledSquadAction] = {
		context = Contexts.Squads,
		eventType = EventTypes.ScheduledSquadAction,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadRegroupButtonClicked,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadRegroupPromptShown,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadRegroupPromptClicked,
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
		context = Contexts.Squads,
		eventType = EventTypes.SquadExperienceInviteImpression,
		formatRulesForAdditionalInfo = {
			experienceInviteId = Dash.identity,
			notificationId = Dash.identity,
			clientTimestamp = Dash.identity
		}
	}
}
