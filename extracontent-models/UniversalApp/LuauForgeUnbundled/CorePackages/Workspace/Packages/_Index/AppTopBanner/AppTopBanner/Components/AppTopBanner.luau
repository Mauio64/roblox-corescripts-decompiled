local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/RoactUtils").Hooks.RoactRodux.useSelector
local fFlagUseSignalsForAppTopBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/SharedFlags").FFlagUseSignalsForAppTopBanner

local useSignalState = if fFlagUseSignalsForAppTopBanner then require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/SignalsReact").useSignalState else nil

local v5 = if fFlagUseSignalsForAppTopBanner then require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Stores/GetAppTopBannerStore") else nil

local useTokens = Foundation.Hooks.useTokens

local AppTopBannerType = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Enums/AppTopBannerType")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local v6 = { contentMaps = {}, deviceStatusBarHeight = 0 }

local function AppTopBanner(p2)
	local joined = Cryo.Dictionary.join(v6, p2)

	local v7 = useTokens()

	local state, setState = React.useState(0)

	local v8 = if fFlagUseSignalsForAppTopBanner then v5(false) else nil
	local v9, v10, v11, v12, v13

	if fFlagUseSignalsForAppTopBanner then
		v9 = useSignalState(v8.getExpanded)
		v10 = useSignalState(v8.getAppTopBannerContentProps)
		v11 = useSignalState(v8.getOnAppTopBannerClick).callback
		v12 = useSignalState(v8.getAppTopBannerContentHeight)
		v13 = useSignalState(v8.getIsDisabled)
	else
		v9 = useSelector((React.useCallback(function(p3)
			if p3.AppTopBanner then
				return p3.AppTopBanner.expanded
			end

			return false
		end, {})))
		v10 = useSelector((React.useCallback(function(p3)
			return p3.AppTopBanner and p3.AppTopBanner.appTopBannerContentProps
		end, {})))
		v11 = useSelector((React.useCallback(function(p3)
			return p3.AppTopBanner and p3.AppTopBanner.onAppTopBannerClick
		end, {})))
		v12 = useSelector((React.useCallback(function(p3)
			return p3.AppTopBanner and p3.AppTopBanner.appTopBannerContentHeight
		end, {})))
		v13 = useSelector((React.useCallback(function(p3)
			if p3.AppTopBanner then
				return p3.AppTopBanner.isDisabled
			end

			return false
		end, {})))
	end

	React.useEffect(function()
		if v9 and not v13 then
			setState(v12 + joined.deviceStatusBarHeight)
		else
			setState(0)
		end
	end, { v12, v9, joined.deviceStatusBarHeight, v13 })
	local v14

	if fFlagUseSignalsForAppTopBanner then
		v14 = useSignalState(v8.getAppTopBannerType)
	else
		v14 = useSelector((React.useCallback(function(p3)
			if p3.AppTopBanner then
				return p3.AppTopBanner.appTopBannerType
			end

			return AppTopBannerType.None
		end, {})))
	end

	local contentMap = joined.contentMaps[v14]

	local createElement = React.createElement
	local view = Foundation.View
	local v15 = {
		Size = UDim2.new(1, 0, 0, state),
		backgroundStyle = v7.Color.Extended.Green.Green_800,
		onActivated = v11,
		padding = {
			left = UDim.new(0, v7.Padding.XLarge),
			right = UDim.new(0, v7.Padding.XLarge),
			top = UDim.new(0, joined.deviceStatusBarHeight)
		}
	}

	local v17 = if contentMap then React.createElement(contentMap, v10) else nil
	local element = createElement(view, v15, { content = v17 })

	return if state > 0 and not v13 then React.createElement(
		focusRoot,
		{ surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.Auxiliary },
		element
	) else nil
end

return React.memo(AppTopBanner)
