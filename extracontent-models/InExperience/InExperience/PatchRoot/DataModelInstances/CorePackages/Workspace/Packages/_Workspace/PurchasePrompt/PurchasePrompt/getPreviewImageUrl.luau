local scriptParent = script.Parent
local ContentProvider = game:GetService("ContentProvider")
local ItemType = require(scriptParent.Enums.ItemType)
local FFlagEnableUnifiedProductPurchaseFlow = require(scriptParent.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "https?://m.", "https?://www.")
local v6 = v5 .. "thumbs/asset.ashx?assetid="
local v7 = v5 .. "outfit-thumbnail/image?userOutfitId=%s&width=100&height=100&format=png"

local function getPreviewImageUrl(p1, p2) -- line: 15
	-- upvalues: ItemType (copy), v7 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), v6 (copy)
	local id = nil

	if p1.itemType == ItemType.Bundle then
		if p1.costumeId then
			return string.format(v7, p1.costumeId)
		end

		id = p1.items[1].id
	elseif p1.AssetId ~= nil and p1.AssetId ~= 0 then
		id = p1.AssetId
	elseif p1.IconImageAssetId ~= nil then
		id = p1.IconImageAssetId
	else
		if FFlagEnableUnifiedProductPurchaseFlow and p1.ImageUrl ~= nil then
			return p1.ImageUrl
		end

		if p2 == Enum.Platform.XBoxOne then
			return "rbxasset://textures/ui/Shell/Icons/ROBUXIcon@1080.png"
		end
	end

	return v6 .. tostring(id) .. "&x=100&y=100&format=png"
end

return getPreviewImageUrl
