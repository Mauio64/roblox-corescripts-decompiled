local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/Cryo")

return function(items, p2)
	local set = {}

	for k, item in items do
		if p2 then
			item = p2[item]
		end

		if item and item ~= "" then
			set[item] = true
		end
	end

	return Cryo.Dictionary.keys(set)
end
