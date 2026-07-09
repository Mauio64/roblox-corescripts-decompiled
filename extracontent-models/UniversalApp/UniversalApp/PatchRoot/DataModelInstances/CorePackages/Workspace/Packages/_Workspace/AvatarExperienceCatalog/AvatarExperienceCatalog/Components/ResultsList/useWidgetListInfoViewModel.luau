local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local useSelector = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(AvatarExperienceCatalogParent.React)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local useTokens = require(AvatarExperienceCatalogParent.Foundation).Hooks.useTokens
local Responsive = require(AvatarExperienceCatalogParent.Responsive)
local v9 = Responsive.GetInputModeStore(false)
local useSignalState = require(AvatarExperienceCatalogParent.SignalsReact).useSignalState
local FFlagAXNoCarouselsOnCatalogWithGamepad = require(AvatarExperienceCatalog.Flags.FFlagAXNoCarouselsOnCatalogWithGamepad)
local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget

require(AvatarExperienceCatalog.Models.WidgetListInfo)
require(script.Parent.WidgetListInfoViewModel)

local WidgetListBreakPointEnum = require(script.Parent.WidgetListBreakPointEnum)
local t1 = {
	{
		contentType = "ItemName"
	},
	{
		contentType = "Price"
	},
	{
		contentType = "AgentName"
	}
}
local t2 = {
	type = "Carousel",
	numItemsToShow = 12,
	itemFooters = t1,
	previewRows = {
		default = 1
	},
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}
local t3 = {
	type = "ItemGroup",
	itemFooters = t1,
	previewRows = {
		default = 1
	},
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}
local v17 = if not FFlagAXHeroWidget then nil else {
	type = "HeroUnit",
	itemFooters = t1,
	previewRows = {
		default = 1
	},
	previewColumns = {
		default = 3,
		medium = 4,
		large = 5,
		xLarge = 7,
		x2Large = 9
	}
}
local t4 = {
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
local t5 = {
	Dark = "dark",
	Light = "light",
	Default = "default"
}

local function getQueryStringForSearchWidgets(p1) -- line: 77
	if not p1 or not p1.searchKeyword then
		return nil
	end

	local t6 = { p1.searchKeyword }

	if p1.sortAndFilters and p1.sortAndFilters.SelectedTopics then
		for _, v51 in p1.sortAndFilters.SelectedTopics do
			table.insert(t6, 1, v51)
		end
	end

	return table.concat(t6, " ")
end
local function getDefaultItemGroupTemplate(p2) -- line: 92
	-- upvalues: Cryo (copy), t3 (copy)
	if p2 and p2.defaultItemGroupTemplate then
		return Cryo.Dictionary.join(t3, p2.defaultItemGroupTemplate)
	end

	if p2 and p2.defaultTemplate then
		return Cryo.Dictionary.join(t3, p2.defaultTemplate)
	end

	return t3
end
local function getDefaultCarouselTemplate(p3) -- line: 103
	-- upvalues: Cryo (copy), t2 (copy)
	if p3 and p3.defaultItemCarouselTemplate then
		return Cryo.Dictionary.join(t2, p3.defaultItemCarouselTemplate)
	end

	return t2
end
local function getResponsiveValue(p4, s1: string?) -- line: 110
	-- upvalues: t4 (copy)
	if not p4 then
		return nil
	end

	local v56 = (not s1 or not t4[s1]) and "default" or t4[s1]

	if p4[v56] then
		return p4[v56]
	end

	return p4.default
end
local function getThemeValue(p5, s2: string?) -- line: 118
	-- upvalues: t5 (copy)
	if not p5 then
		return nil
	end

	local v59 = (not s2 or not t5[s2]) and "default" or t5[s2]

	if p5[v59] then
		return p5[v59]
	end

	return p5.default
end
local function colorToColor3(p6) -- line: 126
	return Color3.new(p6.r, p6.g, p6.b)
end
local function pointToVector2(p7) -- line: 130
	return Vector2.new(p7.x, p7.y)
end
local function pointToUDim2(p8) -- line: 134
	return UDim2.fromOffset(p8.x, p8.y)
end
local function formatResponsivePointToVector(p9, s3: string?) -- line: 138
	-- upvalues: t4 (copy), pointToVector2 (copy)
	local v65

	if not p9 then
		v65 = nil
	else
		local v66 = (not s3 or not t4[s3]) and "default" or t4[s3]

		v65 = if not p9[v66] then p9.default else p9[v66]
	end

	return pointToVector2(v65 or {
		x = 0,
		y = 0
	})
end
local function formatResponsivePointToUDim2(p10, s4: string?) -- line: 146
	-- upvalues: t4 (copy), pointToUDim2 (copy)
	local v69

	if not p10 then
		v69 = nil
	else
		local v70 = (not s4 or not t4[s4]) and "default" or t4[s4]

		v69 = if not p10[v70] then p10.default else p10[v70]
	end

	return pointToUDim2(v69 or {
		x = 0,
		y = 0
	})
end
local function formatColorSequence(t7: {[any]: any}) -- line: 154
	-- upvalues: colorToColor3 (copy)
	local t8 = {}

	for _, v74 in t7 do
		table.insert(t8, ColorSequenceKeypoint.new(v74.time, colorToColor3(v74.color)))
	end

	return ColorSequence.new(t8)
end
local function formatNumberSequence(p11) -- line: 162
	if type(p11) == "number" then
		return NumberSequence.new(p11)
	end

	if #p11 == 0 then
		return nil
	end

	local t9 = {}

	for _, v78 in p11 do
		table.insert(t9, NumberSequenceKeypoint.new(v78.time, v78.number))
	end

	return NumberSequence.new(t9)
end
local function formatImageBackground(p12, s5: string?) -- line: 176
	-- upvalues: t4 (copy)
	local vector2

	if p12.anchorPoint then
		local anchorPoint = p12.anchorPoint
		local v82

		if not anchorPoint then
			v82 = nil
		else
			local v83 = (not s5 or not t4[s5]) and "default" or t4[s5]

			v82 = if not anchorPoint[v83] then anchorPoint.default else anchorPoint[v83]
		end

		local v84 = v82 or {
			x = 0,
			y = 0
		}

		vector2 = Vector2.new(v84.x, v84.y)
	else
		vector2 = nil
	end

	local uDim2

	if p12.position then
		local position = p12.position
		local v87

		if not position then
			v87 = nil
		else
			local v88 = (not s5 or not t4[s5]) and "default" or t4[s5]

			v87 = if not position[v88] then position.default else position[v88]
		end

		local v89 = v87 or {
			x = 0,
			y = 0
		}

		uDim2 = UDim2.fromOffset(v89.x, v89.y)
	else
		uDim2 = nil
	end

	local t10 = {
		type = "ImageBackground"
	}
	local v93

	if p12.resourceIdentifier then
		local resourceIdentifier = p12.resourceIdentifier

		if not resourceIdentifier then
			v93 = nil
		else
			local v94 = (not s5 or not t4[s5]) and "default" or t4[s5]

			v93 = if not resourceIdentifier[v94] then resourceIdentifier.default else resourceIdentifier[v94]
		end
	else
		v93 = nil
	end

	t10.resourceIdentifier = v93

	local color3

	if p12.color then
		local color = p12.color

		color3 = Color3.new(color.r, color.g, color.b)
	else
		color3 = nil
	end

	t10.color = color3
	t10.anchorPoint = vector2
	t10.position = uDim2

	local v98

	if p12.transparency then
		local transparency = p12.transparency

		if not transparency then
			v98 = nil
		else
			local v99 = (not s5 or not t4[s5]) and "default" or t4[s5]

			v98 = if not transparency[v99] then transparency.default else transparency[v99]
		end
	else
		v98 = nil
	end

	t10.transparency = v98

	return t10
end
local function formatGradientBackground(p13) -- line: 200
	-- upvalues: formatColorSequence (copy), formatNumberSequence (copy)
	local t11 = {
		type = "GradientBackground",
		colorSequence = formatColorSequence(p13.colorSequence),
		rotation = p13.rotation,
		transparency = if not p13.transparency then nil else formatNumberSequence(p13.transparency)
	}
	local vector2

	if p13.offset then
		local offset = p13.offset

		vector2 = Vector2.new(offset.x, offset.y)
	else
		vector2 = nil
	end

	t11.offset = vector2

	return t11
end
local function getFormattedBackgroundLayers(p14, s6: string, s7: string?) -- line: 214
	-- upvalues: t5 (copy), formatImageBackground (copy), formatGradientBackground (copy)
	local v107

	if not p14 then
		v107 = nil
	else
		local v108 = (not s7 or not t5[s7]) and "default" or t5[s7]

		v107 = if not p14[v108] then p14.default else p14[v108]
	end

	if not v107 then
		v107 = {}
	end

	local t12 = {}

	for _, v111 in v107 do
		if v111.type == "ImageBackground" then
			table.insert(t12, (formatImageBackground(v111, s6)))
		elseif v111.type == "GradientBackground" then
			table.insert(t12, (formatGradientBackground(v111)))
		end
	end

	return t12
end
local function formatCardStyle(p15, s8: string, s9: string?) -- line: 231
	-- upvalues: getFormattedBackgroundLayers (copy)
	return {
		backgroundLayers = if not p15.backgroundLayers then nil else getFormattedBackgroundLayers(p15.backgroundLayers, s8, s9),
		thumbnailAspectRatio = p15.thumbnailAspectRatio
	}
end
local function formatWidgetStyle(p16, s10: string, s11: string?) -- line: 244
	-- upvalues: getFormattedBackgroundLayers (copy)
	return {
		backgroundLayers = if not p16.backgroundLayers then nil else getFormattedBackgroundLayers(p16.backgroundLayers, s10, s11)
	}
end
local function formatWidgetTemplateAsItemGroup(p17, s12: string, s13: string?) -- line: 256
	-- upvalues: t4 (copy), getFormattedBackgroundLayers (copy)
	local previewColumns = p17.previewColumns
	local v122

	if not previewColumns then
		v122 = nil
	else
		local v123 = (not s12 or not t4[s12]) and "default" or t4[s12]

		v122 = if not previewColumns[v123] then previewColumns.default else previewColumns[v123]
	end

	local v124 = v122 or 1
	local previewRows = p17.previewRows
	local v126

	if not previewRows then
		v126 = nil
	else
		local v127 = (not s12 or not t4[s12]) and "default" or t4[s12]

		v126 = if not previewRows[v127] then previewRows.default else previewRows[v127]
	end

	local v128 = v126 or 1
	local t13 = {
		type = "ItemGroup",
		seeAllButton = p17.seeAllButton,
		title = p17.title,
		localizedTitle = p17.localizedTitle,
		description = p17.description,
		localizedDescription = p17.localizedDescription,
		itemFooters = p17.itemFooters
	}
	local t14

	if p17.widgetStyle then
		local widgetStyle = p17.widgetStyle

		t14 = {
			backgroundLayers = if not widgetStyle.backgroundLayers then nil else getFormattedBackgroundLayers(widgetStyle.backgroundLayers, s12, s13)
		}
	else
		t14 = nil
	end

	t13.widgetStyle = t14

	local t15

	if p17.cardStyle then
		local cardStyle = p17.cardStyle

		t15 = {
			backgroundLayers = if not cardStyle.backgroundLayers then nil else getFormattedBackgroundLayers(cardStyle.backgroundLayers, s12, s13),
			thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
		}
	else
		t15 = nil
	end

	t13.cardStyle = t15
	t13.previewRows = v128
	t13.previewColumns = v124

	return t13
end
local function formatWidgetTemplateAsCarousel(p18, s14: string, s15: string?) -- line: 278
	-- upvalues: t4 (copy), getFormattedBackgroundLayers (copy)
	local previewColumns = p18.previewColumns
	local v138

	if not previewColumns then
		v138 = nil
	else
		local v139 = (not s14 or not t4[s14]) and "default" or t4[s14]

		v138 = if not previewColumns[v139] then previewColumns.default else previewColumns[v139]
	end

	local v140 = v138 or 1
	local previewRows = p18.previewRows
	local v142

	if not previewRows then
		v142 = nil
	else
		local v143 = (not s14 or not t4[s14]) and "default" or t4[s14]

		v142 = if not previewRows[v143] then previewRows.default else previewRows[v143]
	end

	local v144 = v142 or 1
	local t16 = {
		type = "Carousel",
		numItemsToShow = p18.numItemsToShow,
		seeAllButton = p18.seeAllButton,
		title = p18.title,
		localizedTitle = p18.localizedTitle,
		description = p18.description,
		localizedDescription = p18.localizedDescription,
		itemFooters = p18.itemFooters
	}
	local t17

	if p18.widgetStyle then
		local widgetStyle = p18.widgetStyle

		t17 = {
			backgroundLayers = if not widgetStyle.backgroundLayers then nil else getFormattedBackgroundLayers(widgetStyle.backgroundLayers, s14, s15)
		}
	else
		t17 = nil
	end

	t16.widgetStyle = t17

	local t18

	if p18.cardStyle then
		local cardStyle = p18.cardStyle

		t18 = {
			backgroundLayers = if not cardStyle.backgroundLayers then nil else getFormattedBackgroundLayers(cardStyle.backgroundLayers, s14, s15),
			thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
		}
	else
		t18 = nil
	end

	t16.cardStyle = t18
	t16.previewRows = v144
	t16.previewColumns = v140

	return t16
end

local v39 = if not FFlagAXHeroWidget then nil else function(p19, s16: string, s17: string?) -- line: 302
	-- upvalues: t4 (copy), getFormattedBackgroundLayers (copy)
	local previewColumns = p19.previewColumns
	local v154

	if not previewColumns then
		v154 = nil
	else
		local v155 = (not s16 or not t4[s16]) and "default" or t4[s16]

		v154 = if not previewColumns[v155] then previewColumns.default else previewColumns[v155]
	end

	local v156 = v154 or 1
	local previewRows = p19.previewRows
	local v158

	if not previewRows then
		v158 = nil
	else
		local v159 = (not s16 or not t4[s16]) and "default" or t4[s16]

		v158 = if not previewRows[v159] then previewRows.default else previewRows[v159]
	end

	local v160 = v158 or 1
	local t19 = {
		type = "HeroUnit",
		numItemsToShow = p19.numItemsToShow,
		seeAllButton = p19.seeAllButton,
		title = p19.title,
		localizedTitle = p19.localizedTitle,
		description = p19.description,
		localizedDescription = p19.localizedDescription,
		itemFooters = p19.itemFooters
	}
	local t20

	if p19.widgetStyle then
		local widgetStyle = p19.widgetStyle

		t20 = {
			backgroundLayers = if not widgetStyle.backgroundLayers then nil else getFormattedBackgroundLayers(widgetStyle.backgroundLayers, s16, s17)
		}
	else
		t20 = nil
	end

	t19.widgetStyle = t20

	local t21

	if p19.cardStyle then
		local cardStyle = p19.cardStyle

		t21 = {
			backgroundLayers = if not cardStyle.backgroundLayers then nil else getFormattedBackgroundLayers(cardStyle.backgroundLayers, s16, s17),
			thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
		}
	else
		t21 = nil
	end

	t19.cardStyle = t21
	t19.previewRows = v160
	t19.previewColumns = v156
	t19.availableUntil = p19.availableUntil

	return t19
end

local function mergeCardStyle(p20, p21) -- line: 329
	-- upvalues: Cryo (copy)
	if not p20 and not p21 then
		return nil
	end

	local v168 = if not p21 then nil else p21.thumbnailAspectRatio
	local v169 = if not p20 then nil else p20.thumbnailAspectRatio

	return {
		thumbnailAspectRatio = if v168 ~= nil then v168 else v169,
		backgroundLayers = Cryo.Dictionary.join(if not p20 or not p20.backgroundLayers then {} else p20.backgroundLayers, if not p21 or not p21.backgroundLayers then {} else p21.backgroundLayers)
	}
end
local function mergeWidgetStyle(p22, p23) -- line: 345
	-- upvalues: Cryo (copy)
	if not p22 and not p23 then
		return nil
	end

	return {
		backgroundLayers = Cryo.Dictionary.join(if not p22 or not p22.backgroundLayers then {} else p22.backgroundLayers, if not p23 or not p23.backgroundLayers then {} else p23.backgroundLayers)
	}
end
local function mergeItemGroupTemplates(p24, p25) -- line: 360
	-- upvalues: mergeWidgetStyle (copy), mergeCardStyle (copy), Cryo (copy)
	return {
		type = "ItemGroup",
		seeAllButton = if p25.seeAllButton ~= nil then p25.seeAllButton else p24.seeAllButton,
		title = if p25.title ~= nil then p25.title else p24.title,
		localizedTitle = if p25.localizedTitle ~= nil then p25.localizedTitle else p24.localizedTitle,
		description = if p25.description ~= nil then p25.description else p24.description,
		localizedDescription = if p25.localizedDescription ~= nil then p25.localizedDescription else p24.localizedDescription,
		itemFooters = if p25.itemFooters ~= nil then p25.itemFooters else p24.itemFooters,
		widgetStyle = mergeWidgetStyle(p24.widgetStyle, p25.widgetStyle),
		cardStyle = mergeCardStyle(p24.cardStyle, p25.cardStyle),
		previewRows = Cryo.Dictionary.join(p24.previewRows or {}, p25.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(p24.previewColumns or {}, p25.previewColumns or {})
	}
end
local function mergeCarouselTemplates(p26, p27) -- line: 379
	-- upvalues: mergeWidgetStyle (copy), mergeCardStyle (copy), Cryo (copy)
	return {
		type = "Carousel",
		numItemsToShow = if p27.numItemsToShow ~= nil then p27.numItemsToShow else p26.numItemsToShow,
		seeAllButton = if p27.seeAllButton ~= nil then p27.seeAllButton else p26.seeAllButton,
		title = if p27.title ~= nil then p27.title else p26.title,
		localizedTitle = if p27.localizedTitle ~= nil then p27.localizedTitle else p26.localizedTitle,
		description = if p27.description ~= nil then p27.description else p26.description,
		localizedDescription = if p27.localizedDescription ~= nil then p27.localizedDescription else p26.localizedDescription,
		itemFooters = if p27.itemFooters ~= nil then p27.itemFooters else p26.itemFooters,
		widgetStyle = mergeWidgetStyle(p26.widgetStyle, p27.widgetStyle),
		cardStyle = mergeCardStyle(p26.cardStyle, p27.cardStyle),
		previewRows = Cryo.Dictionary.join(p26.previewRows or {}, p27.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(p26.previewColumns or {}, p27.previewColumns or {})
	}
end

local v44 = if not FFlagAXHeroWidget then nil else function(p28, p29) -- line: 400
	-- upvalues: mergeWidgetStyle (copy), mergeCardStyle (copy), Cryo (copy)
	return {
		type = "HeroUnit",
		numItemsToShow = if p29.numItemsToShow ~= nil then p29.numItemsToShow else p28.numItemsToShow,
		seeAllButton = if p29.seeAllButton ~= nil then p29.seeAllButton else p28.seeAllButton,
		title = if p29.title ~= nil then p29.title else p28.title,
		localizedTitle = if p29.localizedTitle ~= nil then p29.localizedTitle else p28.localizedTitle,
		description = if p29.description ~= nil then p29.description else p28.description,
		localizedDescription = if p29.localizedDescription ~= nil then p29.localizedDescription else p28.localizedDescription,
		itemFooters = if p29.itemFooters ~= nil then p29.itemFooters else p28.itemFooters,
		widgetStyle = mergeWidgetStyle(p28.widgetStyle, p29.widgetStyle),
		cardStyle = mergeCardStyle(p28.cardStyle, p29.cardStyle),
		previewRows = Cryo.Dictionary.join(p28.previewRows or {}, p29.previewRows or {}),
		previewColumns = Cryo.Dictionary.join(p28.previewColumns or {}, p29.previewColumns or {}),
		availableUntil = if p29.availableUntil ~= nil then p29.availableUntil else p28.availableUntil
	}
end

local function convertCarouselTemplateToItemGroupTemplate(p30) -- line: 424
	local v179 = table.clone(p30)

	v179.type = "ItemGroup"
	v179.numItemsToShow = nil

	return v179
end
local function formatWidgetListStateToWidgetListInfoViewModel(t22: {[any]: any}?, s18: string, s19: string?, s20: string?) -- line: 433
	-- upvalues: FFlagAXNoCarouselsOnCatalogWithGamepad (copy), Responsive (copy), Cryo (copy), t2 (copy), t3 (copy), FFlagAXHeroWidget (copy), v17 (copy), v39 (copy), v44 (copy), formatWidgetTemplateAsCarousel (copy), mergeCarouselTemplates (copy), formatWidgetTemplateAsItemGroup (copy), mergeItemGroupTemplates (copy)
	local t23 = {
		configuration = {},
		widgets = {}
	}
	local v185 = if not t22 then nil else t22.Configuration
	local v186 = if not FFlagAXNoCarouselsOnCatalogWithGamepad then nil else s20 ~= Responsive.Input.Directional
	local v187 = if not v185 or not v185.defaultItemCarouselTemplate then t2 else Cryo.Dictionary.join(t2, v185.defaultItemCarouselTemplate)
	local v188 = if not v185 or not v185.defaultItemGroupTemplate then if not v185 or not v185.defaultTemplate then t3 else Cryo.Dictionary.join(t3, v185.defaultTemplate) else Cryo.Dictionary.join(t3, v185.defaultItemGroupTemplate)
	local v189 = if not FFlagAXHeroWidget then nil else v17

	if t22 and t22.Details then
		for v190, v191 in t22.Details do
			local v193

			if FFlagAXNoCarouselsOnCatalogWithGamepad then
				if v191.template.type == "Carousel" and not v186 then
					local template = v191.template

					v193 = table.clone(template)
					v193.type = "ItemGroup"
					v193.numItemsToShow = nil
				else
					v193 = v191.template
				end
			else
				v193 = nil
			end

			local v197

			if FFlagAXHeroWidget then
				local v194 = if not FFlagAXNoCarouselsOnCatalogWithGamepad then v191.template else v193
				local type2 = v194.type
				local v196 = type2 == "Carousel"

				v197 = if type2 ~= "HeroUnit" then if not v196 then formatWidgetTemplateAsItemGroup(mergeItemGroupTemplates(v188, v194), s18, s19) else formatWidgetTemplateAsCarousel(mergeCarouselTemplates(v187, v194), s18, s19) else v39(v44(v189, v194), s18, s19)
			else
				v197 = if not if not FFlagAXNoCarouselsOnCatalogWithGamepad then v191.template.type == "Carousel" else v193.type == "Carousel" then formatWidgetTemplateAsItemGroup(mergeItemGroupTemplates(v188, if not FFlagAXNoCarouselsOnCatalogWithGamepad then v191.template else v193), s18, s19) else formatWidgetTemplateAsCarousel(mergeCarouselTemplates(v187, if not FFlagAXNoCarouselsOnCatalogWithGamepad then v191.template else v193), s18, s19)
			end

			t23.widgets[v190] = {
				id = v191.id,
				type = v191.type,
				content = v191.content,
				tagId = v191.tagId,
				template = v197,
				requestId = t22.RequestId
			}
		end
	end

	if v185 then
		t23.configuration.customizedDataMap = v185.customizedDataMap
	end

	t23.configuration.defaultItemGroupTemplate = formatWidgetTemplateAsItemGroup(v188, s18, s19)
	t23.configuration.defaultItemCarouselTemplate = formatWidgetTemplateAsCarousel(v187, s18, s19)

	return t23
end
local function useWidgetListInfoViewModel(s21: string?, s22: string?, p31) -- line: 545
	-- upvalues: WidgetListBreakPointEnum (copy), FFlagAXNoCarouselsOnCatalogWithGamepad (copy), useSignalState (copy), v9 (copy), React (copy), getQueryStringForSearchWidgets (copy), useSelector (copy), useTokens (copy), formatWidgetListStateToWidgetListInfoViewModel (copy)
	local v201 = p31 or WidgetListBreakPointEnum.Default
	local v202 = if not FFlagAXNoCarouselsOnCatalogWithGamepad then nil else useSignalState(v9.getLastInputType)
	local v203 = React.useCallback(function(p32) -- line: 554
		-- upvalues: s21 (copy), getQueryStringForSearchWidgets (copy), s22 (copy)
		local v207 = p32.SearchesParameters[s21]
		local v208 = v207 and v207.searchKeyword ~= nil
		local v209 = getQueryStringForSearchWidgets(v207)

		if v208 then
			return p32.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[v209]
		end

		if s22 then
			return p32.AvatarExperience.Common.Widgets.ContextWidgetInfo[s22]
		end

		return p32.AvatarExperience.Common.Widgets.WidgetInfo
	end, {
		s21,
		s22
	})
	local v204 = useSelector(v203)
	local v205 = useTokens()

	return (React.useMemo(function() -- line: 570
		-- upvalues: formatWidgetListStateToWidgetListInfoViewModel (copy), v204 (copy), v201 (copy), v205 (copy), FFlagAXNoCarouselsOnCatalogWithGamepad (copy), v202 (copy)
		return (formatWidgetListStateToWidgetListInfoViewModel(v204, v201, v205.Config.ColorMode.Name, if not FFlagAXNoCarouselsOnCatalogWithGamepad then nil else v202))
	end, {
		v205.Config.ColorMode.Name,
		v204,
		v201,
		if not FFlagAXNoCarouselsOnCatalogWithGamepad then nil else v202
	}))
end

return useWidgetListInfoViewModel
