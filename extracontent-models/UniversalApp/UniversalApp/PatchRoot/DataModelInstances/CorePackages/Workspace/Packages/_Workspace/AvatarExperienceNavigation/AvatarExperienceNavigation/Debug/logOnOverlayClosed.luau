local Parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent
local v2 = require(Parent.AppDebug).LogTree.logger("ax.rn.overlay")

return function(p1, b1: boolean?) -- line: 6
	-- upvalues: v2 (copy)
	v2:info("onOverlayClosed {}, captureFocus: {}", p1, b1)
end
