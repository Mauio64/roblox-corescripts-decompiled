local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createEmojiSetsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/createEmojiSetsStore")

return Signals.createComputed(function(p2)
	return createEmojiSetsStore()
end)
