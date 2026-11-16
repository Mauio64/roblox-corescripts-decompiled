local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Foundation")

local VisibilityControl = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/VisibilityControl")
local getScrollAwayEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/getScrollAwayEnabled")

local useTokens = Foundation.Hooks.useTokens

local function BottomBarInsetBackground(props)
	local v5 = useTokens()
	local color3 = v5.Color.Common.NavigationBar.Color3
	local transparency = v5.Color.Common.NavigationBar.Transparency
	local color3_2 = v5.Color.Surface.Surface_0.Color3
	local transparency2 = v5.Color.Surface.Surface_0.Transparency

	local v6, v7 = React.useBinding(color3)
	local v8, v9 = React.useBinding(transparency)

	React.useEffect(function()
		local function update(p2)
			local v10 = 1 - p2
			v7(color3:Lerp(color3_2, v10))
			v9(transparency + (transparency2 - transparency) * v10)
		end

		if getScrollAwayEnabled() then
			local footerBinding = VisibilityControl.getFooterBinding()
			local __subscribeToBinding = React.__subscribeToBinding(footerBinding, update)
			local v10 = 1 - footerBinding:getValue()
			v7(color3:Lerp(color3_2, v10))
			v9(transparency + (transparency2 - transparency) * v10)

			return __subscribeToBinding
		else
			local v10 = 1 - (props.isVisible and 1 or 0)
			v7(color3:Lerp(color3_2, v10))
			v9(transparency + (transparency2 - transparency) * v10)

			return nil
		end
	end, { props.isVisible, color3, transparency, color3_2, transparency2 })

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		BorderSizePixel = 0,
		BackgroundColor3 = v6,
		BackgroundTransparency = v8,
		Active = true,
		ZIndex = 0
	})
end

return React.memo(BottomBarInsetBackground)
