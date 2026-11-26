local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/ekj")
local schoolEntryTooltipContainer = module2.Components.SchoolEntryTooltipContainer
local useCanAccessSchools = module2.Hooks.useCanAccessSchools
local useShowSchoolEntryPoint = module2.Hooks.useShowSchoolEntryPoint

local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization
local useNavigation = require("@luauforge/deferred/ein").useNavigation
local useSelector = require("@luauforge/deferred/eiP").Hooks.RoactRodux.useSelector
local appPage = require("@luauforge/deferred/eio").AppPage

local contexts = require("@luauforge/deferred/eiw").Analytics.Enums.Contexts

local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/eiz").FFlagConnectionChannelsTileSize
local fFlagSchoolsEntryRequiresOpenSchool = require("@luauforge/deferred/eiz").FFlagSchoolsEntryRequiresOpenSchool

local eventNames = require("@luauforge/deferred/eiu").EventNames

local function SchoolChannel(props)
	local component = props.component
	local componentUIProps = props.componentUIProps
	local fireAnalyticsEvent = props.fireAnalyticsEvent
	local v5

	if fFlagSchoolsEntryRequiresOpenSchool then
		v5 = useShowSchoolEntryPoint()
	else
		v5 = useCanAccessSchools()
	end

	local v6 = useSelector(function(p2)
		local centralOverlay = p2.CentralOverlay

		if centralOverlay then
			return centralOverlay.OverlayType
		end

		return nil
	end)

	local state, setState = module.useState(nil)
	local ref = module.useRef(nil)

	local v7 = module.useCallback(function(p2)
		setState(p2)
	end, {})

	local v8 = useNavigation()

	local v9 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.SchoolBtnClick)
		local current = ref.current

		if current then
			current()
		end

		v8.navigate(appPage.Schools, {
			extraProps = { source = contexts.AddFriends }
		})
	end, { fireAnalyticsEvent, v8 })

	local v10 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.SchoolBtnImpression)
	end, { fireAnalyticsEvent })

	local v11 = useLocalization({ schoolTitle = "Feature.AddFriends.Label.SchoolTile" })

	local v12 = module.useMemo(function()
		return { current = state }
	end, { state })

	local createElement = module.createElement
	local fragment = module.Fragment
	local v14 = {
		Tile = module.createElement(component, {
			icon = fFlagConnectionChannelsTileSize and "person-graduate" or "icons/menu/education",
			title = v11.schoolTitle,
			onActivated = v9,
			onMounted = v10,
			ref = v7,
			componentUIProps = componentUIProps,
			isVisible = v5
		}),
		Tooltip = 0
	}

	local v15 = if state ~= nil and not not v5 then module.createElement(schoolEntryTooltipContainer, {
		anchorRef = v12,
		dismissTooltipRef = ref,
		occludingOverlayType = v6
	}) else nil
	v14.Tooltip = v15
	return createElement(fragment, nil, v14)
end

return SchoolChannel
