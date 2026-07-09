local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local OpenInfoPeekView = require(CorePackages.Workspace.Packages.DiscoveryRouting).OpenInfoPeekView
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Utils = require(Modules.AvatarExperience.Common.Utils)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local getFooterVisibilityFromItemFooters = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Utils.getFooterVisibilityFromItemFooters
local useCatalogCategoryImpressionsInfo = require(Modules.AvatarExperience.Catalog.Hooks.useCatalogCategoryImpressionsInfo)
local SponsoredItems = require(Modules.AvatarExperience.Catalog.Components.Search.SponsoredItems)
local CatalogItemCardContainer = require(Modules.AvatarExperience.Catalog.Components.ItemsList.CatalogItemCardContainer)
local Constants = require(Modules.LuaApp.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local selectSponsoredItems = require(Modules.AvatarExperience.Catalog.Selectors.selectSponsoredItems)

require(Modules.AvatarExperience.Common.Types)

local v23 = game:DefineFastFlag("AXFixSponsoredItemsWidgetRowFooters", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

return (React.forwardRef(function(p1, p2) -- line: 45
	-- upvalues: v23 (copy), getFooterVisibilityFromItemFooters (copy), useTokens (copy), RoactGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useNavigation (copy), Constants (copy), CatalogConstants (copy), selectSponsoredItems (copy), React (copy), Cryo (copy), useLocalization (copy), useDispatch (copy), AvatarScreen (copy), IsVRAppBuild (copy), OpenInfoPeekView (copy), useCatalogCategoryImpressionsInfo (copy), Utils (copy), SponsoredItems (copy), CatalogItemCardContainer (copy)
	local v27 = if not v23 then nil else getFooterVisibilityFromItemFooters(if not p1.widgetConfiguration or not p1.widgetConfiguration.defaultItemGroupTemplate then nil else p1.widgetConfiguration.defaultItemGroupTemplate.itemFooters)
	local v28 = useTokens()
	local v29 = RoactGamepad.useRefCache()
	local v30 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local v31 = useSelector(function(p3) -- line: 56
		-- upvalues: p1 (copy)
		return p3.Search.SearchesInCatalog[p1.searchUuid]
	end, getUseSelectorDeepEquals())
	local v32 = useNavigation()
	local itemsPerRow = p1.itemsPerRow
	local key = v32.state.key
	local v35 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v36 = v31 and v31.keyword
	local Catalog = CatalogConstants.AnalyticsContext.Catalog

	if p1.fromSearch then
		Catalog = CatalogConstants.AnalyticsContext.CatalogSearch
	end

	local v38 = useSelector(selectSponsoredItems, getUseSelectorDeepEquals())
	local v39 = React.useMemo(function() -- line: 76
		-- upvalues: v38 (copy), itemsPerRow (copy), Cryo (copy)
		if v38 and itemsPerRow > 0 then
			return Cryo.List.getRange(v38, 1, itemsPerRow)
		end

		return nil
	end, {
		v38,
		itemsPerRow
	})
	local v40 = useLocalization({
		sponsored = "Feature.GamePage.Label.Sponsored",
		sponsoredDisclosure = "Feature.GamePage.Label.SponsoredDisclosure",
		gotIt = "Feature.Avatar.Action.GotIt"
	})
	local v41 = useDispatch()

	local function v42(s1: string, s2: string) -- line: 91
		-- upvalues: v32 (copy), AvatarScreen (copy), v40 (copy)
		v32.navigate(AvatarScreen.GenericPrompt, {
			titleText = s1,
			bodyText = s2,
			buttonText = v40.gotIt
		})
	end

	local v43 = React.useCallback(function() -- line: 98
		-- upvalues: v41 (copy), v40 (copy), IsVRAppBuild (copy), v42 (copy), v32 (copy), AvatarScreen (copy), OpenInfoPeekView (copy)
		if v41 and v40.sponsoredDisclosure then
			if IsVRAppBuild() and v42 then
				local sponsored = v40.sponsored
				local sponsoredDisclosure = v40.sponsoredDisclosure

				v32.navigate(AvatarScreen.GenericPrompt, {
					titleText = sponsored,
					bodyText = sponsoredDisclosure,
					buttonText = v40.gotIt
				})

				return
			end

			v41(OpenInfoPeekView(v40.sponsored, v40.sponsoredDisclosure))
		end
	end, {
		v41,
		v40.sponsored,
		v40.sponsoredDisclosure
	})
	local v44 = useCatalogCategoryImpressionsInfo(p1.fromSearch)
	local impressionsCategory = v44.impressionsCategory
	local impressionsSubcategory = v44.impressionsSubcategory
	local impressionsTaxonomyId = v44.impressionsTaxonomyId
	local v48 = Utils.getCreatorNameTileFooterEnabled(p1.widgetConfiguration)

	return React.createElement(React.Fragment, nil, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		SponsoredItems = React.createElement(SponsoredItems, {
			LayoutOrder = 1,
			numItemsPerRow = itemsPerRow,
			renderItem = function(p4) -- line: 129
				-- upvalues: React (copy), RoactGamepad (copy), v29 (copy), itemsPerRow (copy), p1 (copy), CatalogItemCardContainer (copy), Catalog (ref), CatalogConstants (copy), v35 (copy), v36 (copy), impressionsCategory (ref), impressionsSubcategory (ref), impressionsTaxonomyId (ref), v48 (copy), v23 (copy), v27 (copy)
				local index = p4.index
				local item = p4.item

				return React.createElement(RoactGamepad.Focusable.Frame, {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = v29[index],
					NextSelectionRight = if not (index < itemsPerRow) then nil else v29[index + 1],
					NextSelectionLeft = if not (index > 1) then nil else v29[index - 1],
					onFocusGained = function() -- line: 139
						-- upvalues: p1 (copy), index (copy)
						if p1.gamepadNavigationFocusPos:getValue().Y ~= p1.rowIndex then
							return
						end

						p1.setGamepadNavigationFocusPos(Vector2.new(index, p1.rowIndex))
					end
				}, {
					CatalogItemCard = React.createElement(CatalogItemCardContainer, {
						isSponsoredItem = true,
						impressionsSchema = "defaultItem",
						impressionsGroup = nil,
						isOrganic = true,
						analyticsContext = Catalog,
						analyticsItemCountPerPage = CatalogConstants.PageFetchLimit,
						index = index,
						itemType = item.type,
						itemId = item.id,
						adTrackingData = item.encryptedAdTrackingData,
						itemDetailsPeekViewRefs = p1.itemDetailsPeekViewRefs,
						resultsListRef = p1.gridRef,
						impressionsTag = v35,
						impressionsSearch = v36,
						impressionsId = item.id,
						impressionsCategory = impressionsCategory,
						impressionsSubcategory = impressionsSubcategory,
						impressionsTaxonomyId = impressionsTaxonomyId,
						creatorNameTileFooterEnabled = v48,
						isCreatorNameVisible = if not v23 then nil else v27.isCreatorNameVisible,
						isTitleVisible = if not v23 then nil else v27.isTitleVisible,
						isPriceVisible = if not v23 then nil else v27.isPriceVisible,
						gridInformation = {
							gridPositionRow = p1.rowIndex,
							gridPositionColumn = index
						}
					})
				})
			end,
			sponsoredGridRef = p2,
			scrollingFrameRef = p1.scrollingFrameRef,
			requestImpressionsSignal = p1.requestImpressionsSignal,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionRight = p1.NextSelectionRight,
			onFocusGained = p1.onFocusGained,
			moveFocusToColumn = not FFlagAXMigrateAXToGlobalAutofocus and function() -- line: 196
				-- upvalues: p1 (copy), v29 (copy), v39 (copy), v30 (copy)
				p1.setGamepadNavigationFocusPos(Vector2.new(p1.gamepadNavigationFocusPos:getValue().X, p1.rowIndex))

				local X = p1.gamepadNavigationFocusPos:getValue().X
				local v58 = if not X then v29[1] else v29[math.min(X, #v39)]

				v30.moveFocusTo(v58)
			end or nil,
			onActivateTooltipCallback = v43
		}),
		ManualPaddingFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v28.Gap.Large)
		})
	})
end))
