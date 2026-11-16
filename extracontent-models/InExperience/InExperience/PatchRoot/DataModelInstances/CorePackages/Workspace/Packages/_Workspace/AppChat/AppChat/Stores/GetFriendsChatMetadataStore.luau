local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createFriendsChatMetadataStore = require(script.createFriendsChatMetadataStore)

return Signals.createComputed(function()
	return createFriendsChatMetadataStore()
end)
