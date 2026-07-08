local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local Signals = require(Parent.Signals)

require(script.Parent.ChatPlatformTypes)

local t1 = {
	ChatWindowBackgroundTransparency = 0.3,
	ChatWindowMaxWidth = 600,
	ChatWindowMaxHeight = 400,
	ChatWindowBackgroundColor3 = Color3.fromRGB(34, 34, 34)
}
local t2 = {
	getBackgroundColor = function(p1) -- line: 33
		return p1.BackgroundColor3
	end,
	getBackgroundTransparency = function(p2) -- line: 36
		return p2.BackgroundTransparency
	end
}
local t3 = {
	setTextboxFocus = function() -- line: 42
	end,
	clearTextboxFocus = function() -- line: 43
	end
}

local function createDefaultChatPlatformValue() -- line: 46
	-- upvalues: Signals (copy), t1 (copy), t2 (copy), t3 (copy)
	return {
		getChatInputBarSettings = Signals.createSignal({}),
		chatWindowSettings = t1,
		getInterpolators = Signals.createSignal(t2),
		getTransparencyStore = function(_: boolean) -- line: 51
			-- upvalues: t3 (copy)
			return t3
		end
	}
end

return createDefaultChatPlatformValue
