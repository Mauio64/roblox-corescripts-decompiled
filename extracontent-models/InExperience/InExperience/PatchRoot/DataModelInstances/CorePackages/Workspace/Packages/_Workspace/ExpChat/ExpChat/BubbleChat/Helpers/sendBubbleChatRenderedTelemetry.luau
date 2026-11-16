local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")

require(ExpChat.MessageEffects.MessageEffect)

local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)

local getFIntExpChatMessageRenderUserThrottlePermyriad = require(ExpChat.Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)
local fIntExpChatMessageRenderUserThrottlePermyriad = getFIntExpChatMessageRenderUserThrottlePermyriad()

local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(ExpChat.Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)

local EngineFeatureTextChatReportEmojiTelemetryEnabled = require(ExpChat.Flags.EngineFeatureTextChatReportEmojiTelemetryEnabled)

local function sendBubbleChatRenderedTelemetry(p, p2)
	if not (getFFlagExpChatUseUpdatedMessageRendered() and shouldSendHighFrequencyTelemetry(fIntExpChatMessageRenderUserThrottlePermyriad)) then
		return
	end

	if not EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
		TextChatService:SendExpChatMessageClientRendered(p, "bubble_chat")
	elseif EngineFeatureTextChatReportEmojiTelemetryEnabled then
		TextChatService:SendExpChatMessageClientRendered(p, "bubble_chat", -1, "", p2)
	else
		TextChatService:SendExpChatMessageClientRendered(p, "bubble_chat", -1)
	end
end

return sendBubbleChatRenderedTelemetry
