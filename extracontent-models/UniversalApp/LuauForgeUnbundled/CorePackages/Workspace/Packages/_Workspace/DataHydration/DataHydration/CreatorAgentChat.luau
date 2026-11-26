local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local types = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/BuildSuggestions/requestBuildSuggestions")

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioAskUserTool")

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioProposePlanTool")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/SubagentTasks")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioClientLogsTool")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioClientDataModelTools")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageDevProductTool")
local fFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local fFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription
local fFlagBuildExperienceManageMonetizationTool = SharedFlags.FFlagBuildExperienceManageMonetizationTool
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs")

local v5 = {
	FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagBuildAgentAdCampaignCard"),
	FFlagBuildExperienceThoughtStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagBuildExperienceThoughtStatus"),
	getCreatorAgentChatStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/getCreatorAgentChatStore"),
	createCreatorAgentChatStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createCreatorAgentChatStore"),
	createMockStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createMockStore"),
	TurnStateReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/turnState"),
	PublishToolUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/publishToolUtils"),
	ResumeNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ResumeNotification"),
	StudioAskUserTool = module4,
	StudioProposePlanTool = module5,
	SubagentTasks = module6,
	SubagentTaskStatus = types.SubagentTaskStatus,
	SubagentTaskCategory = types.SubagentTaskCategory,
	RequestFailureKind = types.RequestFailureKind,
	StudioClientLogsTool = module7,
	StudioClientDataModelTools = module8,
	StudioManageDevProductTool = module9,
	StudioManageGamePassTool = 0,
	StudioManageSubscriptionTool = 0,
	StudioManageMonetizationTool = 0,
	ClientToolItems = 0,
	decodeAdCampaignEligibilityResult = 0,
	classifyAdCampaignFailure = 0,
	requestBuildSuggestions = 0,
	debug = 0,
	experimentOverride = 0,
	chatOpenTelemetry = 0,
	captureSendConfiguration = 0,
	PreviewSpecs = 0,
	ErrorCodes = 0,
	resolveCreatorAgentAcp = 0
}

local v6 = if fFlagBuildExperienceManageGamePass then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageGamePassTool") else nil
v5.StudioManageGamePassTool = v6

local v7 = if fFlagBuildExperienceManageSubscription then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageSubscriptionTool") else nil
v5.StudioManageSubscriptionTool = v7

local v8 = if fFlagBuildExperienceManageMonetizationTool then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageMonetizationTool") else nil
v5.StudioManageMonetizationTool = v8

v5.ClientToolItems = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ClientToolItems")
v5.decodeAdCampaignEligibilityResult = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeAdCampaignEligibilityResult")
v5.classifyAdCampaignFailure = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/classifyAdCampaignFailure")
v5.requestBuildSuggestions = module3
v5.debug = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/debug")
v5.experimentOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/experimentOverride")
v5.chatOpenTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/chatOpenTelemetry")
v5.captureSendConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sendConfiguration").capture
v5.PreviewSpecs = module10
v5.ErrorCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol").ErrorCodes
v5.resolveCreatorAgentAcp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Env/resolveAcpUrl").resolveCreatorAgentAcp
return v5
