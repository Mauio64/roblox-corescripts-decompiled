local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local buildDefaultProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildDefaultProp)
local buildStringProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildStringProp)
local buildTableProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildTableProp)
local buildRepeatedProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildRepeatedProp)
local buildContainerProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildContainerProp)
local buildNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentProp)
local buildLazyNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentProp)
local buildLazyNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentListProp)
local buildNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentListProp)
local buildActionProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildActionProp)
local SduiParsers = require(SduiCoreSystem.SduiParsers)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiClientBindingParsers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiClientBindingParsers)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiDevStoreSeeAllSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiDevStoreSeeAllSupport
local FFlagSduiEventDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiNestedComponentListProp = require(SduiCoreSystemParent.SharedFlags).FFlagSduiNestedComponentListProp
local FFlagSduiLazyNestedComponentProp = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLazyNestedComponentProp
local FFlagSduiMarketplaceCatalogCategorySupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiMarketplaceCatalogCategorySupport
local FFlagSduiMarketplaceCatalogSortSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiMarketplaceCatalogSortSupport
local FFlagSduiChartsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiSystemBannerComponent = require(SduiCoreSystemParent.SharedFlags).FFlagSduiSystemBannerComponent
local FFlagSduiTileHoldAction = require(SduiCoreSystemParent.SharedFlags).FFlagSduiTileHoldAction
local FFlagSduiGenericContainerDispatch = require(SduiCoreSystemParent.SharedFlags).FFlagSduiGenericContainerDispatch
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured

local function applyParser(p1, p2: ((...any) -> ...any)) -- line: 66
	return function(p3, p4, p5, p6, p7, p8) -- line: 70
		-- upvalues: p1 (copy), p2 (copy)
		local v314, v315 = p1(p3, p4, p5, p6, p7, p8, p2)

		return v314, v315
	end
end
local function createEngineEnumProtoBuilder(p9, s1: string) -- line: 91
	-- upvalues: buildDefaultProp (copy), SduiParsers (copy), ProtoVariableMapper (copy)
	local v84 = buildDefaultProp

	local function v85(p10) -- line: 92
		-- upvalues: SduiParsers (copy), p9 (copy), ProtoVariableMapper (copy), s1 (copy)
		local v317 = SduiParsers.getEngineEnumParser(p9)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p10, s1, v317)
	end

	return function(p11, p12, p13, p14, p15, p16) -- line: 70
		-- upvalues: v84 (copy), v85 (copy)
		local v324, v325 = v84(p11, p12, p13, p14, p15, p16, v85)

		return v324, v325
	end
end

local t1 = {
	StringProp = buildStringProp,
	BoolProp = buildDefaultProp,
	FloatProp = buildDefaultProp,
	DoubleProp = buildDefaultProp,
	Int32Prop = buildDefaultProp,
	Int64Prop = buildDefaultProp
}
local parseStruct = SduiClientBindingParsers.parseStruct

function t1.StructProp(p17, p18, p19, p20, p21, p22) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseStruct (copy)
	local v92, v93 = buildDefaultProp(p17, p18, p19, p20, p21, p22, parseStruct)

	return v92, v93
end

local parseImageStringProp_ = SduiParsers.parseImageStringProp_

function t1.ImageStringProp(p23, p24, p25, p26, p27, p28) -- line: 70
	-- upvalues: buildStringProp (copy), parseImageStringProp_ (copy)
	local v100, v101 = buildStringProp(p23, p24, p25, p26, p27, p28, parseImageStringProp_)

	return v100, v101
end

local parseImageSetOrImageProp_ = SduiParsers.parseImageSetOrImageProp_

function t1.ImageSetProp(p29, p30, p31, p32, p33, p34) -- line: 70
	-- upvalues: buildStringProp (copy), parseImageSetOrImageProp_ (copy)
	local v108, v109 = buildStringProp(p29, p30, p31, p32, p33, p34, parseImageSetOrImageProp_)

	return v108, v109
end

local fromHex = Color3.fromHex

function t1.ColorProp(p35, p36, p37, p38, p39, p40) -- line: 70
	-- upvalues: buildDefaultProp (copy), fromHex (copy)
	local v116, v117 = buildDefaultProp(p35, p36, p37, p38, p39, p40, fromHex)

	return v116, v117
end

t1.TypographyProp = buildDefaultProp
t1.TypographyFontProp = buildDefaultProp

local v35 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDimProp_ else SduiClientBindingParsers.parseUDim

function t1.UDimProp(p41, p42, p43, p44, p45, p46) -- line: 70
	-- upvalues: buildDefaultProp (copy), v35 (copy)
	local v124, v125 = buildDefaultProp(p41, p42, p43, p44, p45, p46, v35)

	return v124, v125
end

local v36 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDim2Prop_ else SduiClientBindingParsers.parseUDim2

function t1.UDim2Prop(p47, p48, p49, p50, p51, p52) -- line: 70
	-- upvalues: buildDefaultProp (copy), v36 (copy)
	local v132, v133 = buildDefaultProp(p47, p48, p49, p50, p51, p52, v36)

	return v132, v133
end

local parseVector2Prop_ = SduiParsers.parseVector2Prop_

function t1.Vector2Prop(p53, p54, p55, p56, p57, p58) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseVector2Prop_ (copy)
	local v140, v141 = buildDefaultProp(p53, p54, p55, p56, p57, p58, parseVector2Prop_)

	return v140, v141
end

t1.NestedComponentProp = buildNestedComponentProp
t1.LazyNestedComponentProp = if not FFlagSduiLazyNestedComponentProp then nil else buildLazyNestedComponentProp
t1.NestedComponentListProp = if not FFlagSduiNestedComponentListProp then nil else buildNestedComponentListProp
t1.LazyNestedComponentListProp = buildLazyNestedComponentListProp

local parseStringArray = SduiClientBindingParsers.parseStringArray

function t1.StringArrayProp(p59, p60, p61, p62, p63, p64) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseStringArray (copy)
	local v148, v149 = buildDefaultProp(p59, p60, p61, p62, p63, p64, parseStringArray)

	return v148, v149
end

local parseIconProp_ = SduiParsers.parseIconProp_

function t1.IconProp(p65, p66, p67, p68, p69, p70) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseIconProp_ (copy)
	local v156, v157 = buildDefaultProp(p65, p66, p67, p68, p69, p70, parseIconProp_)

	return v156, v157
end

local parseGradientProp_ = SduiParsers.parseGradientProp_

function t1.GradientProp(p71, p72, p73, p74, p75, p76) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseGradientProp_ (copy)
	local v164, v165 = buildDefaultProp(p71, p72, p73, p74, p75, p76, parseGradientProp_)

	return v164, v165
end

local parseArrayOfStruct = SduiClientBindingParsers.parseArrayOfStruct

function t1.ArrayOfStructProp(p77, p78, p79, p80, p81, p82) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseArrayOfStruct (copy)
	local v172, v173 = buildDefaultProp(p77, p78, p79, p80, p81, p82, parseArrayOfStruct)

	return v172, v173
end

t1.ActionProp = buildActionProp
t1.TableProp = buildTableProp
t1.ContainerProp = if not FFlagSduiGenericContainerDispatch then nil else buildContainerProp
t1.ArrayOfMenuItemProp = buildRepeatedProp
t1.MenuItemProp = buildTableProp
t1.MenuItem = buildTableProp
t1.GenericShareLinkData = buildTableProp
t1.ShareLinkFetchData = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildTableProp
t1.ExperienceShareLinkPayload = if not FFlagSduiExperienceDetailsSupport then nil else buildTableProp
t1.EventShareLinkPayload = if not FFlagSduiEventDetailsSupport then nil else buildTableProp
t1.MediaGallerySchema_MediaItemArrayProp = if not FFlagSduiExperienceDetailsSupport then nil else buildRepeatedProp
t1.ArrayOfSystemBannerActionsProp = if not FFlagSduiSystemBannerComponent then nil else buildRepeatedProp
t1.SystemBannerActionProp = if not FFlagSduiSystemBannerComponent then nil else buildTableProp
t1.FoundationIconConfigProp = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildTableProp
t1.HoldActionConfigProp = if not FFlagSduiTileHoldAction then nil else buildTableProp
t1.HoldActionConfig = if not FFlagSduiTileHoldAction then nil else buildTableProp
t1.OpenPurchasePromptAction_ProductPayload = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else buildTableProp
t1.OpenPurchasePromptAction_DisplayInfo = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else buildTableProp
t1.OpenPurchasePromptAction_PurchaseOptions = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else buildTableProp
t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else buildTableProp
t1.ArrayOfCatalogCategoryMenuItemProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildRepeatedProp
t1.CatalogCategoryMenuItem = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.ArrayOfCategoryMenuButtonProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildRepeatedProp
t1.CategoryMenuButtonProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.CategoryMenuButton = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.ArrayOfCatalogCategoryMenuTooltipInfoProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildRepeatedProp
t1.CatalogCategoryMenuTooltipInfoProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.CatalogCategoryMenuTooltipInfo = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.ArrayOfTooltipInfoActionsProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildRepeatedProp
t1.TooltipInfoActionPropsProp = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.TooltipInfoActionProps = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else buildTableProp
t1.ArrayOfCatalogSortContentProp = if not FFlagSduiMarketplaceCatalogSortSupport then nil else buildRepeatedProp
t1.ArrayOfItemFooterProp = if not FFlagSduiMarketplaceCatalogSortSupport then nil else buildRepeatedProp
t1.CardStyleProp = if not FFlagSduiMarketplaceCatalogSortSupport then nil else buildTableProp
t1.AnalyticsDataField = buildDefaultProp

local AutomaticSize = Enum.AutomaticSize
local s2 = "AUTOMATIC_SIZE_"

local function v44(p83) -- line: 92
	-- upvalues: SduiParsers (copy), AutomaticSize (copy), ProtoVariableMapper (copy), s2 (copy)
	local v175 = SduiParsers.getEngineEnumParser(AutomaticSize)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p83, s2, v175)
end

function t1.AutomaticSizeProp(p84, p85, p86, p87, p88, p89) -- line: 70
	-- upvalues: buildDefaultProp (copy), v44 (copy)
	local v182, v183 = buildDefaultProp(p84, p85, p86, p87, p88, p89, v44)

	return v182, v183
end

local TextTruncate = Enum.TextTruncate
local s3 = "TEXT_TRUNCATE_"

local function v47(p90) -- line: 92
	-- upvalues: SduiParsers (copy), TextTruncate (copy), ProtoVariableMapper (copy), s3 (copy)
	local v185 = SduiParsers.getEngineEnumParser(TextTruncate)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p90, s3, v185)
end

function t1.TextTruncateProp(p91, p92, p93, p94, p95, p96) -- line: 70
	-- upvalues: buildDefaultProp (copy), v47 (copy)
	local v192, v193 = buildDefaultProp(p91, p92, p93, p94, p95, p96, v47)

	return v192, v193
end

local TextXAlignment = Enum.TextXAlignment
local s4 = "TEXT_X_ALIGNMENT_"

local function v50(p97) -- line: 92
	-- upvalues: SduiParsers (copy), TextXAlignment (copy), ProtoVariableMapper (copy), s4 (copy)
	local v195 = SduiParsers.getEngineEnumParser(TextXAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p97, s4, v195)
end

function t1.TextXAlignmentProp(p98, p99, p100, p101, p102, p103) -- line: 70
	-- upvalues: buildDefaultProp (copy), v50 (copy)
	local v202, v203 = buildDefaultProp(p98, p99, p100, p101, p102, p103, v50)

	return v202, v203
end

local TextYAlignment = Enum.TextYAlignment
local s5 = "TEXT_Y_ALIGNMENT_"

local function v53(p104) -- line: 92
	-- upvalues: SduiParsers (copy), TextYAlignment (copy), ProtoVariableMapper (copy), s5 (copy)
	local v205 = SduiParsers.getEngineEnumParser(TextYAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p104, s5, v205)
end

function t1.TextYAlignmentProp(p105, p106, p107, p108, p109, p110) -- line: 70
	-- upvalues: buildDefaultProp (copy), v53 (copy)
	local v212, v213 = buildDefaultProp(p105, p106, p107, p108, p109, p110, v53)

	return v212, v213
end

local UIFlexMode = Enum.UIFlexMode
local s6 = "UI_FLEX_MODE_"

local function v56(p111) -- line: 92
	-- upvalues: SduiParsers (copy), UIFlexMode (copy), ProtoVariableMapper (copy), s6 (copy)
	local v215 = SduiParsers.getEngineEnumParser(UIFlexMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p111, s6, v215)
end

function t1.UIFlexModeProp(p112, p113, p114, p115, p116, p117) -- line: 70
	-- upvalues: buildDefaultProp (copy), v56 (copy)
	local v222, v223 = buildDefaultProp(p112, p113, p114, p115, p116, p117, v56)

	return v222, v223
end

local EnumScaleType = Enum.ScaleType
local s7 = "SCALE_TYPE_"

local function v59(p118) -- line: 92
	-- upvalues: SduiParsers (copy), EnumScaleType (copy), ProtoVariableMapper (copy), s7 (copy)
	local v225 = SduiParsers.getEngineEnumParser(EnumScaleType)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p118, s7, v225)
end

function t1.ScaleTypeProp(p119, p120, p121, p122, p123, p124) -- line: 70
	-- upvalues: buildDefaultProp (copy), v59 (copy)
	local v232, v233 = buildDefaultProp(p119, p120, p121, p122, p123, p124, v59)

	return v232, v233
end

local ResamplerMode = Enum.ResamplerMode
local s8 = "RESAMPLER_MODE_"

local function v62(p125) -- line: 92
	-- upvalues: SduiParsers (copy), ResamplerMode (copy), ProtoVariableMapper (copy), s8 (copy)
	local v235 = SduiParsers.getEngineEnumParser(ResamplerMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p125, s8, v235)
end

function t1.ResamplerModeProp(p126, p127, p128, p129, p130, p131) -- line: 70
	-- upvalues: buildDefaultProp (copy), v62 (copy)
	local v242, v243 = buildDefaultProp(p126, p127, p128, p129, p130, p131, v62)

	return v242, v243
end

local SizeConstraint = Enum.SizeConstraint
local s9 = "SIZE_CONSTRAINT_"

local function v65(p132) -- line: 92
	-- upvalues: SduiParsers (copy), SizeConstraint (copy), ProtoVariableMapper (copy), s9 (copy)
	local v245 = SduiParsers.getEngineEnumParser(SizeConstraint)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p132, s9, v245)
end

function t1.SizeConstraintProp(p133, p134, p135, p136, p137, p138) -- line: 70
	-- upvalues: buildDefaultProp (copy), v65 (copy)
	local v252, v253 = buildDefaultProp(p133, p134, p135, p136, p137, p138, v65)

	return v252, v253
end

local v69

if FFlagSduiChartsSupport then
	local SelectionBehavior = Enum.SelectionBehavior
	local s10 = "SELECTION_BEHAVIOR_"

	local function v68(p139) -- line: 92
		-- upvalues: SduiParsers (copy), SelectionBehavior (copy), ProtoVariableMapper (copy), s10 (copy)
		local v255 = SduiParsers.getEngineEnumParser(SelectionBehavior)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p139, s10, v255)
	end

	function v69(p140, p141, p142, p143, p144, p145) -- line: 70
		-- upvalues: buildDefaultProp (copy), v68 (copy)
		local v262, v263 = buildDefaultProp(p140, p141, p142, p143, p144, p145, v68)

		return v262, v263
	end
else
	v69 = nil
end

t1.SelectionBehaviorProp = v69

local v73

if FFlagSduiTileHoldAction or FFlagSduiFocusNavActionsStructured then
	local KeyCode = Enum.KeyCode
	local s11 = "KEY_CODE_"

	local function v72(p146) -- line: 92
		-- upvalues: SduiParsers (copy), KeyCode (copy), ProtoVariableMapper (copy), s11 (copy)
		local v265 = SduiParsers.getEngineEnumParser(KeyCode)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p146, s11, v265)
	end

	function v73(p147, p148, p149, p150, p151, p152) -- line: 70
		-- upvalues: buildDefaultProp (copy), v72 (copy)
		local v272, v273 = buildDefaultProp(p147, p148, p149, p150, p151, p152, v72)

		return v272, v273
	end
else
	v73 = nil
end

t1.KeyCodeProp = v73

local v75

if FFlagSduiFocusNavActionsStructured then
	local parseFocusNavActions = SduiClientBindingParsers.parseFocusNavActions

	function v75(p153, p154, p155, p156, p157, p158) -- line: 70
		-- upvalues: buildTableProp (copy), parseFocusNavActions (copy)
		local v280, v281 = buildTableProp(p153, p154, p155, p156, p157, p158, parseFocusNavActions)

		return v280, v281
	end
else
	v75 = nil
end

t1.FocusNavActionsProp = v75
t1.ColorStyleProp = buildDefaultProp

local parseUiScaledUDim2 = SduiClientBindingParsers.parseUiScaledUDim2

function t1.UiScaledUDim2Prop(p159, p160, p161, p162, p163, p164) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim2 (copy)
	local v288, v289 = buildDefaultProp(p159, p160, p161, p162, p163, p164, parseUiScaledUDim2)

	return v288, v289
end

local parseUiScaledUDim = SduiClientBindingParsers.parseUiScaledUDim

function t1.UiScaledUDimProp(p165, p166, p167, p168, p169, p170) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim (copy)
	local v296, v297 = buildDefaultProp(p165, p166, p167, p168, p169, p170, parseUiScaledUDim)

	return v296, v297
end

local parseUiScaledNumber = SduiClientBindingParsers.parseUiScaledNumber

function t1.UiScaledFloatProp(p171, p172, p173, p174, p175, p176) -- line: 70
	-- upvalues: buildDefaultProp (copy), parseUiScaledNumber (copy)
	local v304, v305 = buildDefaultProp(p171, p172, p173, p174, p175, p176, parseUiScaledNumber)

	return v304, v305
end

t1.FillBehaviorProp = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildDefaultProp
t1.InputSizeProp = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildDefaultProp
t1.LaunchExperienceAction_ExperienceJoinData = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildTableProp
t1.AvatarConfigProp = if not FFlagSduiExperienceDetailsSupport then nil else buildTableProp
t1.ArrayOfAvatarProp = if not FFlagSduiExperienceDetailsSupport then nil else buildRepeatedProp

local function getPropBuilder(s12: string) -- line: 248
	-- upvalues: t1 (copy), buildDefaultProp (copy)
	if not s12 then
		error("Failed to find prop builder -- missing propDescriptorName")
	end

	local v307 = t1[s12]

	if not v307 then
		warn(`Could not find propBuilder for propDescriptorName { s12 }. Using default.`)
		v307 = buildDefaultProp
	end

	return v307
end

return getPropBuilder
