local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Style").useDesignTokens
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/ReactOtter")
local defineFastFlag = game:DefineFastFlag("RemovePeekViewScrimBorder", false)

return (React.forwardRef(function(props, p2)
	local v5 = useDesignTokens()

	local state, setState = React.useState(true)
	local v8, v9 = ReactOtter.useAnimatedBinding(1)
	React.useEffect(function()
		v9(ReactOtter.spring(state and 0.35 or 1))
	end, { state })

	return React.createElement("TextButton", {
		ref = p2,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v8,
		BackgroundColor3 = v5.Color.Common.Scrim.Color3,
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
