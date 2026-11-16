local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

return function(p2, items)
	local nones = {}

	for k, item in pairs(items) do
		nones[item] = llama.None
	end

	return llama.Dictionary.join(p2, nones)
end
