local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Signal = require(InExperienceShopParent.AppCommonLib).Signal
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)

local function v6() -- line: 22
end
local function useShopImpressionsDetector(t1: {[any]: any}) -- line: 24
	-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), v6 (copy), React (copy), Signal (copy), InExperienceShop (copy)
	if not FFlagEnableInExperienceShopUnifiedLogging then
		return {
			impressionsDetector = nil,
			gridRef = {
				current = nil
			},
			onLayoutChange = v6
		}
	end

	local v9 = React.useMemo(function() -- line: 33
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v10 = React.useRef(nil)

	React.useEffect(function() -- line: 39
		-- upvalues: t1 (copy), v9 (copy)
		local externalScrollSignal = t1.externalScrollSignal

		if externalScrollSignal == nil then
			return function() -- line: 42
			end
		end

		local v15 = externalScrollSignal:connect(function() -- line: 45
			-- upvalues: v9 (copy)
			v9:fire()
		end)

		return function() -- line: 49
			-- upvalues: v15 (copy)
			v15:disconnect()
		end
	end, {
		t1.externalScrollSignal,
		v9
	})

	local v11 = React.useCallback(function() -- line: 54
		-- upvalues: v9 (copy)
		v9:fire()
	end, { v9 })
	local v12 = React.useCallback(function() -- line: 58
		-- upvalues: t1 (copy)
		return t1.isPageActive
	end, { t1.isPageActive })
	local v13 = React.useMemo(function() -- line: 62
		-- upvalues: InExperienceShop (copy), React (copy), v10 (copy), v12 (copy), v9 (copy), t1 (copy)
		local Analytics = require(InExperienceShop.Analytics)
		local ShopTagBasedImpressionsDetector = Analytics.ShopTagBasedImpressionsDetector
		local InExperienceShopUnifiedImpressionsReporter = Analytics.InExperienceShopUnifiedImpressionsReporter

		return React.createElement(ShopTagBasedImpressionsDetector, {
			parentRef = v10,
			pageFilter = v12,
			requestImpressionsSignal = v9,
			extensions = { InExperienceShopUnifiedImpressionsReporter(t1.pageType) }
		})
	end, {
		t1.pageType,
		v12,
		v9
	})

	return {
		gridRef = v10,
		onLayoutChange = v11,
		impressionsDetector = v13
	}
end

return useShopImpressionsDetector
