local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)

local VisibilityControl = require(parent.VisibilityControl)
local getScrollAwayEnabled = require(parent.getScrollAwayEnabled)

local useTokens = Foundation.Hooks.useTokens

local function BottomBarInsetBackground(props)
	local v = useTokens()
	local color3 = v.Color.Common.NavigationBar.Color3
	local transparency = v.Color.Common.NavigationBar.Transparency
	local color3_2 = v.Color.Surface.Surface_0.Color3
	local transparency2 = v.Color.Surface.Surface_0.Transparency

	local backgroundColor, v2 = React.useBinding(color3)
	local backgroundTransparency, v3 = React.useBinding(transparency)

	React.useEffect(function()
		local function update(p: number) -- 2 equivalent calls inferred from this helper
			local v4 = 1 - p
			v2(color3:Lerp(color3_2, v4))
			v3(transparency + (transparency2 - transparency) * v4)
		end

		if getScrollAwayEnabled() then
			local footerBinding = VisibilityControl.getFooterBinding()
			local __subscribeToBinding = React.__subscribeToBinding(footerBinding, update)
			update(footerBinding:getValue()) -- inferred equivalent call
			return __subscribeToBinding
		end

		update(props.isVisible and 1 or 0) -- inferred equivalent call
		return nil
	end, { props.isVisible, color3, transparency, color3_2, transparency2 })

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundColor,
		BackgroundTransparency = backgroundTransparency,
		Active = true,
		ZIndex = 0
	})
end

return React.memo(BottomBarInsetBackground)
