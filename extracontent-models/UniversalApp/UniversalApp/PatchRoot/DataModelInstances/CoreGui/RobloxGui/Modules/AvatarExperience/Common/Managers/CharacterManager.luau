local AvatarEditorService = game:GetService("AvatarEditorService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local ParticleUtility = require(CorePackages.Packages.Thumbnailing).ParticleUtility
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceExperiments = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments)
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AXEnableAccessoryAdjustmentDuringTryOnIXP = AvatarExperienceExperiments.AXEnableAccessoryAdjustmentDuringTryOnIXP

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local v16 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectHasBodyTryOn) else AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
local v17 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectAvatarPreviewColors) else AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local destroyMakeupDescriptions = AvatarExperienceCommon.Utils.destroyMakeupDescriptions
local getMakeupDescriptionsFromHumanoidDescription = AvatarExperienceCommon.Utils.getMakeupDescriptionsFromHumanoidDescription
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local mutedError = require(Modules.LuaApp.mutedError)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetCurrentCharacter = AvatarExperienceRodux.Actions.SetCurrentCharacter
local AssetTypeToAssetCategory = AvatarExperienceRodux.Constants.AssetTypeToAssetCategory
local SetAdjustableTryOnIds = require(Modules.AvatarExperience.Common.Actions.SetAdjustableTryOnIds)
local UpdateCharacter = require(Modules.AvatarExperience.Common.Thunks.UpdateCharacter)
local IncrementCharacterVersion = require(Modules.AvatarExperience.Common.Actions.IncrementCharacterVersion)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local IncrementCharacterModelVersion = require(Modules.AvatarExperience.AvatarEditor.Actions.IncrementCharacterModelVersion)
local IncrementTryOnCharacterModelVersion = require(Modules.AvatarExperience.Catalog.Actions.IncrementTryOnCharacterModelVersion)
local FinishedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.FinishedWaitingOnLCUpdate)
local AnimationManager = require(Modules.AvatarExperience.Common.Managers.AnimationManager)
local ToolManager = require(Modules.AvatarExperience.Common.Managers.ToolManager)
local CharacterModelPool = require(Modules.AvatarExperience.Common.Managers.CharacterModelPool)
local selectHasAvatarData = require(Modules.AvatarExperience.Common.Selectors.selectHasAvatarData)
local selectLastTryOnClassicHeadShape = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Selectors.selectLastTryOnClassicHeadShape)
local selectDefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColorsToggled)
local selectDefaultTryOnBodyColors = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColors)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local AvatarWidgetBlockyUtils = require(Modules.AvatarExperience.Common.Util.AvatarWidgetBlockyUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local GetFFlagFixCharacterManagerValueConversionWarning = require(Modules.AvatarExperience.Flags.GetFFlagFixCharacterManagerValueConversionWarning)
local FFlagAXFixBodyScaleReduxUpdates = require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates)
local FFlagAXNilGuardCharacterManager = require(Modules.AvatarExperience.Flags.FFlagAXNilGuardCharacterManager)
local mutedErrorWithCounter = require(Modules.AvatarExperience.Common.Util.mutedErrorWithCounter)
local v59 = game:DefineFastFlag("AXRemoveDynamicHeadAssetsFromTryOn", false)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXMakeupFixAvatarLooksTryOn = AvatarExperienceFlags.FFlagAXMakeupFixAvatarLooksTryOn
local FFlagEnableHeadShapeForCharacterManager = AvatarExperienceFlags.FFlagEnableHeadShapeForCharacterManager
local FFlagFixHeadShapeColorSlider = AvatarExperienceFlags.FFlagFixHeadShapeColorSlider
local v66 = game:DefineFastFlag("AXFixTryOnDefaultClothing", false)
local v67 = game:DefineFastFlag("AXCheckApplyDefaultClothingErrorGuards", false)
local v68 = settings():GetFVariable("LuaAppsDiagLoadTimeAvatarModel") .. "_" .. Utils.getDeviceType()
local t1 = {}

t1.__index = t1

local AssetTypeIdStringToHumanoidDescriptionProp = Constants2.AssetTypeIdStringToHumanoidDescriptionProp
local HumanoidDescriptionScaleToName = Constants2.HumanoidDescriptionScaleToName
local AssetTypeIdStrings = Constants2.AssetTypeIdStrings
local v73 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.loadtime")
local t2 = {
	toastMessage = "Feature.Avatar.Message.FaceNotVisible",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function isHumanoidDescriptionPropertyEmpty(p1) -- line: 133
	return p1 == "" or p1 == 0
end
local function isHumanoidDescriptionEmpty(p2) -- line: 137
	-- upvalues: AssetTypeIdStringToHumanoidDescriptionProp (copy)
	for _, v80 in AssetTypeIdStringToHumanoidDescriptionProp do
		local v81 = p2[v80]

		if v81 ~= "" and v81 ~= 0 then
			return false
		end
	end

	if #p2:GetAccessories(true) > 0 then
		return false
	end

	return true
end

function t1.new(p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 154
	-- upvalues: t1 (copy), CharacterModelPool (copy), UpdateCharacter (copy), IncrementCharacterVersion (copy), AnimationManager (copy), ToolManager (copy), IsVRAppBuild (copy)
	local t3 = {}

	setmetatable(t3, t1)
	t3.startAvatarModelLoadTime = tick()
	t3.connections = {}
	t3.store = p3
	t3.networking = p4
	t3.analytics = p5
	t3.characterManagerEvents = p8
	t3.characterManagerCallbacks = p9
	t3.catalogAnalytics = p10
	t3.characterModelPool = CharacterModelPool.new(p3, p5, p7, p11)
	t3._currentCharacter = t3.characterModelPool:getCurrentCharacter()
	t3.store:dispatch(UpdateCharacter(t3._currentCharacter))
	t3.store:dispatch(IncrementCharacterVersion())
	t3.characterRoot = Instance.new("Folder")
	t3.characterRoot.Name = "CharacterRoot"
	t3.characterRoot.Parent = game.Workspace
	t3.needsToEquipBundleTryOn = false
	t3.initialHumanoidDescriptionApplied = false
	t3.initialTryOnApplied = false
	t3.destroyed = false
	t3.checkBodyColors = true
	t3.modelInitialized = false
	t3.firstCallinPPE = true
	t3.shouldUnequipAccessoriesAndMakeupBeforeTryOn = false
	t3.animationManager = AnimationManager.new(p3, t3, p6)
	t3.toolManager = ToolManager.new(p3, t3.animationManager, t3)
	t3.humanoidDescriptionCurrentlyEquipped = Instance.new("HumanoidDescription")
	t3.humanoidDescriptionTryOn = Instance.new("HumanoidDescription")
	t3.lastHumanoidDescriptionApplied = Instance.new("HumanoidDescription")

	if not IsVRAppBuild() then
		t3:maybeInitializeModel(t3.store:getState())
	end

	t3.cachedRoduxState = t3.store:getState()

	return t3
end
function t1.maybeInitializeModel(p12, p13) -- line: 228
	-- upvalues: selectHasAvatarData (copy)
	if not p12.modelInitialized and selectHasAvatarData(p13) then
		p12.modelInitialized = true
		p12:initializeModel(p13)
	end
end
function t1.setupAnimations(p14, p15, p16) -- line: 235
	p14.characterModelPool:setupAnimations(p15, p16)
end
function t1.initializeModel(p17, p18) -- line: 240
	-- upvalues: Constants (copy)
	local AvatarType = p18.AvatarExperience.AvatarEditor.Character.AvatarType

	if AvatarType == Constants.AvatarType.R6 then
		p17:switchAvatarType(AvatarType)
	end

	p17._currentCharacter.Parent = p17.characterRoot
	p17:updateHumanoidDescriptionCurrentlyEquipped(p18)
	p17:applyHumanoidDescription(true)
	p17.toolManager:update(p18)
end
function t1.updateCharacterFromConnection(p19, p20) -- line: 253
	p19.characterModelPool:maybeUpdateCharacter(p20):andThen(function(_, _) -- line: 254
		-- upvalues: p19 (copy)
		p19.characterManagerCallbacks.setAppliedDescription(p19._currentCharacter.Humanoid.HumanoidDescription)
	end)
end
function t1.initAvatarScalesChangedConnection(p23) -- line: 259
	-- upvalues: FFlagAXNilGuardCharacterManager (copy), mutedErrorWithCounter (copy), HumanoidDescriptionScaleToName (copy)
	if FFlagAXNilGuardCharacterManager and (p23.characterManagerEvents == nil or p23.characterManagerEvents.avatarScalesChangedEvent == nil) then
		mutedErrorWithCounter("CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents")

		return
	end

	local connection = p23.characterManagerEvents.avatarScalesChangedEvent:Connect(function(p24) -- line: 267
		-- upvalues: p23 (copy), HumanoidDescriptionScaleToName (copy)
		if not p24 then
			return
		end

		local clone = p23.lastHumanoidDescriptionApplied:Clone()

		for v315, v316 in p24 do
			clone[HumanoidDescriptionScaleToName[v315]] = v316
		end

		p23:updateCharacterFromConnection(clone)

		if p23.characterModelPool:isR15() then
			p23:adjustHeightToStandOnPlatform(p23._currentCharacter)
		end
	end)

	table.insert(p23.connections, connection)
end
function t1.initBodyColorsChangedConnection(p25) -- line: 284
	-- upvalues: FFlagAXNilGuardCharacterManager (copy), mutedErrorWithCounter (copy), selectDefaultTryOnBodyColorsToggled (copy), Constants (copy), v16 (copy), Utils2 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), AvatarEditorService (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), v67 (copy), mutedError (copy)
	if FFlagAXNilGuardCharacterManager and (p25.characterManagerEvents == nil or p25.characterManagerEvents.bodyColorsChangedEvent == nil) then
		mutedErrorWithCounter("CharacterManager_initBodyColorsChangedConnection_characterManagerEvents")

		return
	end

	local connection = p25.characterManagerEvents.bodyColorsChangedEvent:Connect(function(p26) -- line: 292
		-- upvalues: p25 (copy), selectDefaultTryOnBodyColorsToggled (copy), Constants (copy), v16 (copy), Utils2 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), AvatarEditorService (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), v67 (copy), mutedError (copy)
		if not p26 then
			p25.overrideBodyColor3s = nil

			return
		end

		local v318 = p25.store:getState()

		if selectDefaultTryOnBodyColorsToggled(v318) then
			p25.overrideBodyColor3s = nil

			return
		end

		local selectedBodyPartIndex = v318.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
		local t4 = {}

		for _, v322 in Constants.BodyPartButtonData[selectedBodyPartIndex].bodyPartForSkinColoringIds do
			t4[v322] = p26
		end

		local u323

		if v16(v318) then
			u323 = p25:combineOutfitTryOnAndEquippedHumanoidDescriptions()
			p25:updateHumanoidDescriptionTryOnWithColors(v318)
		else
			u323 = p25.humanoidDescriptionCurrentlyEquipped:Clone()
		end

		Utils2.setHumanoidDescriptionColorsFromBodyColor3s(u323, t4)

		local v324 = nil

		if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
			local ok, result = pcall(function() -- line: 323
				-- upvalues: AvatarEditorService (copy), u323 (ref)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return AvatarEditorService:CheckApplyDefaultClothingAsync(u323)
				end

				return AvatarEditorService:CheckApplyDefaultClothing(u323)
			end)

			if ok then
				v324 = result
			else
				reportAvatarEventCounterNoAnalyticsArgument(Constants3.Counter.AvatarEditorServiceErrors.CheckApplyDefaultClothing)

				if v67 then
					mutedError(result)
					v324 = nil
				else
					error(result)
				end
			end
		else
			v324 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then AvatarEditorService:CheckApplyDefaultClothing(u323) else AvatarEditorService:CheckApplyDefaultClothingAsync(u323)
		end

		p25.overrideBodyColor3s = t4
		p25:updateCharacterFromConnection(v324 or u323)
	end)

	table.insert(p25.connections, connection)
end
function t1.initAdjustmentChangedConnection(p27) -- line: 356
	-- upvalues: FFlagAXNilGuardCharacterManager (copy), mutedErrorWithCounter (copy), Utils (copy)
	if FFlagAXNilGuardCharacterManager and (p27.characterManagerEvents == nil or p27.characterManagerEvents.adjustmentChangedEvent == nil) then
		mutedErrorWithCounter("CharacterManager_initAdjustmentChangedConnection_characterManagerEvents")

		return
	end

	local connection = p27.characterManagerEvents.adjustmentChangedEvent:Connect(function(p28, p29, p30) -- line: 365
		-- upvalues: p27 (copy), Utils (copy)
		local SelectedAccessory = p27.store:getState().AvatarExperience.AccessoryAdjustment.SelectedAccessory
		local clone = p27.lastHumanoidDescriptionApplied:Clone()
		local v332 = Utils.getSelectedAccessoryDescription(clone, SelectedAccessory)

		if v332 then
			if p28 then
				v332.Position = p28
			end

			if p29 then
				v332.Rotation = p29
			end

			if p30 then
				v332.Scale = p30
			end

			p27:updateCharacterFromConnection(clone)
		end
	end)

	table.insert(p27.connections, connection)
end
function t1.start(p31) -- line: 388
	-- upvalues: FFlagAXFixBodyScaleReduxUpdates (copy)
	p31:maybeInitializeModel(p31.store:getState())
	p31._currentCharacter.Parent = p31.characterRoot

	local v109 = p31.store.changed:connect(function(p32, p33) -- line: 392
		-- upvalues: p31 (copy)
		p31:update(p32, p33)
	end)

	table.insert(p31.connections, v109)

	if FFlagAXFixBodyScaleReduxUpdates then
		p31:initAvatarScalesChangedConnection()
	end

	p31:initBodyColorsChangedConnection()
	p31:initAdjustmentChangedConnection()
	p31.characterModelPool:start()
	p31.animationManager:start()
	p31.toolManager:start()
	p31:updateHumanoidDescriptionCurrentlyEquipped(p31.store:getState())
	p31:applyHumanoidDescription(true)
	p31.toolManager:update(p31.store:getState())
	p31:update(p31.store:getState(), p31.cachedRoduxState)
end
function t1.updateHumanoidDescriptionTryOnWithColors(p34, p35) -- line: 421
	-- upvalues: selectDefaultTryOnBodyColorsToggled (copy), selectDefaultTryOnBodyColors (copy), v17 (copy), Utils2 (copy)
	local v112 = if not selectDefaultTryOnBodyColorsToggled(p35) then if not p34.overrideBodyColor3s then v17(p35) else p34.overrideBodyColor3s else selectDefaultTryOnBodyColors(p35)

	Utils2.setHumanoidDescriptionColorsFromBodyColor3s(p34.humanoidDescriptionTryOn, v112)
end
function t1.update(p36, p37, p38) -- line: 429
	-- upvalues: CharacterManagerUtils (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IxpUtils (copy), Constants (copy), AccessoryAdjustmentUtils (copy), SetAdjustableTryOnIds (copy), FFlagAXMakeupEquipping (copy), Constants2 (copy), FFlagAXMISEnableMultiShopping (copy), AvatarWidgetBlockyUtils (copy)
	local v116 = p36:shouldUpdateHumanoidDescriptionCurrentlyEquipped(p37, p38)

	if v116 then
		p36:updateHumanoidDescriptionCurrentlyEquipped(p37)
	end

	local v117 = p36:shouldUpdateHumanoidDescriptionTryOnOutfit(p37, p38)

	if v117 then
		CharacterManagerUtils.updateHumanoidDescriptionUsingOutfitTryOn(p37, p36.humanoidDescriptionTryOn)

		if if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser) then
			local v118 = p36.store:getState().AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.accessoryRefinementTypes]
			local v119 = AccessoryAdjustmentUtils.getAdjustableAccessories(p36.humanoidDescriptionTryOn, v118)

			p36.store:dispatch(SetAdjustableTryOnIds(v119))
		end
	end

	local AvatarType = p37.AvatarExperience.AvatarEditor.Character.AvatarType
	local v121 = AvatarType ~= p38.AvatarExperience.AvatarEditor.Character.AvatarType

	if v121 then
		p36:switchAvatarType(AvatarType)
	end

	if FFlagAXMakeupEquipping then
		p36.isTryingOnLook = p37.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
		p36.isTryingOnMakeupLook = p36.isTryingOnLook and p37.AvatarExperience.AvatarScene.OutfitTryOn.LookType == Constants2.LookType.Makeup
	end

	if FFlagAXMISEnableMultiShopping then
		p36.isTryingOnMakeupLook = p37.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId ~= nil
		p36.shouldUnequipAccessoriesAndMakeupBeforeTryOn = p37.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems and not p36.isTryingOnMakeupLook
	else
		p36.shouldUnequipAccessoriesAndMakeupBeforeTryOn = p37.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil and not p36.isTryingOnMakeupLook
	end

	p36.shouldUnequipBodyBeforeTryOn = AvatarWidgetBlockyUtils.shouldUnequipBodyBeforeTryOn(p37)

	local v122 = p38.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= p37.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode

	if v116 or v117 or v121 then
		p36:applyHumanoidDescription(v116, v117)
	end

	if v122 or v116 or v117 or v121 then
		p36.toolManager:update(p37)
	end
end
function t1.updateNoFace(p39, p40) -- line: 497
	-- upvalues: AssetTypeIdStringToHumanoidDescriptionProp (copy), AssetTypeIdStrings (copy), SetCurrentToastMessage (copy), Cryo (copy), t2 (copy), Constants2 (copy)
	local Head = p39._currentCharacter:FindFirstChild("Head")

	if not Head then
		warn("No head was found on the character!")

		return
	end

	local Decal = Head:FindFirstChildWhichIsA("Decal")
	local v127 = AssetTypeIdStringToHumanoidDescriptionProp[AssetTypeIdStrings.Face]
	local v128 = p40[v127]
	local v129 = p39.lastHumanoidDescriptionApplied[v127]

	if not Decal and v128 ~= v129 and v129 ~= 0 then
		p39.store:dispatch(SetCurrentToastMessage(Cryo.Dictionary.join(t2)))

		local catalogAnalytics = p39.catalogAnalytics
		local latestAvatarRoute = p39.latestAvatarRoute

		if catalogAnalytics and latestAvatarRoute and latestAvatarRoute.opaque then
			catalogAnalytics.sendAXCounterV2(Constants2.Counter.Toasts.NoFaceHead, {
				route = latestAvatarRoute.opaque.name
			})
		end
	end
end
function t1.shouldUpdateHumanoidDescriptionCurrentlyEquipped(_, p42, p43) -- line: 529
	local EquippedAssets = p42.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local EquippedAssets2 = p43.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p42.AvatarExperience.AvatarEditor.Character.AvatarScales
	local AvatarScales2 = p43.AvatarExperience.AvatarEditor.Character.AvatarScales
	local BodyColors = p42.AvatarExperience.AvatarEditor.Character.BodyColors
	local BodyColors2 = p43.AvatarExperience.AvatarEditor.Character.BodyColors
	local BodyColor3s = p42.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local BodyColor3s2 = p43.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local v143 = EquippedAssets ~= EquippedAssets2
	local v144 = AvatarScales ~= AvatarScales2
	local v145 = BodyColors ~= BodyColors2
	local v146 = BodyColor3s ~= BodyColor3s2

	return v143 or (v144 or (v145 or v146))
end
function t1.updateHumanoidDescriptionCurrentlyEquipped(p44, p45) -- line: 546
	-- upvalues: Logging (copy), GetFFlagFixCharacterManagerValueConversionWarning (copy), CharacterManagerUtils (copy), AssetTypeIdStringToHumanoidDescriptionProp (copy), AssetTypeIdStrings (copy), Cryo (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), Constants2 (copy), Utils (copy), FFlagFixHeadShapeColorSlider (copy), setMakeupDescriptions (copy), HumanoidDescriptionScaleToName (copy), Utils2 (copy)
	local EquippedAssets = p45.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p45.AvatarExperience.AvatarEditor.Character.AvatarScales

	if not EquippedAssets then
		Logging.warn("CharacterManager: Equipped assets has not been initialized!")

		return
	end

	if GetFFlagFixCharacterManagerValueConversionWarning() then
		CharacterManagerUtils.resetHumanoidDescriptionProperties(p44.humanoidDescriptionCurrentlyEquipped)
	else
		for _, v152 in AssetTypeIdStringToHumanoidDescriptionProp do
			p44.humanoidDescriptionCurrentlyEquipped[v152] = ""
		end
	end

	p44.humanoidDescriptionCurrentlyEquipped:SetAccessories({}, true)

	local t5 = {}
	local v154 = false
	local v155 = false

	if EquippedAssets and (not EquippedAssets[AssetTypeIdStrings.Head] or Cryo.isEmpty(EquippedAssets[AssetTypeIdStrings.Head])) then
		v154 = true
	elseif EquippedAssets and (not EquippedAssets[AssetTypeIdStrings.DynamicHead] or Cryo.isEmpty(EquippedAssets[AssetTypeIdStrings.DynamicHead])) then
		v155 = true
	end

	for v156, v157 in EquippedAssets do
		local v158 = AssetTypeIdStringToHumanoidDescriptionProp[v156]

		if v156 ~= AssetTypeIdStrings.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v156)) then
			if Constants2.AssetTypeIdToAccessoryTypeEnum[v156] then
				for v159, v160 in v157 do
					table.insert(t5, Utils.createHumanoidDescriptionAccessoryInfo(v156, v159, v160))
				end
			elseif v158 and (v156 ~= AssetTypeIdStrings.Head or not v154) and (v156 ~= AssetTypeIdStrings.DynamicHead or not v155) then
				local v161 = Cryo.Dictionary.keys(v157)

				if #v161 == 0 then
					p44.humanoidDescriptionCurrentlyEquipped[v158] = 0
				elseif FFlagFixHeadShapeColorSlider and v156 == Constants2.AssetTypeIdStrings.DynamicHead then
					CharacterManagerUtils.applyHeadShapeFromAssetMetadata(p44.humanoidDescriptionCurrentlyEquipped, v157)
				else
					p44.humanoidDescriptionCurrentlyEquipped[v158] = table.concat(v161, ",")
				end
			end
		end
	end

	p44.humanoidDescriptionCurrentlyEquipped:SetAccessories(t5, true)

	if FFlagAXMakeupEquipping then
		setMakeupDescriptions(p44.humanoidDescriptionCurrentlyEquipped, EquippedAssets)
	end

	for v162, v163 in AvatarScales do
		p44.humanoidDescriptionCurrentlyEquipped[HumanoidDescriptionScaleToName[v162]] = v163
	end

	p44.checkBodyColors = true

	if p44.overrideBodyColor3s then
		Utils2.setHumanoidDescriptionColorsFromBodyColor3s(p44.humanoidDescriptionCurrentlyEquipped, p44.overrideBodyColor3s)

		return
	end

	Utils2.setHumanoidDescriptionColorsFromCharacter(p44.humanoidDescriptionCurrentlyEquipped, p45.AvatarExperience)
end
function t1.shouldUpdateHumanoidDescriptionTryOnOutfit(p46, p47, p48) -- line: 655
	-- upvalues: Utils (copy), selectLastTryOnClassicHeadShape (copy), selectDefaultTryOnBodyColorsToggled (copy)
	if p46.latestAvatarRoute then
		if Utils.routeIsProfilePictureEditor(p46.latestAvatarRoute) then
			if not p46.firstCallinPPE then
				return false
			end

			p46.firstCallinPPE = false
		else
			p46.firstCallinPPE = true
		end
	end

	local v167 = p47.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems ~= p48.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v168 = p47.AvatarExperience.LayeredClothingSort.CurrentSort ~= p48.AvatarExperience.LayeredClothingSort.CurrentSort
	local v169 = selectLastTryOnClassicHeadShape(p47) ~= selectLastTryOnClassicHeadShape(p48)

	if not p46.initialTryOnApplied then
		v167 = true
		p46.initialTryOnApplied = true
	end

	if v167 or v168 or v169 then
		return true
	end

	if p47.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s ~= p48.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s then
		return true
	end

	if selectDefaultTryOnBodyColorsToggled(p47) ~= selectDefaultTryOnBodyColorsToggled(p48) then
		return true
	end

	return false
end
function t1.setAccessoriesForTryOn(p49, p50) -- line: 716
	-- upvalues: Constants2 (copy), AssetTypeToAssetCategory (copy), FFlagAXMakeupEquipping (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), AssetTypeIdStrings (copy), CharacterManagerUtils (copy), v59 (copy), Cryo (copy)
	local Accessories = p50:GetAccessories(true)
	local Accessories2 = p49.humanoidDescriptionTryOn:GetAccessories(true)
	local RemovedList = p49.store:getState().AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
	local t6 = {}
	local t7 = {}

	for _, v178 in Accessories2 do
		local v179 = AssetTypeToAssetCategory[Constants2.AccessoryTypeEnumToAssetTypeId[v178.AccessoryType]]

		t6[v178.AccessoryType] = true

		if v179 then
			t7[v179] = true
		end
	end

	for _, v181 in RemovedList do
		if not FFlagAXMakeupEquipping or not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v181] then
			local v182 = Constants2.AssetTypeIdToAccessoryTypeEnum[v181]
			local v183 = AssetTypeToAssetCategory[v181]

			t6[v182] = true

			if v183 then
				t7[v183] = true
			end
		end
	end

	if FFlagAXMakeupEquipping and p49.isTryingOnMakeupLook then
		t6[Constants2.AssetTypeIdToAccessoryTypeEnum[AssetTypeIdStrings.EyebrowAccessory]] = true
		t6[Constants2.AssetTypeIdToAccessoryTypeEnum[AssetTypeIdStrings.EyelashAccessory]] = true
	end

	for _, v185 in Accessories do
		local v186 = Constants2.AccessoryTypeEnumToAssetTypeId[v185.AccessoryType]
		local v187 = not t6[v185.AccessoryType]
		local v188 = AssetTypeToAssetCategory[v186]

		if v188 then
			v187 = not t7[v188]
		end

		if CharacterManagerUtils.isDHBundleTryOn(p49.store:getState()) and Constants2.DynamicHeadAssetTypes[v186] then
			v187 = false
		end

		if v187 then
			table.insert(Accessories2, v185)
		end
	end

	if v59 and CharacterManagerUtils.isClassicHeadOrClassicFaceTryOn(p49.store:getState()) then
		Accessories2 = Cryo.List.filter(Accessories2, function(p51) -- line: 790
			-- upvalues: Constants2 (copy)
			local v336 = Constants2.AccessoryTypeEnumToAssetTypeId[p51.AccessoryType]

			return not Constants2.DynamicHeadAssetTypes[v336]
		end)
	end

	p50:SetAccessories(Accessories2, true)
end
function t1.getTryOnsBundleOutfitInfo(p52) -- line: 802
	-- upvalues: Constants2 (copy), Utils (copy)
	local v190 = p52.store:getState()

	for _, v192 in v190.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v192.itemType ~= Constants2.ItemType.Bundle or v192.itemSubType ~= Constants2.BundleTypeIdStrings.BodyParts then
			continue
		end

		local v193 = Utils.getOutfitInfoFromBundleId(v190, v192.itemId)

		if v193 then
			return v193
		end
	end

	return nil
end
function t1.makeupAssetsTryOn(p53, p54, p55) -- line: 820
	-- upvalues: getMakeupDescriptionsFromHumanoidDescription (copy), Cryo (copy), getTryOnItemReducerKey (copy), Constants2 (copy), MAX_MAKEUP_LAYERS (copy), destroyMakeupDescriptions (copy)
	local v197 = getMakeupDescriptionsFromHumanoidDescription(p55)

	if #v197 == 0 then
		return
	end

	local v198 = p53.store:getState()
	local TryOnItems = v198.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v200 = getMakeupDescriptionsFromHumanoidDescription(p54)

	if v198.AvatarExperience.LayeredClothingSort and v198.AvatarExperience.LayeredClothingSort.CurrentSort and #v198.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList > 0 then
		local OrderedList = v198.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList

		v200 = Cryo.List.filter(v200, function(p56) -- line: 839
			-- upvalues: OrderedList (copy)
			for _, v339 in OrderedList do
				if tostring(v339.id) == tostring(p56.AssetId) then
					return true
				end
			end

			return false
		end)
	end

	table.sort(v200, function(p57, p58) -- line: 850
		return p57.Order < p58.Order
	end)

	local t8 = {}

	for _, v204 in v200 do
		t8[v204.AssetId] = true
	end

	local t9 = {}

	for _, v207 in v197 do
		if not t8[v207.AssetId] then
			local v208 = TryOnItems[getTryOnItemReducerKey(tostring(v207.AssetId), Constants2.ItemType.Asset)]

			v207.Order = if not v208 then MAX_MAKEUP_LAYERS else v208.order
			table.insert(t9, v207)
		end
	end

	local v209 = if not (#v200 + #t9 <= MAX_MAKEUP_LAYERS) then { table.unpack(v200, #v200 + #t9 - MAX_MAKEUP_LAYERS + 1) } else v200

	for _, v211 in t9 do
		table.insert(v209, v211)
	end

	table.sort(v209, function(p59, p60) -- line: 892
		-- upvalues: getTryOnItemReducerKey (copy), Constants2 (copy), TryOnItems (copy)
		if p59.Order == p60.Order then
			local v344 = getTryOnItemReducerKey(tostring(p59.AssetId), Constants2.ItemType.Asset)
			local v345 = getTryOnItemReducerKey(tostring(p60.AssetId), Constants2.ItemType.Asset)

			if not TryOnItems[v344] then
				return true
			end

			if not TryOnItems[v345] then
				return false
			end

			return TryOnItems[v344].itemRecency < TryOnItems[v345].itemRecency
		end

		return p59.Order < p60.Order
	end)

	local t10 = {}

	for _, v214 in v209 do
		table.insert(t10, v214:Clone())
	end

	destroyMakeupDescriptions(p54)

	for v215, v216 in t10 do
		v216.Order = v215 - 1
		v216.Parent = p54
	end
end
function t1.singleMakeupAssetTryOn(p61, p62, p63) -- line: 925
	-- upvalues: FFlagAXMakeupEquipping (copy), getMakeupDescriptionsFromHumanoidDescription (copy), getTryOnItemReducerKey (copy), Constants2 (copy), MAX_MAKEUP_LAYERS (copy), destroyMakeupDescriptions (copy)
	if not FFlagAXMakeupEquipping then
		return
	end

	local v220 = getMakeupDescriptionsFromHumanoidDescription(p63)[1]

	if not v220 then
		return
	end

	local v221 = p61.store:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(tostring(v220.AssetId), Constants2.ItemType.Asset)]
	local v222 = getMakeupDescriptionsFromHumanoidDescription(p62)

	table.sort(v222, function(p64, p65) -- line: 945
		return p64.Order < p65.Order
	end)

	for _, v224 in v222 do
		if v224.AssetId == v220.AssetId then
			return
		end
	end

	if #v222 < MAX_MAKEUP_LAYERS then
	else
		table.remove(v222, 1)
	end

	local v225 = if not v221 then nil else v221.order
	local v226 = #v222
	local v227 = if v225 ~= nil then math.max(0, (math.min(v225, v226))) else v226
	local t11 = {}

	for _, v230 in v222 do
		table.insert(t11, v230:Clone())
	end

	table.insert(t11, v227 + 1, v220)
	destroyMakeupDescriptions(p62)

	for v231, v232 in t11 do
		v232.Order = v231 - 1
		v232.Parent = p62
	end
end
function t1.lookMakeupTryOn(_, p67, p68) -- line: 996
	-- upvalues: FFlagAXMakeupEquipping (copy), destroyMakeupDescriptions (copy), getMakeupDescriptionsFromHumanoidDescription (copy)
	if not FFlagAXMakeupEquipping then
		return
	end

	destroyMakeupDescriptions(p67)

	for _, v237 in getMakeupDescriptionsFromHumanoidDescription(p68) do
		v237:Clone().Parent = p67
	end
end
function t1.combineTryOnMakeupDescriptionsWithEquipped(p69, p70, p71) -- line: 1010
	-- upvalues: FFlagAXMakeupEquipping (copy), FFlagAXMakeupFixAvatarLooksTryOn (copy), CharacterManagerUtils (copy), FFlagAXMISEnableMultiShopping (copy)
	if not FFlagAXMakeupEquipping then
		return
	end

	if FFlagAXMakeupFixAvatarLooksTryOn and p69.isTryingOnLook or p69.isTryingOnMakeupLook then
		CharacterManagerUtils.lookMakeupTryOn(p70, p71)

		return
	end

	if FFlagAXMISEnableMultiShopping then
		local v241 = p69.store:getState()

		CharacterManagerUtils.makeupAssetsTryOn(v241, p70, p71)

		return
	end

	local v242 = p69.store:getState()

	CharacterManagerUtils.singleMakeupAssetTryOn(v242, p70, p71)
end
function t1.combineOutfitTryOnAndEquippedHumanoidDescriptions(p72) -- line: 1035
	-- upvalues: FFlagAXCatalogMakeupSupport (copy), destroyMakeupDescriptions (copy), AssetTypeIdStringToHumanoidDescriptionProp (copy), Constants2 (copy), FFlagAXMakeupEquipping (copy), v66 (copy), HumanoidDescriptionScaleToName (copy), CharacterManagerUtils (copy), FFlagEnableHeadShapeForCharacterManager (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), AvatarEditorService (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), v67 (copy), mutedError (copy)
	local v244 = p72:getTryOnsBundleOutfitInfo()
	local clone = p72.humanoidDescriptionCurrentlyEquipped:Clone()

	if p72.shouldUnequipAccessoriesAndMakeupBeforeTryOn then
		clone:SetAccessories({}, true)
		clone.GraphicTShirt = 0
		clone.Shirt = 0
		clone.Pants = 0

		if FFlagAXCatalogMakeupSupport then
			destroyMakeupDescriptions(clone)
		end
	end

	for v246, v247 in AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants2.AssetTypeIdToCategory[v246] == Constants2.AssetCategories.Body and p72.shouldUnequipBodyBeforeTryOn then
			clone[v247] = 0
		end

		if not Constants2.AssetTypeIdToAccessoryTypeEnum[v246] then
			local v248 = p72.humanoidDescriptionTryOn[v247]

			if v248 ~= "" and v248 ~= 0 then
				clone[v247] = p72.humanoidDescriptionTryOn[v247]
			end
		end
	end

	p72:setAccessoriesForTryOn(clone)

	if FFlagAXMakeupEquipping then
		p72:combineTryOnMakeupDescriptionsWithEquipped(clone, p72.humanoidDescriptionTryOn)
	end

	if v66 then
		if v244 then
			for v249, v250 in v244.scales do
				clone[HumanoidDescriptionScaleToName[v249]] = v250
			end
		end

		CharacterManagerUtils.setAvatarTryOnProperties(clone, p72.store:getState())

		if FFlagEnableHeadShapeForCharacterManager then
			CharacterManagerUtils.applyHeadShapeToHumanoidDescription(clone, p72.store:getState())
		end
	end

	local v251 = nil

	if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
		local ok, result = pcall(function() -- line: 1099
			-- upvalues: AvatarEditorService (copy), clone (ref)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return AvatarEditorService:CheckApplyDefaultClothingAsync(clone)
			end

			return AvatarEditorService:CheckApplyDefaultClothing(clone)
		end)

		if ok then
			v251 = result
		else
			reportAvatarEventCounterNoAnalyticsArgument(Constants3.Counter.AvatarEditorServiceErrors.CheckApplyDefaultClothing)

			if v67 then
				mutedError(result)
				v251 = nil
			else
				error(result)
			end
		end
	else
		v251 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then AvatarEditorService:CheckApplyDefaultClothing(clone) else AvatarEditorService:CheckApplyDefaultClothingAsync(clone)
	end

	clone = v251 or clone

	if not v66 then
		if v244 then
			for v254, v255 in v244.scales do
				clone[HumanoidDescriptionScaleToName[v254]] = v255
			end
		end

		CharacterManagerUtils.setAvatarTryOnProperties(clone, p72.store:getState())

		if FFlagEnableHeadShapeForCharacterManager then
			CharacterManagerUtils.applyHeadShapeToHumanoidDescription(clone, p72.store:getState())
		end
	end

	return clone
end
function t1.finishApplyDescription(p73, p74, p75, p76, p77) -- line: 1162
	-- upvalues: v73 (copy), v68 (copy), IncrementCharacterModelVersion (copy), IncrementTryOnCharacterModelVersion (copy), Utils (copy), mutedError (copy)
	if p73.initialHumanoidDescriptionApplied and not p76 then
		p73:updateNoFace(p77)
	end

	if not p73.initialHumanoidDescriptionApplied then
		local v261 = (tick() - p73.startAvatarModelLoadTime) * 1000

		v73:info("Avatar model load time: {} ms", v261)
		p73.analytics.Diag:reportStats(v68, v261)
	end

	if p73.characterModelPool:isR15() then
		p73:adjustHeightToStandOnPlatform(p73._currentCharacter)
	end

	if p74 then
		p73.store:dispatch(IncrementCharacterModelVersion())
	elseif p75 then
		p73.store:dispatch(IncrementTryOnCharacterModelVersion())
	end

	p73.initialHumanoidDescriptionApplied = true

	if p73._currentCharacter then
		local v262, v263 = p73._currentCharacter:GetBoundingBox()

		if not Utils.isBoundingBoxVectorSane(v263) or not Utils.isBoundingBoxCFrameSane(v262) then
			local v264 = Utils.calculateNewAssetIdsWithGeometry(p77, p73.lastHumanoidDescriptionApplied)

			if #v264 > 0 then
				mutedError("(Avatar Experience) bad bounding box on adding assetIds: " .. table.concat(v264, ","))
			end
		end
	end
end
function t1.getCurrentCharacter(p78) -- line: 1215
	return p78._currentCharacter
end
function t1.applyHumanoidDescription(p79, p80, p81) -- line: 1219
	-- upvalues: ArgCheck (copy), isHumanoidDescriptionEmpty (copy), IncrementCharacterVersion (copy), UpdateCharacter (copy), FinishedWaitingOnLCUpdate (copy)
	ArgCheck.assert(p79.modelInitialized, "applyHumanoidDescription called before initializeModel")
	task.spawn(function() -- line: 1225
		-- upvalues: p79 (copy), p81 (copy), isHumanoidDescriptionEmpty (copy), IncrementCharacterVersion (copy), UpdateCharacter (copy), FinishedWaitingOnLCUpdate (copy), p80 (copy)
		if p79.destroyed or not p79._currentCharacter:IsDescendantOf(game) then
			return
		end

		local lastHumanoidDescriptionApplied = p79.lastHumanoidDescriptionApplied
		local v349 = p79:combineOutfitTryOnAndEquippedHumanoidDescriptions()

		p79.checkBodyColors = false

		local v350 = p81 and isHumanoidDescriptionEmpty(p79.humanoidDescriptionTryOn)

		p79.characterModelPool:maybeUpdateCharacter(v349):andThen(function(p82, p83) -- line: 1240
			-- upvalues: p79 (copy), IncrementCharacterVersion (copy), UpdateCharacter (copy), FinishedWaitingOnLCUpdate (copy), v349 (copy), p80 (copy), p81 (copy), v350 (copy), lastHumanoidDescriptionApplied (copy)
			p79.store:dispatch(IncrementCharacterVersion())

			if p82 ~= p79._currentCharacter then
				p79.toolManager:unequipTool()
				p79._currentCharacter = p82
				p79.store:dispatch(UpdateCharacter(p79._currentCharacter))
				p79._currentCharacter.Parent = p79.characterRoot
				p79.toolManager:checkAndEquipTool()
			end

			if not p83 and p79.store:getState().AvatarExperience.AvatarScene.Character.WaitingOnLayeredClothingUpdates then
				p79.store:dispatch(FinishedWaitingOnLCUpdate())
			end

			p79.lastHumanoidDescriptionApplied = v349
			p79:finishApplyDescription(p80, p81, v350, lastHumanoidDescriptionApplied)
			p79.characterManagerCallbacks.setAppliedDescription(p79._currentCharacter.Humanoid.HumanoidDescription)
		end)
	end)
end
function t1.switchAvatarType(p84, p85) -- line: 1280
	-- upvalues: UpdateCharacter (copy), IncrementCharacterVersion (copy)
	p84._currentCharacter = p84.characterModelPool:switchAvatarType(p85)
	p84.store:dispatch(UpdateCharacter(p84._currentCharacter))
	p84.store:dispatch(IncrementCharacterVersion())
	p84._currentCharacter.Parent = p84.characterRoot
	p84.toolManager:notifySwitchedAvatarType()
end
function t1.adjustHeightToStandOnPlatform(_, p87) -- line: 1291
	local HumanoidRootPart = p87.HumanoidRootPart
	local Humanoid = p87.Humanoid
	local v275 = HumanoidRootPart.Size.y * 0.5 + Humanoid.HipHeight
	local v276, _, v278, v279, v280, v281, v282, v283, v284, v285, v286, v287 = HumanoidRootPart.CFrame:components()

	HumanoidRootPart.CFrame = CFrame.new(v276, v275, v278, v279, v280, v281, v282, v283, v284, v285, v286, v287)
end
function t1.stop(p88) -- line: 1301
	-- upvalues: CharacterManagerUtils (copy)
	CharacterManagerUtils.updateHumanoidDescriptionUsingOutfitTryOn(p88.store:getState(), p88.humanoidDescriptionTryOn)
	p88:applyHumanoidDescription(true)

	for _, v290 in p88.connections do
		v290:disconnect()
	end

	p88.connections = {}
	p88.characterModelPool:stop()
	p88.animationManager:stop()
	p88.toolManager:stop()
	p88.initialTryOnApplied = false
	p88.cachedRoduxState = p88.store:getState()
end
function t1.onDestroy(p89) -- line: 1327
	-- upvalues: SetCurrentCharacter (copy), IncrementCharacterVersion (copy)
	p89.humanoidDescriptionCurrentlyEquipped:Destroy()
	p89.humanoidDescriptionTryOn:Destroy()
	p89.lastHumanoidDescriptionApplied:Destroy()
	p89.characterRoot:Destroy()
	p89.destroyed = true
	p89.animationManager:onDestroy()
	p89.toolManager:onDestroy()
	p89.characterModelPool:onDestroy()
	p89.store:dispatch(SetCurrentCharacter(nil))
	p89.store:dispatch(IncrementCharacterVersion())
end
function t1.updateAvatarRoute(p90, p91, p92) -- line: 1343
	-- upvalues: Utils (copy)
	p90.animationManager:updateAvatarRoute(p91, p92)
	p90.toolManager:updateAvatarRoute(p91, p92)
	p90.latestAvatarRoute = p91

	local v295 = Utils.routeIsPPEStaticImagePage(p91)
	local v296 = Utils.routeIsPPEStaticImagePage(p92)

	if v295 and not v296 then
		p90:freezeParticles()
		p90:watchCharacterToFreezeNewParticles()

		return
	end

	if v296 and not v295 then
		p90:stopWatchingCharacter()
		p90:unfreezeParticles()
	end
end
function t1.watchCharacterToFreezeNewParticles(p93) -- line: 1367
	-- upvalues: RunService (copy), ParticleUtility (copy)
	local CurrentCharacter = p93.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if CurrentCharacter then
		p93.freezeParticlesCharacterConnection = CurrentCharacter.DescendantAdded:Connect(function(descendant) -- line: 1370
			-- upvalues: RunService (copy), p93 (copy), ParticleUtility (copy)
			if descendant:IsA("Tool") then
				RunService.Heartbeat:Wait()
				p93:recursiveFreezeParticles(descendant)
				ParticleUtility.FastForwardParticles(descendant)
			end
		end)
	end
end
function t1.stopWatchingCharacter(p94) -- line: 1381
	if p94.freezeParticlesCharacterConnection then
		p94.freezeParticlesCharacterConnection:Disconnect()
		p94.freezeParticlesCharacterConnection = nil
	end
end
function t1.instanceIsAParticleEffect(_, p96) -- line: 1388
	return p96:IsA("ParticleEmitter") or (p96:IsA("Fire") or (p96:IsA("Smoke") or p96:IsA("Sparkles")))
end
function t1.recursiveFreezeParticles(p97, p98) -- line: 1392
	-- upvalues: ParticleUtility (copy)
	if ParticleUtility.InstanceIsAParticleEffect(p98) then
		p97.frozenParticlesToTimeScale[p98] = p98.TimeScale
		p98.TimeScale = 0
	end

	for _, child in (p98:GetChildren()) do
		p97:recursiveFreezeParticles(child)
	end
end
function t1.freezeParticles(p99) -- line: 1403
	p99.frozenParticlesToTimeScale = {}

	local CurrentCharacter = p99.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if CurrentCharacter then
		p99:recursiveFreezeParticles(CurrentCharacter)
	end
end
function t1.unfreezeParticles(p100) -- line: 1417
	if p100.frozenParticlesToTimeScale then
		for v309, v310 in p100.frozenParticlesToTimeScale do
			v309.TimeScale = v310
		end

		p100.frozenParticlesToTimeScale = {}
	end
end

return t1
