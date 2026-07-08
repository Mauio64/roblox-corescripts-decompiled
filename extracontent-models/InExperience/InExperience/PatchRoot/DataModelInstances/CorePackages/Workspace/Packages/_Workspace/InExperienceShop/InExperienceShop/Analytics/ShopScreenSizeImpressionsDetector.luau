local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local getShopImpressionsViewportBounds = require(script.Parent.getShopViewportBounds).getShopImpressionsViewportBounds
local ShopImpressionsDetector = require(script.Parent.ShopImpressionsDetector)
local vector2 = Vector2.new(1920, 1080)

local function ShopScreenSizeImpressionsDetector(t1: {[any]: any}) -- line: 22
	-- upvalues: vector2 (copy), React (copy), getShopImpressionsViewportBounds (copy), ShopImpressionsDetector (copy)
	local CurrentCamera = workspace.CurrentCamera
	local v9 = if not CurrentCamera then vector2 else CurrentCamera.ViewportSize
	local v10, v11 = React.useState(v9)

	React.useEffect(function() -- line: 27
		-- upvalues: v11 (copy)
		local CurrentCamera2 = workspace.CurrentCamera

		if CurrentCamera2 == nil then
			return function() -- line: 30
			end
		end

		local connection = CurrentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 33
			-- upvalues: v11 (copy), CurrentCamera2 (copy)
			v11(CurrentCamera2.ViewportSize)
		end)

		return function() -- line: 37
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v12 = React.useCallback(function() -- line: 42
		-- upvalues: t1 (copy), getShopImpressionsViewportBounds (copy), v10 (copy)
		local v15 = if not t1.parentRef then nil else t1.parentRef.current

		return getShopImpressionsViewportBounds(v10, v15)
	end, {
		t1.parentRef,
		v10
	})

	return React.createElement(ShopImpressionsDetector, {
		parentRef = t1.parentRef,
		onRequestImpressionsSignal = t1.onRequestImpressionsSignal,
		getViewPortBounds = v12,
		pageFilter = t1.pageFilter,
		collectObjectsFunc = t1.collectObjectsFunc,
		filterImpressionFunc = t1.filterImpressionFunc,
		onImpressionsDetected = t1.onImpressionsDetected,
		scanDebounceSeconds = t1.scanDebounceSeconds
	})
end

return ShopScreenSizeImpressionsDetector
