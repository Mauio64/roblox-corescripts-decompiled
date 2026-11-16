return {
	AssistantBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/AssistantBuild"),
	BuildPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/BuildPage"),
	BuildPillMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenu"),
	BuildPillMenuPortalHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPortalHost"),
	BuildEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/BuildEventReceiver"),
	GetBuildPillMenuPortalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPillMenuPortalStore"),
	GetAssistantBuildStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore"),
	GetAdsCampaignDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdsCampaignDeepLinkStore"),
	requestAdsCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/requestAdsCampaign"),
	GetCreatorAgentResumeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetCreatorAgentResumeStore"),
	GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore"),
	mountChatSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/mountChatSheet"),
	mountCreatorAgentResumeToastReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/mountCreatorAgentResumeToastReceiver"),
	sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent"),
	UnpublishedPlaytestModeTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UnpublishedPlaytestModeTooltip/UnpublishedPlaytestModeTooltip")
}
