local AssetService = game:GetService("AssetService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")

local function getAudioMetadataAsync(p2)
	local audioMetadataAsync = AssetService:GetAudioMetadataAsync(p2)

	return Cryo.List.map(audioMetadataAsync, function(p3)
		local clone = table.clone(p3)

		clone.AlbumArt = "rbxassetid://11204867732"

		return clone
	end)
end

return getAudioMetadataAsync
