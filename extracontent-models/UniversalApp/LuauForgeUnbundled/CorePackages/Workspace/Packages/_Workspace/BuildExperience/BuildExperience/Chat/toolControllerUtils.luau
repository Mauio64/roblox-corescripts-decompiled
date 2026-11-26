local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local downloadGeneratedImageAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/downloadGeneratedImageAsync")
local monetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/monetizationFailureCauses")

return {
	awaitRequestState = function(callback, p2)
		while callback(false).status == "pending" do
			if p2 <= os.clock() then
				return callback(false)
			end

			task.wait()
		end

		return callback(false)
	end,
	isConversationGone = function(p2): boolean
		return p2 == CreatorAgentChat.ErrorCodes.NotFound or p2 == CreatorAgentChat.ErrorCodes.Gone
	end,
	getToolCallOrder = function(p2, p3)
		for k, activityItem in p2.activityItems do
			if activityItem.kind == "tool_call" and activityItem.toolCallId == p3 then
				return k
			end
		end

		local v5 = {}

		for k in p2.toolCalls do
			table.insert(v5, k)
		end

		table.sort(v5)

		for k, v6 in v5 do
			if v6 == p3 then
				return k
			end
		end

		return 0
	end,
	withGeneratedImage = function(p2, p3, callback)
		if p2 == nil then
			return callback(nil)
		end

		return downloadGeneratedImageAsync(p2):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS, monetizationFailureCauses.MESSAGES.imagePreparing):andThen(
			callback,
			function(value)
				if typeof(value) ~= "string" or monetizationFailureCauses.classify(value) == nil then
					value = monetizationFailureCauses.MESSAGES.imageFailed
				end

				return Promise.reject({
					errorMessage = `{p3} {value}`,
					retryable = true
				})
			end
		)
	end
}
