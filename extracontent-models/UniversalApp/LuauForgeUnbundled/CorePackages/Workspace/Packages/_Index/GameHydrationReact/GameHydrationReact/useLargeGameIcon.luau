local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")
local useGameIconForSize = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameIconForSize")

local function useLargeGameIcon(p2)
	return useGameIconForSize(p2, DataHydration.Game.GameIconSize.Large)
end

return useLargeGameIcon
