local parent = script:FindFirstAncestor("PeekView").Parent

local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local strictInterface = t.strictInterface({ page = t.string, dismissMethod = t.string })

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
	logEvent = function(object, p: string, p2)
		local v, v2 = union(p2)

		if not v then
			mutedError(v2)
		end

		object:sendEventDeferred(p, "uiPeekViewDismissed", p2)
	end
}
