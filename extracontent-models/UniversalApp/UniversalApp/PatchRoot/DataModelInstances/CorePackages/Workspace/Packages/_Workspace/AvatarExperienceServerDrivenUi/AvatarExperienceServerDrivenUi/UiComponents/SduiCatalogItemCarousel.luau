local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local React = require(AvatarExperienceServerDrivenUiParent.React)
local useSignalState = require(AvatarExperienceServerDrivenUiParent.SignalsReact).useSignalState
local AvatarExperienceCatalog = require(AvatarExperienceServerDrivenUiParent.AvatarExperienceCatalog)
local CatalogItemCarouselSortContainer = AvatarExperienceCatalog.Components.CatalogItemCarouselSort.CatalogItemCarouselSortContainer
local CATALOG_RESULTS_HORIZONTAL_MARGIN = AvatarExperienceCatalog.Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local CatalogSduiPageContext = AvatarExperienceCatalog.Sdui.CatalogSduiPageContext
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore

require(AvatarExperienceServerDrivenUiParent.AvatarExperienceCommon)
require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
require(AvatarExperienceServerDrivenUi.Utils.wrapZeroArgAction)

local useTrackedRowWidth = require(AvatarExperienceServerDrivenUi.hooks.useTrackedRowWidth)
local useWrapZeroArgActionHandler = require(AvatarExperienceServerDrivenUi.hooks.useWrapZeroArgActionHandler)

require(AvatarExperienceServerDrivenUi.Types.CatalogSortPropTypes)

local CatalogSortConstants = require(AvatarExperienceServerDrivenUi.Constants.CatalogSortConstants)
local SduiWidgetTTITileLatencyContext = require(AvatarExperienceServerDrivenUi.Context.SduiWidgetTTITileLatencyContext)
local FFlagAXSduiWidgetsTTITracking = require(AvatarExperienceServerDrivenUiParent.AvatarExperienceFlags).FFlagAXSduiWidgetsTTITracking

local function SduiCatalogItemCarousel(t1: {[any]: any}) -- line: 92
	-- upvalues: CatalogSortConstants (copy), React (copy), CatalogSduiPageContext (copy), getCatalogPageRequestIdStore (copy), useSignalState (copy), useWrapZeroArgActionHandler (copy), useTrackedRowWidth (copy), CATALOG_RESULTS_HORIZONTAL_MARGIN (copy), FFlagAXSduiWidgetsTTITracking (copy), SduiWidgetTTITileLatencyContext (copy), CatalogItemCarouselSortContainer (copy)
	local id = t1.id
	local type = t1.type
	local content = t1.content
	local numItemsToShow = t1.numItemsToShow
	local previewColumns = t1.previewColumns
	local title = t1.title
	local description = t1.description
	local v24 = t1.itemFooters or CatalogSortConstants.DEFAULT_ITEM_FOOTERS
	local cardStyle = t1.cardStyle
	local tagId = t1.tagId
	local informationPopoverText = t1.informationPopoverText
	local v28 = t1.layoutOrder or (t1.startRow or 1)
	local v29 = previewColumns or CatalogSortConstants.DEFAULT_PREVIEW_COLUMNS
	local v30 = React.useMemo(function() -- line: 112
		-- upvalues: id (copy), type (copy), content (copy), numItemsToShow (copy), title (copy), description (copy), informationPopoverText (copy), v24 (copy), cardStyle (copy), v29 (copy), tagId (copy)
		return {
			id = id,
			type = type,
			content = content or {},
			template = {
				type = "Carousel",
				previewRows = 1,
				numItemsToShow = numItemsToShow,
				localizedTitle = title,
				localizedDescription = description,
				informationPopoverText = informationPopoverText,
				itemFooters = v24,
				cardStyle = cardStyle,
				previewColumns = v29
			},
			tagId = tagId
		}
	end, {
		id,
		type,
		content,
		numItemsToShow,
		title,
		description,
		informationPopoverText,
		v24,
		cardStyle,
		tagId,
		v29
	})
	local v31 = React.useContext(CatalogSduiPageContext)
	local v32 = if not v31 then nil else v31.identifier
	local v33 = getCatalogPageRequestIdStore(false)
	local v34 = useSignalState(v33.getPageRequestIdMap)[v32 or ""]

	React.useEffect(function() -- line: 153
		-- upvalues: v32 (copy), v33 (copy)
		if v32 ~= nil then
			v33.getOrCreatePageRequestId(v32)
		end
	end, {
		v32,
		v33
	})

	local v35 = React.useMemo(function() -- line: 160
		-- upvalues: content (copy), v29 (copy)
		local t2 = {}
		local v43 = content or {}

		for i = 1, math.min(#v43, v29) do
			local v45 = v43[i]

			if v45 ~= nil and v45.id ~= nil then
				table.insert(t2, v45.id)
			end
		end

		return t2
	end, {
		content,
		v29
	})
	local v36 = React.useMemo(function() -- line: 173
		-- upvalues: id (copy), type (copy), v28 (copy), v29 (copy), v34 (copy), v35 (copy)
		return {
			widgetId = id,
			widgetType = type,
			widgetPosition = v28,
			widgetAbsPosition = (v28 - 1) * v29,
			requestId = v34,
			widgetItemIds = v35
		}
	end, {
		id,
		type,
		v28,
		v29,
		v34,
		v35
	})
	local v37 = useWrapZeroArgActionHandler(t1.onSeeAll)
	local v38, v39 = useTrackedRowWidth(t1.feedRowWidth)
	local v40 = t1.horizontalMargin or CATALOG_RESULTS_HORIZONTAL_MARGIN
	local v41 = nil

	if FFlagAXSduiWidgetsTTITracking then
		v41 = React.useContext(SduiWidgetTTITileLatencyContext)
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v39
	}, {
		Carousel = React.createElement(CatalogItemCarouselSortContainer, {
			widgetRow = v28,
			widgetInfo = v30,
			itemsPerRow = v29,
			widgetAnalyticsInfo = v36,
			onSeeAll = v37,
			rowWidth = v38,
			horizontalMargin = v40,
			onThumbnailLoaded = v41
		})
	})
end

return React.memo(SduiCatalogItemCarousel)
