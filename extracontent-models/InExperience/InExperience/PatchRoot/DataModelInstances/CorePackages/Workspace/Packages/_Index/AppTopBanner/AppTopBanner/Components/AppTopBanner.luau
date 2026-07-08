local AppTopBanner = script:FindFirstAncestor("AppTopBanner")
local AppTopBannerParent = AppTopBanner.Parent
local Cryo = require(AppTopBannerParent.Cryo)
local Foundation = require(AppTopBannerParent.Foundation)
local React = require(AppTopBannerParent.React)
local useSelector = require(AppTopBannerParent.RoactUtils).Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local AppTopBannerType = require(AppTopBanner.Enums.AppTopBannerType)
local FocusNavigationUtils = require(AppTopBannerParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local t1 = {
	deviceStatusBarHeight = 0,
	contentMaps = {}
}

local function AppTopBanner2(t2: {[any]: any}) -- line: 28
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), React (copy), useSelector (copy), AppTopBannerType (copy), Foundation (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local u15 = Cryo.Dictionary.join(t1, t2)
	local v16 = useTokens()
	local v17, v18 = React.useState(0)
	local v19 = React.useCallback(function(p1) -- line: 38
		if p1.AppTopBanner then
			return p1.AppTopBanner.expanded
		end

		return false
	end, {})
	local v20 = useSelector(v19)
	local v21 = React.useCallback(function(p2) -- line: 42
		return p2.AppTopBanner and p2.AppTopBanner.appTopBannerContentProps
	end, {})
	local v22 = useSelector(v21)
	local v23 = React.useCallback(function(p3) -- line: 46
		return p3.AppTopBanner and p3.AppTopBanner.onAppTopBannerClick
	end, {})
	local v24 = useSelector(v23)
	local v25 = React.useCallback(function(p4) -- line: 50
		return p4.AppTopBanner and p4.AppTopBanner.appTopBannerContentHeight
	end, {})
	local v26 = useSelector(v25)
	local v27 = React.useCallback(function(p5) -- line: 54
		if p5.AppTopBanner then
			return p5.AppTopBanner.isDisabled
		end

		return false
	end, {})
	local v28 = useSelector(v27)

	React.useEffect(function() -- line: 61
		-- upvalues: v20 (copy), v28 (copy), v18 (copy), v26 (copy), u15 (ref)
		if v20 and not v28 then
			v18(v26 + u15.deviceStatusBarHeight)

			return
		end

		v18(0)
	end, {
		v26,
		v20,
		u15.deviceStatusBarHeight,
		v28
	})

	local v29 = React.useCallback(function(p6) -- line: 77
		-- upvalues: AppTopBannerType (copy)
		if p6.AppTopBanner then
			return p6.AppTopBanner.appTopBannerType
		end

		return AppTopBannerType.None
	end, {})
	local v30 = useSelector(v29)
	local v31 = u15.contentMaps[v30]
	local v32 = React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 0, v17),
		backgroundStyle = v16.Color.Extended.Green.Green_800,
		onActivated = v24,
		padding = {
			left = UDim.new(0, v16.Padding.XLarge),
			right = UDim.new(0, v16.Padding.XLarge),
			top = UDim.new(0, u15.deviceStatusBarHeight)
		}
	}, {
		content = if not v31 then nil else React.createElement(v31, v22)
	})

	return if not (v17 > 0) or v28 then nil else React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.Auxiliary
	}, v32)
end

return React.memo(AppTopBanner2)
