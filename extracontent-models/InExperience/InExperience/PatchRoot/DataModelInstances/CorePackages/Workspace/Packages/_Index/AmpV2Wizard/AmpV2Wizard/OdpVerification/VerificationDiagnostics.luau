local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

require(script.Parent.Types)

local function boundedIdentifier(value) -- 4 equivalent calls inferred from this helper
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

local VerificationDiagnostics = {}

function VerificationDiagnostics.beginAttempt(odpSessionId: string, method, presentation: string, flowId: string?, analyticsSessionId: string?)
	local localPlayer = Players.LocalPlayer
	local v = {
		schemaVersion = 1,
		attemptId = HttpService:GenerateGUID(false),
		flowId = 0,
		analyticsSessionId = 0,
		odpSessionId = 0,
		childUserIdAtStart = 0,
		method = 0,
		presentation = 0
	}
	flowId = boundedIdentifier(flowId) -- inferred equivalent call
	v.flowId = flowId
	analyticsSessionId = boundedIdentifier(analyticsSessionId) -- inferred equivalent call
	v.analyticsSessionId = analyticsSessionId
	odpSessionId = boundedIdentifier(odpSessionId) -- inferred equivalent call
	v.odpSessionId = odpSessionId
	local childUserIdAtStart

	if localPlayer and localPlayer.UserId > 0 then
		childUserIdAtStart = localPlayer.UserId
	end

	v.childUserIdAtStart = childUserIdAtStart
	v.method = method
	v.presentation = presentation
	return v
end

function VerificationDiagnostics.completeFailure(p, failureOrigin: string, inquiryId: string?, p2: number?, p3, debugMessage)
	local clone = table.clone(p)
	clone.clientOccurredAtMs = DateTime.now().UnixTimestampMillis
	clone.failureOrigin = failureOrigin
	inquiryId = boundedIdentifier(inquiryId) -- inferred equivalent call
	clone.inquiryId = inquiryId

	if p2 then
		clone.elapsedSinceNativeLaunchMs = math.max(0, (math.floor((os.clock() - p2) * 1000)))
	end

	if typeof(p3) == "EnumItem" then
		clone.nativeResultType = p3.Name
	end

	local debugMessageTruncated

	if typeof(debugMessage) == "string" and debugMessage ~= "" then
		if #debugMessage <= 2048 then
			debugMessageTruncated = false
		else
			debugMessage = string.sub(debugMessage, 1, utf8.offset(debugMessage, 0, 2049) - 1)
			debugMessageTruncated = true
		end
	else
		debugMessage = nil
	end

	clone.debugMessage = debugMessage
	clone.debugMessageTruncated = debugMessageTruncated
	return clone
end

return VerificationDiagnostics
