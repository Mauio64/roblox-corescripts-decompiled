local parent = script:FindFirstAncestor("DataHydration").Parent

local SharedFlags = require(parent.SharedFlags)
local types = require(script.types)

local requestBuildSuggestions = require(script.BuildSuggestions.requestBuildSuggestions)

local StudioAskUserTool = require(script.StudioAskUserTool)

local StudioProposePlanTool = require(script.StudioProposePlanTool)
local SubagentTasks = require(script.SubagentTasks)
local StudioClientLogsTool = require(script.StudioClientLogsTool)
local StudioClientDataModelTools = require(script.StudioClientDataModelTools)
local StudioManageDevProductTool = require(script.StudioManageDevProductTool)
local FFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local FFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription
local FFlagBuildExperienceManageMonetizationTool = SharedFlags.FFlagBuildExperienceManageMonetizationTool
local PreviewSpecs = require(script.PreviewSpecs)

local CreatorAgentChat = {
	FFlagBuildAgentAdCampaignCard = require(script.FFlagBuildAgentAdCampaignCard),
	FFlagBuildExperienceThoughtStatus = require(script.FFlagBuildExperienceThoughtStatus),
	getCreatorAgentChatStore = require(script.getCreatorAgentChatStore),
	createCreatorAgentChatStore = require(script.createCreatorAgentChatStore),
	createMockStore = require(script.createMockStore),
	TurnStateReducer = require(script.turnState),
	PublishToolUtils = require(script.publishToolUtils),
	ResumeNotification = require(script.ResumeNotification),
	StudioAskUserTool = StudioAskUserTool,
	StudioProposePlanTool = StudioProposePlanTool,
	SubagentTasks = SubagentTasks,
	SubagentTaskStatus = types.SubagentTaskStatus,
	SubagentTaskCategory = types.SubagentTaskCategory,
	RequestFailureKind = types.RequestFailureKind,
	StudioClientLogsTool = StudioClientLogsTool,
	StudioClientDataModelTools = StudioClientDataModelTools,
	StudioManageDevProductTool = StudioManageDevProductTool,
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
local studioManageGamePassTool

if FFlagBuildExperienceManageGamePass then
	studioManageGamePassTool = require(script.StudioManageGamePassTool)
end

CreatorAgentChat.StudioManageGamePassTool = studioManageGamePassTool
local studioManageSubscriptionTool

if FFlagBuildExperienceManageSubscription then
	studioManageSubscriptionTool = require(script.StudioManageSubscriptionTool)
end

CreatorAgentChat.StudioManageSubscriptionTool = studioManageSubscriptionTool
local studioManageMonetizationTool

if FFlagBuildExperienceManageMonetizationTool then
	studioManageMonetizationTool = require(script.StudioManageMonetizationTool)
end

CreatorAgentChat.StudioManageMonetizationTool = studioManageMonetizationTool

CreatorAgentChat.ClientToolItems = require(script.ClientToolItems)
CreatorAgentChat.decodeAdCampaignEligibilityResult = require(script.decodeAdCampaignEligibilityResult)
CreatorAgentChat.classifyAdCampaignFailure = require(script.classifyAdCampaignFailure)
CreatorAgentChat.requestBuildSuggestions = requestBuildSuggestions
CreatorAgentChat.debug = require(script.debug)
CreatorAgentChat.experimentOverride = require(script.experimentOverride)
CreatorAgentChat.chatOpenTelemetry = require(script.chatOpenTelemetry)
local sendConfiguration = require(script.sendConfiguration)
CreatorAgentChat.captureSendConfiguration = sendConfiguration.capture
CreatorAgentChat.PreviewSpecs = PreviewSpecs
local AcpProtocol = require(script.Acp.AcpProtocol)
CreatorAgentChat.ErrorCodes = AcpProtocol.ErrorCodes
local resolveAcpUrl = require(script.Env.resolveAcpUrl)
CreatorAgentChat.resolveCreatorAgentAcp = resolveAcpUrl.resolveCreatorAgentAcp
return CreatorAgentChat
