local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)

local function onLayoutChange() end

local function useShopImpressionsDetector(data)
	if not FFlagEnableInExperienceShopUnifiedLogging then
		return {
			gridRef = { current = nil },
			onLayoutChange = onLayoutChange,
			impressionsDetector = nil
		}
	end

	local requestImpressionsSignal = React.useMemo(function()
		return Signal.new()
	end, {})

	local ref = React.useRef(nil)

	React.useEffect(function()
		local externalScrollSignal = data.externalScrollSignal

		if externalScrollSignal == nil then
			return function() end
		end

		local connection = externalScrollSignal:connect(function()
			requestImpressionsSignal:fire()
		end)

		return function()
			connection:disconnect()
		end
	end, { data.externalScrollSignal, requestImpressionsSignal })

	local onLayoutChange2 = React.useCallback(function()
		requestImpressionsSignal:fire()
	end, { requestImpressionsSignal })

	local pageFilter = React.useCallback(function()
		return data.isPageActive
	end, { data.isPageActive })

	return {
		gridRef = ref,
		onLayoutChange = onLayoutChange2,
		impressionsDetector = React.useMemo(function()
			local Analytics = require(InExperienceShop.Analytics)
			local shopTagBasedImpressionsDetector = Analytics.ShopTagBasedImpressionsDetector
			local inExperienceShopUnifiedImpressionsReporter = Analytics.InExperienceShopUnifiedImpressionsReporter

			return React.createElement(shopTagBasedImpressionsDetector, {
				parentRef = ref,
				pageFilter = pageFilter,
				requestImpressionsSignal = requestImpressionsSignal,
				extensions = { inExperienceShopUnifiedImpressionsReporter(data.pageType) }
			})
		end, { data.pageType, pageFilter, requestImpressionsSignal })
	}
end

return useShopImpressionsDetector
