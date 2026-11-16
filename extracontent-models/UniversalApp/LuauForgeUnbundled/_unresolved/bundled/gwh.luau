local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

require("@luauforge/bundled/gvW")

local function boundedIdentifier(value)
	if typeof(value) == "string" and #value <= 128 and string.match(value, "^[%w_%-]+$") then
		return value
	end

	return nil
end

local function boundedMessage(value)
	if typeof(value) ~= "string" or value == "" then
		return nil, nil
	end

	if #value <= 2048 then
		return value, false
	end

	return string.sub(value, 1, utf8.offset(value, 0, 2049) - 1), true
end

return {
	beginAttempt = function(odpSessionId, method, presentation, flowId, analyticsSessionId)
		local localPlayer = Players.LocalPlayer
		local v5 = {
			schemaVersion = 1,
			attemptId = HttpService:GenerateGUID(false),
			flowId = 0,
			analyticsSessionId = 0,
			odpSessionId = 0,
			childUserIdAtStart = 0,
			method = 0,
			presentation = 0
		}

		if typeof(flowId) ~= "string" or not (#flowId <= 128 and string.match(flowId, "^[%w_%-]+$")) then
			flowId = nil
		end

		v5.flowId = flowId

		if
			typeof(analyticsSessionId) ~= "string"
			or not (#analyticsSessionId <= 128 and string.match(analyticsSessionId, "^[%w_%-]+$"))
		then
			analyticsSessionId = nil
		end

		v5.analyticsSessionId = analyticsSessionId

		if
			typeof(odpSessionId) ~= "string"
			or not (#odpSessionId <= 128 and string.match(odpSessionId, "^[%w_%-]+$"))
		then
			odpSessionId = nil
		end

		v5.odpSessionId = odpSessionId
		local v6 = if localPlayer and localPlayer.UserId > 0 then localPlayer.UserId else nil
		v5.childUserIdAtStart = v6
		v5.method = method
		v5.presentation = presentation
		return v5
	end,
	completeFailure = function(p2, failureOrigin, inquiryId, p3, p4, debugMessage)
		local clone = table.clone(p2)
		clone.clientOccurredAtMs = DateTime.now().UnixTimestampMillis
		clone.failureOrigin = failureOrigin

		if
			typeof(inquiryId) ~= "string"
			or not (#inquiryId <= 128 and string.match(inquiryId, "^[%w_%-]+$"))
		then
			inquiryId = nil
		end

		clone.inquiryId = inquiryId

		if p3 then
			clone.elapsedSinceNativeLaunchMs = math.max(0, (math.floor((os.clock() - p3) * 1000)))
		end

		if typeof(p4) == "EnumItem" then
			clone.nativeResultType = p4.Name
		end

		local v5

		if typeof(debugMessage) == "string" and debugMessage ~= "" then
			if #debugMessage <= 2048 then
				v5 = false
			else
				debugMessage = string.sub(debugMessage, 1, utf8.offset(debugMessage, 0, 2049) - 1)
				v5 = true
			end
		else
			debugMessage = nil
		end

		clone.debugMessage = debugMessage
		clone.debugMessageTruncated = v5
		return clone
	end
}
