local parent = script:FindFirstAncestor("PeekView").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local ReactOtter = require(parent.ReactOtter)
local defineFastFlag = game:DefineFastFlag("RemovePeekViewScrimBorder", false)

return (React.forwardRef(function(props, ref)
	local v = useDesignTokens()

	local state, setState = React.useState(true)
	local backgroundTransparency, v2 = ReactOtter.useAnimatedBinding(1)
	React.useEffect(function()
		v2(ReactOtter.spring(state and 0.35 or 1))
	end, { state })

	return React.createElement("TextButton", {
		ref = ref,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = v.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = function()
			if props.onActivated then
				props.onActivated()
			end

			setState(not state)
		end,
		[React.Change.AbsoluteSize] = props.onSizeChanged,
		BorderSizePixel = defineFastFlag and 0 or nil
	}, props.children)
end))
