local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Promise = require(parent.Promise)

local chatConstants = require(script.Parent.chatConstants)
local downloadGeneratedImageAsync = require(BuildExperience.utils.downloadGeneratedImageAsync)
local monetizationFailureCauses = require(BuildExperience.utils.monetizationFailureCauses)
local ToolControllerUtils = {}

function ToolControllerUtils.awaitRequestState(callback, p: number)
	while callback(false).status == "pending" do
		if p <= os.clock() then
			return callback(false)
		end

		task.wait()
	end

	return callback(false)
end

function ToolControllerUtils.isConversationGone(p: number?): boolean
	return p == CreatorAgentChat.ErrorCodes.NotFound or p == CreatorAgentChat.ErrorCodes.Gone
end

function ToolControllerUtils.getToolCallOrder(p, p2: string)
	for k, activityItem in p.activityItems do
		if activityItem.kind == "tool_call" and activityItem.toolCallId == p2 then
			return k
		end
	end

	local v = {}

	for k in p.toolCalls do
		table.insert(v, k)
	end

	table.sort(v)

	for k, v2 in v do
		if v2 == p2 then
			return k
		end
	end

	return 0
end

function ToolControllerUtils.withGeneratedImage(p: number?, p2: string, callback)
	if p == nil then
		return callback(nil)
	end

	return downloadGeneratedImageAsync(p):timeout(
		chatConstants.CAS_RPC_TIMEOUT_SECONDS,
		monetizationFailureCauses.MESSAGES.imagePreparing
	):andThen(
		callback,
		function(value)
			if typeof(value) ~= "string" or monetizationFailureCauses.classify(value) == nil then
				value = monetizationFailureCauses.MESSAGES.imageFailed
			end

			return Promise.reject({ errorMessage = `{p2} {value}`, retryable = true })
		end
	)
end

return ToolControllerUtils
