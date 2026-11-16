local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/t")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Loggers").mutedError

local strictInterface = t.strictInterface({
	page = t.string,
	dismissMethod = t.string
})

local strictInterface2 = t.strictInterface({
	page = t.string,
	dismissMethod = t.string,
	locale = t.optional(t.string),
	universeId = t.string,
	source = t.string,
	index = t.number
})

local union = t.union(strictInterface, strictInterface2)

return {
	dismissMethodEnum = {
		topBarTap = "topBarTap",
		scrimTap = "scrimTap",
		swipe = "swipe",
		handleTap = "handleTap"
	},
	logEvent = function(object, p2, p3)
		local v5, v6 = union(p3)

		if not v5 then
			mutedError(v6)
		end

		object:sendEventDeferred(p2, "uiPeekViewDismissed", p3)
	end
}
