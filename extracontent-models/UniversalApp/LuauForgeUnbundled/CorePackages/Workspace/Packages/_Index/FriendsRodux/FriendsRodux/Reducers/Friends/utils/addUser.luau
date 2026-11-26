local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

return function(p2, p3)
	if not p2 then
		return { p3 }
	end

	if llama.List.find(p2, p3) then
		return p2
	end

	return llama.List.join(p2, { p3 })
end
