local HttpService = game:GetService("HttpService")

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/HttpRequest")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").FFlagLuaAppDefaultHttpRetry
local v5 = require("@luauforge/bundled/cap").Logger:new("AppChat.Networking")
local AppChatNetworkingTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/analytics/AppChatNetworkingTelemetry")

local getFFlagDebugUnfilteredThreads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").getFFlagDebugUnfilteredThreads
local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/GenericChallenges").Middleware.ChallengeRequestWrapper

local telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SocialLuaAnalytics").Telemetry.new({
	name = "AppChat.NetworkResponse",
	description = "Event when a response is received from AppChat's networking layer",
	lastUpdated = { 2024, 10, 18 },
	backendsList = {
		{
			type = "RobloxTelemetryCounter",
			format = function(data)
				local v6 = string.match(data.url, ".%w+/(.*)")

				return {
					endpoint = string.match(v6 or "", "([^?#]+)") or "unknown",
					statusCode = tostring(data.statusCode),
					isOK = data.isOK
				}
			end
		}
	}
})

local function chunkAndLogString(value)
	local v6 = {}

	for i = 1, #value, 800 do
		table.insert(v6, value:sub(i, i + 800 - 1))
	end

	for k, v7 in v6 do
		v5:debug(v7)
	end
end

local config = HttpRequest.config
local v6 = {
	requestFunction = function(value, p2, p3)
		v5:info(`Fetching: [ requestMethod = "{p2}", url = "{value}" ]`)

		if getFFlagDebugUnfilteredThreads() then
			local postBody = p3 and p3.postBody or {}

			if string.find(value, "get%-conversations") then
				local v7 = ""

				for k, v8 in postBody.ids or {} do
					v7 = `{v7}, {v8}`
				end

				chunkAndLogString(`FETCHING CONVERSATIONS{v7}`)
			elseif string.find(value, "get%-modal%-sequence") then
				local conversation_id = postBody.conversation_id or postBody.friend_id
				v5:debug(`FETCHING MODAL SEQUENCE sequence: {postBody.modal_sequence} id: {conversation_id}`)
			elseif string.find(value, "record%-modal%-sequence%-response") then
				local modal_id = postBody.modal_id
				local modal_variant = postBody.modal_variant
				local conversation_id = postBody.conversation_id or postBody.friend_id
				v5:debug(`RECORDING MODAL SEQUENCE RESPONSE action: {postBody.action_type} sequence: {postBody.modal_sequence} id: {modal_id} variant: {modal_variant} conversationId: {conversation_id}`)
			end
		end

		return HttpRequest.requestFunctions.RequestInternal(value, p2, p3)
	end,
	postRequestFunction = function(data, data2)
		v5:debug(`Returned: [ requestMethod = "{data2.requestMethod}", url = "{data2.url}", statusCode = {data.StatusCode}{data.HttpError == Enum.HttpError.OK and "" or `, HttpError = {data.HttpError}` or ""}]`)

		AppChatNetworkingTelemetry.emit(telemetry, {
			url = data2.url,
			statusCode = data.StatusCode,
			isOK = data.HttpError == Enum.HttpError.OK
		})

		if getFFlagDebugUnfilteredThreads() then
			local success, result = pcall(function()
				return HttpService:JSONDecode(data.Body)
			end)

			if not success then
				return
			end

			local conversation_id = data2.options
				and data2.options.postBody
				and (data2.options.postBody.conversation_id or data2.options.postBody.friend_id)

			if
				string.find(data2.url, "get%-user%-conversations")
				or string.find(data2.url, "get%-conversations")
			then
				local v7 = ""

				for k, v8 in result and result.conversations or {} do
					v7 = `{v7}, {v8.id} {v8.moderation_type} {v8.user_pending_status}`
				end

				chunkAndLogString(`RETURNED CONVERSATIONS{v7}`)
			elseif string.find(data2.url, "get%-modal%-sequence") then
				local modal_variant = result and result.modal_variant
				local modal_sequence = data2.options
					and data2.options.postBody
					and data2.options.postBody.modal_sequence
				v5:debug(`RETURNED MODAL VARIANT sequence: {modal_sequence} variant: {modal_variant} conversationId: {conversation_id}`)
			end
		end
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("AppChatNetworkingHttpRetryCount", 4) else nil
v6.maxRetryCount = v7
return {
	default = challengeRequestWrapper((config(v6))),
	logger = v5
}
