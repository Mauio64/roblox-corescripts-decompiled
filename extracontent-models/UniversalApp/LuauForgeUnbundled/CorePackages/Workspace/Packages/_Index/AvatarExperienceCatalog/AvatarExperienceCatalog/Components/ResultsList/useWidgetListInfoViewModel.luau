local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").Hooks.useTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Responsive")
local inputModeStore = Responsive.GetInputModeStore(false)
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local FFlagAXNoCarouselsOnCatalogWithGamepad = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Flags/FFlagAXNoCarouselsOnCatalogWithGamepad")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local WidgetListBreakPointEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")

local v5 = {
	{ contentType = "ItemName" },
	{ contentType = "Price" },
	{ contentType = "AgentName" }
}

local v6 = {
	type = "Carousel",
	numItemsToShow = 12,
	itemFooters = v5,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v7 = {
	type = "ItemGroup",
	itemFooters = v5,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v8 = {
	type = "HeroUnit",
	itemFooters = v5,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v9 = {
	Default = "default",
	XSmall = "xSmall",
	Small = "small",
	Medium = "medium",
	Large = "large",
	XLarge = "xLarge",
	X2Large = "x2Large",
	Landscape = "landscape",
	Portrait = "portrait"
}

local v10 = { Dark = "dark", Light = "light", Default = "default" }

local function getQueryStringForSearchWidgets(searchesParameter)
	if not (searchesParameter and searchesParameter.searchKeyword) then
		return nil
	end

	local v11 = { searchesParameter.searchKeyword }

	if searchesParameter.sortAndFilters and searchesParameter.sortAndFilters.SelectedTopics then
		for k, selectedTopic in searchesParameter.sortAndFilters.SelectedTopics do
			table.insert(v11, 1, selectedTopic)
		end
	end

	return table.concat(v11, " ")
end

local function getDefaultItemGroupTemplate(p2)
	if p2 and p2.defaultItemGroupTemplate then
		return Cryo.Dictionary.join(v7, p2.defaultItemGroupTemplate)
	end

	if p2 and p2.defaultTemplate then
		return Cryo.Dictionary.join(v7, p2.defaultTemplate)
	end

	return v7
end

local function getDefaultCarouselTemplate(p2)
	if p2 and p2.defaultItemCarouselTemplate then
		return Cryo.Dictionary.join(v6, p2.defaultItemCarouselTemplate)
	end

	return v6
end

local function getResponsiveValue(p2, p3)
	if not p2 then
		return nil
	end

	local v11 = not (p3 and v9[p3]) and "default" or v9[p3]

	if p2[v11] then
		return p2[v11]
	end

	return p2.default
end

local function getThemeValue(p2, p3)
	if not p2 then
		return nil
	end

	local v11 = not (p3 and v10[p3]) and "default" or v10[p3]

	if p2[v11] then
		return p2[v11]
	end

	return p2.default
end

local function colorToColor3(color)
	return Color3.new(color.r, color.g, color.b)
end

local function pointToVector2(p2)
	return Vector2.new(p2.x, p2.y)
end

local function pointToUDim2(p2)
	return UDim2.fromOffset(p2.x, p2.y)
end

local function formatResponsivePointToVector(p2, p3)
	local v11

	if p2 then
		local v12 = not (p3 and v9[p3]) and "default" or v9[p3]
		v11 = if p2[v12] then p2[v12] else p2.default
	end

	return pointToVector2(v11 or { x = 0, y = 0 })
end

local function formatResponsivePointToUDim2(p2, p3)
	local v11

	if p2 then
		local v12 = not (p3 and v9[p3]) and "default" or v9[p3]
		v11 = if p2[v12] then p2[v12] else p2.default
	end

	return pointToUDim2(v11 or { x = 0, y = 0 })
end

local function formatColorSequence(colorSequence)
	local colorSequenceKeypoints = {}

	for k, item in colorSequence do
		table.insert(
			colorSequenceKeypoints,
			ColorSequenceKeypoint.new(item.time, colorToColor3(item.color))
		)
	end

	return ColorSequence.new(colorSequenceKeypoints)
end

local function formatNumberSequence(transparency)
	if type(transparency) == "number" then
		return NumberSequence.new(transparency)
	end

	if #transparency == 0 then
		return nil
	end

	local numberSequenceKeypoints = {}

	for k, v11 in transparency do
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v11.time, v11.number))
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

local function formatImageBackground(data, p2)
	local vector2

	if data.anchorPoint then
		local anchorPoint = data.anchorPoint
		local v11

		if anchorPoint then
			local v12 = not (p2 and v9[p2]) and "default" or v9[p2]
			v11 = if anchorPoint[v12] then anchorPoint[v12] else anchorPoint.default
		end

		local v12 = v11 or { x = 0, y = 0 }
		vector2 = Vector2.new(v12.x, v12.y)
	end

	local udim

	if data.position then
		local position = data.position
		local v11

		if position then
			local v12 = not (p2 and v9[p2]) and "default" or v9[p2]
			v11 = if position[v12] then position[v12] else position.default
		end

		local v12 = v11 or { x = 0, y = 0 }
		udim = UDim2.fromOffset(v12.x, v12.y)
	end

	local v12

	if data.resourceIdentifier then
		local resourceIdentifier = data.resourceIdentifier

		if resourceIdentifier then
			local v13 = not (p2 and v9[p2]) and "default" or v9[p2]
			v12 = if resourceIdentifier[v13] then resourceIdentifier[v13] else resourceIdentifier.default
		end
	end

	local color

	if data.color then
		local color2 = data.color
		color = Color3.new(color2.r, color2.g, color2.b)
	end

	local v13

	if data.transparency then
		local transparency = data.transparency

		if transparency then
			local v14 = not (p2 and v9[p2]) and "default" or v9[p2]
			v13 = if transparency[v14] then transparency[v14] else transparency.default
		end
	end

	return {
		type = "ImageBackground",
		resourceIdentifier = v12,
		color = color,
		anchorPoint = vector2,
		position = udim,
		transparency = v13
	}
end

local function formatGradientBackground(data)
	local v11 = {
		type = "GradientBackground",
		colorSequence = formatColorSequence(data.colorSequence),
		rotation = data.rotation,
		transparency = 0,
		offset = 0
	}
	local v12 = if data.transparency then formatNumberSequence(data.transparency) else nil
	v11.transparency = v12
	local vector2

	if data.offset then
		local offset = data.offset
		vector2 = Vector2.new(offset.x, offset.y)
	end

	v11.offset = vector2
	return v11
end

local function getFormattedBackgroundLayers(backgroundLayers, p2, p3)
	local v11

	if backgroundLayers then
		local v12 = not (p3 and v10[p3]) and "default" or v10[p3]
		v11 = if backgroundLayers[v12] then backgroundLayers[v12] else backgroundLayers.default
	end

	local formattedBackgroundLayers = {}

	for k, v12 in v11 or {} do
		if v12.type == "ImageBackground" then
			table.insert(formattedBackgroundLayers, formatImageBackground(v12, p2))
		elseif v12.type == "GradientBackground" then
			table.insert(formattedBackgroundLayers, formatGradientBackground(v12))
		end
	end

	return formattedBackgroundLayers
end

local function formatCardStyle(p2, p3, p4)
	local v12 = if p2.backgroundLayers then getFormattedBackgroundLayers(p2.backgroundLayers, p3, p4) else nil
	return { backgroundLayers = v12, thumbnailAspectRatio = p2.thumbnailAspectRatio }
end

local function formatWidgetStyle(p2, p3, p4)
	local v12 = if p2.backgroundLayers then getFormattedBackgroundLayers(p2.backgroundLayers, p3, p4) else nil
	return { backgroundLayers = v12 }
end

local function formatWidgetTemplateAsItemGroup(data, p2, p3)
	local previewColumns = data.previewColumns
	local v11

	if previewColumns then
		local v12 = not (p2 and v9[p2]) and "default" or v9[p2]
		v11 = if previewColumns[v12] then previewColumns[v12] else previewColumns.default
	end

	local previewRows = data.previewRows
	local v13

	if previewRows then
		local v14 = not (p2 and v9[p2]) and "default" or v9[p2]
		v13 = if previewRows[v14] then previewRows[v14] else previewRows.default
	end

	local v15 = {
		type = "ItemGroup",
		seeAllButton = data.seeAllButton,
		title = data.title,
		localizedTitle = data.localizedTitle,
		description = data.description,
		localizedDescription = data.localizedDescription,
		itemFooters = data.itemFooters,
		widgetStyle = 0,
		cardStyle = 0,
		previewRows = 0,
		previewColumns = 0
	}
	local v16

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		v16 = { backgroundLayers = 0 }
		local v17 = if widgetStyle.backgroundLayers then getFormattedBackgroundLayers(
			widgetStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v16.backgroundLayers = v17
	end

	v15.widgetStyle = v16
	local v17

	if data.cardStyle then
		local cardStyle = data.cardStyle
		v17 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local v18 = if cardStyle.backgroundLayers then getFormattedBackgroundLayers(
			cardStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v17.backgroundLayers = v18

		v17.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v15.cardStyle = v17
	v15.previewRows = v13 or 1
	v15.previewColumns = v11 or 1
	return v15
end

local function formatWidgetTemplateAsCarousel(data, p2, p3)
	local previewColumns = data.previewColumns
	local v11

	if previewColumns then
		local v12 = not (p2 and v9[p2]) and "default" or v9[p2]
		v11 = if previewColumns[v12] then previewColumns[v12] else previewColumns.default
	end

	local previewRows = data.previewRows
	local v13

	if previewRows then
		local v14 = not (p2 and v9[p2]) and "default" or v9[p2]
		v13 = if previewRows[v14] then previewRows[v14] else previewRows.default
	end

	local v15 = {
		type = "Carousel",
		numItemsToShow = data.numItemsToShow,
		seeAllButton = data.seeAllButton,
		title = data.title,
		localizedTitle = data.localizedTitle,
		description = data.description,
		localizedDescription = data.localizedDescription,
		itemFooters = data.itemFooters,
		widgetStyle = 0,
		cardStyle = 0,
		previewRows = 0,
		previewColumns = 0
	}
	local v16

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		v16 = { backgroundLayers = 0 }
		local v17 = if widgetStyle.backgroundLayers then getFormattedBackgroundLayers(
			widgetStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v16.backgroundLayers = v17
	end

	v15.widgetStyle = v16
	local v17

	if data.cardStyle then
		local cardStyle = data.cardStyle
		v17 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local v18 = if cardStyle.backgroundLayers then getFormattedBackgroundLayers(
			cardStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v17.backgroundLayers = v18

		v17.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v15.cardStyle = v17
	v15.previewRows = v13 or 1
	v15.previewColumns = v11 or 1
	return v15
end

local function formatWidgetTemplateAsHeroUnit(data, p2, p3)
	local previewColumns = data.previewColumns
	local v11

	if previewColumns then
		local v12 = not (p2 and v9[p2]) and "default" or v9[p2]
		v11 = if previewColumns[v12] then previewColumns[v12] else previewColumns.default
	end

	local previewRows = data.previewRows
	local v13

	if previewRows then
		local v14 = not (p2 and v9[p2]) and "default" or v9[p2]
		v13 = if previewRows[v14] then previewRows[v14] else previewRows.default
	end

	local v15 = {
		type = "HeroUnit",
		numItemsToShow = data.numItemsToShow,
		seeAllButton = data.seeAllButton,
		title = data.title,
		localizedTitle = data.localizedTitle,
		description = data.description,
		localizedDescription = data.localizedDescription,
		itemFooters = data.itemFooters,
		widgetStyle = 0,
		cardStyle = 0,
		previewRows = 0,
		previewColumns = 0,
		availableUntil = 0
	}
	local v16

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		v16 = { backgroundLayers = 0 }
		local v17 = if widgetStyle.backgroundLayers then getFormattedBackgroundLayers(
			widgetStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v16.backgroundLayers = v17
	end

	v15.widgetStyle = v16
	local v17

	if data.cardStyle then
		local cardStyle = data.cardStyle
		v17 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local v18 = if cardStyle.backgroundLayers then getFormattedBackgroundLayers(
			cardStyle.backgroundLayers,
			p2,
			p3
		) else nil
		v17.backgroundLayers = v18

		v17.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v15.cardStyle = v17
	v15.previewRows = v13 or 1
	v15.previewColumns = v11 or 1
	v15.availableUntil = data.availableUntil
	return v15
end

local function mergeCardStyle(cardStyle, cardStyle2)
	if not (cardStyle or cardStyle2) then
		return nil
	end

	local v11 = if cardStyle2 then cardStyle2.thumbnailAspectRatio else nil
	local thumbnailAspectRatio = if cardStyle then cardStyle.thumbnailAspectRatio else nil

	if v11 == nil then
		v11 = thumbnailAspectRatio
	end

	return {
		thumbnailAspectRatio = v11,
		backgroundLayers = Cryo.Dictionary.join(
			not (cardStyle and cardStyle.backgroundLayers) and {} or cardStyle.backgroundLayers,
			not (cardStyle2 and cardStyle2.backgroundLayers) and {} or cardStyle2.backgroundLayers
		)
	}
end

local function mergeWidgetStyle(widgetStyle, widgetStyle2)
	if widgetStyle or widgetStyle2 then
		return {
			backgroundLayers = Cryo.Dictionary.join(
				not (widgetStyle and widgetStyle.backgroundLayers) and {} or widgetStyle.backgroundLayers,
				not (widgetStyle2 and widgetStyle2.backgroundLayers) and {} or widgetStyle2.backgroundLayers
			)
		}
	end

	return nil
end

local function mergeItemGroupTemplates(data, data2)
	local v12 = if data2.seeAllButton == nil then data.seeAllButton else data2.seeAllButton
	local v13 = if data2.title == nil then data.title else data2.title
	local v14 = if data2.localizedTitle == nil then data.localizedTitle else data2.localizedTitle
	local v15 = if data2.description == nil then data.description else data2.description
	local v16 = if data2.localizedDescription == nil then data.localizedDescription else data2.localizedDescription
	local v17 = if data2.itemFooters == nil then data.itemFooters else data2.itemFooters
	return {
		type = "ItemGroup",
		seeAllButton = v12,
		title = v13,
		localizedTitle = v14,
		description = v15,
		localizedDescription = v16,
		itemFooters = v17,
		widgetStyle = mergeWidgetStyle(data.widgetStyle, data2.widgetStyle),
		cardStyle = mergeCardStyle(data.cardStyle, data2.cardStyle),
		previewRows = Cryo.Dictionary.join(data.previewRows or {}, data2.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(data.previewColumns or {}, data2.previewColumns or {})
	}
end

local function mergeCarouselTemplates(data, data2)
	local v12 = if data2.numItemsToShow == nil then data.numItemsToShow else data2.numItemsToShow
	local v13 = if data2.seeAllButton == nil then data.seeAllButton else data2.seeAllButton
	local v14 = if data2.title == nil then data.title else data2.title
	local v15 = if data2.localizedTitle == nil then data.localizedTitle else data2.localizedTitle
	local v16 = if data2.description == nil then data.description else data2.description
	local v17 = if data2.localizedDescription == nil then data.localizedDescription else data2.localizedDescription
	local v18 = if data2.itemFooters == nil then data.itemFooters else data2.itemFooters
	return {
		type = "Carousel",
		numItemsToShow = v12,
		seeAllButton = v13,
		title = v14,
		localizedTitle = v15,
		description = v16,
		localizedDescription = v17,
		itemFooters = v18,
		widgetStyle = mergeWidgetStyle(data.widgetStyle, data2.widgetStyle),
		cardStyle = mergeCardStyle(data.cardStyle, data2.cardStyle),
		previewRows = Cryo.Dictionary.join(data.previewRows or {}, data2.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(data.previewColumns or {}, data2.previewColumns or {})
	}
end

local function mergeHeroUnitTemplates(data, data2)
	local v12 = if data2.numItemsToShow == nil then data.numItemsToShow else data2.numItemsToShow
	local v13 = if data2.seeAllButton == nil then data.seeAllButton else data2.seeAllButton
	local v14 = if data2.title == nil then data.title else data2.title
	local v15 = if data2.localizedTitle == nil then data.localizedTitle else data2.localizedTitle
	local v16 = if data2.description == nil then data.description else data2.description
	local v17 = if data2.localizedDescription == nil then data.localizedDescription else data2.localizedDescription
	local v18 = if data2.itemFooters == nil then data.itemFooters else data2.itemFooters
	local v11 = {
		type = "HeroUnit",
		numItemsToShow = v12,
		seeAllButton = v13,
		title = v14,
		localizedTitle = v15,
		description = v16,
		localizedDescription = v17,
		itemFooters = v18,
		widgetStyle = mergeWidgetStyle(data.widgetStyle, data2.widgetStyle),
		cardStyle = mergeCardStyle(data.cardStyle, data2.cardStyle),
		previewRows = Cryo.Dictionary.join(data.previewRows or {}, data2.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(data.previewColumns or {}, data2.previewColumns or {}),
		availableUntil = 0
	}
	local v19 = if data2.availableUntil == nil then data.availableUntil else data2.availableUntil
	v11.availableUntil = v19
	return v11
end

local function convertCarouselTemplateToItemGroupTemplate(p2)
	local clone = table.clone(p2)
	clone.type = "ItemGroup"
	clone.numItemsToShow = nil
	return clone
end

local function formatWidgetListStateToWidgetListInfoViewModel(data, p2, p3, p4)
	local v11 = { configuration = {}, widgets = {} }
	local configuration = if data then data.Configuration else nil

	local v12 = if FFlagAXNoCarouselsOnCatalogWithGamepad then p4 ~= Responsive.Input.Directional else nil
	local v13

	if configuration and configuration.defaultItemCarouselTemplate then
		v13 = Cryo.Dictionary.join(v6, configuration.defaultItemCarouselTemplate)
	else
		v13 = v6
	end

	local v14

	if configuration and configuration.defaultItemGroupTemplate then
		v14 = Cryo.Dictionary.join(v7, configuration.defaultItemGroupTemplate)
	elseif configuration and configuration.defaultTemplate then
		v14 = Cryo.Dictionary.join(v7, configuration.defaultTemplate)
	else
		v14 = v7
	end

	if data and data.Details then
		for k, detail in data.Details do
			local v15

			if FFlagAXNoCarouselsOnCatalogWithGamepad then
				if detail.template.type == "Carousel" and not v12 then
					local template = detail.template
					v15 = table.clone(template)
					v15.type = "ItemGroup"
					v15.numItemsToShow = nil
				else
					v15 = detail.template
				end
			end

			if not FFlagAXNoCarouselsOnCatalogWithGamepad then
				v15 = detail.template
			end

			local kind = v15.type
			local v16 = kind == "Carousel"
			local v17

			if kind == "HeroUnit" then
				v17 = formatWidgetTemplateAsHeroUnit(mergeHeroUnitTemplates(v8, v15), p2, p3)
			elseif v16 then
				v17 = formatWidgetTemplateAsCarousel(mergeCarouselTemplates(v13, v15), p2, p3)
			else
				v17 = formatWidgetTemplateAsItemGroup(mergeItemGroupTemplates(v14, v15), p2, p3)
			end

			v11.widgets[k] = {
				id = detail.id,
				type = detail.type,
				content = detail.content,
				tagId = detail.tagId,
				template = v17,
				requestId = data.RequestId
			}
		end
	end

	if configuration then
		v11.configuration.customizedDataMap = configuration.customizedDataMap
	end

	v11.configuration.defaultItemGroupTemplate = formatWidgetTemplateAsItemGroup(v14, p2, p3)

	v11.configuration.defaultItemCarouselTemplate = formatWidgetTemplateAsCarousel(v13, p2, p3)

	return v11
end

local function useWidgetListInfoViewModel(p2, p3, p4)
	local v11 = p4 or WidgetListBreakPointEnum.Default

	local v12 = if FFlagAXNoCarouselsOnCatalogWithGamepad then useSignalState(inputModeStore.getLastInputType) else nil

	local v14 = useSelector((React.useCallback(function(p5)
		local searchesParameter = p5.SearchesParameters[p2]
		local v14 = searchesParameter and searchesParameter.searchKeyword ~= nil
		local queryStringForSearchWidgets = getQueryStringForSearchWidgets(searchesParameter)

		if v14 then
			return p5.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[queryStringForSearchWidgets]
		end

		if p3 then
			return p5.AvatarExperience.Common.Widgets.ContextWidgetInfo[p3]
		end

		return p5.AvatarExperience.Common.Widgets.WidgetInfo
	end, { p2, p3 })))
	local v15 = useTokens()

	local function fn()
		local name = v15.Config.ColorMode.Name
		local v19 = if FFlagAXNoCarouselsOnCatalogWithGamepad then v12 else nil
		return formatWidgetListStateToWidgetListInfoViewModel(v14, v11, name, v19)
	end

	return (React.useMemo(fn, {
		v15.Config.ColorMode.Name,
		v14,
		v11,
		if FFlagAXNoCarouselsOnCatalogWithGamepad then v12 else nil
	}))
end

return useWidgetListInfoViewModel
