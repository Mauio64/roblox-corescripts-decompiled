local GameHydrationReact = script:FindFirstAncestor("GameHydrationReact")

local useGameIconForSize = require(GameHydrationReact.useGameIconForSize)

local function useGameIcon(p)
	return useGameIconForSize(p)
end

return useGameIcon
