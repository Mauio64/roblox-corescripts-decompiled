local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local Signals = require(parent.Signals)

require(script.Parent.ChatPlatformTypes)

local chatWindowSettings = {
	ChatWindowBackgroundColor3 = Color3.fromRGB(34, 34, 34),
	ChatWindowBackgroundTransparency = 0.3,
	ChatWindowMaxWidth = 600,
	ChatWindowMaxHeight = 400
}

local v = {
	getBackgroundColor = function(p)
		return p.BackgroundColor3
	end,
	getBackgroundTransparency = function(p)
		return p.BackgroundTransparency
	end
}

local transparencyStore = {
	setTextboxFocus = function() end,
	clearTextboxFocus = function() end
}

local function createDefaultChatPlatformValue()
	return {
		getChatInputBarSettings = Signals.createSignal({}),
		chatWindowSettings = chatWindowSettings,
		getInterpolators = Signals.createSignal(v),
		getTransparencyStore = function(_: boolean)
			return transparencyStore
		end
	}
end

return createDefaultChatPlatformValue
