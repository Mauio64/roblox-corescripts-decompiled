local Parent = script:FindFirstAncestor("NavigationRodux").Parent
local Cryo = require(Parent.Cryo)

return function(p1, p2) -- line: 8
	-- upvalues: Cryo (copy)
	local v5 = p1 or {
		Navigation = {
			lockNavigationActions = nil
		}
	}

	if p2.type == "ApplySetNavigationLocked" then
		if v5.Navigation.lockNavigationActions == p2.locked then
			return v5
		end

		return {
			Navigation = Cryo.Dictionary.join(v5.Navigation, {
				lockNavigationActions = p2.locked or false
			})
		}
	end

	return v5
end
