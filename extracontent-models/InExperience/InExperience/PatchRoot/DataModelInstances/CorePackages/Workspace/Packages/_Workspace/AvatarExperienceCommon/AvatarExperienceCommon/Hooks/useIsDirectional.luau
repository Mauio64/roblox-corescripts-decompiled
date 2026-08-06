local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Responsive = require(Parent.Responsive)

local function useIsDirectional() -- line: 6
	-- upvalues: Responsive (copy)
	local v4 = Responsive.useLastInput()

	return Responsive.usePreferredInput() == Responsive.Input.Directional or v4 == Responsive.Input.Directional
end

return useIsDirectional
