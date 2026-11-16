local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)

local getShopViewportBounds = require(script.Parent.getShopViewportBounds)
local getShopImpressionsViewportBounds = getShopViewportBounds.getShopImpressionsViewportBounds
local ShopImpressionsDetector = require(script.Parent.ShopImpressionsDetector)

local vector2 = Vector2.new(1920, 1080)

local function ShopScreenSizeImpressionsDetector(props)
	local currentCamera = workspace.CurrentCamera
	local v

	if currentCamera then
		v = currentCamera.ViewportSize
	else
		v = vector2
	end

	local state, setState = React.useState(v)

	React.useEffect(function()
		local currentCamera2 = workspace.CurrentCamera

		if currentCamera2 == nil then
			return function() end
		end

		local viewportSizeChangedConnection = currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setState(currentCamera2.ViewportSize)
		end)

		return function()
			viewportSizeChangedConnection:Disconnect()
		end
	end, {})

	local getViewPortBounds = React.useCallback(function()
		local v2

		if props.parentRef then
			v2 = props.parentRef.current
		end

		return getShopImpressionsViewportBounds(state, v2)
	end, { props.parentRef, state })

	return React.createElement(ShopImpressionsDetector, {
		parentRef = props.parentRef,
		onRequestImpressionsSignal = props.onRequestImpressionsSignal,
		getViewPortBounds = getViewPortBounds,
		pageFilter = props.pageFilter,
		collectObjectsFunc = props.collectObjectsFunc,
		filterImpressionFunc = props.filterImpressionFunc,
		onImpressionsDetected = props.onImpressionsDetected,
		scanDebounceSeconds = props.scanDebounceSeconds
	})
end

return ShopScreenSizeImpressionsDetector
