local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local module = require("@luauforge/bundled/fuM")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module.Context.useAvatarEditorStores
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(CorePackages.Packages.Signals)
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local module4 = require("@luauforge/bundled/eeH")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module5 = require("@luauforge/deferred/gSy")
local module6 = require("@luauforge/deferred/fyd")
local module7 = require("@luauforge/bundled/gOc")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module9 = require("@luauforge/deferred/gSz")
local module10 = require("@luauforge/bundled/dTM")

local module11 = require("@luauforge/deferred/gOR")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local module12 = require("@luauforge/deferred/gSA")

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext
local fFlagAXShowExpiredItemsFilterTooltip = AvatarExperienceFlags.FFlagAXShowExpiredItemsFilterTooltip
local module13 = require("@luauforge/bundled/dOc")

local function FilterButton(props)
	local v5 = useNavigation()
	local v6 = useAvatarRoute()

	local v7 = module9()

	local v8 = useDispatch()

	local v9 = module4(avatarExperienceAnalyticsService)

	local ref = React.useRef(nil)
	local buttonRef = props.buttonRef or ref

	local v10 = if module11() then useSlotBasedEditorContext() else nil

	local ref2 = if fFlagAXShowExpiredItemsFilterTooltip then React.useRef(nil) else nil

	local function toggleFilters()
		if v6.current.name == avatarScreen.SortAndFilters then
			v7:fire()
		else
			module10.closeTryOnManager(v5)

			local navigate = v5.navigate
			local sortAndFilters = avatarScreen.SortAndFilters
			local v11 = {
				navigation = v5,
				catalogSort = "",
				isPortrait = true,
				onAcceptCallback = function() end,
				slotBasedEditorContext = 0
			}
			local v12 = if module11() then v10 else nil
			v11.slotBasedEditorContext = v12
			navigate(sortAndFilters, v11)
		end

		if fFlagAXShowExpiredItemsFilterTooltip and ref2.current then
			ref2.current()
		end

		v8(module5(v9, v5.state.routeName))
	end

	local v11

	if module11() then
		v11 = useSelector(module7, getUseSelectorDeepEquals())
		local v12

		if fFlagAXAvatarEditorStoresContext then
			v12 = useSignalState(useAvatarEditorStores().sortAndFiltersStore.getFiltersCount)
		else
			local v13 = React.useMemo(function()
				return Signals.createSignal(0)
			end, {})

			if v10 then
				v13 = v10.sortAndFiltersStore.getFiltersCount
			end

			v12 = useSignalState(v13)
		end

		if v10 then
			v11 = v12
		end
	else
		v11 = useSelector(module7, getUseSelectorDeepEquals())
	end

	local v12 = if v10 then unifiedLoggingSurface.CUSTOMIZE else unifiedLoggingSurface.CATALOG

	React.useEffect(function()
		addUnifiedEventLogging(
			buttonRef,
			{
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = "OPEN_FILTER",
				surface = v12
			},
			{ sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME }
		)
	end, { buttonRef })

	local createElement = React.createElement
	local v14 = {
		anchorPoint = props.anchorPoint or Vector2.new(0, 0.5),
		position = props.position or UDim2.fromScale(0, 0.5),
		size = UDim2.fromOffset(24, 24),
		iconSize = iconSize.Medium,
		icon = 0,
		onActivated = 0,
		buttonRef = 0,
		layoutOrder = 0,
		NextSelectionLeft = 0,
		NextSelectionRight = 0,
		NextSelectionUp = 0,
		NextSelectionDown = 0
	}
	local v15 = if module13() then images["icons/actions/adjust"] else images["icons/actions/filter"]
	v14.icon = v15

	v14.onActivated = toggleFilters
	v14.buttonRef = buttonRef
	v14.layoutOrder = props.layoutOrder
	v14.NextSelectionLeft = props.NextSelectionLeft
	v14.NextSelectionRight = props.NextSelectionRight
	v14.NextSelectionUp = props.NextSelectionUp
	v14.NextSelectionDown = props.NextSelectionDown
	local v16 = {
		NotificationBadge = React.createElement(module6, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0.5, 0, 0.5, 4),
			badgeCount = v11
		}),
		FilterTooltip = 0
	}

	local v17 = if fFlagAXShowExpiredItemsFilterTooltip and v10 then React.createElement(module12, {
		dismissTooltipRef = ref2
	}) else nil
	v16.FilterTooltip = v17
	return createElement(iconButton, v14, v16)
end

return FilterButton
