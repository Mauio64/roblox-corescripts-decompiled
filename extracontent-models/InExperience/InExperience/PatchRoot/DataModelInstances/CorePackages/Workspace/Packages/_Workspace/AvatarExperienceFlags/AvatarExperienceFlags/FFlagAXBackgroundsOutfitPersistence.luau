local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXOutfitDetailsV4 = require(script.Parent.FFlagAXOutfitDetailsV4)

local defineFastFlag = game:DefineFastFlag("AXBackgroundsOutfitPersistence", false)

local v = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and FFlagAXOutfitDetailsV4 and defineFastFlag and v
