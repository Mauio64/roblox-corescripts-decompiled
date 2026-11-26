require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return {
	renderCoreScriptGameInviteModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/renderCoreScriptGameInviteModalContainer"),
	GetCustomizedInvitePromptTrigger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/getCustomizedInvitePromptTrigger"),
	GameInviteModalManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteModalManager"),
	GameInviteModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteModal"),
	GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants"),
	GameInviteAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalytics"),
	GameInviteEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteEvents"),
	GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager"),
	GameInvitesStatusReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Reducers/Invites"),
	GetCanSendAndCanCustomizeInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Requests/GetCanSendAndCanCustomizeInvites"),
	PostSendExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Requests/PostSendExperienceInvite")
}
