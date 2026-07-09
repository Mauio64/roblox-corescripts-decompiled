local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local useSelector = require(AvatarExperienceInspectAndBuyParent.RoactUtils).Hooks.RoactRodux.useSelector
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)
local useTokens = require(AvatarExperienceInspectAndBuyParent.Foundation).Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local function selectView(p1) -- line: 32
	return p1.view
end
local function useViewBreakpoints(n1: number) -- line: 44
	-- upvalues: useTokens (copy), React (copy), ViewType (copy), useSelector (copy), selectView (copy), tutils (copy)
	local v12 = useTokens()

	return React.useMemo(function() -- line: 46
		-- upvalues: ViewType (copy), n1 (copy), v12 (copy)
		return {
			[ViewType.Wide] = {
				ContainerSize = UDim2.new(0, 800, 0.9, -n1),
				ContainerAnchorPoint = Vector2.new(0.5, 0.5),
				ContainerPosition = UDim2.new(0.5, 0, 0.5, n1 / 2),
				OverlaySize = UDim2.new(1, 0, 1, n1),
				OverlayPosition = UDim2.new(0, 0, 0, -n1)
			},
			[ViewType.WideLandscape] = {
				ContainerSize = UDim2.new(0.95, 0, 1, -n1),
				ContainerAnchorPoint = Vector2.new(0.5, 0),
				ContainerPosition = UDim2.new(0.5, 0, 0, n1 + v12.Padding.XSmall),
				OverlaySize = UDim2.new(1, 0, 1, n1),
				OverlayPosition = UDim2.new(0, 0, 0, -n1)
			},
			[ViewType.Compact] = {
				ContainerSize = UDim2.new(1, 0, 1, -n1),
				ContainerAnchorPoint = Vector2.new(0, 0),
				ContainerPosition = UDim2.new(0, 0, 0, n1 + v12.Padding.Small),
				OverlaySize = UDim2.new(1, 0, 1, n1),
				OverlayPosition = UDim2.new(0, 0, 0, -n1)
			}
		}
	end, { n1 })[useSelector(selectView, tutils.deepEqual)] or {}
end

return useViewBreakpoints
