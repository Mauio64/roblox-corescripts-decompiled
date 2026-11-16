local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local StateLayerMode = require(Foundation.Enums.StateLayerMode)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function Dot(props, ref)
	local v = useTokens()
	local contrast = v.Color.System.Contrast
	local transparency = props.isActive and (contrast.Transparency or 0) or 0.78
	local udim = UDim.new(0, v.Radius.Circle)

	local scale, v2 = ReactOtter.useAnimatedBinding(props.scale)
	local v3, v4 = ReactOtter.useAnimatedBinding(transparency)

	React.useEffect(function()
		v2(ReactOtter.ease(props.scale, props.scaleEaseConfig))
	end, { props.scale, props.scaleEaseConfig })

	local selection = React.useMemo(function()
		return {
			Selectable = props.Selectable,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight
		}
	end, {
		props.Selectable,
		props.NextSelectionUp,
		props.NextSelectionDown,
		props.NextSelectionLeft,
		props.NextSelectionRight
	})

	local onActivated = React.useCallback(function()
		if props.onActivated ~= nil and not props.isActive then
			props.onActivated(props.page)
		end
	end, { props.isActive, props.onActivated, props.page })

	local stateLayer = React.useMemo(function()
		local mode

		if props.isActive then
			mode = StateLayerMode.Inverse
		else
			mode = StateLayerMode.Default
		end

		return { mode = mode }
	end, { props.isActive })

	React.useEffect(function()
		v4(ReactOtter.ease(transparency, props.colorEaseConfig))
	end, { transparency, props.colorEaseConfig })

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromOffset(props.maxSize, props.maxSize),
		backgroundStyle = v3:map(function(transparency2)
			return { Color3 = contrast.Color3, Transparency = transparency2 }
		end),
		cornerRadius = udim,
		onActivated = 0,
		selection = 0,
		stateLayer = 0,
		ref = 0,
		testId = 0,
		scale = 0
	}

	if not props.onActivated then
		onActivated = nil
	end

	v5.onActivated = onActivated
	v5.selection = selection
	v5.stateLayer = stateLayer
	v5.ref = ref
	v5.testId = props.testId
	v5.scale = scale
	return createElement(View, v5)
end

return React.memo(React.forwardRef(Dot))
