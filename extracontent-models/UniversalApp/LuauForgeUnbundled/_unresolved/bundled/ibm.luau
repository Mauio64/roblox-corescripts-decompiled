require("@luauforge/bundled/ibf")

local v5 = {}

function v5.shouldShowLeftChevron(p2): boolean
	return p2 - 1 >= 1
end

function v5.hasPreviousOutfit(p2, p3): boolean
	return p2 - 1 >= 1 and p2 - 1 <= p3
end

function v5.hasNextOutfit(p2, p3): boolean
	return p2 + 1 <= p3
end

function v5.isRightChevronDisabled(p2, p3, p4): boolean
	if p2 then
		return true
	end

	return not (p3 or p4)
end

function v5.shouldShowRightChevron(p2, p3): boolean
	return p2 < p3
end

function v5.getOutfitInfoAtIndex(p2, p3, p4)
	local v6 = p2[p4]

	if v6 == nil then
		return nil, nil
	end

	local v7 = tostring(v6)
	return p3[v7], v7
end

v5.EDIT_AVATAR_HIDDEN_TRANSPARENCY = 1
v5.EDIT_AVATAR_SHOWN_TRANSPARENCY = 0

function v5.getEditAvatarTransparency(p2, p3)
	if p2 or not p3 then
		return v5.EDIT_AVATAR_SHOWN_TRANSPARENCY
	end

	return v5.EDIT_AVATAR_HIDDEN_TRANSPARENCY
end

function v5.isEditAvatarVisible(p2): boolean
	return p2 < v5.EDIT_AVATAR_HIDDEN_TRANSPARENCY
end

return v5
