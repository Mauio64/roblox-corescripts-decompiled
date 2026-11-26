local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RegExp")("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")

local function validateSquadId(p2): boolean
	if p2 and p2 ~= "" and v5:exec(p2) then
		return true
	end

	return false
end

return validateSquadId
