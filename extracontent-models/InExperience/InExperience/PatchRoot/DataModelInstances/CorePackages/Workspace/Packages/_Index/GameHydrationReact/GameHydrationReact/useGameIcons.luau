local GameHydrationReact = script:FindFirstAncestor("GameHydrationReact")
local parent = GameHydrationReact.Parent

require(parent.DataHydration)
local useGameIconsForSize = require(GameHydrationReact.useGameIconsForSize)

local function useGameIcons(p, p2)
	return useGameIconsForSize(p, p2)
end

return useGameIcons
