local fFlagArgoEnableMoments = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagArgoEnableMoments

return function(p2)
	if p2 then
		return fFlagArgoEnableMoments
	end

	return false
end
