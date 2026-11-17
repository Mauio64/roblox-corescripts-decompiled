local function isCreatorOfGameVerified(data, p): boolean
	local creator = nil

	if p.shouldUseV2GameDetails then
		if data.GameDetailsV2 and data.GameDetailsV2[p.universeId] then
			creator = data.GameDetailsV2[p.universeId].creator
		end
	elseif data.GameDetails and data.GameDetails[p.universeId] then
		creator = data.GameDetails[p.universeId].creator
	end

	if creator == nil or creator.id == nil then
		return false
	end

	local id = tostring(creator.id)

	if creator and data.VerifiedBadges then
		if data.VerifiedBadges.VerifiedUsers and creator.type == Enum.CreatorType.User.Name then
			return data.VerifiedBadges.VerifiedUsers[tostring(id)] == true
		end

		if data.VerifiedBadges.VerifiedGroups and creator.type == Enum.CreatorType.Group.Name then
			return data.VerifiedBadges.VerifiedGroups[tostring(id)] == true
		end
	end

	return false
end

return isCreatorOfGameVerified
