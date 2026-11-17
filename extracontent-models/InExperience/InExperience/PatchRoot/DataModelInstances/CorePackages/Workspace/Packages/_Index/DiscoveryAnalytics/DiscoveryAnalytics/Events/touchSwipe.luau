local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local ArgCheck = require(parent.ArgCheck)

local v = {
	[Enum.SwipeDirection.Up] = "up",
	[Enum.SwipeDirection.Right] = "right",
	[Enum.SwipeDirection.Down] = "down",
	[Enum.SwipeDirection.Left] = "left"
}

return function(object, p, elt, p2, cstm)
	ArgCheck.isType(p, "string", "eventContext")
	ArgCheck.isType(elt, "string", "elementName")

	local v2 = { elt = elt, dir = v[p2] }

	if cstm ~= nil then
		ArgCheck.isType(cstm, "string", "extraData")
		v2.cstm = cstm
	end

	object:setRBXEventStream(p, "touchSwipe", v2)
end
