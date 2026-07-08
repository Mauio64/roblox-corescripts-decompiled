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
local FFlagSduiOverflowMenuComponent = require(SduiCoreSystemParent.SharedFlags).FFlagSduiOverflowMenuComponent
local FFlagSduiStructPropParsers = require(SduiCoreSystemParent.SharedFlags).FFlagSduiStructPropParsers
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

local function applyParser(p1, p2: ((...any) -> ...any)) -- line: 68
	return function(p3, p4, p5, p6, p7, p8) -- line: 72
		-- upvalues: p1 (copy), p2 (copy)
		local v318, v319 = p1(p3, p4, p5, p6, p7, p8, p2)

		return v318, v319
	end
end
local function createEngineEnumProtoBuilder(p9, s1: string) -- line: 93
	-- upvalues: buildDefaultProp (copy), SduiParsers (copy), ProtoVariableMapper (copy)
	local v88 = buildDefaultProp

	local function v89(p10) -- line: 94
		-- upvalues: SduiParsers (copy), p9 (copy), ProtoVariableMapper (copy), s1 (copy)
		local v321 = SduiParsers.getEngineEnumParser(p9)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p10, s1, v321)
	end

	return function(p11, p12, p13, p14, p15, p16) -- line: 72
		-- upvalues: v88 (copy), v89 (copy)
		local v328, v329 = v88(p11, p12, p13, p14, p15, p16, v89)

		return v328, v329
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
local v34

if FFlagSduiStructPropParsers then
	local parseStruct = SduiClientBindingParsers.parseStruct

	function v34(p17, p18, p19, p20, p21, p22) -- line: 72
		-- upvalues: buildDefaultProp (copy), parseStruct (copy)
		local v96, v97 = buildDefaultProp(p17, p18, p19, p20, p21, p22, parseStruct)

		return v96, v97
	end
else
	v34 = buildDefaultProp
end

t1.StructProp = v34

local parseImageStringProp_ = SduiParsers.parseImageStringProp_

function t1.ImageStringProp(p23, p24, p25, p26, p27, p28) -- line: 72
	-- upvalues: buildStringProp (copy), parseImageStringProp_ (copy)
	local v104, v105 = buildStringProp(p23, p24, p25, p26, p27, p28, parseImageStringProp_)

	return v104, v105
end

local parseImageSetOrImageProp_ = SduiParsers.parseImageSetOrImageProp_

function t1.ImageSetProp(p29, p30, p31, p32, p33, p34) -- line: 72
	-- upvalues: buildStringProp (copy), parseImageSetOrImageProp_ (copy)
	local v112, v113 = buildStringProp(p29, p30, p31, p32, p33, p34, parseImageSetOrImageProp_)

	return v112, v113
end

local fromHex = Color3.fromHex

function t1.ColorProp(p35, p36, p37, p38, p39, p40) -- line: 72
	-- upvalues: buildDefaultProp (copy), fromHex (copy)
	local v120, v121 = buildDefaultProp(p35, p36, p37, p38, p39, p40, fromHex)

	return v120, v121
end

t1.TypographyProp = buildDefaultProp
t1.TypographyFontProp = buildDefaultProp

local v38 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDimProp_ else SduiClientBindingParsers.parseUDim

function t1.UDimProp(p41, p42, p43, p44, p45, p46) -- line: 72
	-- upvalues: buildDefaultProp (copy), v38 (copy)
	local v128, v129 = buildDefaultProp(p41, p42, p43, p44, p45, p46, v38)

	return v128, v129
end

local v39 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDim2Prop_ else SduiClientBindingParsers.parseUDim2

function t1.UDim2Prop(p47, p48, p49, p50, p51, p52) -- line: 72
	-- upvalues: buildDefaultProp (copy), v39 (copy)
	local v136, v137 = buildDefaultProp(p47, p48, p49, p50, p51, p52, v39)

	return v136, v137
end

local parseVector2Prop_ = SduiParsers.parseVector2Prop_

function t1.Vector2Prop(p53, p54, p55, p56, p57, p58) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseVector2Prop_ (copy)
	local v144, v145 = buildDefaultProp(p53, p54, p55, p56, p57, p58, parseVector2Prop_)

	return v144, v145
end

t1.NestedComponentProp = buildNestedComponentProp
t1.LazyNestedComponentProp = if not FFlagSduiLazyNestedComponentProp then nil else buildLazyNestedComponentProp
t1.NestedComponentListProp = if not FFlagSduiNestedComponentListProp then nil else buildNestedComponentListProp
t1.LazyNestedComponentListProp = buildLazyNestedComponentListProp

local parseStringArray = SduiClientBindingParsers.parseStringArray

function t1.StringArrayProp(p59, p60, p61, p62, p63, p64) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseStringArray (copy)
	local v152, v153 = buildDefaultProp(p59, p60, p61, p62, p63, p64, parseStringArray)

	return v152, v153
end

local parseIconProp_ = SduiParsers.parseIconProp_

function t1.IconProp(p65, p66, p67, p68, p69, p70) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseIconProp_ (copy)
	local v160, v161 = buildDefaultProp(p65, p66, p67, p68, p69, p70, parseIconProp_)

	return v160, v161
end

local parseGradientProp_ = SduiParsers.parseGradientProp_

function t1.GradientProp(p71, p72, p73, p74, p75, p76) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseGradientProp_ (copy)
	local v168, v169 = buildDefaultProp(p71, p72, p73, p74, p75, p76, parseGradientProp_)

	return v168, v169
end

local v45

if FFlagSduiStructPropParsers then
	local parseArrayOfStruct = SduiClientBindingParsers.parseArrayOfStruct

	function v45(p77, p78, p79, p80, p81, p82) -- line: 72
		-- upvalues: buildDefaultProp (copy), parseArrayOfStruct (copy)
		local v176, v177 = buildDefaultProp(p77, p78, p79, p80, p81, p82, parseArrayOfStruct)

		return v176, v177
	end
else
	v45 = buildDefaultProp
end

t1.ArrayOfStructProp = v45
t1.ActionProp = buildActionProp
t1.TableProp = buildTableProp
t1.ContainerProp = if not FFlagSduiGenericContainerDispatch then nil else buildContainerProp
t1.ArrayOfMenuItemProp = if not FFlagSduiOverflowMenuComponent then nil else buildRepeatedProp
t1.MenuItemProp = if not FFlagSduiOverflowMenuComponent then nil else buildTableProp
t1.MenuItem = if not FFlagSduiOverflowMenuComponent then nil else buildTableProp
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

local function v48(p83) -- line: 94
	-- upvalues: SduiParsers (copy), AutomaticSize (copy), ProtoVariableMapper (copy), s2 (copy)
	local v179 = SduiParsers.getEngineEnumParser(AutomaticSize)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p83, s2, v179)
end

function t1.AutomaticSizeProp(p84, p85, p86, p87, p88, p89) -- line: 72
	-- upvalues: buildDefaultProp (copy), v48 (copy)
	local v186, v187 = buildDefaultProp(p84, p85, p86, p87, p88, p89, v48)

	return v186, v187
end

local TextTruncate = Enum.TextTruncate
local s3 = "TEXT_TRUNCATE_"

local function v51(p90) -- line: 94
	-- upvalues: SduiParsers (copy), TextTruncate (copy), ProtoVariableMapper (copy), s3 (copy)
	local v189 = SduiParsers.getEngineEnumParser(TextTruncate)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p90, s3, v189)
end

function t1.TextTruncateProp(p91, p92, p93, p94, p95, p96) -- line: 72
	-- upvalues: buildDefaultProp (copy), v51 (copy)
	local v196, v197 = buildDefaultProp(p91, p92, p93, p94, p95, p96, v51)

	return v196, v197
end

local TextXAlignment = Enum.TextXAlignment
local s4 = "TEXT_X_ALIGNMENT_"

local function v54(p97) -- line: 94
	-- upvalues: SduiParsers (copy), TextXAlignment (copy), ProtoVariableMapper (copy), s4 (copy)
	local v199 = SduiParsers.getEngineEnumParser(TextXAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p97, s4, v199)
end

function t1.TextXAlignmentProp(p98, p99, p100, p101, p102, p103) -- line: 72
	-- upvalues: buildDefaultProp (copy), v54 (copy)
	local v206, v207 = buildDefaultProp(p98, p99, p100, p101, p102, p103, v54)

	return v206, v207
end

local TextYAlignment = Enum.TextYAlignment
local s5 = "TEXT_Y_ALIGNMENT_"

local function v57(p104) -- line: 94
	-- upvalues: SduiParsers (copy), TextYAlignment (copy), ProtoVariableMapper (copy), s5 (copy)
	local v209 = SduiParsers.getEngineEnumParser(TextYAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p104, s5, v209)
end

function t1.TextYAlignmentProp(p105, p106, p107, p108, p109, p110) -- line: 72
	-- upvalues: buildDefaultProp (copy), v57 (copy)
	local v216, v217 = buildDefaultProp(p105, p106, p107, p108, p109, p110, v57)

	return v216, v217
end

local UIFlexMode = Enum.UIFlexMode
local s6 = "UI_FLEX_MODE_"

local function v60(p111) -- line: 94
	-- upvalues: SduiParsers (copy), UIFlexMode (copy), ProtoVariableMapper (copy), s6 (copy)
	local v219 = SduiParsers.getEngineEnumParser(UIFlexMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p111, s6, v219)
end

function t1.UIFlexModeProp(p112, p113, p114, p115, p116, p117) -- line: 72
	-- upvalues: buildDefaultProp (copy), v60 (copy)
	local v226, v227 = buildDefaultProp(p112, p113, p114, p115, p116, p117, v60)

	return v226, v227
end

local EnumScaleType = Enum.ScaleType
local s7 = "SCALE_TYPE_"

local function v63(p118) -- line: 94
	-- upvalues: SduiParsers (copy), EnumScaleType (copy), ProtoVariableMapper (copy), s7 (copy)
	local v229 = SduiParsers.getEngineEnumParser(EnumScaleType)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p118, s7, v229)
end

function t1.ScaleTypeProp(p119, p120, p121, p122, p123, p124) -- line: 72
	-- upvalues: buildDefaultProp (copy), v63 (copy)
	local v236, v237 = buildDefaultProp(p119, p120, p121, p122, p123, p124, v63)

	return v236, v237
end

local ResamplerMode = Enum.ResamplerMode
local s8 = "RESAMPLER_MODE_"

local function v66(p125) -- line: 94
	-- upvalues: SduiParsers (copy), ResamplerMode (copy), ProtoVariableMapper (copy), s8 (copy)
	local v239 = SduiParsers.getEngineEnumParser(ResamplerMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p125, s8, v239)
end

function t1.ResamplerModeProp(p126, p127, p128, p129, p130, p131) -- line: 72
	-- upvalues: buildDefaultProp (copy), v66 (copy)
	local v246, v247 = buildDefaultProp(p126, p127, p128, p129, p130, p131, v66)

	return v246, v247
end

local SizeConstraint = Enum.SizeConstraint
local s9 = "SIZE_CONSTRAINT_"

local function v69(p132) -- line: 94
	-- upvalues: SduiParsers (copy), SizeConstraint (copy), ProtoVariableMapper (copy), s9 (copy)
	local v249 = SduiParsers.getEngineEnumParser(SizeConstraint)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p132, s9, v249)
end

function t1.SizeConstraintProp(p133, p134, p135, p136, p137, p138) -- line: 72
	-- upvalues: buildDefaultProp (copy), v69 (copy)
	local v256, v257 = buildDefaultProp(p133, p134, p135, p136, p137, p138, v69)

	return v256, v257
end

local v73

if FFlagSduiChartsSupport then
	local SelectionBehavior = Enum.SelectionBehavior
	local s10 = "SELECTION_BEHAVIOR_"

	local function v72(p139) -- line: 94
		-- upvalues: SduiParsers (copy), SelectionBehavior (copy), ProtoVariableMapper (copy), s10 (copy)
		local v259 = SduiParsers.getEngineEnumParser(SelectionBehavior)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p139, s10, v259)
	end

	function v73(p140, p141, p142, p143, p144, p145) -- line: 72
		-- upvalues: buildDefaultProp (copy), v72 (copy)
		local v266, v267 = buildDefaultProp(p140, p141, p142, p143, p144, p145, v72)

		return v266, v267
	end
else
	v73 = nil
end

t1.SelectionBehaviorProp = v73

local v77

if FFlagSduiTileHoldAction or FFlagSduiFocusNavActionsStructured then
	local KeyCode = Enum.KeyCode
	local s11 = "KEY_CODE_"

	local function v76(p146) -- line: 94
		-- upvalues: SduiParsers (copy), KeyCode (copy), ProtoVariableMapper (copy), s11 (copy)
		local v269 = SduiParsers.getEngineEnumParser(KeyCode)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p146, s11, v269)
	end

	function v77(p147, p148, p149, p150, p151, p152) -- line: 72
		-- upvalues: buildDefaultProp (copy), v76 (copy)
		local v276, v277 = buildDefaultProp(p147, p148, p149, p150, p151, p152, v76)

		return v276, v277
	end
else
	v77 = nil
end

t1.KeyCodeProp = v77

local v79

if FFlagSduiFocusNavActionsStructured then
	local parseFocusNavActions = SduiClientBindingParsers.parseFocusNavActions

	function v79(p153, p154, p155, p156, p157, p158) -- line: 72
		-- upvalues: buildTableProp (copy), parseFocusNavActions (copy)
		local v284, v285 = buildTableProp(p153, p154, p155, p156, p157, p158, parseFocusNavActions)

		return v284, v285
	end
else
	v79 = nil
end

t1.FocusNavActionsProp = v79
t1.ColorStyleProp = buildDefaultProp

local parseUiScaledUDim2 = SduiClientBindingParsers.parseUiScaledUDim2

function t1.UiScaledUDim2Prop(p159, p160, p161, p162, p163, p164) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim2 (copy)
	local v292, v293 = buildDefaultProp(p159, p160, p161, p162, p163, p164, parseUiScaledUDim2)

	return v292, v293
end

local parseUiScaledUDim = SduiClientBindingParsers.parseUiScaledUDim

function t1.UiScaledUDimProp(p165, p166, p167, p168, p169, p170) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim (copy)
	local v300, v301 = buildDefaultProp(p165, p166, p167, p168, p169, p170, parseUiScaledUDim)

	return v300, v301
end

local parseUiScaledNumber = SduiClientBindingParsers.parseUiScaledNumber

function t1.UiScaledFloatProp(p171, p172, p173, p174, p175, p176) -- line: 72
	-- upvalues: buildDefaultProp (copy), parseUiScaledNumber (copy)
	local v308, v309 = buildDefaultProp(p171, p172, p173, p174, p175, p176, parseUiScaledNumber)

	return v308, v309
end

t1.FillBehaviorProp = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildDefaultProp
t1.InputSizeProp = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildDefaultProp
t1.LaunchExperienceAction_ExperienceJoinData = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else buildTableProp
t1.AvatarConfigProp = if not FFlagSduiExperienceDetailsSupport then nil else buildTableProp
t1.ArrayOfAvatarProp = if not FFlagSduiExperienceDetailsSupport then nil else buildRepeatedProp

local function getPropBuilder(s12: string) -- line: 254
	-- upvalues: t1 (copy), buildDefaultProp (copy)
	if not s12 then
		error("Failed to find prop builder -- missing propDescriptorName")
	end

	local v311 = t1[s12]

	if not v311 then
		warn(`Could not find propBuilder for propDescriptorName { s12 }. Using default.`)
		v311 = buildDefaultProp
	end

	return v311
end

return getPropBuilder
