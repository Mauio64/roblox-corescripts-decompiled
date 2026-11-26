local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")

local LocalCharacterLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/LocalCharacterLoaded")

return Rodux.createReducer(nil, {
	[LocalCharacterLoaded.name] = function(p2, p3)
		return p3.character
	end
})
