local module = require("@luauforge/deferred/eeO")

local module2 = require("@luauforge/deferred/egP")
local schoolEntryTooltipContainer = module2.Components.SchoolEntryTooltipContainer
local useCanAccessSchools = module2.Hooks.useCanAccessSchools
local useShowSchoolEntryPoint = module2.Hooks.useShowSchoolEntryPoint

local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization
local useNavigation = require("@luauforge/deferred/eeQ").useNavigation
local useSelector = require("@luauforge/deferred/efh").Hooks.RoactRodux.useSelector
local appPage = require("@luauforge/deferred/eeR").AppPage

local contexts = require("@luauforge/deferred/eeZ").Analytics.Enums.Contexts

local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/efc").FFlagConnectionChannelsTileSize
local module3 = require("@luauforge/deferred/egH")
local fFlagSchoolsEntryRequiresOpenSchool = require("@luauforge/deferred/efc").FFlagSchoolsEntryRequiresOpenSchool

local eventNames = require("@luauforge/deferred/eeX").EventNames

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

	if not (module3 or v5) then
		return nil
	end

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
			isVisible = if module3 then v5 else nil
		}),
		Tooltip = 0
	}

	local v17 = if state ~= nil and not (module3 and not v5) then module.createElement(schoolEntryTooltipContainer, {
		anchorRef = v12,
		dismissTooltipRef = ref,
		occludingOverlayType = v6
	}) else nil
	v14.Tooltip = v17
	return createElement(fragment, nil, v14)
end

return SchoolChannel
