local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local Signals = require(parent.Signals)

require(script.Parent.ChatPlatformTypes)
local createDefaultChatPlatformValue = require(script.Parent.createDefaultChatPlatformValue)

local function createMockChatPlatformValue(options)
	local v = options or {}
	local defaultChatPlatformValue = createDefaultChatPlatformValue()

	local getChatInputBarSettings = defaultChatPlatformValue.getChatInputBarSettings

	if v.chatInputBarSettings ~= nil then
		getChatInputBarSettings = Signals.createSignal(v.chatInputBarSettings)
	end

	local getInterpolators = defaultChatPlatformValue.getInterpolators

	if v.interpolators ~= nil then
		getInterpolators = Signals.createSignal(v.interpolators)
	end

	local getTransparencyStore = defaultChatPlatformValue.getTransparencyStore
	local transparencyStore = v.transparencyStore

	local fn = transparencyStore ~= nil and function(_: boolean)
		return transparencyStore
	end or getTransparencyStore

	return {
		getChatInputBarSettings = getChatInputBarSettings,
		chatWindowSettings = v.chatWindowSettings or defaultChatPlatformValue.chatWindowSettings,
		getInterpolators = getInterpolators,
		getTransparencyStore = fn
	}
end

return createMockChatPlatformValue
