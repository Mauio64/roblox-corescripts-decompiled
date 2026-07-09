local Parent = script:FindFirstAncestor("PeekView").Parent
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local v4 = t.strictInterface({
	page = t.string,
	dismissMethod = t.string
})
local v5 = t.strictInterface({
	page = t.string,
	dismissMethod = t.string,
	locale = t.optional(t.string),
	universeId = t.string,
	source = t.string,
	index = t.number
})
local v6 = t.union(v4, v5)

return {
	dismissMethodEnum = {
		topBarTap = "topBarTap",
		scrimTap = "scrimTap",
		swipe = "swipe",
		handleTap = "handleTap"
	},
	logEvent = function(p1, s1: string, p2) -- line: 31
		-- upvalues: v6 (copy), mutedError (copy)
		local v10, v11 = v6(p2)

		if not v10 then
			mutedError(v11)
		end

		p1:sendEventDeferred(s1, "uiPeekViewDismissed", p2)
	end
}
