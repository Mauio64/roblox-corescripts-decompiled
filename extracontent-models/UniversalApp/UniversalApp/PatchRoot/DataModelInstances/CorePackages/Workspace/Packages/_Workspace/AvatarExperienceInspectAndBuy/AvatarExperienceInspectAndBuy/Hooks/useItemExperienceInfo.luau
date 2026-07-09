local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local tutils = require(Parent.tutils)

return function(p1) -- line: 11
	-- upvalues: useSelector (copy), tutils (copy)
	return (useSelector(function(p2) -- line: 12
		-- upvalues: p1 (copy)
		if not p1 then
			return nil
		end

		return p2.creatingExperiences[tostring(p1)]
	end, tutils.deepEqual))
end
