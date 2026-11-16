local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UnifiedLogging")

local sduiCollectionAnalyticsBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").SduiCollectionAnalyticsBuilder

local v5 = {}

local function useCollectionAnalyticsContext(state, p2, p3, p4, p5, p6, p7)
	local ref = React.useRef(nil)

	ref.current = React.useMemo(function()
		return sduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(
			p5,
			state.ancestorAnalyticsData,
			state.analyticsData,
			p2,
			p3,
			p4,
			nil,
			p2,
			p6
		)
	end, { p5, state, p3, p4, p2, p6 })

	return React.useMemo(function()
		local function fn()
			return ref.current
		end

		if state and p7 then
			state.getCollectionData = fn
		end

		return Cryo.Dictionary.join(state or v5, { getCollectionData = fn })
	end, { ref, state, p7 }), ref
end

return useCollectionAnalyticsContext
