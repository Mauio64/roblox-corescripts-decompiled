local module = require("@luauforge/deferred/hhE")
local module2 = require("@luauforge/deferred/hhF")

local function FavoritesSavedView()
	return module.createElement(module2.View, {
		tag = "size-full bg-surface-0",
		testId = "FavoritesSavedView"
	})
end

return module.memo(FavoritesSavedView)
