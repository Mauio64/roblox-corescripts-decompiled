local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createEmojiSetsStore = require(script.createEmojiSetsStore)

return Signals.createComputed(function(_)
	return createEmojiSetsStore()
end)
