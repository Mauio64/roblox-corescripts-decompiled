local parent = script.Parent
local ContentProvider = game:GetService("ContentProvider")
local ItemType = require(parent.Enums.ItemType)

local v = string.gsub(ContentProvider.BaseUrl:lower(), "https?://m.", "https?://www.")
local v2 = v .. "thumbs/asset.ashx?assetid="
local v3 = v .. "outfit-thumbnail/image?userOutfitId=%s&width=100&height=100&format=png"

local function getPreviewImageUrl(data, p)
	local v4 = nil

	if data.itemType == ItemType.Bundle then
		if data.costumeId then
			return string.format(v3, data.costumeId)
		end

		v4 = data.items[1].id
	else
		if data.AssetId ~= nil and data.AssetId ~= 0 then
			v4 = data.AssetId

			return v2 .. tostring(v4) .. "&x=100&y=100&format=png"
		end

		if data.IconImageAssetId ~= nil then
			v4 = data.IconImageAssetId

			return v2 .. tostring(v4) .. "&x=100&y=100&format=png"
		end

		if data.ImageUrl ~= nil then
			return data.ImageUrl
		end

		if p == Enum.Platform.XBoxOne then
			return "rbxasset://textures/ui/Shell/Icons/ROBUXIcon@1080.png"
		end
	end

	return v2 .. tostring(v4) .. "&x=100&y=100&format=png"
end

return getPreviewImageUrl
