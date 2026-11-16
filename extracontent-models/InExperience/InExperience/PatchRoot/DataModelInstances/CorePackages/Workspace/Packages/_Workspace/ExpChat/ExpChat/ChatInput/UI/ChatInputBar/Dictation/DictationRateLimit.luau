local ExpChat = script:FindFirstAncestor("ExpChat")

local createDictationRateLimit = require(script.Parent.createDictationRateLimit)
local GetDictationStateStore = require(ExpChat.Stores.GetDictationStateStore)

return createDictationRateLimit({
	getIsListening = function()
		return GetDictationStateStore(false).getIsListening(false)
	end
})
