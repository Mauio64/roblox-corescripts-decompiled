local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require(parent.tutils)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local function selectView(p)
	return p.view
end

local function useViewBreakpoints(p: number)
	local v = useTokens()
	return React.useMemo(function()
		return {
			[ViewType.Wide] = {
				ContainerSize = UDim2.new(0, 800, 0.9, -p),
				ContainerAnchorPoint = Vector2.new(0.5, 0.5),
				ContainerPosition = UDim2.new(0.5, 0, 0.5, p / 2),
				OverlaySize = UDim2.new(1, 0, 1, p),
				OverlayPosition = UDim2.new(0, 0, 0, -p)
			},
			[ViewType.WideLandscape] = {
				ContainerSize = UDim2.new(0.95, 0, 1, -p),
				ContainerAnchorPoint = Vector2.new(0.5, 0),
				ContainerPosition = UDim2.new(0.5, 0, 0, p + v.Padding.XSmall),
				OverlaySize = UDim2.new(1, 0, 1, p),
				OverlayPosition = UDim2.new(0, 0, 0, -p)
			},
			[ViewType.Compact] = {
				ContainerSize = UDim2.new(1, 0, 1, -p),
				ContainerAnchorPoint = Vector2.new(0, 0),
				ContainerPosition = UDim2.new(0, 0, 0, p + v.Padding.Small),
				OverlaySize = UDim2.new(1, 0, 1, p),
				OverlayPosition = UDim2.new(0, 0, 0, -p)
			}
		}
	end, { p })[useSelector(selectView, tutils.deepEqual)] or {}
end

return useViewBreakpoints
