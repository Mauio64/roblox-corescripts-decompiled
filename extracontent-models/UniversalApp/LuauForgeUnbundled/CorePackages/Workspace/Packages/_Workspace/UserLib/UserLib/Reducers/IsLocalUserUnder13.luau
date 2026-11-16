local SetLocalUserUnder13 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetLocalUserUnder13")

return function(p2, p3)
	local v5 = p2 == true

	if p3.type == SetLocalUserUnder13.name then
		return p3.isUnder13
	end

	return v5
end
