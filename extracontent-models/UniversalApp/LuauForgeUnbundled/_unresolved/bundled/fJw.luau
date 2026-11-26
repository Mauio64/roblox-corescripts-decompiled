require("@luauforge/bundled/fJx")
local module = require("@luauforge/bundled/fJy")
local appPage = require("@luauforge/bundled/fJz").AppPage
local module2 = require("@luauforge/bundled/fJA")
local compositionTags = require("@luauforge/bundled/fJB").CompositionTags

local sduiPageEntryPoint = module2.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = module2.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = module2.getSduiClientPageScope
local module3 = require("@luauforge/bundled/fJC")
local module4 = require("@luauforge/bundled/fJH")
local module5 = require("@luauforge/bundled/fJG")
local module6 = require("@luauforge/bundled/fJM")

local fFlagAppIaHomeShowCampaignTab = require("@luauforge/bundled/fJv").FFlagAppIaHomeShowCampaignTab

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function createPageTimer(p2, p3)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(p2, {
		eventName = module5.SurfaceLoadTimeEventName,
		metadata = { page = p3 }
	})

	loadTimerWithSurfaceLoadTime.start(p3)
	return loadTimerWithSurfaceLoadTime
end

local function CampaignContentEntryPoint(props)
	local screenSize = props.screenSize
	local v5 = module4(screenSize)
	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	local v6 = module.useMemo(function()
		return getSduiClientPageScope(v5)
	end, { v5 })
	local v7 = module.useMemo(function()
		local v8 = pageTimer or createPageTimer(v5, "mount")
		v6.set(sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v8)
		return v8
	end, { v5, v6, pageTimer })

	module.useEffect(function()
		module3(v7, screenSize)
	end, { screenSize, v7 })

	local v8 = module.useCallback(function()
		return (module3(createPageTimer(v5, "refresh"), screenSize, true))
	end, { v5, screenSize })

	if fFlagAppIaHomeShowCampaignTab then
		module6(v8)
	end

	return module.createElement(sduiPageEntryPoint, {
		appPage = appPage.Campaign,
		configKey = v5,
		pageTimer = v7,
		refresh = v8,
		includeNavigationHeaderBar = false,
		contentTag = compositionTags.ContentRegion.Body,
		stickyContentTag = compositionTags.ContentRegion.Header,
		scrollPerformanceIntervalName = module5.ScrollPerformanceIntervalName,
		pageTopPadding = props.pageTopPadding,
		feedTopMargin = props.feedTopMargin,
		scrollAway = props.scrollAway
	})
end

return module.memo(CampaignContentEntryPoint)
