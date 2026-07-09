local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function isCreatorOfGameVerified(t1: {[any]: any}, t2: {[any]: any}) -- line: 48
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	local creator = nil

	if (FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp) and t2.shouldUseV2GameDetails then
		if t1.GameDetailsV2 and t1.GameDetailsV2[t2.universeId] then
			creator = t1.GameDetailsV2[t2.universeId].creator
		end
	elseif t1.GameDetails and t1.GameDetails[t2.universeId] then
		creator = t1.GameDetails[t2.universeId].creator
	end

	if creator == nil or creator.id == nil then
		return false
	end

	local str = tostring(creator.id)

	if creator and t1.VerifiedBadges then
		if t1.VerifiedBadges.VerifiedUsers and creator.type == Enum.CreatorType.User.Name then
			return t1.VerifiedBadges.VerifiedUsers[tostring(str)] == true
		end

		if t1.VerifiedBadges.VerifiedGroups and creator.type == Enum.CreatorType.Group.Name then
			return t1.VerifiedBadges.VerifiedGroups[tostring(str)] == true
		end
	end

	return false
end

return isCreatorOfGameVerified
