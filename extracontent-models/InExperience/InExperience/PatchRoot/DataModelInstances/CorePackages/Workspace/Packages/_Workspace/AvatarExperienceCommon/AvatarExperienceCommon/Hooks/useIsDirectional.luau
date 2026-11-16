local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Responsive = require(parent.Responsive)

local function useIsDirectional(): boolean
	local v = Responsive.useLastInput()
	return Responsive.usePreferredInput() == Responsive.Input.Directional or v == Responsive.Input.Directional
end

return useIsDirectional
