local ServerType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Enums/ServerType")

local function canShareGameInviteLink(p2, p3, p4)
	local v5

	if p2 > 0 then
		v5 = p3.isCoreScript

		if v5 then
			v5 = p3.serverType == ServerType.StandardServer and p4 == true
		end
	else
		v5 = false
	end

	return v5
end

return canShareGameInviteLink
