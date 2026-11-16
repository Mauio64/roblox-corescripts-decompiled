local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundCycloramaRendering = require(script.Parent.FFlagAXBackgroundCycloramaRendering)

local defineFastFlag = game:DefineFastFlag("AXBackgroundsCustomizeHydration4", false)

local v = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundCycloramaRendering and defineFastFlag and v
