local GameHydrationReact = script:FindFirstAncestor("GameHydrationReact")
local parent = GameHydrationReact.Parent

local DataHydration = require(parent.DataHydration)
local useGameIconForSize = require(GameHydrationReact.useGameIconForSize)

local function useLargeGameIcon(p)
	return useGameIconForSize(p, DataHydration.Game.GameIconSize.Large)
end

return useLargeGameIcon
