local GameInvite = script:FindFirstAncestor("GameInvite")

local ServerType = require(GameInvite.Enums.ServerType)

local function canShareGameInviteLink(p: number, p2, flag: boolean?)
	local v

	if p > 0 then
		v = p2.isCoreScript

		if v then
			if p2.serverType == ServerType.StandardServer then
				return flag == true
			end

			return false
		end
	else
		return false
	end

	return v
end

return canShareGameInviteLink
