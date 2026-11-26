local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require("@luauforge/deferred/hfO")

local module = require("@luauforge/deferred/hbr")
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local defineFastFlag = game:DefineFastFlag("AXFixOrganicTTILogging", false)

local function useTileLatencyTracker(p2, list, p3)
	local v5 = module(p2)
	local v6 = usePrevious(list)
	local state, setState = React.useState(v5.currentCategory)
	local state2, setState2 = React.useState(v5.currentSubcategory)

	React.useEffect(function()
		if p3 and v5 then
			v5.fireTileLoadingLatencyTracker(v5, nil, true)
		end
	end, { p3 })

	React.useEffect(function()
		if not list or #list == 0 then
			return
		end

		if
			v5.trackerStartTime ~= nil
			and #list > 0
			and v6 ~= list
			and (state ~= v5.currentCategory or state2 ~= v5.currentSubcategory or defineFastFlag and (not v6 or #v6 == 0))
		then
			v5.fireTileLoadingLatencyTracker(v5)
		end

		setState(v5.currentCategory)
		setState2(v5.currentSubcategory)
	end, {
		v5.currentPageName,
		p2,
		v5.trackerStartTime,
		v5.currentCategory,
		v5.currentSubcategory,
		list,
		state
	})
end

return useTileLatencyTracker
