local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local parent = UiShellEvents.Parent
local t = require(parent.t)
local Logger = require(UiShellEvents.Logger)

local strictInterface = t.strictInterface({ page = t.string })

return function(object, p: string, p2)
	local v, v2 = strictInterface(p2)

	if not v then
		Logger:error(v2)
	end

	object:sendEventDeferred(p, "uiShellStatusBarTapped", p2)
end
