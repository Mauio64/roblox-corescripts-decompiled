local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundCycloramaRendering = require(script.Parent.FFlagAXBackgroundCycloramaRendering)
local v3 = game:DefineFastFlag("AXBackgroundsCustomizeHydration4", false)
local ok = pcall(function() -- line: 7
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and (FFlagAXBackgroundCycloramaRendering and (v3 and ok))
