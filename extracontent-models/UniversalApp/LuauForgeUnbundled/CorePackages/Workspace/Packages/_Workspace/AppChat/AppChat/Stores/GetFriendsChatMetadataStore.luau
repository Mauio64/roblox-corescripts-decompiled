local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createFriendsChatMetadataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatMetadataStore/createFriendsChatMetadataStore")

return Signals.createComputed(function()
	return createFriendsChatMetadataStore()
end)
