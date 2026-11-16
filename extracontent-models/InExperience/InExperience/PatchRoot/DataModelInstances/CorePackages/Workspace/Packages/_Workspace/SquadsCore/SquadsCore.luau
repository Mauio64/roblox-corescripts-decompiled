require(script.Enums.SquadRootViewType)
require(script.Enums.SquadState)

require(script.Types)

local SquadsCore = {}
SquadsCore.Actions = require(script.Actions)

local Analytics = require(script.Analytics)
local analytics = { EventNames = Analytics.EventNames, logInExpCoplayTelemetry = 0 }
local Analytics2 = require(script.Analytics)
analytics.logInExpCoplayTelemetry = Analytics2.logInExpCoplayTelemetry
SquadsCore.Analytics = analytics

local Constants = require(script.Common.Constants)
local constants = {
	CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE = Constants.CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE,
	CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE = 0,
	COMMUNICATION_CHANNEL_RTN_NAMESPACE = 0,
	CONVERSATION_CHANNEL_GROUP_TYPE = 0,
	CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE = 0,
	ACTIVE_SQUAD_APP_STORAGE_KEY = 0,
	SQUAD_CHANNEL_TYPE = 0,
	SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = 0,
	SQUAD_VOICE_EU_MODAL_SEEN_KEY = 0,
	SQUAD_TOP_BANNER_TEST_ID = 0
}
local Constants2 = require(script.Common.Constants)
constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE = Constants2.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE
local Constants3 = require(script.Common.Constants)
constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE = Constants3.COMMUNICATION_CHANNEL_RTN_NAMESPACE
local Constants4 = require(script.Common.Constants)
constants.CONVERSATION_CHANNEL_GROUP_TYPE = Constants4.CONVERSATION_CHANNEL_GROUP_TYPE
local Constants5 = require(script.Common.Constants)
constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE = Constants5.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
local Constants6 = require(script.Common.Constants)
constants.ACTIVE_SQUAD_APP_STORAGE_KEY = Constants6.ACTIVE_SQUAD_APP_STORAGE_KEY
local Constants7 = require(script.Common.Constants)
constants.SQUAD_CHANNEL_TYPE = Constants7.SQUAD_CHANNEL_TYPE
local Constants8 = require(script.Common.Constants)
constants.SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = Constants8.SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local Constants9 = require(script.Common.Constants)
constants.SQUAD_VOICE_EU_MODAL_SEEN_KEY = Constants9.SQUAD_VOICE_EU_MODAL_SEEN_KEY
local Constants10 = require(script.Common.Constants)
constants.SQUAD_TOP_BANNER_TEST_ID = Constants10.SQUAD_TOP_BANNER_TEST_ID
SquadsCore.Common = {
	Constants = constants,
	getColorFromUserId = require(script.Common.getColorFromUserId),
	clearSquadStorage = require(script.Common.clearSquadStorage),
	validateSquadId = require(script.Common.validateSquadId),
	encodeSquadMembers = require(script.Common.encodeSquadMembers),
	encodeUserIds = require(script.Common.encodeUserIds)
}

local Components = require(script.Components)
SquadsCore.Components = {
	LocalPlayerPartyVoiceEligibleBinder = Components.LocalPlayerPartyVoiceEligibleBinder
}

SquadsCore.Enums = require(script.Enums)
SquadsCore.Flags = require(script.Flags)
SquadsCore.Hooks = require(script.Hooks)
SquadsCore.Http = require(script.Http)
SquadsCore.Middleware = require(script.Middleware)
SquadsCore.Models = require(script.Models)
SquadsCore.NetworkRequests = require(script.NetworkRequests)
local Constants11 = require(script.Common.Constants)
SquadsCore.RoduxKey = Constants11.RODUX_KEY
SquadsCore.RoduxSquads = require(script.RoduxSquads)
local Components2 = require(script.Components)
SquadsCore.SquadAppChatEventReceiver = Components2.SquadAppChatEventReceiver
local Components3 = require(script.Components)
SquadsCore.SquadEventReceiver = Components3.SquadEventReceiver
local Components4 = require(script.Components)
SquadsCore.SquadExternalContractProvider = Components4.SquadExternalContractProvider
local Components5 = require(script.Components)
SquadsCore.SquadOverlay = Components5.SquadOverlay
local Components6 = require(script.Components)
SquadsCore.SquadPrompt = Components6.SquadPrompt
local Components7 = require(script.Components)
SquadsCore.SquadSessionProvider = Components7.SquadSessionProvider
SquadsCore.Stores = require(script.Stores)
SquadsCore.Thunks = require(script.Thunks)
SquadsCore.Types = require(script.Types)
SquadsCore.installReducer = require(script.installReducer)
SquadsCore.Utils = {
	appStorageAccess = require(script.Utils.appStorageAccess),
	displayEuConsentPrompt = require(script.Utils.displayEuConsentPrompt)
}

SquadsCore["jest.config"] = script["jest.config"]
return SquadsCore
