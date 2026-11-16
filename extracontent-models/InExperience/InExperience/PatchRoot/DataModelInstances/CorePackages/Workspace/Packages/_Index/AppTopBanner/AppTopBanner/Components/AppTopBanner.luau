local appTopBanner = script:FindFirstAncestor("AppTopBanner")
local parent = appTopBanner.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAppTopBanner = SharedFlags.FFlagUseSignalsForAppTopBanner
local useSignalState

if FFlagUseSignalsForAppTopBanner then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local GetAppTopBannerStore

if FFlagUseSignalsForAppTopBanner then
	GetAppTopBannerStore = require(appTopBanner.Stores.GetAppTopBannerStore)
else
	GetAppTopBannerStore = nil
end

local useTokens = Foundation.Hooks.useTokens

local AppTopBannerType = require(appTopBanner.Enums.AppTopBannerType)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local v = { contentMaps = {}, deviceStatusBarHeight = 0 }

local function AppTopBanner(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useTokens()

	local state, setState = React.useState(0)
	local v3

	if FFlagUseSignalsForAppTopBanner then
		v3 = GetAppTopBannerStore(false)
	end

	local v4, v5, onActivated, v6, v7

	if FFlagUseSignalsForAppTopBanner then
		v4 = useSignalState(v3.getExpanded)
		v5 = useSignalState(v3.getAppTopBannerContentProps)
		onActivated = useSignalState(v3.getOnAppTopBannerClick).callback
		v6 = useSignalState(v3.getAppTopBannerContentHeight)
		v7 = useSignalState(v3.getIsDisabled)
	else
		v4 = useSelector((React.useCallback(function(p2)
			if p2.AppTopBanner then
				return p2.AppTopBanner.expanded
			end

			return false
		end, {})))
		v5 = useSelector((React.useCallback(function(p2)
			return p2.AppTopBanner and p2.AppTopBanner.appTopBannerContentProps
		end, {})))
		onActivated = useSelector((React.useCallback(function(p2)
			return p2.AppTopBanner and p2.AppTopBanner.onAppTopBannerClick
		end, {})))
		v6 = useSelector((React.useCallback(function(p2)
			return p2.AppTopBanner and p2.AppTopBanner.appTopBannerContentHeight
		end, {})))
		v7 = useSelector((React.useCallback(function(p2)
			if p2.AppTopBanner then
				return p2.AppTopBanner.isDisabled
			end

			return false
		end, {})))
	end

	React.useEffect(function()
		if v4 and not v7 then
			setState(v6 + joined.deviceStatusBarHeight)
		else
			setState(0)
		end
	end, { v6, v4, joined.deviceStatusBarHeight, v7 })
	local v8

	if FFlagUseSignalsForAppTopBanner then
		v8 = useSignalState(v3.getAppTopBannerType)
	else
		v8 = useSelector((React.useCallback(function(p2)
			if p2.AppTopBanner then
				return p2.AppTopBanner.appTopBannerType
			end

			return AppTopBannerType.None
		end, {})))
	end

	local contentMap = joined.contentMaps[v8]

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		Size = UDim2.new(1, 0, 0, state),
		backgroundStyle = v2.Color.Extended.Green.Green_800,
		onActivated = onActivated,
		padding = {
			left = UDim.new(0, v2.Padding.XLarge),
			right = UDim.new(0, v2.Padding.XLarge),
			top = UDim.new(0, joined.deviceStatusBarHeight)
		}
	}
	local content

	if contentMap then
		content = React.createElement(contentMap, v5)
	end

	local element = createElement(view, v9, { content = content })
	local v10

	if state > 0 and not v7 then
		return (React.createElement(
			FocusRoot,
			{ surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.Auxiliary },
			element
		))
	end

	return v10
end

return React.memo(AppTopBanner)
