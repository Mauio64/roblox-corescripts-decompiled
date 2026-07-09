local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

require(CorePackages.Workspace.Packages.DiscoveryTypes)

local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy

require(CorePackages.Workspace.Packages.ServerDrivenUi)

local OmniFeedImpressionsDetector = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedImpressionsDetector
local OmniFeedItemsContainer = require(script.Parent.OmniFeedItemsContainer)
local t1 = {}

return function(t2: {[any]: any}) -- line: 37
	-- upvalues: useAppPolicy (copy), useUiModeInfo (copy), UiMode (copy), React (copy), Signal (copy), useDesignTokens (copy), useSelector (copy), t1 (copy), OmniFeedItemsContainer (copy), OmniFeedImpressionsDetector (copy)
	local v13 = useAppPolicy(function(p1) -- line: 38
		return p1.useGridPageLayout()
	end)
	local v14 = useUiModeInfo().uiMode == UiMode.TenFoot
	local u15 = v13 and not v14
	local v16 = React.useRef(Signal.new())
	local v17 = useDesignTokens()
	local BackgroundColor = v17.LuaApps.App.Page.BackgroundColor
	local PageBackgroundTransparency = v17.LuaApps.App.Page.BackgroundTransparency
	local v20 = React.useMemo(function() -- line: 53
		-- upvalues: v17 (copy), u15 (ref)
		return v17.LuaApps.HomeOmniFeed.getLayoutSpacing(u15)
	end, {
		u15,
		v17
	})
	local v21 = t2.topPadding or v20.topMargin
	local v22 = t2.bottomPadding or 80
	local v23 = useSelector(function(p2) -- line: 61
		-- upvalues: t2 (copy)
		return p2.OmniRecommendations[t2.pageContext]
	end)
	local v24 = v23 and v23.sorts or t1

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = BackgroundColor,
		BackgroundTransparency = PageBackgroundTransparency,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		OmniFeed = React.createElement(OmniFeedItemsContainer, {
			omniFeedItems = t2.omniFeedItems,
			pageContext = t2.pageContext,
			sduiContext = t2.sduiContext,
			impressionsTag = t2.impressionsTag,
			topMargin = v21,
			bottomMargin = v22,
			layoutPadding = v20.layoutPadding,
			onItemsUpdatedSignalRef = v16,
			defaultContainerSize = t2.defaultContainerSize,
			sortsData = v24,
			omniFeedPageSection = t2.omniFeedPageSection,
			enableRelativeGui = t2.enableRelativeGui,
			appCompositionEnabled = t2.appCompositionEnabled,
			contentTag = t2.contentTag
		}),
		OmniFeedImpressionsDetector = React.createElement(OmniFeedImpressionsDetector, {
			onItemsUpdatedSignal = v16.current,
			impressionsTag = t2.impressionsTag,
			omniFeedItems = t2.omniFeedItems,
			eventContext = t2.analyticsContext
		})
	})
end
