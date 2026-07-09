local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local useAvatarEditorStores = AvatarExperienceSlotBasedEditor.Context.useAvatarEditorStores
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Signals = require(CorePackages.Packages.Signals)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local NumericalBadge = require(Modules.LuaApp.Components.NumericalBadge)
local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useCloseFiltersSignal = require(Modules.AvatarExperience.Catalog.Hooks.useCloseFiltersSignal)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local ExpiredFilterTooltip = require(Modules.AvatarExperience.Catalog.Components.Filters.ExpiredFilterTooltip)
local FFlagAXAvatarEditorStoresContext = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext
local FFlagAXShowExpiredItemsFilterTooltip = AvatarExperienceFlags.FFlagAXShowExpiredItemsFilterTooltip
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v38 = game:DefineFastFlag("AXUnifiedLoggingFilterOpen", false)

local function FilterButton(t1: {[any]: any}) -- line: 62
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useCloseFiltersSignal (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), v38 (copy), React (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), useSlotBasedEditorContext (copy), FFlagAXShowExpiredItemsFilterTooltip (copy), AvatarScreen (copy), NavigationUtils (copy), Exit3DFullView (copy), useSelector (copy), selectFilterCount (copy), getUseSelectorDeepEquals (copy), FFlagAXAvatarEditorStoresContext (copy), useAvatarEditorStores (copy), useSignalState (copy), Signals (copy), UnifiedLoggingSurface (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedEventLogConstants (copy), IconButton (copy), IconSize (copy), GetFFlagAXEnableSlotBasedEditor (copy), Images (copy), NumericalBadge (copy), ExpiredFilterTooltip (copy)
	local v41 = useNavigation()
	local v42 = useAvatarRoute()
	local v43 = useCloseFiltersSignal()
	local v44 = useDispatch()
	local v45 = useRoactService(Analytics)
	local v46 = if not v38 then nil else React.useRef(nil)
	local v47 = if not v38 then nil else t1.buttonRef or v46
	local v48 = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else useSlotBasedEditorContext()
	local v49 = if not FFlagAXShowExpiredItemsFilterTooltip then nil else React.useRef(nil)

	local function toggleFilters() -- line: 82
		-- upvalues: v42 (copy), AvatarScreen (copy), v43 (copy), NavigationUtils (copy), v41 (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), v48 (copy), FFlagAXShowExpiredItemsFilterTooltip (copy), v49 (copy), v44 (copy), Exit3DFullView (copy), v45 (copy)
		if v42.current.name == AvatarScreen.SortAndFilters then
			v43:fire()
		else
			NavigationUtils.closeTryOnManager(v41)
			v41.navigate(AvatarScreen.SortAndFilters, {
				catalogSort = "",
				isPortrait = true,
				navigation = v41,
				onAcceptCallback = function() -- line: 92
				end,
				slotBasedEditorContext = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else v48
			})
		end

		if FFlagAXShowExpiredItemsFilterTooltip and v49.current then
			v49.current()
		end

		v44(Exit3DFullView(v45, v41.state.routeName))
	end

	local v55

	if GetFFlagAXEnableInventorySortsAndFilters() then
		local v51 = useSelector(selectFilterCount, getUseSelectorDeepEquals())
		local v53

		if FFlagAXAvatarEditorStoresContext then
			local v52 = useAvatarEditorStores()

			v53 = useSignalState(v52.sortAndFiltersStore.getFiltersCount)
		else
			local v54 = React.useMemo(function() -- line: 116
				-- upvalues: Signals (copy)
				return Signals.createSignal(0)
			end, {})

			v53 = useSignalState(if not v48 then v54 else v48.sortAndFiltersStore.getFiltersCount)
		end

		v55 = if not v48 then v51 else v53
	else
		v55 = useSelector(selectFilterCount, getUseSelectorDeepEquals())
	end

	if v38 then
		local v56 = if not v48 then UnifiedLoggingSurface.CATALOG else UnifiedLoggingSurface.CUSTOMIZE

		React.useEffect(function() -- line: 136
			-- upvalues: addUnifiedEventLogging (copy), v47 (copy), UnifiedEventLogEnums (copy), v56 (copy), UnifiedEventLogConstants (copy)
			addUnifiedEventLogging(v47, {
				elementName = "OPEN_FILTER",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = v56
			}, {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end, { v47 })
	end

	return React.createElement(IconButton, {
		anchorPoint = t1.anchorPoint or Vector2.new(0, 0.5),
		position = t1.position or UDim2.fromScale(0, 0.5),
		size = UDim2.fromOffset(24, 24),
		iconSize = IconSize.Medium,
		icon = if not GetFFlagAXEnableSlotBasedEditor() then Images["icons/actions/filter"] else Images["icons/actions/adjust"],
		onActivated = toggleFilters,
		buttonRef = if not v38 then t1.buttonRef else v47,
		layoutOrder = t1.layoutOrder,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown
	}, {
		NotificationBadge = React.createElement(NumericalBadge, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0.5, 0, 0.5, 4),
			badgeCount = v55
		}),
		FilterTooltip = if not FFlagAXShowExpiredItemsFilterTooltip or not v48 then nil else React.createElement(ExpiredFilterTooltip, {
			dismissTooltipRef = v49
		})
	})
end

return FilterButton
