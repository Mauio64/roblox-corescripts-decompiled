local module = require("@luauforge/deferred/gVx")
local module2 = require("@luauforge/deferred/gVy")

local function FavoritesSavedView()
	return module.createElement(module2.View, {
		tag = "size-full bg-surface-0",
		testId = "FavoritesSavedView"
	})
end

return module.memo(FavoritesSavedView)
