local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createFriendsChatMetadataStore = require(script.createFriendsChatMetadataStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createFriendsChatMetadataStore (copy)
	return createFriendsChatMetadataStore()
end)
