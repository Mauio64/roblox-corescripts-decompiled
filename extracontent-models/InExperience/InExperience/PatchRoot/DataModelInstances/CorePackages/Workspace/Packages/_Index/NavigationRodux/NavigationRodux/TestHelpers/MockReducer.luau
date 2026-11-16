local parent = script:FindFirstAncestor("NavigationRodux").Parent

local Cryo = require(parent.Cryo)

return function(p, p2)
	local selected = p or {
		Navigation = { lockNavigationActions = nil }
	}

	if not (p2.type == "ApplySetNavigationLocked" and selected.Navigation.lockNavigationActions ~= p2.locked) then
		return selected
	end

	return {
		Navigation = Cryo.Dictionary.join(selected.Navigation, {
			lockNavigationActions = p2.locked or false
		})
	}
end
