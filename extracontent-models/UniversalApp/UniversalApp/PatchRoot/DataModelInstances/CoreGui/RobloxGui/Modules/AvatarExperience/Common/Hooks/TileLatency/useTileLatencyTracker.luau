local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)

require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local useTileLoadingLatencyInitializer = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileLoadingLatencyInitializer)
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local v6 = game:DefineFastFlag("AXFixOrganicTTILogging", false)

local function useTileLatencyTracker(s1: string, t1: {[any]: any}?, b1: boolean?) -- line: 16
	-- upvalues: useTileLoadingLatencyInitializer (copy), usePrevious (copy), React (copy), v6 (copy)
	local v11 = useTileLoadingLatencyInitializer(s1)
	local v12 = usePrevious(t1)
	local v13, v14 = React.useState(v11.currentCategory)
	local v15, v16 = React.useState(v11.currentSubcategory)

	React.useEffect(function() -- line: 26
		-- upvalues: b1 (copy), v11 (copy)
		if not b1 or not v11 then
			return
		end

		v11.fireTileLoadingLatencyTracker(v11, nil, true)
	end, { b1 })
	React.useEffect(function() -- line: 34
		-- upvalues: t1 (copy), v11 (copy), v12 (copy), v13 (copy), v15 (copy), v6 (copy), v14 (copy), v16 (copy)
		if not t1 or #t1 == 0 then
			return
		end

		if v11.trackerStartTime ~= nil and #t1 > 0 and v12 ~= t1 and (v13 ~= v11.currentCategory or v15 ~= v11.currentSubcategory or v6 and (not v12 or #v12 == 0)) then
			v11.fireTileLoadingLatencyTracker(v11)
		end

		v14(v11.currentCategory)
		v16(v11.currentSubcategory)
	end, {
		v11.currentPageName,
		s1,
		v11.trackerStartTime,
		v11.currentCategory,
		v11.currentSubcategory,
		t1,
		v13
	})
end

return useTileLatencyTracker
