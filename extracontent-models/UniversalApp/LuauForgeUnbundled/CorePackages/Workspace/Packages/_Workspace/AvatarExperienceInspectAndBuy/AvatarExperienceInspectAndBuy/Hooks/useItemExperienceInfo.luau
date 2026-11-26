local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils").Hooks.RoactRodux.useSelector
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")

return function(p2)
	return (useSelector(function(p3)
		if p2 then
			return p3.creatingExperiences[tostring(p2)]
		end

		return nil
	end, tutils.deepEqual))
end
