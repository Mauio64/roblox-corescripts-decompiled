local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local t1 = {
	[Enum.SwipeDirection.Up] = "up",
	[Enum.SwipeDirection.Right] = "right",
	[Enum.SwipeDirection.Down] = "down",
	[Enum.SwipeDirection.Left] = "left"
}

return function(p1, p2, p3, p4, p5) -- line: 17
	-- upvalues: ArgCheck (copy), t1 (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "elementName")

	local t2 = {
		elt = p3,
		dir = t1[p4]
	}

	if p5 ~= nil then
		ArgCheck.isType(p5, "string", "extraData")
		t2.cstm = p5
	end

	p1:setRBXEventStream(p2, "touchSwipe", t2)
end
