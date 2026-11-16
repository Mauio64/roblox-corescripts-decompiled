local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Drawer = require(parent.Drawer)
local useSetDrawerVisible = Drawer.Hooks.useSetDrawerVisible
local Drawer2 = require(parent.Drawer)
local GetDrawerVisibleStore = Drawer2.Stores.GetDrawerVisibleStore
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAppTopBanner = SharedFlags.FFlagUseSignalsForAppTopBanner
local useSignalState

if FFlagUseSignalsForAppTopBanner then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local getAppTopBannerStore

if FFlagUseSignalsForAppTopBanner then
	local AppTopBanner = require(parent.AppTopBanner)
	getAppTopBannerStore = AppTopBanner.GetAppTopBannerStore
else
	getAppTopBannerStore = nil
end

local function useDismissFlyoutOnPartyTopBanner()
	local v = useSetDrawerVisible()
	local current

	if FFlagUseSignalsForAppTopBanner then
		current = useSignalState(getAppTopBannerStore(false).getExpanded)
	else
		current = useSelector(function(p)
			if p.AppTopBanner then
				return p.AppTopBanner.expanded
			end

			return false
		end)
	end

	local ref = React.useRef(current)

	React.useEffect(function()
		if GetDrawerVisibleStore(false).getDrawerVisible() and ref.current and not current then
			v(false)
		end

		ref.current = current
	end, { current, v })
end

return useDismissFlyoutOnPartyTopBanner
