local Songbird = script:FindFirstAncestor("Songbird")

local AssetService = game:GetService("AssetService")

local Cryo = require(Songbird.Parent.Cryo)
require(Songbird.types)

local function getAudioMetadataAsync(p)
	local audioMetadataAsync = AssetService:GetAudioMetadataAsync(p)

	return Cryo.List.map(audioMetadataAsync, function(p2)
		local clone = table.clone(p2)

		clone.AlbumArt = "rbxassetid://11204867732"

		return clone
	end)
end

return getAudioMetadataAsync
