local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local signal = require("@luauforge/deferred/glW").Signal
local useAppPolicy = require("@luauforge/deferred/glX").useAppPolicy
local useAvatarRoute = require("@luauforge/bundled/dQv").AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceAnalytics")
local tagBasedImpressionsDetector = AvatarExperienceAnalytics.TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = AvatarExperienceAnalytics.useUnifiedEventImpressionsReporter
local useRequestImpressionsOnTagAdded = AvatarExperienceAnalytics.useRequestImpressionsOnTagAdded
local module3 = require("@luauforge/deferred/gle")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceFlags")
local fFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local fFlagAXFavoritesPillExposureLogging = AvatarExperienceFlags.FFlagAXFavoritesPillExposureLogging

local function ItemDetailsSduiBodyLogging(props)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(nil)

	if ref2.current == nil then
		ref2.current = signal.new()
	end

	local current = ref2.current

	local v5 = React.useCallback(function()
		current:fire()
	end, { current })

	useRequestImpressionsOnTagAdded(ref, current)

	local v6 = useAvatarRoute()
	local v7 = useUnifiedEventImpressionsReporter(v6.current.name)

	local v8 = React.useMemo(function()
		return { v7 }
	end, { v7 })

	local navigation = props.navigation
	local v9 = React.useCallback(function(): boolean
		return navigation.state.key == v6.current.key
	end, { navigation, v6 })

	local v10 = useAppPolicy(function(p2)
		return p2.getEnableAggregateLikesFavoritesCount()
	end)

	local v11 = not props.simpleView and v10

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = ref,
		[React.Change.AbsolutePosition] = v5,
		[React.Change.AbsoluteSize] = v5
	}
	local v14 = {
		Body = React.createElement(React.Fragment, nil, props.children),
		UnifiedImpressionsReporter = 0,
		FavoritePillExposure = 0
	}

	local v15 = if fFlagAXItemDetailsIxpExposure then React.createElement(tagBasedImpressionsDetector, {
		parentRef = ref,
		pageFilter = v9,
		requestImpressionsSignal = current,
		extensions = v8
	}) else nil
	v14.UnifiedImpressionsReporter = v15

	local v16 = if fFlagAXFavoritesPillExposureLogging and v11 then React.createElement(module3) else nil
	v14.FavoritePillExposure = v16
	return createElement("Frame", v13, v14)
end

return ItemDetailsSduiBodyLogging
