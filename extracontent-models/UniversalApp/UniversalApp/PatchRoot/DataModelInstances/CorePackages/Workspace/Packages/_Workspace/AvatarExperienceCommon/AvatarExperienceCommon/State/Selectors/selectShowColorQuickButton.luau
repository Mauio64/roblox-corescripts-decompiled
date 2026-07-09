local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local selectTryOnBodyIds = require(script.Parent.selectTryOnBodyIds)
local FFlagAXMISEnableMultiShopping = require(Parent.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping

local function selectShowColorQuickButton(p1) -- line: 9
	-- upvalues: selectTryOnBodyIds (copy), FFlagAXMISEnableMultiShopping (copy)
	local v6 = selectTryOnBodyIds(p1)
	local v7 = if not FFlagAXMISEnableMultiShopping then nil else p1.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	for _, v9 in v6 do
		local v10 = p1.AvatarExperience.Common.BundleInfos[v9]

		if FFlagAXMISEnableMultiShopping and v10 and v10.isRecolorable and v7 and v9 == v7.itemId then
			return true
		end

		if not FFlagAXMISEnableMultiShopping and v10 and v10.isRecolorable then
			return true
		end
	end

	return false
end

return selectShowColorQuickButton
