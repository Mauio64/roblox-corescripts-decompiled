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
local FFlagLuaAppSduiColorPropMigration = require(SduiCoreSystemParent.SharedFlags).FFlagLuaAppSduiColorPropMigration
local FFlagSduiGenericContainerDispatch = require(SduiCoreSystemParent.SharedFlags).FFlagSduiGenericContainerDispatch
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured

local function applyParser(p1, p2: ((...any) -> ...any)) -- line: 67
	return function(p3, p4, p5, p6, p7, p8) -- line: 71
		-- upvalues: p1 (copy), p2 (copy)
		local v335, v336 = p1(p3, p4, p5, p6, p7, p8, p2)

		return v335, v336
	end
end
local function createEngineEnumProtoBuilder(p9, s1: string) -- line: 92
	-- upvalues: buildDefaultProp (copy), SduiParsers (copy), ProtoVariableMapper (copy)
	local v89 = buildDefaultProp

	local function v90(p10) -- line: 93
		-- upvalues: SduiParsers (copy), p9 (copy), ProtoVariableMapper (copy), s1 (copy)
		local v338 = SduiParsers.getEngineEnumParser(p9)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p10, s1, v338)
	end

	return function(p11, p12, p13, p14, p15, p16) -- line: 71
		-- upvalues: v89 (copy), v90 (copy)
		local v345, v346 = v89(p11, p12, p13, p14, p15, p16, v90)

		return v345, v346
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

function t1.StructProp(p17, p18, p19, p20, p21, p22) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseStruct (copy)
	local v97, v98 = buildDefaultProp(p17, p18, p19, p20, p21, p22, parseStruct)

	return v97, v98
end

local parseImageStringProp_ = SduiParsers.parseImageStringProp_

function t1.ImageStringProp(p23, p24, p25, p26, p27, p28) -- line: 71
	-- upvalues: buildStringProp (copy), parseImageStringProp_ (copy)
	local v105, v106 = buildStringProp(p23, p24, p25, p26, p27, p28, parseImageStringProp_)

	return v105, v106
end

local parseImageSetOrImageProp_ = SduiParsers.parseImageSetOrImageProp_

function t1.ImageSetProp(p29, p30, p31, p32, p33, p34) -- line: 71
	-- upvalues: buildStringProp (copy), parseImageSetOrImageProp_ (copy)
	local v113, v114 = buildStringProp(p29, p30, p31, p32, p33, p34, parseImageSetOrImageProp_)

	return v113, v114
end

local v36

if FFlagLuaAppSduiColorPropMigration then
	local parseColorPropLegacy = SduiClientBindingParsers.parseColorPropLegacy

	function v36(p35, p36, p37, p38, p39, p40) -- line: 71
		-- upvalues: buildDefaultProp (copy), parseColorPropLegacy (copy)
		local v121, v122 = buildDefaultProp(p35, p36, p37, p38, p39, p40, parseColorPropLegacy)

		return v121, v122
	end
else
	local fromHex = Color3.fromHex

	function v36(p41, p42, p43, p44, p45, p46) -- line: 71
		-- upvalues: buildDefaultProp (copy), fromHex (copy)
		local v129, v130 = buildDefaultProp(p41, p42, p43, p44, p45, p46, fromHex)

		return v129, v130
	end
end

t1.ColorProp = v36

local v39

if FFlagLuaAppSduiColorPropMigration then
	local parseColor3 = SduiClientBindingParsers.parseColor3

	function v39(p47, p48, p49, p50, p51, p52) -- line: 71
		-- upvalues: buildDefaultProp (copy), parseColor3 (copy)
		local v137, v138 = buildDefaultProp(p47, p48, p49, p50, p51, p52, parseColor3)

		return v137, v138
	end
else
	v39 = nil
end

t1.Color3Prop = v39
t1.TypographyProp = buildDefaultProp
t1.TypographyFontProp = buildDefaultProp

local v40 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDimProp_ else SduiClientBindingParsers.parseUDim

function t1.UDimProp(p53, p54, p55, p56, p57, p58) -- line: 71
	-- upvalues: buildDefaultProp (copy), v40 (copy)
	local v145, v146 = buildDefaultProp(p53, p54, p55, p56, p57, p58, v40)

	return v145, v146
end

local v41 = if not FFlagSduiExperienceDetailsSupport then SduiParsers.parseUDim2Prop_ else SduiClientBindingParsers.parseUDim2

function t1.UDim2Prop(p59, p60, p61, p62, p63, p64) -- line: 71
	-- upvalues: buildDefaultProp (copy), v41 (copy)
	local v153, v154 = buildDefaultProp(p59, p60, p61, p62, p63, p64, v41)

	return v153, v154
end

local parseVector2Prop_ = SduiParsers.parseVector2Prop_

function t1.Vector2Prop(p65, p66, p67, p68, p69, p70) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseVector2Prop_ (copy)
	local v161, v162 = buildDefaultProp(p65, p66, p67, p68, p69, p70, parseVector2Prop_)

	return v161, v162
end

t1.NestedComponentProp = buildNestedComponentProp
t1.LazyNestedComponentProp = if not FFlagSduiLazyNestedComponentProp then nil else buildLazyNestedComponentProp
t1.NestedComponentListProp = if not FFlagSduiNestedComponentListProp then nil else buildNestedComponentListProp
t1.LazyNestedComponentListProp = buildLazyNestedComponentListProp

local parseStringArray = SduiClientBindingParsers.parseStringArray

function t1.StringArrayProp(p71, p72, p73, p74, p75, p76) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseStringArray (copy)
	local v169, v170 = buildDefaultProp(p71, p72, p73, p74, p75, p76, parseStringArray)

	return v169, v170
end

local parseIconProp_ = SduiParsers.parseIconProp_

function t1.IconProp(p77, p78, p79, p80, p81, p82) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseIconProp_ (copy)
	local v177, v178 = buildDefaultProp(p77, p78, p79, p80, p81, p82, parseIconProp_)

	return v177, v178
end

local parseGradientProp_ = SduiParsers.parseGradientProp_

function t1.GradientProp(p83, p84, p85, p86, p87, p88) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseGradientProp_ (copy)
	local v185, v186 = buildDefaultProp(p83, p84, p85, p86, p87, p88, parseGradientProp_)

	return v185, v186
end

local parseArrayOfStruct = SduiClientBindingParsers.parseArrayOfStruct

function t1.ArrayOfStructProp(p89, p90, p91, p92, p93, p94) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseArrayOfStruct (copy)
	local v193, v194 = buildDefaultProp(p89, p90, p91, p92, p93, p94, parseArrayOfStruct)

	return v193, v194
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

local function v49(p95) -- line: 93
	-- upvalues: SduiParsers (copy), AutomaticSize (copy), ProtoVariableMapper (copy), s2 (copy)
	local v196 = SduiParsers.getEngineEnumParser(AutomaticSize)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p95, s2, v196)
end

function t1.AutomaticSizeProp(p96, p97, p98, p99, p100, p101) -- line: 71
	-- upvalues: buildDefaultProp (copy), v49 (copy)
	local v203, v204 = buildDefaultProp(p96, p97, p98, p99, p100, p101, v49)

	return v203, v204
end

local TextTruncate = Enum.TextTruncate
local s3 = "TEXT_TRUNCATE_"

local function v52(p102) -- line: 93
	-- upvalues: SduiParsers (copy), TextTruncate (copy), ProtoVariableMapper (copy), s3 (copy)
	local v206 = SduiParsers.getEngineEnumParser(TextTruncate)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p102, s3, v206)
end

function t1.TextTruncateProp(p103, p104, p105, p106, p107, p108) -- line: 71
	-- upvalues: buildDefaultProp (copy), v52 (copy)
	local v213, v214 = buildDefaultProp(p103, p104, p105, p106, p107, p108, v52)

	return v213, v214
end

local TextXAlignment = Enum.TextXAlignment
local s4 = "TEXT_X_ALIGNMENT_"

local function v55(p109) -- line: 93
	-- upvalues: SduiParsers (copy), TextXAlignment (copy), ProtoVariableMapper (copy), s4 (copy)
	local v216 = SduiParsers.getEngineEnumParser(TextXAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p109, s4, v216)
end

function t1.TextXAlignmentProp(p110, p111, p112, p113, p114, p115) -- line: 71
	-- upvalues: buildDefaultProp (copy), v55 (copy)
	local v223, v224 = buildDefaultProp(p110, p111, p112, p113, p114, p115, v55)

	return v223, v224
end

local TextYAlignment = Enum.TextYAlignment
local s5 = "TEXT_Y_ALIGNMENT_"

local function v58(p116) -- line: 93
	-- upvalues: SduiParsers (copy), TextYAlignment (copy), ProtoVariableMapper (copy), s5 (copy)
	local v226 = SduiParsers.getEngineEnumParser(TextYAlignment)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p116, s5, v226)
end

function t1.TextYAlignmentProp(p117, p118, p119, p120, p121, p122) -- line: 71
	-- upvalues: buildDefaultProp (copy), v58 (copy)
	local v233, v234 = buildDefaultProp(p117, p118, p119, p120, p121, p122, v58)

	return v233, v234
end

local UIFlexMode = Enum.UIFlexMode
local s6 = "UI_FLEX_MODE_"

local function v61(p123) -- line: 93
	-- upvalues: SduiParsers (copy), UIFlexMode (copy), ProtoVariableMapper (copy), s6 (copy)
	local v236 = SduiParsers.getEngineEnumParser(UIFlexMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p123, s6, v236)
end

function t1.UIFlexModeProp(p124, p125, p126, p127, p128, p129) -- line: 71
	-- upvalues: buildDefaultProp (copy), v61 (copy)
	local v243, v244 = buildDefaultProp(p124, p125, p126, p127, p128, p129, v61)

	return v243, v244
end

local EnumScaleType = Enum.ScaleType
local s7 = "SCALE_TYPE_"

local function v64(p130) -- line: 93
	-- upvalues: SduiParsers (copy), EnumScaleType (copy), ProtoVariableMapper (copy), s7 (copy)
	local v246 = SduiParsers.getEngineEnumParser(EnumScaleType)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p130, s7, v246)
end

function t1.ScaleTypeProp(p131, p132, p133, p134, p135, p136) -- line: 71
	-- upvalues: buildDefaultProp (copy), v64 (copy)
	local v253, v254 = buildDefaultProp(p131, p132, p133, p134, p135, p136, v64)

	return v253, v254
end

local ResamplerMode = Enum.ResamplerMode
local s8 = "RESAMPLER_MODE_"

local function v67(p137) -- line: 93
	-- upvalues: SduiParsers (copy), ResamplerMode (copy), ProtoVariableMapper (copy), s8 (copy)
	local v256 = SduiParsers.getEngineEnumParser(ResamplerMode)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p137, s8, v256)
end

function t1.ResamplerModeProp(p138, p139, p140, p141, p142, p143) -- line: 71
	-- upvalues: buildDefaultProp (copy), v67 (copy)
	local v263, v264 = buildDefaultProp(p138, p139, p140, p141, p142, p143, v67)

	return v263, v264
end

local SizeConstraint = Enum.SizeConstraint
local s9 = "SIZE_CONSTRAINT_"

local function v70(p144) -- line: 93
	-- upvalues: SduiParsers (copy), SizeConstraint (copy), ProtoVariableMapper (copy), s9 (copy)
	local v266 = SduiParsers.getEngineEnumParser(SizeConstraint)

	return ProtoVariableMapper.mapProtoEngineEnumToLua(p144, s9, v266)
end

function t1.SizeConstraintProp(p145, p146, p147, p148, p149, p150) -- line: 71
	-- upvalues: buildDefaultProp (copy), v70 (copy)
	local v273, v274 = buildDefaultProp(p145, p146, p147, p148, p149, p150, v70)

	return v273, v274
end

local v74

if FFlagSduiChartsSupport then
	local SelectionBehavior = Enum.SelectionBehavior
	local s10 = "SELECTION_BEHAVIOR_"

	local function v73(p151) -- line: 93
		-- upvalues: SduiParsers (copy), SelectionBehavior (copy), ProtoVariableMapper (copy), s10 (copy)
		local v276 = SduiParsers.getEngineEnumParser(SelectionBehavior)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p151, s10, v276)
	end

	function v74(p152, p153, p154, p155, p156, p157) -- line: 71
		-- upvalues: buildDefaultProp (copy), v73 (copy)
		local v283, v284 = buildDefaultProp(p152, p153, p154, p155, p156, p157, v73)

		return v283, v284
	end
else
	v74 = nil
end

t1.SelectionBehaviorProp = v74

local v78

if FFlagSduiTileHoldAction or FFlagSduiFocusNavActionsStructured then
	local KeyCode = Enum.KeyCode
	local s11 = "KEY_CODE_"

	local function v77(p158) -- line: 93
		-- upvalues: SduiParsers (copy), KeyCode (copy), ProtoVariableMapper (copy), s11 (copy)
		local v286 = SduiParsers.getEngineEnumParser(KeyCode)

		return ProtoVariableMapper.mapProtoEngineEnumToLua(p158, s11, v286)
	end

	function v78(p159, p160, p161, p162, p163, p164) -- line: 71
		-- upvalues: buildDefaultProp (copy), v77 (copy)
		local v293, v294 = buildDefaultProp(p159, p160, p161, p162, p163, p164, v77)

		return v293, v294
	end
else
	v78 = nil
end

t1.KeyCodeProp = v78

local v80

if FFlagSduiFocusNavActionsStructured then
	local parseFocusNavActions = SduiClientBindingParsers.parseFocusNavActions

	function v80(p165, p166, p167, p168, p169, p170) -- line: 71
		-- upvalues: buildTableProp (copy), parseFocusNavActions (copy)
		local v301, v302 = buildTableProp(p165, p166, p167, p168, p169, p170, parseFocusNavActions)

		return v301, v302
	end
else
	v80 = nil
end

t1.FocusNavActionsProp = v80
t1.ColorStyleProp = buildDefaultProp

local parseUiScaledUDim2 = SduiClientBindingParsers.parseUiScaledUDim2

function t1.UiScaledUDim2Prop(p171, p172, p173, p174, p175, p176) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim2 (copy)
	local v309, v310 = buildDefaultProp(p171, p172, p173, p174, p175, p176, parseUiScaledUDim2)

	return v309, v310
end

local parseUiScaledUDim = SduiClientBindingParsers.parseUiScaledUDim

function t1.UiScaledUDimProp(p177, p178, p179, p180, p181, p182) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseUiScaledUDim (copy)
	local v317, v318 = buildDefaultProp(p177, p178, p179, p180, p181, p182, parseUiScaledUDim)

	return v317, v318
end

local parseUiScaledNumber = SduiClientBindingParsers.parseUiScaledNumber

function t1.UiScaledFloatProp(p183, p184, p185, p186, p187, p188) -- line: 71
	-- upvalues: buildDefaultProp (copy), parseUiScaledNumber (copy)
	local v325, v326 = buildDefaultProp(p183, p184, p185, p186, p187, p188, parseUiScaledNumber)

	return v325, v326
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

	local v328 = t1[s12]

	if not v328 then
		warn(`Could not find propBuilder for propDescriptorName { s12 }. Using default.`)
		v328 = buildDefaultProp
	end

	return v328
end

return getPropBuilder
