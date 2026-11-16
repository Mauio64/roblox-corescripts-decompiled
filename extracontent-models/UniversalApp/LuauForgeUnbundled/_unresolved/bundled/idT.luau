local module = require("@luauforge/bundled/dwM")

local v5 = {
	[Enum.SwipeDirection.Up] = "up",
	[Enum.SwipeDirection.Right] = "right",
	[Enum.SwipeDirection.Down] = "down",
	[Enum.SwipeDirection.Left] = "left"
}

return function(object, p2, p3, p4, cstm)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "elementName")

	local v6 = { elt = p3, dir = v5[p4] }

	if cstm ~= nil then
		module.isType(cstm, "string", "extraData")
		v6.cstm = cstm
	end

	object:setRBXEventStream(p2, "touchSwipe", v6)
end
