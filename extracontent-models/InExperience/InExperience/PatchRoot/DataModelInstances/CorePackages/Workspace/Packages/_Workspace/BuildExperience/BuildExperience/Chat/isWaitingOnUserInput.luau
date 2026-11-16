local BuildExperience = script:FindFirstAncestor("BuildExperience")

local parent = BuildExperience.Parent
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local SharedFlags = require(parent.SharedFlags)

local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local FFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription

local unifiedMonetizationTool = require(script.Parent.unifiedMonetizationTool)

local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local StudioManageGamePassTool = CreatorAgentChat.StudioManageGamePassTool
local StudioManageSubscriptionTool = CreatorAgentChat.StudioManageSubscriptionTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local function isWaitingOnMonetizationApproval(p, p2, callback, callback2, getActionKind)
	local clone = table.clone(p2)

	while true do
		local v, v2 = callback(p, clone)

		if v == nil then
			return false
		end

		local v3 = callback2(v2)

		if v3 ~= nil and getActionKind(v3.action) == "mutation" then
			return true
		end

		clone[v] = true
	end
end

local function isWaitingOnDevProductApproval(p, p2) -- 1 equivalent call inferred from this helper
	return isWaitingOnMonetizationApproval(
		p,
		p2,
		StudioManageDevProductTool.findManageDevProductRequestInTurnState,
		StudioManageDevProductTool.parseManageDevProductInput,
		StudioManageDevProductTool.getActionKind
	)
end

local function isWaitingOnGamePassApproval(p, p2) -- 1 equivalent call inferred from this helper
	return isWaitingOnMonetizationApproval(
		p,
		p2,
		StudioManageGamePassTool.findRequestInTurnState,
		StudioManageGamePassTool.parseInput,
		StudioManageGamePassTool.getActionKind
	)
end

local function isWaitingOnSubscriptionApproval(p, p2) -- 1 equivalent call inferred from this helper
	return isWaitingOnMonetizationApproval(
		p,
		p2,
		StudioManageSubscriptionTool.findRequestInTurnState,
		StudioManageSubscriptionTool.parseInput,
		StudioManageSubscriptionTool.getActionKind
	)
end

local function isWaitingOnUnifiedApproval(p, p2): boolean
	for _, tool in unifiedMonetizationTool.toolsByKind do
		if isWaitingOnMonetizationApproval(p, p2, tool.findRequestInTurnState, tool.parseInput, tool.getActionKind) then
			return true
		end
	end

	return false
end

local function isWaitingOnUserInput(p, p2)
	local _, v = StudioAskUserTool.findQuestionsInTurnState(p, p2)

	if v ~= nil then
		return true
	end

	local _, v2 = StudioProposePlanTool.findPlanInTurnState(p, p2)

	if v2 ~= nil then
		return true
	end

	if unifiedMonetizationTool.isEnabled then
		return isWaitingOnUnifiedApproval(p, p2)
	end

	if
		FFlagBuildExperienceManageDevProduct and isWaitingOnDevProductApproval(p, p2) -- inferred equivalent call
		or FFlagBuildExperienceManageGamePass
		and FFlagBuildExperienceManageDevProduct
		and isWaitingOnGamePassApproval(p, p2) -- inferred equivalent call
	then
		return true
	end

	return FFlagBuildExperienceManageSubscription
		and FFlagBuildExperienceManageDevProduct
		and isWaitingOnSubscriptionApproval(p, p2) -- inferred equivalent call
end

return isWaitingOnUserInput
