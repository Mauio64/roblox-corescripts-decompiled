local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

return function(p2, p3)
	if p2 and p2.participants then
		return Cryo.List.filter(p2.participants, function(p4): boolean
			return tostring(p4) ~= tostring(p3)
		end)
	end

	return {}
end
