require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")
local useGameIconsForSize = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameIconsForSize")

local function useFetchGameIcons(p2, p3)
	return useGameIconsForSize(p2, p3, true)
end

return useFetchGameIcons
