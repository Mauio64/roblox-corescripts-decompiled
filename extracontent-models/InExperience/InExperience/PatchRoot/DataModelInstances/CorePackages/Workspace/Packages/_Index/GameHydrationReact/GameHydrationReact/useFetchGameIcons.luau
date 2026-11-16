local GameHydrationReact = script:FindFirstAncestor("GameHydrationReact")
local parent = GameHydrationReact.Parent

require(parent.DataHydration)
local useGameIconsForSize = require(GameHydrationReact.useGameIconsForSize)

local function useFetchGameIcons(p, p2)
	return useGameIconsForSize(p, p2, true)
end

return useFetchGameIcons
