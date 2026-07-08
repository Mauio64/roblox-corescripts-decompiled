local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local Signals = require(Parent.Signals)

require(script.Parent.ChatPlatformTypes)

local createDefaultChatPlatformValue = require(script.Parent.createDefaultChatPlatformValue)

local function createMockChatPlatformValue(t1: {[any]: any}?) -- line: 29
	-- upvalues: createDefaultChatPlatformValue (copy), Signals (copy)
	local v6 = t1 or {}
	local v7 = createDefaultChatPlatformValue()
	local getChatInputBarSettings = v7.getChatInputBarSettings

	if v6.chatInputBarSettings ~= nil then
		getChatInputBarSettings = Signals.createSignal(v6.chatInputBarSettings)
	end

	local getInterpolators = v7.getInterpolators

	if v6.interpolators ~= nil then
		getInterpolators = Signals.createSignal(v6.interpolators)
	end

	local getTransparencyStore = v7.getTransparencyStore
	local transparencyStore = v6.transparencyStore

	if transparencyStore ~= nil then
		function getTransparencyStore(_: boolean) -- line: 46
			-- upvalues: transparencyStore (copy)
			return transparencyStore
		end
	end

	return {
		getChatInputBarSettings = getChatInputBarSettings,
		chatWindowSettings = v6.chatWindowSettings or v7.chatWindowSettings,
		getInterpolators = getInterpolators,
		getTransparencyStore = getTransparencyStore
	}
end

return createMockChatPlatformValue
