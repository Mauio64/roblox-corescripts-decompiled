local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AppDebug").LogTree.logger("ax.rn.overlay")

return function(p2, p3)
	logger:info("onOverlayClosed {}, captureFocus: {}", p2, p3)
end
