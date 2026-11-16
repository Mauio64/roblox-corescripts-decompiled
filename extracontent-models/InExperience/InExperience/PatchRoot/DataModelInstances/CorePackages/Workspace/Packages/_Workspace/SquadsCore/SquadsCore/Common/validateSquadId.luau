local parent = script:FindFirstAncestor("SquadsCore").Parent
local RegExp = require(parent.RegExp)

local regExp = RegExp("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")

local function validateSquadId(p: string): boolean
	return if p and p ~= "" and regExp:exec(p) then true else false
end

return validateSquadId
