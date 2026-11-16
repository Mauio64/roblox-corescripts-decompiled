require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local function getRootNavigation(dangerouslyGetParent)
	local dangerouslyGetParent2 = dangerouslyGetParent._dangerouslyGetParent()

	if dangerouslyGetParent2 then
		return (getRootNavigation(dangerouslyGetParent2))
	end

	return dangerouslyGetParent
end

return getRootNavigation
