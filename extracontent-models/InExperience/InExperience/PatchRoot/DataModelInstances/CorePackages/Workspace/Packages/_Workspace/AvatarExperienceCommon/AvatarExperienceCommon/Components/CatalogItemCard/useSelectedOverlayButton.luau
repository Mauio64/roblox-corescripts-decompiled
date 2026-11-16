local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)

local useTokens = Foundation.Hooks.useTokens

local function useSelectedOverlayButton(flag: boolean)
	local v = useTokens()
	local v2 = Responsive.useLastInput()
	local v3 = Responsive.useIsSpatial()

	local v4 = v2 == Responsive.Input.Directional and not v3

	return {
		isVisible = flag and not v4,
		height = v.Size.Size_700,
		bottomOffset = v.Gap.XXSmall,
		occupiedHeight = v.Size.Size_700 + v.Gap.XXSmall
	}
end

return useSelectedOverlayButton
