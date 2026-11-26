local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/ArgCheck")

local v5 = {
	[Enum.SwipeDirection.Up] = "up",
	[Enum.SwipeDirection.Right] = "right",
	[Enum.SwipeDirection.Down] = "down",
	[Enum.SwipeDirection.Left] = "left"
}

return function(object, p2, p3, p4, cstm)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "elementName")

	local v6 = { elt = p3, dir = v5[p4] }

	if cstm ~= nil then
		ArgCheck.isType(cstm, "string", "extraData")
		v6.cstm = cstm
	end

	object:setRBXEventStream(p2, "touchSwipe", v6)
end
