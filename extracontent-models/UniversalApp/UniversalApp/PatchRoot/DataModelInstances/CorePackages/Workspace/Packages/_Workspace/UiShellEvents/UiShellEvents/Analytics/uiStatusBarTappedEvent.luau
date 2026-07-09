local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UiShellEventsParent = UiShellEvents.Parent
local t = require(UiShellEventsParent.t)
local Logger = require(UiShellEvents.Logger)
local v5 = t.strictInterface({
	page = t.string
})

return function(p1, s1: string, t1: {[any]: any}) -- line: 14
	-- upvalues: v5 (copy), Logger (copy)
	local v9, v10 = v5(t1)

	if not v9 then
		Logger:error(v10)
	end

	p1:sendEventDeferred(s1, "uiShellStatusBarTapped", t1)
end
