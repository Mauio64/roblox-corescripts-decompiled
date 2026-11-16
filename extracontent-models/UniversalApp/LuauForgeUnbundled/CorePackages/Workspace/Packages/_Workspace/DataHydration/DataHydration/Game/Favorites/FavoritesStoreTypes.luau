require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

return {
	favoriteResponseValidator = t.interface({
		isFavorited = t.optional(t.boolean)
	})
}
