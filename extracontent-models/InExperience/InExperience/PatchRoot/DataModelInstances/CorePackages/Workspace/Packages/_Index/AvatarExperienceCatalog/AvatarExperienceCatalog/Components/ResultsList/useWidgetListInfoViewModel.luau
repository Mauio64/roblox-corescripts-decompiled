local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(parent.Responsive)
local inputModeStore = Responsive.GetInputModeStore(false)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagAXNoCarouselsOnCatalogWithGamepad = require(AvatarExperienceCatalog.Flags.FFlagAXNoCarouselsOnCatalogWithGamepad)
local FFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

require(AvatarExperienceCatalog.Models.WidgetListInfo)

require(script.Parent.WidgetListInfoViewModel)

local WidgetListBreakPointEnum = require(script.Parent.WidgetListBreakPointEnum)

local itemFooters = {
	{ contentType = "ItemName" },
	{ contentType = "Price" },
	{ contentType = "AgentName" }
}

local v = {
	type = "Carousel",
	numItemsToShow = 12,
	itemFooters = itemFooters,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v2 = {
	type = "ItemGroup",
	itemFooters = itemFooters,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v3 = {
	type = "HeroUnit",
	itemFooters = itemFooters,
	previewRows = { default = 1 },
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}

local v4 = {
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

local v5 = { Dark = "dark", Light = "light", Default = "default" }

local function getQueryStringForSearchWidgets(searchesParameter)
	if not (searchesParameter and searchesParameter.searchKeyword) then
		return nil
	end

	local v6 = { searchesParameter.searchKeyword }

	if searchesParameter.sortAndFilters and searchesParameter.sortAndFilters.SelectedTopics then
		for _, selectedTopic in searchesParameter.sortAndFilters.SelectedTopics do
			table.insert(v6, 1, selectedTopic)
		end
	end

	return table.concat(v6, " ")
end

local function getDefaultItemGroupTemplate(configuration) -- 1 equivalent call inferred from this helper
	if configuration and configuration.defaultItemGroupTemplate then
		return Cryo.Dictionary.join(v2, configuration.defaultItemGroupTemplate)
	end

	if configuration and configuration.defaultTemplate then
		return Cryo.Dictionary.join(v2, configuration.defaultTemplate)
	end

	return v2
end

local function getDefaultCarouselTemplate(configuration) -- 1 equivalent call inferred from this helper
	if configuration and configuration.defaultItemCarouselTemplate then
		return Cryo.Dictionary.join(v, configuration.defaultItemCarouselTemplate)
	end

	return v
end

local function getResponsiveValue(p, p2: string?) -- 10 equivalent calls inferred from this helper
	if not p then
		return nil
	end

	local v6 = not (p2 and v4[p2]) and "default" or v4[p2]

	if p[v6] then
		return p[v6]
	end

	return p.default
end

local function getThemeValue(p, p2: string?) -- 1 equivalent call inferred from this helper
	if not p then
		return nil
	end

	local v6 = not (p2 and v5[p2]) and "default" or v5[p2]

	if p[v6] then
		return p[v6]
	end

	return p.default
end

local function colorToColor3(color) -- 1 equivalent call inferred from this helper
	return Color3.new(color.r, color.g, color.b)
end

local function pointToVector2(p) -- 1 equivalent call inferred from this helper
	return Vector2.new(p.x, p.y)
end

local function pointToUDim2(p)
	return UDim2.fromOffset(p.x, p.y)
end

local function formatResponsivePointToVector(p, p2: string?) -- 1 equivalent call inferred from this helper
	return pointToVector2(getResponsiveValue(p, p2) or { x = 0, y = 0 }) -- inferred equivalent call
end

local function formatResponsivePointToUDim2(p, p2: string?) -- 1 equivalent call inferred from this helper
	return pointToUDim2(getResponsiveValue(p, p2) or { x = 0, y = 0 }) -- inferred equivalent call
end

local function formatColorSequence(colorSequence)
	local colorSequenceKeypoints = {}

	for _, item in colorSequence do
		table.insert(colorSequenceKeypoints, ColorSequenceKeypoint.new(item.time, colorToColor3(item.color)))
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

	for _, v6 in transparency do
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v6.time, v6.number))
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

local function formatImageBackground(data, p: string?)
	local anchorPoint

	if data.anchorPoint then
		anchorPoint = formatResponsivePointToVector(data.anchorPoint, p) -- inferred equivalent call
	end

	local position

	if data.position then
		position = formatResponsivePointToUDim2(data.position, p) -- inferred equivalent call
	end

	local resourceIdentifier

	if data.resourceIdentifier then
		resourceIdentifier = getResponsiveValue(data.resourceIdentifier, p) -- inferred equivalent call
	end

	local color

	if data.color then
		color = colorToColor3(data.color) -- inferred equivalent call
	end

	local transparency

	if data.transparency then
		transparency = getResponsiveValue(data.transparency, p) -- inferred equivalent call
	end

	return {
		type = "ImageBackground",
		resourceIdentifier = resourceIdentifier,
		color = color,
		anchorPoint = anchorPoint,
		position = position,
		transparency = transparency
	}
end

local function formatGradientBackground(data)
	local v6 = {
		type = "GradientBackground",
		colorSequence = formatColorSequence(data.colorSequence),
		rotation = data.rotation,
		transparency = 0,
		offset = 0
	}
	local transparency

	if data.transparency then
		transparency = formatNumberSequence(data.transparency)
	end

	v6.transparency = transparency
	local offset

	if data.offset then
		offset = pointToVector2(data.offset) -- inferred equivalent call
	end

	v6.offset = offset
	return v6
end

local function getFormattedBackgroundLayers(backgroundLayers, p: string, p2: string?)
	local themeValue = getThemeValue(backgroundLayers, p2) -- inferred equivalent call
	local formattedBackgroundLayers = {}

	for _, v6 in themeValue or {} do
		if v6.type == "ImageBackground" then
			table.insert(formattedBackgroundLayers, formatImageBackground(v6, p))
		elseif v6.type == "GradientBackground" then
			table.insert(formattedBackgroundLayers, formatGradientBackground(v6))
		end
	end

	return formattedBackgroundLayers
end

local function formatCardStyle(p, p2: string, p3: string?)
	local backgroundLayers

	if p.backgroundLayers then
		backgroundLayers = getFormattedBackgroundLayers(p.backgroundLayers, p2, p3)
	end

	return { backgroundLayers = backgroundLayers, thumbnailAspectRatio = p.thumbnailAspectRatio }
end

local function formatWidgetStyle(p, p2: string, p3: string?)
	local backgroundLayers

	if p.backgroundLayers then
		backgroundLayers = getFormattedBackgroundLayers(p.backgroundLayers, p2, p3)
	end

	return { backgroundLayers = backgroundLayers }
end

local function formatWidgetTemplateAsItemGroup(data, p: string, p2: string?)
	local previewColumns = getResponsiveValue(data.previewColumns, p) or 1 -- inferred equivalent call
	local previewRows = getResponsiveValue(data.previewRows, p) or 1 -- inferred equivalent call
	local v6 = {
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
	local widgetStyle2

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		widgetStyle2 = { backgroundLayers = 0 }
		local backgroundLayers

		if widgetStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(widgetStyle.backgroundLayers, p, p2)
		end

		widgetStyle2.backgroundLayers = backgroundLayers
	end

	v6.widgetStyle = widgetStyle2
	local cardStyle2

	if data.cardStyle then
		local cardStyle = data.cardStyle
		cardStyle2 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local backgroundLayers

		if cardStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(cardStyle.backgroundLayers, p, p2)
		end

		cardStyle2.backgroundLayers = backgroundLayers

		cardStyle2.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v6.cardStyle = cardStyle2
	v6.previewRows = previewRows
	v6.previewColumns = previewColumns
	return v6
end

local function formatWidgetTemplateAsCarousel(data, p: string, p2: string?)
	local previewColumns = getResponsiveValue(data.previewColumns, p) or 1 -- inferred equivalent call
	local previewRows = getResponsiveValue(data.previewRows, p) or 1 -- inferred equivalent call
	local v6 = {
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
	local widgetStyle2

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		widgetStyle2 = { backgroundLayers = 0 }
		local backgroundLayers

		if widgetStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(widgetStyle.backgroundLayers, p, p2)
		end

		widgetStyle2.backgroundLayers = backgroundLayers
	end

	v6.widgetStyle = widgetStyle2
	local cardStyle2

	if data.cardStyle then
		local cardStyle = data.cardStyle
		cardStyle2 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local backgroundLayers

		if cardStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(cardStyle.backgroundLayers, p, p2)
		end

		cardStyle2.backgroundLayers = backgroundLayers

		cardStyle2.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v6.cardStyle = cardStyle2
	v6.previewRows = previewRows
	v6.previewColumns = previewColumns
	return v6
end

local function formatWidgetTemplateAsHeroUnit(data, p: string, p2: string?)
	local previewColumns = getResponsiveValue(data.previewColumns, p) or 1 -- inferred equivalent call
	local previewRows = getResponsiveValue(data.previewRows, p) or 1 -- inferred equivalent call
	local v6 = {
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
		availableUntil = 0,
		button = 0
	}
	local widgetStyle2

	if data.widgetStyle then
		local widgetStyle = data.widgetStyle
		widgetStyle2 = { backgroundLayers = 0 }
		local backgroundLayers

		if widgetStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(widgetStyle.backgroundLayers, p, p2)
		end

		widgetStyle2.backgroundLayers = backgroundLayers
	end

	v6.widgetStyle = widgetStyle2
	local cardStyle2

	if data.cardStyle then
		local cardStyle = data.cardStyle
		cardStyle2 = { backgroundLayers = 0, thumbnailAspectRatio = 0 }
		local backgroundLayers

		if cardStyle.backgroundLayers then
			backgroundLayers = getFormattedBackgroundLayers(cardStyle.backgroundLayers, p, p2)
		end

		cardStyle2.backgroundLayers = backgroundLayers

		cardStyle2.thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	v6.cardStyle = cardStyle2
	v6.previewRows = previewRows
	v6.previewColumns = previewColumns
	v6.availableUntil = data.availableUntil
	local button

	if FFlagAXHeroUnitActionButton then
		button = data.button
	end

	v6.button = button
	return v6
end

local function mergeCardStyle(cardStyle, cardStyle2)
	if not (cardStyle or cardStyle2) then
		return nil
	end

	local thumbnailAspectRatio2

	if cardStyle2 then
		thumbnailAspectRatio2 = cardStyle2.thumbnailAspectRatio
	end

	local thumbnailAspectRatio

	if cardStyle then
		thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	end

	if thumbnailAspectRatio2 == nil then
		thumbnailAspectRatio2 = thumbnailAspectRatio
	end

	return {
		thumbnailAspectRatio = thumbnailAspectRatio2,
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

local function mergeItemGroupTemplates(defaultItemGroupTemplate, data)
	local seeAllButton

	if data.seeAllButton == nil then
		seeAllButton = defaultItemGroupTemplate.seeAllButton
	else
		seeAllButton = data.seeAllButton
	end

	local title

	if data.title == nil then
		title = defaultItemGroupTemplate.title
	else
		title = data.title
	end

	local localizedTitle

	if data.localizedTitle == nil then
		localizedTitle = defaultItemGroupTemplate.localizedTitle
	else
		localizedTitle = data.localizedTitle
	end

	local description

	if data.description == nil then
		description = defaultItemGroupTemplate.description
	else
		description = data.description
	end

	local localizedDescription

	if data.localizedDescription == nil then
		localizedDescription = defaultItemGroupTemplate.localizedDescription
	else
		localizedDescription = data.localizedDescription
	end

	local itemFooters2

	if data.itemFooters == nil then
		itemFooters2 = defaultItemGroupTemplate.itemFooters
	else
		itemFooters2 = data.itemFooters
	end

	return {
		type = "ItemGroup",
		seeAllButton = seeAllButton,
		title = title,
		localizedTitle = localizedTitle,
		description = description,
		localizedDescription = localizedDescription,
		itemFooters = itemFooters2,
		widgetStyle = mergeWidgetStyle(defaultItemGroupTemplate.widgetStyle, data.widgetStyle),
		cardStyle = mergeCardStyle(defaultItemGroupTemplate.cardStyle, data.cardStyle),
		previewRows = Cryo.Dictionary.join(defaultItemGroupTemplate.previewRows or {}, data.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(defaultItemGroupTemplate.previewColumns or {}, data.previewColumns or {})
	}
end

local function mergeCarouselTemplates(defaultCarouselTemplate, data)
	local numItemsToShow

	if data.numItemsToShow == nil then
		numItemsToShow = defaultCarouselTemplate.numItemsToShow
	else
		numItemsToShow = data.numItemsToShow
	end

	local seeAllButton

	if data.seeAllButton == nil then
		seeAllButton = defaultCarouselTemplate.seeAllButton
	else
		seeAllButton = data.seeAllButton
	end

	local title

	if data.title == nil then
		title = defaultCarouselTemplate.title
	else
		title = data.title
	end

	local localizedTitle

	if data.localizedTitle == nil then
		localizedTitle = defaultCarouselTemplate.localizedTitle
	else
		localizedTitle = data.localizedTitle
	end

	local description

	if data.description == nil then
		description = defaultCarouselTemplate.description
	else
		description = data.description
	end

	local localizedDescription

	if data.localizedDescription == nil then
		localizedDescription = defaultCarouselTemplate.localizedDescription
	else
		localizedDescription = data.localizedDescription
	end

	local itemFooters2

	if data.itemFooters == nil then
		itemFooters2 = defaultCarouselTemplate.itemFooters
	else
		itemFooters2 = data.itemFooters
	end

	return {
		type = "Carousel",
		numItemsToShow = numItemsToShow,
		seeAllButton = seeAllButton,
		title = title,
		localizedTitle = localizedTitle,
		description = description,
		localizedDescription = localizedDescription,
		itemFooters = itemFooters2,
		widgetStyle = mergeWidgetStyle(defaultCarouselTemplate.widgetStyle, data.widgetStyle),
		cardStyle = mergeCardStyle(defaultCarouselTemplate.cardStyle, data.cardStyle),
		previewRows = Cryo.Dictionary.join(defaultCarouselTemplate.previewRows or {}, data.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(defaultCarouselTemplate.previewColumns or {}, data.previewColumns or {})
	}
end

local function mergeHeroUnitTemplates(data, data2)
	local numItemsToShow

	if data2.numItemsToShow == nil then
		numItemsToShow = data.numItemsToShow
	else
		numItemsToShow = data2.numItemsToShow
	end

	local seeAllButton

	if data2.seeAllButton == nil then
		seeAllButton = data.seeAllButton
	else
		seeAllButton = data2.seeAllButton
	end

	local title = if data2.title == nil then data.title else data2.title
	local localizedTitle

	if data2.localizedTitle == nil then
		localizedTitle = data.localizedTitle
	else
		localizedTitle = data2.localizedTitle
	end

	local description

	if data2.description == nil then
		description = data.description
	else
		description = data2.description
	end

	local localizedDescription

	if data2.localizedDescription == nil then
		localizedDescription = data.localizedDescription
	else
		localizedDescription = data2.localizedDescription
	end

	local itemFooters2

	if data2.itemFooters == nil then
		itemFooters2 = data.itemFooters
	else
		itemFooters2 = data2.itemFooters
	end

	local v6 = {
		type = "HeroUnit",
		numItemsToShow = numItemsToShow,
		seeAllButton = seeAllButton,
		title = title,
		localizedTitle = localizedTitle,
		description = description,
		localizedDescription = localizedDescription,
		itemFooters = itemFooters2,
		widgetStyle = mergeWidgetStyle(data.widgetStyle, data2.widgetStyle),
		cardStyle = mergeCardStyle(data.cardStyle, data2.cardStyle),
		previewRows = Cryo.Dictionary.join(data.previewRows or {}, data2.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(data.previewColumns or {}, data2.previewColumns or {}),
		availableUntil = 0,
		button = 0
	}
	local availableUntil

	if data2.availableUntil == nil then
		availableUntil = data.availableUntil
	else
		availableUntil = data2.availableUntil
	end

	v6.availableUntil = availableUntil
	local button

	if FFlagAXHeroUnitActionButton then
		if data2.button == nil then
			button = data.button
		else
			button = data2.button
		end
	end

	v6.button = button
	return v6
end

local function convertCarouselTemplateToItemGroupTemplate(p)
	local clone = table.clone(p)
	clone.type = "ItemGroup"
	clone.numItemsToShow = nil
	return clone
end

local function formatWidgetListStateToWidgetListInfoViewModel(data, p: string, name: string?, p2: string?)
	local v6 = { configuration = {}, widgets = {} }
	local configuration

	if data then
		configuration = data.Configuration
	end

	local v7

	if FFlagAXNoCarouselsOnCatalogWithGamepad then
		v7 = p2 ~= Responsive.Input.Directional
	end

	local defaultCarouselTemplate = getDefaultCarouselTemplate(configuration) -- inferred equivalent call
	local defaultItemGroupTemplate = getDefaultItemGroupTemplate(configuration) -- inferred equivalent call

	if data and data.Details then
		for k, detail in data.Details do
			local v8

			if FFlagAXNoCarouselsOnCatalogWithGamepad then
				if detail.template.type == "Carousel" and not v7 then
					local template = detail.template
					v8 = table.clone(template)
					v8.type = "ItemGroup"
					v8.numItemsToShow = nil
				else
					v8 = detail.template
				end
			end

			if not FFlagAXNoCarouselsOnCatalogWithGamepad then
				v8 = detail.template
			end

			local kind = v8.type
			local v9 = kind == "Carousel"
			local template

			if kind == "HeroUnit" then
				template = formatWidgetTemplateAsHeroUnit(mergeHeroUnitTemplates(v3, v8), p, name)
			elseif v9 then
				template = formatWidgetTemplateAsCarousel(mergeCarouselTemplates(defaultCarouselTemplate, v8), p, name)
			else
				template = formatWidgetTemplateAsItemGroup(
					mergeItemGroupTemplates(defaultItemGroupTemplate, v8),
					p,
					name
				)
			end

			v6.widgets[k] = {
				id = detail.id,
				type = detail.type,
				content = detail.content,
				tagId = detail.tagId,
				template = template,
				requestId = data.RequestId
			}
		end
	end

	if configuration then
		v6.configuration.customizedDataMap = configuration.customizedDataMap
	end

	v6.configuration.defaultItemGroupTemplate = formatWidgetTemplateAsItemGroup(defaultItemGroupTemplate, p, name)

	v6.configuration.defaultItemCarouselTemplate = formatWidgetTemplateAsCarousel(defaultCarouselTemplate, p, name)

	return v6
end

local function useWidgetListInfoViewModel(p: string?, p2: string?, p3)
	local v6 = p3 or WidgetListBreakPointEnum.Default
	local v7

	if FFlagAXNoCarouselsOnCatalogWithGamepad then
		v7 = useSignalState(inputModeStore.getLastInputType)
	else
		v7 = nil
	end

	local v8 = useSelector((React.useCallback(function(p4)
		local searchesParameter = p4.SearchesParameters[p]
		local v8 = searchesParameter and searchesParameter.searchKeyword ~= nil
		local queryStringForSearchWidgets = getQueryStringForSearchWidgets(searchesParameter)

		if v8 then
			return p4.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[queryStringForSearchWidgets]
		end

		if p2 then
			return p4.AvatarExperience.Common.Widgets.ContextWidgetInfo[p2]
		end

		return p4.AvatarExperience.Common.Widgets.WidgetInfo
	end, { p, p2 })))
	local v9 = useTokens()
	local useMemo = React.useMemo
	local function fn()
		local name = v9.Config.ColorMode.Name
		local v10

		if FFlagAXNoCarouselsOnCatalogWithGamepad then
			v10 = v7
		end

		return formatWidgetListStateToWidgetListInfoViewModel(v8, v6, name, v10)
	end

	local name = v9.Config.ColorMode.Name
	local v10

	if FFlagAXNoCarouselsOnCatalogWithGamepad then
		v10 = v7
	end

	return (useMemo(fn, { name, v8, v6, v10 }))
end

return useWidgetListInfoViewModel
