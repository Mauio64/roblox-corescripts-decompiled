local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(parent.UnifiedLogging)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder

local v = {}

local function useCollectionAnalyticsContext(state, p, p2: number, p3: number, p4, p5: number?, flag: boolean?)
	local ref = React.useRef(nil)

	ref.current = React.useMemo(function()
		return SduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(
			p4,
			state.ancestorAnalyticsData,
			state.analyticsData,
			p,
			p2,
			p3,
			nil,
			p,
			p5
		)
	end, { p4, state, p2, p3, p, p5 })

	return React.useMemo(function()
		local function fn()
			return ref.current
		end

		if state and flag then
			state.getCollectionData = fn
		end

		return Cryo.Dictionary.join(state or v, { getCollectionData = fn })
	end, { ref, state, flag }), ref
end

return useCollectionAnalyticsContext
