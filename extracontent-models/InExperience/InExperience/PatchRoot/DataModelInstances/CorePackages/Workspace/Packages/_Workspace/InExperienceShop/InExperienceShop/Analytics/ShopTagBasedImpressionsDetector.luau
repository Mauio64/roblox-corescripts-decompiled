local parent = script:FindFirstAncestor("InExperienceShop").Parent

local CollectionService = game:GetService("CollectionService")
local React = require(parent.React)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants

local ShopScreenSizeImpressionsDetector = require(script.Parent.ShopScreenSizeImpressionsDetector)

local function ShopTagBasedImpressionsDetector(props)
	local ref = React.useRef({})
	local ref2 = React.useRef({})

	local filterImpressionFunc = React.useCallback(function(instance): boolean
		return not ref.current[instance:GetFullName()]
	end, {})

	local onImpressionsDetected = React.useCallback(function(items)
		local v = {}

		for _, item in items do
			local fullName = item:GetFullName()

			if ref.current[fullName] then
				continue
			end

			v[fullName] = item

			if not ref2.current[fullName] then
				ref2.current[fullName] = item.AncestryChanged:Connect(function()
					if not item.Parent then
						ref.current[fullName] = nil

						if ref2.current[fullName] then
							ref2.current[fullName]:Disconnect()
							ref2.current[fullName] = nil
						end
					end
				end)
			end

			ref.current[fullName] = true
		end

		if next(v) and props.extensions then
			for _, visibleInstance in v do
				for _, extension in props.extensions do
					extension({ visibleInstance = visibleInstance })
				end
			end
		end
	end, { props.extensions })

	React.useEffect(function()
		return function()
			for _, connection in ref2.current do
				if connection then
					connection:Disconnect()
				end
			end

			ref2.current = {}
		end
	end, {})

	local collectObjectsFunc = React.useCallback(function()
		return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
	end, {})

	return React.createElement(ShopScreenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		pageFilter = props.pageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		filterImpressionFunc = filterImpressionFunc,
		onImpressionsDetected = onImpressionsDetected,
		collectObjectsFunc = collectObjectsFunc
	})
end

return ShopTagBasedImpressionsDetector
