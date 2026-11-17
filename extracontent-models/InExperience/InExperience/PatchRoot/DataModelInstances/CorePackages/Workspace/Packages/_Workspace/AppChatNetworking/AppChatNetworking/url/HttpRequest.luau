local HttpService = game:GetService("HttpService")

local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local HttpRequest = require(parent.HttpRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local Loggers = require(parent.Loggers)
local logger = Loggers.Logger:new("AppChat.Networking")
local AppChatNetworkingTelemetry = require(AppChatNetworking.analytics.AppChatNetworkingTelemetry)

local SharedFlags2 = require(parent.SharedFlags)
local getFFlagDebugUnfilteredThreads = SharedFlags2.getFFlagDebugUnfilteredThreads
local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "AppChat.NetworkResponse",
	description = "Event when a response is received from AppChat's networking layer",
	lastUpdated = { 2024, 10, 18 },
	backendsList = {
		{
			type = "RobloxTelemetryCounter",
			format = function(self)
				local v = string.match(self.url, ".%w+/(.*)")

				return {
					endpoint = string.match(v or "", "([^?#]+)") or "unknown",
					statusCode = tostring(self.statusCode),
					isOK = self.isOK
				}
			end
		}
	}
})

local function chunkAndLogString(value)
	local v = {}

	for i = 1, #value, 800 do
		table.insert(v, value:sub(i, i + 800 - 1))
	end

	for _, v2 in v do
		logger:debug(v2)
	end
end

local config = HttpRequest.config
local v = {
	requestFunction = function(value, p, p2)
		logger:info(`Fetching: [ requestMethod = "{p}", url = "{value}" ]`)

		if getFFlagDebugUnfilteredThreads() then
			local postBody = p2 and p2.postBody or {}

			if string.find(value, "get%-conversations") then
				local v = ""

				for _, v2 in postBody.ids or {} do
					v = `{v}, {v2}`
				end

				chunkAndLogString(`FETCHING CONVERSATIONS{v}`)
			elseif string.find(value, "get%-modal%-sequence") then
				local conversation_id = postBody.conversation_id or postBody.friend_id
				logger:debug(`FETCHING MODAL SEQUENCE sequence: {postBody.modal_sequence} id: {conversation_id}`)
			elseif string.find(value, "record%-modal%-sequence%-response") then
				local modal_id = postBody.modal_id
				local modal_variant = postBody.modal_variant
				local conversation_id = postBody.conversation_id or postBody.friend_id
				logger:debug(`RECORDING MODAL SEQUENCE RESPONSE action: {postBody.action_type} sequence: {postBody.modal_sequence} id: {modal_id} variant: {modal_variant} conversationId: {conversation_id}`)
			end
		end

		return HttpRequest.requestFunctions.RequestInternal(value, p, p2)
	end,
	postRequestFunction = function(data, data2)
		logger:debug(`Returned: [ requestMethod = "{data2.requestMethod}", url = "{data2.url}", statusCode = {data.StatusCode}{data.HttpError == Enum.HttpError.OK and "" or `, HttpError = {data.HttpError}` or ""}]`)

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

			if string.find(data2.url, "get%-user%-conversations") or string.find(data2.url, "get%-conversations") then
				local v = ""

				for _, v2 in result and result.conversations or {} do
					v = `{v}, {v2.id} {v2.moderation_type} {v2.user_pending_status}`
				end

				chunkAndLogString(`RETURNED CONVERSATIONS{v}`)
			elseif string.find(data2.url, "get%-modal%-sequence") then
				local modal_variant = result and result.modal_variant
				local modal_sequence = data2.options
					and data2.options.postBody
					and data2.options.postBody.modal_sequence
				logger:debug(`RETURNED MODAL VARIANT sequence: {modal_sequence} variant: {modal_variant} conversationId: {conversation_id}`)
			end
		end
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("AppChatNetworkingHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
return {
	default = ChallengeRequestWrapper((config(v))),
	logger = logger
}
