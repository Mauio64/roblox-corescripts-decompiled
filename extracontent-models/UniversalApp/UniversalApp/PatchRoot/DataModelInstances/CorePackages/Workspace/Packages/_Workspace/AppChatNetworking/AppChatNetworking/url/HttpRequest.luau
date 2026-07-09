local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local HttpRequest = require(AppChatNetworkingParent.HttpRequest)
local FFlagLuaAppDefaultHttpRetry = require(AppChatNetworkingParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v6 = require(AppChatNetworkingParent.Loggers).Logger:new("AppChat.Networking")
local AppChatNetworkingTelemetry = require(AppChatNetworking.analytics.AppChatNetworkingTelemetry)
local getFFlagDebugUnfilteredThreads = require(AppChatNetworkingParent.SharedFlags).getFFlagDebugUnfilteredThreads
local ChallengeRequestWrapper = require(AppChatNetworkingParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v10 = require(AppChatNetworkingParent.SocialLuaAnalytics).Telemetry.new({
	name = "AppChat.NetworkResponse",
	description = "Event when a response is received from AppChat's networking layer",
	lastUpdated = {
		2024,
		10,
		18
	},
	backendsList = {{
		type = "RobloxTelemetryCounter",
		format = function(t1: {[any]: any}) -- line: 23
			local match = string.match(t1.url, ".%w+/(.*)")

			return {
				endpoint = string.match(match or "", "([^?#]+)") or "unknown",
				statusCode = tostring(t1.statusCode),
				isOK = t1.isOK
			}
		end
	}}
})

local function chunkAndLogString(p1) -- line: 41
	-- upvalues: v6 (copy)
	local t2 = {}

	for i = 1, #p1, 800 do
		table.insert(t2, p1:sub(i, i + 800 - 1))
	end

	for _, v18 in t2 do
		v6:debug(v18)
	end
end

return {
	default = ChallengeRequestWrapper((HttpRequest.config({
		requestFunction = function(p2, p3, p4) -- line: 53
			-- upvalues: v6 (copy), getFFlagDebugUnfilteredThreads (copy), chunkAndLogString (copy), HttpRequest (copy)
			v6:info(`Fetching: [ requestMethod = "{ p3 }", url = "{ p2 }" ]`)

			if getFFlagDebugUnfilteredThreads() then
				local v22 = p4 and p4.postBody or {}

				if string.find(p2, "get%-conversations") then
					local s1 = ""

					for _, v25 in v22.ids or {} do
						s1 = `{ s1 }, { v25 }`
					end

					chunkAndLogString(`FETCHING CONVERSATIONS{ s1 }`)
				elseif string.find(p2, "get%-modal%-sequence") then
					local v26 = v22.conversation_id or v22.friend_id

					v6:debug(`FETCHING MODAL SEQUENCE sequence: { v22.modal_sequence } id: { v26 }`)
				elseif string.find(p2, "record%-modal%-sequence%-response") then
					local modal_id = v22.modal_id
					local modal_variant = v22.modal_variant
					local v29 = v22.conversation_id or v22.friend_id

					v6:debug(`RECORDING MODAL SEQUENCE RESPONSE action: { v22.action_type } sequence: { v22.modal_sequence } id: { modal_id } variant: { modal_variant } conversationId: { v29 }`)
				end
			end

			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end,
		postRequestFunction = function(p5, p6) -- line: 78
			-- upvalues: v6 (copy), AppChatNetworkingTelemetry (copy), v10 (copy), getFFlagDebugUnfilteredThreads (copy), HttpService (copy), chunkAndLogString (copy)
			v6:debug(`Returned: [ requestMethod = "{ p6.requestMethod }", url = "{ p6.url }", statusCode = { p5.StatusCode }{ p5.HttpError ~= Enum.HttpError.OK and `, HttpError = { p5.HttpError }` or "" }]`)
			AppChatNetworkingTelemetry.emit(v10, {
				url = p6.url,
				statusCode = p5.StatusCode,
				isOK = p5.HttpError == Enum.HttpError.OK
			})

			if getFFlagDebugUnfilteredThreads() then
				local ok, result = pcall(function() -- line: 90
					-- upvalues: HttpService (copy), p5 (copy)
					return HttpService:JSONDecode(p5.Body)
				end)

				if not ok then
					return
				end

				local v34 = p6.options and (p6.options.postBody and (p6.options.postBody.conversation_id or p6.options.postBody.friend_id))

				if string.find(p6.url, "get%-user%-conversations") or string.find(p6.url, "get%-conversations") then
					local s2 = ""

					for _, v37 in result and result.conversations or {} do
						s2 = `{ s2 }, { v37.id } { v37.moderation_type } { v37.user_pending_status }`
					end

					chunkAndLogString(`RETURNED CONVERSATIONS{ s2 }`)

					return
				end

				if string.find(p6.url, "get%-modal%-sequence") then
					local v38 = result and result.modal_variant
					local v39 = p6.options and (p6.options.postBody and p6.options.postBody.modal_sequence)

					v6:debug(`RETURNED MODAL VARIANT sequence: { v39 } variant: { v38 } conversationId: { v34 }`)
				end
			end
		end,
		maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("AppChatNetworkingHttpRetryCount", 4)
	}))),
	logger = v6
}
