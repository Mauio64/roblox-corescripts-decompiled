local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useSelector
local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useSetDrawerVisible
local getDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Stores.GetDrawerVisibleStore
local fFlagUseSignalsForAppTopBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagUseSignalsForAppTopBanner

local useSignalState = if fFlagUseSignalsForAppTopBanner then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SignalsReact").useSignalState else nil

local getAppTopBannerStore = if fFlagUseSignalsForAppTopBanner then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/AppTopBanner").GetAppTopBannerStore else nil

local function useDismissFlyoutOnPartyTopBanner()
	local v5 = useSetDrawerVisible()
	local v6

	if fFlagUseSignalsForAppTopBanner then
		v6 = useSignalState(getAppTopBannerStore(false).getExpanded)
	else
		v6 = useSelector(function(p2)
			if p2.AppTopBanner then
				return p2.AppTopBanner.expanded
			end

			return false
		end)
	end

	local ref = React.useRef(v6)

	React.useEffect(function()
		if getDrawerVisibleStore(false).getDrawerVisible() and ref.current and not v6 then
			v5(false)
		end

		ref.current = v6
	end, { v6, v5 })
end

return useDismissFlyoutOnPartyTopBanner
