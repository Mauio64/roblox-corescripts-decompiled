local appPage = require("@luauforge/deferred/hFl").AppPage
require("@luauforge/deferred/hFm")
local module = require("@luauforge/deferred/hFn")
local module2 = require("@luauforge/deferred/hFo")
local compositionTags = require("@luauforge/deferred/hFp").CompositionTags
local sduiPageEntryPoint = module2.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = module2.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = module2.getSduiClientPageScope
local usePageScopeRef = module2.usePageScopeRef

local module3 = require("@luauforge/deferred/hFq")
local module4 = require("@luauforge/deferred/hFr")
local module5 = require("@luauforge/deferred/hFy")
local module6 = require("@luauforge/deferred/hFz")

local function getFromPropsOrNavigationParams(p2, p3)
	local v5 = p2.navigation and p2.navigation.getParam("extraProps")
	return p2[p3] or v5 and v5[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function SduiLandingPage(props)
	local v5 = props.navigation and props.navigation.getParam("extraProps")
	local pageIdentifier = props.pageIdentifier
		or v5 and v5.pageIdentifier
		or props.navigation and props.navigation.getParam("pageIdentifier")

	local v6 = module4(pageIdentifier)
	local v7 = props.navigation and props.navigation.getParam("extraProps")
	local pageTimer = props.pageTimer
		or v7 and v7.pageTimer
		or props.navigation and props.navigation.getParam("pageTimer")

	usePageScopeRef(v6)
	local v8 = module.useMemo(function()
		local v9 = pageTimer

		if not v9 then
			v9 = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v6, {
				eventName = module5.SurfaceLoadTimeEventName,
				metadata = { page = "mount" }
			})

			v9.start("mount")
		end

		getSduiClientPageScope(v6).set(sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v9)
		return v9
	end, { v6, pageTimer })

	module.useEffect(function()
		if pageIdentifier then
			module3(pageIdentifier, module6:Get(), v8)
		end
	end, { pageIdentifier, v8 })

	local v9 = module.useCallback(function()
		if pageIdentifier then
			local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
				v6,
				{
					eventName = module5.SurfaceLoadTimeEventName,
					metadata = { page = "refresh" }
				}
			)

			loadTimerWithSurfaceLoadTime.start("refresh")
			module3(pageIdentifier, module6:Refresh(), loadTimerWithSurfaceLoadTime, true)
		end
	end, { pageIdentifier, v6 })

	if pageIdentifier == nil or pageIdentifier == "" then
		return nil
	end

	return module.createElement(sduiPageEntryPoint, {
		appPage = appPage.SduiLandingPage,
		configKey = v6,
		pageTimer = v8,
		includeNavigationHeaderBar = true,
		refresh = v9,
		contentTag = compositionTags.ContentRegion.Body
	})
end

return module.memo(SduiLandingPage)
