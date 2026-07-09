local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXOutfitDetailsV4 = require(script.Parent.FFlagAXOutfitDetailsV4)
local v3 = game:DefineFastFlag("AXBackgroundsOutfitPersistence", false)
local ok = pcall(function() -- line: 10
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and (FFlagAXOutfitDetailsV4 and (v3 and ok))
