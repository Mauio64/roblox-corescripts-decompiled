local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils").Hooks.RoactRodux.useSelector
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation").Hooks.useTokens

local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")

local function selectView(p2)
	return p2.view
end

local function useViewBreakpoints(p2)
	local v5 = useTokens()
	return React.useMemo(function()
		return {
			[ViewType.Wide] = {
				ContainerSize = UDim2.new(0, 800, 0.9, -p2),
				ContainerAnchorPoint = Vector2.new(0.5, 0.5),
				ContainerPosition = UDim2.new(0.5, 0, 0.5, p2 / 2),
				OverlaySize = UDim2.new(1, 0, 1, p2),
				OverlayPosition = UDim2.new(0, 0, 0, -p2)
			},
			[ViewType.WideLandscape] = {
				ContainerSize = UDim2.new(0.95, 0, 1, -p2),
				ContainerAnchorPoint = Vector2.new(0.5, 0),
				ContainerPosition = UDim2.new(0.5, 0, 0, p2 + v5.Padding.XSmall),
				OverlaySize = UDim2.new(1, 0, 1, p2),
				OverlayPosition = UDim2.new(0, 0, 0, -p2)
			},
			[ViewType.Compact] = {
				ContainerSize = UDim2.new(1, 0, 1, -p2),
				ContainerAnchorPoint = Vector2.new(0, 0),
				ContainerPosition = UDim2.new(0, 0, 0, p2 + v5.Padding.Small),
				OverlaySize = UDim2.new(1, 0, 1, p2),
				OverlayPosition = UDim2.new(0, 0, 0, -p2)
			}
		}
	end, { p2 })[useSelector(selectView, tutils.deepEqual)] or {}
end

return useViewBreakpoints
