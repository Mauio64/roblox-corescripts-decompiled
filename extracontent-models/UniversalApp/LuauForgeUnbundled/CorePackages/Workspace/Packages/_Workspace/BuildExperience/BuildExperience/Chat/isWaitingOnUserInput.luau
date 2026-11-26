local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")

local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local fFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local fFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription

local unifiedMonetizationTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/unifiedMonetizationTool")

local studioAskUserTool = CreatorAgentChat.StudioAskUserTool
local studioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local studioManageGamePassTool = CreatorAgentChat.StudioManageGamePassTool
local studioManageSubscriptionTool = CreatorAgentChat.StudioManageSubscriptionTool
local studioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local function isWaitingOnMonetizationApproval(p2, p3, callback, callback2, getActionKind)
	local clone = table.clone(p3)

	while true do
		local v5, v6 = callback(p2, clone)

		if v5 == nil then
			return false
		end

		local v7 = callback2(v6)

		if v7 ~= nil and getActionKind(v7.action) == "mutation" then
			return true
		end

		clone[v5] = true
	end
end

local function isWaitingOnDevProductApproval(p2, p3)
	return isWaitingOnMonetizationApproval(
		p2,
		p3,
		studioManageDevProductTool.findManageDevProductRequestInTurnState,
		studioManageDevProductTool.parseManageDevProductInput,
		studioManageDevProductTool.getActionKind
	)
end

local function isWaitingOnGamePassApproval(p2, p3)
	return isWaitingOnMonetizationApproval(
		p2,
		p3,
		studioManageGamePassTool.findRequestInTurnState,
		studioManageGamePassTool.parseInput,
		studioManageGamePassTool.getActionKind
	)
end

local function isWaitingOnSubscriptionApproval(p2, p3)
	return isWaitingOnMonetizationApproval(
		p2,
		p3,
		studioManageSubscriptionTool.findRequestInTurnState,
		studioManageSubscriptionTool.parseInput,
		studioManageSubscriptionTool.getActionKind
	)
end

local function isWaitingOnUnifiedApproval(p2, p3): boolean
	for k, tool in unifiedMonetizationTool.toolsByKind do
		if isWaitingOnMonetizationApproval(
			p2,
			p3,
			tool.findRequestInTurnState,
			tool.parseInput,
			tool.getActionKind
		) then
			return true
		end
	end

	return false
end

local function isWaitingOnUserInput(p2, p3)
	local questionsInTurnState, v5 = studioAskUserTool.findQuestionsInTurnState(p2, p3)

	if v5 ~= nil then
		return true
	end

	local planInTurnState, v6 = studioProposePlanTool.findPlanInTurnState(p2, p3)

	if v6 ~= nil then
		return true
	end

	if unifiedMonetizationTool.isEnabled then
		return isWaitingOnUnifiedApproval(p2, p3)
	end

	if
		FFlagBuildExperienceManageDevProduct
		and isWaitingOnMonetizationApproval(
			p2,
			p3,
			studioManageDevProductTool.findManageDevProductRequestInTurnState,
			studioManageDevProductTool.parseManageDevProductInput,
			studioManageDevProductTool.getActionKind
		)
		or fFlagBuildExperienceManageGamePass
		and FFlagBuildExperienceManageDevProduct
		and isWaitingOnMonetizationApproval(
			p2,
			p3,
			studioManageGamePassTool.findRequestInTurnState,
			studioManageGamePassTool.parseInput,
			studioManageGamePassTool.getActionKind
		)
	then
		return true
	end

	return fFlagBuildExperienceManageSubscription
		and FFlagBuildExperienceManageDevProduct
		and isWaitingOnMonetizationApproval(
			p2,
			p3,
			studioManageSubscriptionTool.findRequestInTurnState,
			studioManageSubscriptionTool.parseInput,
			studioManageSubscriptionTool.getActionKind
		)
end

return isWaitingOnUserInput
