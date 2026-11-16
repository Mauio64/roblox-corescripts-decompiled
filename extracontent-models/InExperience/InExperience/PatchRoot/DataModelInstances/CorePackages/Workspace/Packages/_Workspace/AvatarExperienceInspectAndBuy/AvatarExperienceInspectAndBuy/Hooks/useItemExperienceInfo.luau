local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require(parent.tutils)

return function(p)
	return (useSelector(function(p2)
		if p then
			return p2.creatingExperiences[tostring(p)]
		end

		return nil
	end, tutils.deepEqual))
end
