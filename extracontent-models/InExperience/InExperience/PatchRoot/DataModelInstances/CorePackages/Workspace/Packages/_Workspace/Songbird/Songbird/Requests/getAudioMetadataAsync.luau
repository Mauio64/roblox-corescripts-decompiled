local Songbird = script:FindFirstAncestor("Songbird")
local AssetService = game:GetService("AssetService")
local Cryo = require(Songbird.Parent.Cryo)

require(Songbird.types)

local function getAudioMetadataAsync(t1: {[any]: any}) -- line: 12
	-- upvalues: AssetService (copy), Cryo (copy)
	local AudioMetadataAsync = AssetService:GetAudioMetadataAsync(t1)

	return Cryo.List.map(AudioMetadataAsync, function(p1) -- line: 15
		local v8 = table.clone(p1)

		v8.AlbumArt = "rbxassetid://11204867732"

		return v8
	end)
end

return getAudioMetadataAsync
