local ContentProvider = game:GetService("ContentProvider")
local ItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ItemType")

local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "https?://m.", "https?://www.")
local v6 = v5 .. "thumbs/asset.ashx?assetid="
local v7 = v5 .. "outfit-thumbnail/image?userOutfitId=%s&width=100&height=100&format=png"

local function getPreviewImageUrl(data, p2)
	local v8 = nil

	if data.itemType == ItemType.Bundle then
		if data.costumeId then
			return string.format(v7, data.costumeId)
		end

		v8 = data.items[1].id
	else
		if data.AssetId ~= nil and data.AssetId ~= 0 then
			v8 = data.AssetId

			return v6 .. tostring(v8) .. "&x=100&y=100&format=png"
		end

		if data.IconImageAssetId ~= nil then
			v8 = data.IconImageAssetId

			return v6 .. tostring(v8) .. "&x=100&y=100&format=png"
		end

		if data.ImageUrl ~= nil then
			return data.ImageUrl
		end

		if p2 == Enum.Platform.XBoxOne then
			return "rbxasset://textures/ui/Shell/Icons/ROBUXIcon@1080.png"
		end
	end

	return v6 .. tostring(v8) .. "&x=100&y=100&format=png"
end

return getPreviewImageUrl
