local parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent

local AppDebug = require(parent.AppDebug)
local logger = AppDebug.LogTree.logger("ax.rn.overlay")

return function(p, flag: boolean?)
	logger:info("onOverlayClosed {}, captureFocus: {}", p, flag)
end
