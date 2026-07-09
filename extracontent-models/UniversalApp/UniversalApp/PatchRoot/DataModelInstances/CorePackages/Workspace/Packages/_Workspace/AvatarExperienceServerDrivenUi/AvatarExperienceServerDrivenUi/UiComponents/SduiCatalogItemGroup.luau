local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local React = require(AvatarExperienceServerDrivenUiParent.React)
local useSignalState = require(AvatarExperienceServerDrivenUiParent.SignalsReact).useSignalState
local AvatarExperienceCatalog = require(AvatarExperienceServerDrivenUiParent.AvatarExperienceCatalog)
local CatalogItemGroupSortContainer = AvatarExperienceCatalog.Components.CatalogItemGroupSort.CatalogItemGroupSortContainer
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

local function SduiCatalogItemGroup(t1: {[any]: any}) -- line: 94
	-- upvalues: CatalogSortConstants (copy), React (copy), CatalogSduiPageContext (copy), getCatalogPageRequestIdStore (copy), useSignalState (copy), useWrapZeroArgActionHandler (copy), useTrackedRowWidth (copy), CATALOG_RESULTS_HORIZONTAL_MARGIN (copy), FFlagAXSduiWidgetsTTITracking (copy), SduiWidgetTTITileLatencyContext (copy), CatalogItemGroupSortContainer (copy)
	local id = t1.id
	local type = t1.type
	local content = t1.content
	local previewRows = t1.previewRows
	local previewColumns = t1.previewColumns
	local title = t1.title
	local description = t1.description
	local v24 = t1.itemFooters or CatalogSortConstants.DEFAULT_ITEM_FOOTERS
	local cardStyle = t1.cardStyle
	local tagId = t1.tagId
	local informationPopoverText = t1.informationPopoverText
	local v28 = t1.layoutOrder or (t1.startRow or 1)
	local v29 = previewColumns or CatalogSortConstants.DEFAULT_PREVIEW_COLUMNS
	local v30 = previewRows or 1
	local v31 = React.useMemo(function() -- line: 112
		-- upvalues: id (copy), type (copy), content (copy), title (copy), description (copy), informationPopoverText (copy), v24 (copy), cardStyle (copy), v30 (copy), v29 (copy), tagId (copy)
		return {
			id = id,
			type = type,
			content = content or {},
			template = {
				type = "ItemGroup",
				localizedTitle = title,
				localizedDescription = description,
				informationPopoverText = informationPopoverText,
				itemFooters = v24,
				cardStyle = cardStyle,
				previewRows = v30,
				previewColumns = v29
			},
			tagId = tagId
		}
	end, {
		id,
		type,
		content,
		title,
		description,
		informationPopoverText,
		v24,
		cardStyle,
		tagId,
		v30,
		v29
	})
	local v32 = React.useContext(CatalogSduiPageContext)
	local v33 = if not v32 then nil else v32.identifier
	local v34 = getCatalogPageRequestIdStore(false)
	local v35 = useSignalState(v34.getPageRequestIdMap)[v33 or ""]

	React.useEffect(function() -- line: 152
		-- upvalues: v33 (copy), v34 (copy)
		if v33 ~= nil then
			v34.getOrCreatePageRequestId(v33)
		end
	end, {
		v33,
		v34
	})

	local v36 = React.useMemo(function() -- line: 159
		-- upvalues: content (copy), v29 (copy)
		local t2 = {}
		local v44 = content or {}

		for i = 1, math.min(#v44, v29) do
			local v46 = v44[i]

			if v46 ~= nil and v46.id ~= nil then
				table.insert(t2, v46.id)
			end
		end

		return t2
	end, {
		content,
		v29
	})
	local v37 = React.useMemo(function() -- line: 172
		-- upvalues: id (copy), type (copy), v28 (copy), v29 (copy), v35 (copy), v36 (copy)
		return {
			widgetId = id,
			widgetType = type,
			widgetPosition = v28,
			widgetAbsPosition = (v28 - 1) * v29,
			requestId = v35,
			widgetItemIds = v36
		}
	end, {
		id,
		type,
		v28,
		v29,
		v35,
		v36
	})
	local v38 = useWrapZeroArgActionHandler(t1.onSeeAll)
	local v39, v40 = useTrackedRowWidth(t1.feedRowWidth)
	local v41 = t1.horizontalMargin or CATALOG_RESULTS_HORIZONTAL_MARGIN
	local v42 = nil

	if FFlagAXSduiWidgetsTTITracking then
		v42 = React.useContext(SduiWidgetTTITileLatencyContext)
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v40
	}, {
		Group = React.createElement(CatalogItemGroupSortContainer, {
			widgetRow = v28,
			widgetInfo = v31,
			itemsPerRow = v29,
			rowCount = v30,
			widgetAnalyticsInfo = v37,
			onSeeAll = v38,
			rowWidth = v39,
			horizontalMargin = v41,
			onThumbnailLoaded = v42
		})
	})
end

return React.memo(SduiCatalogItemGroup)
