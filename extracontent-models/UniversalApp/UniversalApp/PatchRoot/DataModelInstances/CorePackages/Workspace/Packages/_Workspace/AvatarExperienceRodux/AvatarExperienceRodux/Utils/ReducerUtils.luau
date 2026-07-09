local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Constants = require(Parent.AvatarExperienceCommon).Constants
local FFlagAXCatalogMakeupSupport = require(Parent.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local AssetTypeToAssetCategory = require(script.Parent.Parent.Constants).AssetTypeToAssetCategory

require(script.Parent.Parent.Types.BodyColors)
require(script.Parent.Parent.Types.OutfitTryOn)

local LOOK_TYPE = Constants.LOOK_TYPE

return {
	filterTryOns = function(p1, p2) -- line: 42
		-- upvalues: AssetTypeToAssetCategory (copy)
		local t1 = {}
		local v9 = nil

		for v10, v11 in p1 do
			local v12 = AssetTypeToAssetCategory[p2.itemSubType]
			local v13 = not v12 or v12 ~= AssetTypeToAssetCategory[v11.itemSubType]

			if v11.itemSubType ~= p2.itemSubType and v13 then
				t1[v10] = v11
			else
				v9 = v11
			end
		end

		return t1, v9
	end,
	convertDefaultBodyColorRanges = function(t2: {[any]: any}) -- line: 62
		local t3 = {}

		for _, v17 in t2 do
			table.insert(t3, {
				rangeId = v17[1]:ToHex(),
				range = v17
			})
		end

		return t3
	end,
	generateTryOnItemIdKey = function(s1: string, p3, p4) -- line: 76
		-- upvalues: LOOK_TYPE (copy), FFlagAXCatalogMakeupSupport (copy)
		if p4 ~= nil and (p4 == LOOK_TYPE.Avatar or FFlagAXCatalogMakeupSupport and p4 == LOOK_TYPE.Makeup) then
			return tostring(s1) .. "-" .. p3
		end

		return s1
	end,
	generateRecommendedItemsKey = function(s2: string?, s3: string?) -- line: 89
		local v23 = s2 or ""

		return (s3 or "") .. "-" .. v23
	end
}
