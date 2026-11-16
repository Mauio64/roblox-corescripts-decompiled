local FormFactor = require("@game/CorePackages/Workspace/Packages/_Index/FormFactor/FormFactor/FormFactor")
local SetFormFactor = require("@game/CorePackages/Workspace/Packages/_Index/FormFactor/FormFactor/SetFormFactor")

return function(p2, p3)
	local v5 = p2 or FormFactor.UNKNOWN

	if p3.type == SetFormFactor.name then
		return p3.formFactor
	end

	return v5
end
