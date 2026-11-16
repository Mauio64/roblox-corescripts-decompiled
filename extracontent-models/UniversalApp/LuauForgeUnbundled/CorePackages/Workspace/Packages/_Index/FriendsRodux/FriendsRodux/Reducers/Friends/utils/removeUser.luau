local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

return function(options, p2)
	return llama.List.removeValue(options or {}, p2)
end
