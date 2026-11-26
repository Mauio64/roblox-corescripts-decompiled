require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRootViewType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadState")

require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

return {
	Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Actions"),
	Analytics = {
		EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics").EventNames,
		logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics").logInExpCoplayTelemetry
	},
	Common = {
		Constants = {
			CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE,
			CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE,
			COMMUNICATION_CHANNEL_RTN_NAMESPACE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").COMMUNICATION_CHANNEL_RTN_NAMESPACE,
			CONVERSATION_CHANNEL_GROUP_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").CONVERSATION_CHANNEL_GROUP_TYPE,
			CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE,
			ACTIVE_SQUAD_APP_STORAGE_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").ACTIVE_SQUAD_APP_STORAGE_KEY,
			SQUAD_CHANNEL_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_CHANNEL_TYPE,
			SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY,
			SQUAD_VOICE_EU_MODAL_SEEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_SEEN_KEY,
			SQUAD_TOP_BANNER_TEST_ID = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_TOP_BANNER_TEST_ID
		},
		getColorFromUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/getColorFromUserId"),
		clearSquadStorage = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/clearSquadStorage"),
		validateSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/validateSquadId"),
		encodeSquadMembers = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeSquadMembers"),
		encodeUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeUserIds")
	},
	Components = {
		LocalPlayerPartyVoiceEligibleBinder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").LocalPlayerPartyVoiceEligibleBinder
	},
	Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums"),
	Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags"),
	Hooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks"),
	Http = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http"),
	Middleware = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Middleware"),
	Models = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Models"),
	NetworkRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests"),
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").RODUX_KEY,
	RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads"),
	SquadAppChatEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadAppChatEventReceiver,
	SquadEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadEventReceiver,
	SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadExternalContractProvider,
	SquadOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadOverlay,
	SquadPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadPrompt,
	SquadSessionProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components").SquadSessionProvider,
	Stores = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores"),
	Thunks = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks"),
	Types = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/installReducer"),
	Utils = {
		appStorageAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/appStorageAccess"),
		displayEuConsentPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/displayEuConsentPrompt")
	}
}
