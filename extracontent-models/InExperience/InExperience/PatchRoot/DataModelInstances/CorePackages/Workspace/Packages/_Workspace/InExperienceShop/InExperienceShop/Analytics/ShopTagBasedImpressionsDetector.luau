local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local CollectionService = game:GetService("CollectionService")
local React = require(Parent.React)
local UnifiedEventLogConstants = require(Parent.AvatarExperienceAnalytics).UnifiedEventLogConstants
local ShopScreenSizeImpressionsDetector = require(script.Parent.ShopScreenSizeImpressionsDetector)

local function ShopTagBasedImpressionsDetector(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), ShopScreenSizeImpressionsDetector (copy)
	local v8 = React.useRef({})
	local v9 = React.useRef({})
	local v10 = React.useCallback(function(p1) -- line: 25
		-- upvalues: v8 (copy)
		return not v8.current[p1:GetFullName()]
	end, {})
	local v11 = React.useCallback(function(t2: {[any]: any}) -- line: 29
		-- upvalues: v8 (copy), v9 (copy), t1 (copy)
		local t3 = {}

		for _, v17 in t2 do
			local FullName = v17:GetFullName()

			if not v8.current[FullName] then
				t3[FullName] = v17

				if not v9.current[FullName] then
					v9.current[FullName] = v17.AncestryChanged:Connect(function() -- line: 39
						-- upvalues: v17 (copy), v8 (copy), FullName (copy), v9 (copy)
						if not v17.Parent then
							v8.current[FullName] = nil

							if v9.current[FullName] then
								v9.current[FullName]:Disconnect()
								v9.current[FullName] = nil
							end
						end
					end)
				end

				v8.current[FullName] = true
			end
		end

		if next(t3) and t1.extensions then
			for _, v20 in t3 do
				for _, v22 in t1.extensions do
					v22({
						visibleInstance = v20
					})
				end
			end
		end
	end, { t1.extensions })

	React.useEffect(function() -- line: 63
		-- upvalues: v9 (copy)
		return function() -- line: 64
			-- upvalues: v9 (copy)
			for _, v24 in v9.current do
				if v24 then
					v24:Disconnect()
				end
			end

			v9.current = {}
		end
	end, {})

	local v12 = React.useCallback(function() -- line: 74
		-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy)
		return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
	end, {})

	return React.createElement(ShopScreenSizeImpressionsDetector, {
		parentRef = t1.parentRef,
		pageFilter = t1.pageFilter,
		onRequestImpressionsSignal = t1.requestImpressionsSignal,
		filterImpressionFunc = v10,
		onImpressionsDetected = v11,
		collectObjectsFunc = v12
	})
end

return ShopTagBasedImpressionsDetector
