local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local normalize = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local HttpService = game:GetService("HttpService")

require(AvatarExperienceCatalog.Models.CatalogCategories)

local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesSDUITaxonomy = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUITaxonomy
local FFlagAXCatalogCategoriesSDUIPillTitleNormalization = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUIPillTitleNormalization

local function SearchUuid() -- line: 21
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(true)
end
local function extractShowCatalogContentActionRequestParams(p1) -- line: 39
	if p1.props and p1.props.OnActivated then
		for _, v43 in p1.props.OnActivated do
			if v43.componentType == "ShowCatalogContentAction" then
				return v43.props and v43.props.requestParams
			end
		end
	end

	return nil
end
local function extractWidgetContext(p2) -- line: 53
	if p2.props and p2.props.OnActivated then
		for _, v46 in p2.props.OnActivated do
			if v46.componentType == "ShowWidgetContentAction" then
				return v46.props and (v46.props.requestParams and v46.props.requestParams.context)
			end
		end
	end

	return nil
end
local function stringToBoolean(p3) -- line: 69
	if type(p3) == "boolean" then
		return p3, nil
	end

	if type(p3) == "string" then
		if p3 == "True" then
			return true, nil
		end

		if p3 == "False" then
			return false, nil
		end

		return nil, "Invalid boolean string value, expected \"True\" or \"False\""
	end

	return nil, "Expected boolean or string"
end
local function splitCommaSeparatedString(s1: string?) -- line: 88
	if not s1 or s1 == "" then
		return nil
	end

	local t1 = {}

	for _, v51 in (string.split(s1, ",")) do
		if v51 ~= "" then
			table.insert(t1, v51)
		end
	end

	return #t1 > 0 and t1 or nil
end
local function normalizeAssetTypeIdStrings(p4) -- line: 105
	-- upvalues: extractShowCatalogContentActionRequestParams (copy), normalizeString (copy), splitCommaSeparatedString (copy)
	local v53 = extractShowCatalogContentActionRequestParams(p4)
	local v54 = v53 and v53.assetTypeIds

	if v54 == nil or v54 == "" then
		return nil, nil
	end

	local v55, v56 = normalizeString(v54)

	if v56 then
		return nil, v56
	end

	return splitCommaSeparatedString(v55), nil
end
local function normalizeBundleTypes(p5) -- line: 123
	-- upvalues: extractShowCatalogContentActionRequestParams (copy), normalizeString (copy), splitCommaSeparatedString (copy)
	local v58 = extractShowCatalogContentActionRequestParams(p5)
	local v59 = v58 and v58.bundleTypeIds

	if v59 == nil or v59 == "" then
		return nil, nil
	end

	local v60, v61 = normalizeString(v59)

	if v61 then
		return nil, v61
	end

	return splitCommaSeparatedString(v60), nil
end
local function normalizeTaxonomy(p6) -- line: 141
	-- upvalues: extractShowCatalogContentActionRequestParams (copy), normalizeNotEmptyString (copy)
	local v63 = extractShowCatalogContentActionRequestParams(p6)
	local v64 = v63 and v63.taxonomyId
	local v65, v66 = normalizeNotEmptyString(v64)

	return v65, v66
end
local function normalizeWidgetContext(p7) -- line: 150
	-- upvalues: extractWidgetContext (copy)
	return extractWidgetContext(p7), nil
end
local function normalizeSearchUuid() -- line: 156
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(true), nil
end
local function normalizePillTitle(p8) -- line: 162
	-- upvalues: FFlagAXCatalogCategoriesSDUIPillTitleNormalization (copy), normalizeNotEmptyString (copy), normalizeString (copy)
	local v69 = p8.props and p8.props.pillTitle

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		local v70, v71 = normalizeNotEmptyString(v69)

		return v70, v71
	end

	local v72, v73 = normalizeString(v69)

	return v72, v73
end
local function normalizePillId(p9) -- line: 174
	-- upvalues: FFlagAXCatalogCategoriesSDUIPillTitleNormalization (copy), normalizeNotEmptyString (copy), normalizeString (copy)
	local v75 = p9.props and p9.props.pillId

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		local v76, v77 = normalizeNotEmptyString(v75)

		return v76, v77
	end

	local v78, v79 = normalizeString(v75)

	return v78, v79
end
local function normalizeTimeToRefresh(p10) -- line: 186
	-- upvalues: normalizeNumber (copy)
	local v81 = p10.props and p10.props.timeToRefresh

	if v81 == nil or v81 == "" then
		return nil, nil
	end

	if type(v81) == "string" then
		v81 = tonumber(v81)
	end

	if v81 == nil then
		return nil, nil
	end

	local v82, v83 = normalizeNumber(v81)

	return v82, v83
end
local function normalizeCameraFocus(p11) -- line: 204
	-- upvalues: normalizeNotEmptyString (copy)
	local v85 = p11.props and p11.props.cameraFocus
	local v86, v87 = normalizeNotEmptyString(v85)

	return v86, v87
end
local function normalizeCameraZoomRadius(p12) -- line: 211
	-- upvalues: normalizeNumber (copy)
	local v89 = p12.props and p12.props.cameraZoomRadius

	if v89 == nil or v89 == "" then
		return nil, nil
	end

	if type(v89) == "string" then
		v89 = tonumber(v89)
	end

	if v89 == nil then
		return nil, nil
	end

	local v90, v91 = normalizeNumber(v89)

	return v90, v91
end
local function normalizeCanAnimateCameraBasedMood(p13) -- line: 229
	-- upvalues: normalizeBoolean (copy)
	local v93 = p13.props and p13.props.canAnimateCameraBasedMood

	if v93 == nil or v93 == "" then
		return nil, nil
	end

	local v94

	if type(v93) == "boolean" then
		v94 = nil
	elseif type(v93) == "string" then
		if v93 == "True" then
			v93 = true
			v94 = nil
		elseif v93 == "False" then
			v93 = false
			v94 = nil
		else
			v93 = nil
			v94 = "Invalid boolean string value, expected \"True\" or \"False\""
		end
	else
		v93 = nil
		v94 = "Expected boolean or string"
	end

	if v94 then
		return nil, v94
	end

	local v95, v96 = normalizeBoolean(v93)

	return v95, v96
end
local function normalizeDisableFilters(p14) -- line: 245
	-- upvalues: normalizeBoolean (copy)
	local v98 = p14.props and p14.props.disableFilters

	if v98 == nil or v98 == "" then
		return nil, nil
	end

	local v99

	if type(v98) == "boolean" then
		v99 = nil
	elseif type(v98) == "string" then
		if v98 == "True" then
			v98 = true
			v99 = nil
		elseif v98 == "False" then
			v98 = false
			v99 = nil
		else
			v98 = nil
			v99 = "Invalid boolean string value, expected \"True\" or \"False\""
		end
	else
		v98 = nil
		v99 = "Expected boolean or string"
	end

	if v99 then
		return nil, v99
	end

	local v100, v101 = normalizeBoolean(v98)

	return v100, v101
end
local function normalizePageType(p15) -- line: 261
	-- upvalues: normalizeNotEmptyString (copy)
	local v103 = p15.props and p15.props.pageType
	local v104, v105 = normalizeNotEmptyString(v103)

	return v104, v105
end
local function normalizeLooksWidgetContextForOrganicContent(p16) -- line: 268
	-- upvalues: extractShowCatalogContentActionRequestParams (copy), normalizeString (copy)
	local v107 = extractShowCatalogContentActionRequestParams(p16)
	local v108 = v107 and v107.context

	if v108 == nil or v108 == "" then
		return nil, nil
	end

	local v109, v110 = normalizeString(v108)

	return v109, v110
end
local function normalizeTooltipKey(p17) -- line: 281
	-- upvalues: normalizeNotEmptyString (copy)
	local v112 = p17.props and p17.props.tooltipKey
	local v113, v114 = normalizeNotEmptyString(v112)

	return v113, v114
end
local function normalizeTooltipBody(p18) -- line: 288
	-- upvalues: normalizeNotEmptyString (copy)
	local v116 = p18.props and p18.props.tooltipBody
	local v117, v118 = normalizeNotEmptyString(v116)

	return v117, v118
end
local function normalizeTileType(p19) -- line: 295
	-- upvalues: normalizeNotEmptyString (copy)
	local v120 = p19.props and p19.props.tileType
	local v121, v122 = normalizeNotEmptyString(v120)

	return v121, v122
end

local u35 = nil

local function u36(p20) -- line: 306
	-- upvalues: u35 (ref)
	if not p20.props or (not p20.props.Configs or type(p20.props.Configs) ~= "table") then
		return nil, nil
	end

	local t2 = {}
	local t3 = {}

	for _, v127 in p20.props.Configs do
		local v128, v129 = u35(v127)

		if v129 then
			table.insert(t3, v129)
		end

		if v128 and not v129 then
			table.insert(t2, v128)
		end
	end

	local v130 = nil

	if next(t3) then
		v130 = table.concat(t3, " ")
	end

	return t2, v130
end
local function normalizeCategoryOrSubcategory(p21, t4: {[any]: any}) -- line: 334
	-- upvalues: FFlagAXCatalogCategoriesSDUIPillTitleNormalization (copy), normalizeNotEmptyString (copy), normalizeString (copy), HttpService (copy), extractShowCatalogContentActionRequestParams (copy), splitCommaSeparatedString (copy), FFlagAXCatalogCategoriesSDUITaxonomy (copy), extractWidgetContext (copy), normalizeNumber (copy), u36 (ref), normalizeBoolean (copy)
	if type(p21) ~= "table" then
		return nil, "Config must be a table"
	end

	local t5 = {}
	local v134 = p21.props and p21.props.pillId
	local v135, v136

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		v135, v136 = normalizeNotEmptyString(v134)
	else
		v135, v136 = normalizeString(v134)
	end

	if v136 then
		table.insert(t5, "Id: " .. v136)
	end

	local v137 = p21.props and p21.props.pillTitle
	local v138, v139

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		v138, v139 = normalizeNotEmptyString(v137)
	else
		v138, v139 = normalizeString(v137)
	end

	if v139 then
		table.insert(t5, "Name: " .. v139)
	end

	local v140 = p21.props and p21.props.pillTitle
	local v141, v142

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		v141, v142 = normalizeNotEmptyString(v140)
	else
		v141, v142 = normalizeString(v140)
	end

	if v142 then
		table.insert(t5, "LocalizedTitle: " .. v142)
	end

	local v143 = p21.props and p21.props.pillTitle
	local v144, v145

	if FFlagAXCatalogCategoriesSDUIPillTitleNormalization then
		v144, v145 = normalizeNotEmptyString(v143)
	else
		v144, v145 = normalizeString(v143)
	end

	if v145 then
		table.insert(t5, "Title: " .. v145)
	end

	local guid = HttpService:GenerateGUID(true)
	local v147 = nil

	if v147 then
		table.insert(t5, "SearchUuid: " .. v147)
	end

	local v148 = extractShowCatalogContentActionRequestParams(p21)
	local v149 = v148 and v148.assetTypeIds
	local v150, v151

	if v149 == nil or v149 == "" then
		v150 = nil
		v151 = nil
	else
		local v152

		v152, v151 = normalizeString(v149)

		if v151 then
			v150 = nil
		else
			v150 = splitCommaSeparatedString(v152)
			v151 = nil
		end
	end

	if v151 then
		table.insert(t5, "AssetTypeIdStrings: " .. v151)
	end

	local v153 = extractShowCatalogContentActionRequestParams(p21)
	local v154 = v153 and v153.bundleTypeIds
	local v155, v156

	if v154 == nil or v154 == "" then
		v155 = nil
		v156 = nil
	else
		local v157

		v157, v156 = normalizeString(v154)

		if v156 then
			v155 = nil
		else
			v155 = splitCommaSeparatedString(v157)
			v156 = nil
		end
	end

	if v156 then
		table.insert(t5, "BundleTypes: " .. v156)
	end

	local v158 = nil

	if FFlagAXCatalogCategoriesSDUITaxonomy then
		local v159 = extractShowCatalogContentActionRequestParams(p21)
		local v160 = v159 and v159.taxonomyId
		local v161

		v158, v161 = normalizeNotEmptyString(v160)

		if v161 then
			table.insert(t5, "Taxonomy: " .. v161)
		end
	end

	local v162 = extractWidgetContext(p21)
	local v163 = nil

	if v163 then
		table.insert(t5, "WidgetContext: " .. v163)
	end

	local v164 = p21.props and p21.props.timeToRefresh
	local v165, v166

	if v164 == nil or v164 == "" then
		v165 = nil
		v166 = nil
	else
		if type(v164) == "string" then
			v164 = tonumber(v164)
		end

		if v164 == nil then
			v165 = nil
			v166 = nil
		else
			v165, v166 = normalizeNumber(v164)
		end
	end

	if v166 then
		table.insert(t5, "TimeToRefresh: " .. v166)
	end

	local v167 = p21.props and p21.props.cameraFocus
	local v168, v169 = normalizeNotEmptyString(v167)

	if v169 then
		table.insert(t5, "CameraFocus: " .. v169)
	end

	local v170 = p21.props and p21.props.cameraZoomRadius
	local v171, v172

	if v170 == nil or v170 == "" then
		v171 = nil
		v172 = nil
	else
		if type(v170) == "string" then
			v170 = tonumber(v170)
		end

		if v170 == nil then
			v171 = nil
			v172 = nil
		else
			v171, v172 = normalizeNumber(v170)
		end
	end

	if v172 then
		table.insert(t5, "CameraZoomRadius: " .. v172)
	end

	local v173 = nil

	if not t4.isSubcategory then
		local v174

		v173, v174 = u36(p21)

		if v174 then
			table.insert(t5, "Subcategories: " .. v174)
		end
	end

	local v175 = p21.props and p21.props.canAnimateCameraBasedMood
	local v176, v177

	if v175 == nil or v175 == "" then
		v176 = nil
		v177 = nil
	else
		if type(v175) == "boolean" then
			v177 = nil
		elseif type(v175) == "string" then
			if v175 == "True" then
				v175 = true
				v177 = nil
			elseif v175 == "False" then
				v175 = false
				v177 = nil
			else
				v175 = nil
				v177 = "Invalid boolean string value, expected \"True\" or \"False\""
			end
		else
			v175 = nil
			v177 = "Expected boolean or string"
		end

		if v177 then
			v176 = nil
		else
			v176, v177 = normalizeBoolean(v175)
		end
	end

	if v177 then
		table.insert(t5, "CanAnimateCameraBasedMood: " .. v177)
	end

	local v178 = p21.props and p21.props.disableFilters
	local v179, v180

	if v178 == nil or v178 == "" then
		v179 = nil
		v180 = nil
	else
		if type(v178) == "boolean" then
			v180 = nil
		elseif type(v178) == "string" then
			if v178 == "True" then
				v178 = true
				v180 = nil
			elseif v178 == "False" then
				v178 = false
				v180 = nil
			else
				v178 = nil
				v180 = "Invalid boolean string value, expected \"True\" or \"False\""
			end
		else
			v178 = nil
			v180 = "Expected boolean or string"
		end

		if v180 then
			v179 = nil
		else
			v179, v180 = normalizeBoolean(v178)
		end
	end

	if v180 then
		table.insert(t5, "DisableFilters: " .. v180)
	end

	local v181 = p21.props and p21.props.pageType
	local v182, v183 = normalizeNotEmptyString(v181)

	if v183 then
		table.insert(t5, "PageType: " .. v183)
	end

	local v184 = extractShowCatalogContentActionRequestParams(p21)
	local v185 = v184 and v184.context
	local v186, v187

	if v185 == nil or v185 == "" then
		v186 = nil
		v187 = nil
	else
		v186, v187 = normalizeString(v185)
	end

	if v187 then
		table.insert(t5, "LooksWidgetContextForOrganicContent: " .. v187)
	end

	local v188 = p21.props and p21.props.tooltipKey
	local v189, v190 = normalizeNotEmptyString(v188)

	if v190 then
		table.insert(t5, "TooltipKey: " .. v190)
	end

	local v191 = p21.props and p21.props.tooltipBody
	local v192, v193 = normalizeNotEmptyString(v191)

	if v193 then
		table.insert(t5, "TooltipBody: " .. v193)
	end

	local v194 = p21.props and p21.props.tileType
	local v195, v196 = normalizeNotEmptyString(v194)

	if v196 then
		table.insert(t5, "TileType: " .. v196)
	end

	if #t5 > 0 then
		return nil, (not t4.isSubcategory and "Category" or "Subcategory") .. " normalization failed: " .. table.concat(t5, "; ")
	end

	local t6 = {
		Id = v135,
		Name = v138,
		LocalizedTitle = v141,
		Title = v144,
		SearchUuid = guid,
		AssetTypeIdStrings = v150,
		BundleTypes = v155,
		TaxonomyUuid = if not FFlagAXCatalogCategoriesSDUITaxonomy then nil else v158,
		WidgetContext = v162,
		TimeToRefresh = v165,
		CameraFocus = v168,
		CameraZoomRadius = v171,
		CanAnimateCameraBasedMood = v176,
		DisableFilters = v179,
		PageType = v182,
		LooksWidgetContextForOrganicContent = v186,
		TooltipKey = v189,
		TooltipBody = v192,
		TileType = v195
	}

	if t4.isSubcategory then
		t6.isSubcategory = true
	elseif v173 and #v173 > 0 then
		t6.Subcategories = v173
	end

	return t6, nil
end

function u35(p22) -- line: 491
	-- upvalues: normalizeCategoryOrSubcategory (copy)
	return normalizeCategoryOrSubcategory(p22, {
		isSubcategory = true
	})
end

local function u38(p23) -- line: 497
	-- upvalues: normalizeCategoryOrSubcategory (copy)
	return normalizeCategoryOrSubcategory(p23, {
		isSubcategory = false
	})
end
local function normalizeConfigs(p24) -- line: 502
	-- upvalues: u38 (ref)
	if type(p24) ~= "table" then
		return {}, "Configs field must be a table"
	end

	local t7 = {}
	local t8 = {}

	for _, v204 in p24 do
		local v205, v206 = u38(v204)

		if v206 then
			table.insert(t8, v206)
		end

		if v205 and not v206 then
			table.insert(t7, v205)
		end
	end

	local v207 = nil

	if next(t8) then
		v207 = table.concat(t8, " ")
	end

	return t7, v207
end

local v40 = makeNormalizeTableFn({
	Configs = {
		fn = normalizeConfigs
	}
})

return function(p25) -- line: 535
	-- upvalues: v40 (copy)
	if not p25 or type(p25.Configs) ~= "table" then
		return {}, "Configs field is required and must be a table"
	end

	local v209, v210 = v40(p25)

	return v209 and v209.Configs or {}, v210
end
