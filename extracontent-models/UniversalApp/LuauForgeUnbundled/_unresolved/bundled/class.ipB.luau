local AvatarEditorService = game:GetService("AvatarEditorService")

local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local particleUtility = Thumbnailing.ParticleUtility
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectHasBodyTryOn = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
local selectAvatarPreviewColors = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local destroyMakeupDescriptions = AvatarExperienceCommon.Utils.destroyMakeupDescriptions

local getMakeupDescriptionsFromHumanoidDescription = AvatarExperienceCommon.Utils.getMakeupDescriptionsFromHumanoidDescription
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS

local module3 = require("@luauforge/bundled/dFs")
local module4 = require("@luauforge/bundled/dzP")
local module5 = require("@luauforge/bundled/dKU")
local setCurrentCharacter = module5.Actions.SetCurrentCharacter
local assetTypeToAssetCategory = module5.Constants.AssetTypeToAssetCategory
local module6 = require("@luauforge/bundled/ipC")
local module7 = require("@luauforge/bundled/dOZ")
local module8 = require("@luauforge/bundled/dFm")

local module9 = require("@luauforge/bundled/dPb")

local module10 = require("@luauforge/bundled/dPd")
local module11 = require("@luauforge/bundled/dPl")

local module12 = require("@luauforge/bundled/ipD")
local module13 = require("@luauforge/bundled/ipK")

local module14 = require("@luauforge/bundled/ipL")
local CharacterModelPool = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/CharacterModelPool")
local module16 = require("@luauforge/bundled/hcC")

local module17 = require("@luauforge/bundled/gLb")

local module18 = require("@luauforge/bundled/gKW")
local module19 = require("@luauforge/bundled/gKX")

local module20 = require("@luauforge/bundled/dRg")
local module21 = require("@luauforge/bundled/dPN")
local module22 = require("@luauforge/bundled/gKV")
local module23 = require("@luauforge/bundled/gKU")
local module24 = require("@luauforge/bundled/fCe")
local module25 = require("@luauforge/bundled/dzE")
local module26 = require("@luauforge/bundled/fCI")
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dKT")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module28 = require("@luauforge/bundled/dPN")
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE

local module29 = require("@luauforge/bundled/gKY")
local module30 = require("@luauforge/bundled/ipO")
local module31 = require("@luauforge/bundled/ipP")
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagEnableHeadShapeForCharacterManager = AvatarExperienceFlags.FFlagEnableHeadShapeForCharacterManager
local fFlagFixHeadShapeColorSlider = AvatarExperienceFlags.FFlagFixHeadShapeColorSlider
local defineFastFlag = game:DefineFastFlag("AXFixTryOnDefaultClothing", false)
local defineFastFlag2 = game:DefineFastFlag("AXCheckApplyDefaultClothingErrorGuards", false)
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXCharacterManagerResumeFromLastUpdate = AvatarExperienceFlags.FFlagAXCharacterManagerResumeFromLastUpdate
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings

local v5 = if fFlagAXUseSignalsForBodyColorPickerSettings then require("@luauforge/bundled/haA") else nil

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local fFlagAXSpawnEffectPreview = AvatarExperienceFlags.FFlagAXSpawnEffectPreview
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = AvatarExperienceCommon.Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local v6 = settings():GetFVariable("LuaAppsDiagLoadTimeAvatarModel") .. "_" .. module24.getDeviceType()

local class = {}
class.__index = class

local assetTypeIdStringToHumanoidDescriptionProp = module21.AssetTypeIdStringToHumanoidDescriptionProp
local humanoidDescriptionScaleToName = module21.HumanoidDescriptionScaleToName

local assetTypeIdStrings = module21.AssetTypeIdStrings

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.loadtime")

local function getEffectiveAvatarType(p2)
	local avatarType = fFlagAXPhotoboothMomentsPage
		and p2.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType

	if avatarType then
		return avatarType
	end

	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local v7 = {
	toastMessage = "Feature.Avatar.Message.FaceNotVisible",
	isLocalized = false,
	toastType = module25.InformationMessage
}

local function isHumanoidDescriptionPropertyEmpty(p2): boolean
	return p2 == "" or p2 == 0
end

local function isHumanoidDescriptionEmpty(humanoidDescriptionTryOn): boolean
	for k, v8 in assetTypeIdStringToHumanoidDescriptionProp do
		local v9 = humanoidDescriptionTryOn[v8]

		if v9 ~= "" and v9 ~= 0 then
			return false
		end
	end

	return not (#humanoidDescriptionTryOn:GetAccessories(true) > 0)
end

function class.new(store, networking, analytics, p2, p3, characterManagerEvents, characterManagerCallbacks, catalogAnalytics, p4)
	local class2 = {}
	setmetatable(class2, class)

	class2.startAvatarModelLoadTime = tick()
	class2.connections = {}
	class2.store = store
	class2.networking = networking
	class2.analytics = analytics

	class2.characterManagerEvents = characterManagerEvents
	class2.characterManagerCallbacks = characterManagerCallbacks

	class2.catalogAnalytics = catalogAnalytics

	class2.characterModelPool = CharacterModelPool.new(store, analytics, p3, p4)

	class2._currentCharacter = class2.characterModelPool:getCurrentCharacter()
	class2.store:dispatch(module6(class2._currentCharacter))
	class2.store:dispatch(module7())

	class2.characterRoot = Instance.new("Folder")
	class2.characterRoot.Name = "CharacterRoot"
	class2.characterRoot.Parent = game.Workspace

	class2.needsToEquipBundleTryOn = false
	class2.initialHumanoidDescriptionApplied = false
	class2.initialTryOnApplied = false
	class2.destroyed = false
	class2.checkBodyColors = true
	class2.modelInitialized = false
	class2.firstCallinPPE = true
	class2.shouldUnequipAccessoriesAndMakeupBeforeTryOn = false

	class2.animationManager = module12.new(store, class2, p2)
	local v8 = if fFlagAXSpawnEffectPreview then module13.new(store) else nil
	class2.spawnEffectManager = v8

	class2.toolManager = module14.new(store, class2.animationManager, class2)

	class2.humanoidDescriptionCurrentlyEquipped = Instance.new("HumanoidDescription")
	class2.humanoidDescriptionTryOn = Instance.new("HumanoidDescription")
	class2.lastHumanoidDescriptionApplied = Instance.new("HumanoidDescription")

	if not isVRAppBuild() then
		class2:maybeInitializeModel(class2.store:getState())
	end

	class2.cachedRoduxState = class2.store:getState()

	return class2
end

function class:maybeInitializeModel(p2)
	if not self.modelInitialized and module16(p2) then
		self.modelInitialized = true
		self:initializeModel(p2)
	end
end

function class:setupAnimations(p3, p4)
	self.characterModelPool:setupAnimations(p3, p4)
end

function class:initializeModel(p2)
	local avatarType

	if fFlagAXPhotoboothMomentsPage then
		avatarType = fFlagAXPhotoboothMomentsPage
			and p2.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
			or p2.AvatarExperience.AvatarEditor.Character.AvatarType
	else
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	if avatarType == module20.AvatarType.R6 then
		self:switchAvatarType(avatarType)
	end

	self._currentCharacter.Parent = self.characterRoot
	self:updateHumanoidDescriptionCurrentlyEquipped(p2)
	self:applyHumanoidDescription(true)
	self.toolManager:update(p2)
end

function class:updateCharacterFromConnection(p2)
	self.characterModelPool:maybeUpdateCharacter(p2):andThen(function(p3, p4)
		self.characterManagerCallbacks.setAppliedDescription(self._currentCharacter.Humanoid.HumanoidDescription)
	end)
end

function class:initAvatarScalesChangedConnection()
	if
		module30
		and (self.characterManagerEvents == nil or self.characterManagerEvents.avatarScalesChangedEvent == nil)
	then
		module31("CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents")
		return
	end

	local avatarScalesChangedEventConnection = self.characterManagerEvents.avatarScalesChangedEvent:Connect(function(items)
		if not items then
			return
		end

		local clone = self.lastHumanoidDescriptionApplied:Clone()

		for k, item in items do
			clone[humanoidDescriptionScaleToName[k]] = item
		end

		self:updateCharacterFromConnection(clone)

		if self.characterModelPool:isR15() then
			self:adjustHeightToStandOnPlatform(self._currentCharacter)
		end
	end)
	table.insert(self.connections, avatarScalesChangedEventConnection)
end

function class:getBodyColor3sForSelectedBodyParts(p3, p4)
	local v8

	if fFlagAXUseSignalsForBodyColorPickerSettings then
		v8 = v5(false).getSelectedBodyPartIndex(false)
	else
		v8 = p3.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
	end

	local bodyColor3sForSelectedBodyParts = {}

	for k, bodyPartForSkinColoringId in module20.BodyPartButtonData[v8].bodyPartForSkinColoringIds do
		bodyColor3sForSelectedBodyParts[bodyPartForSkinColoringId] = p4
	end

	return bodyColor3sForSelectedBodyParts
end

function class:initBodyColorsChangedConnection()
	if
		module30
		and (self.characterManagerEvents == nil or self.characterManagerEvents.bodyColorsChangedEvent == nil)
	then
		module31("CharacterManager_initBodyColorsChangedConnection_characterManagerEvents")
		return
	end

	local bodyColorsChangedEventConnection = self.characterManagerEvents.bodyColorsChangedEvent:Connect(function(p2)
		if not p2 then
			self.overrideBodyColor3s = nil
			return
		end

		local state = self.store:getState()

		if module18(state) then
			self.overrideBodyColor3s = nil
			return
		end

		local bodyColor3sForSelectedBodyParts = self:getBodyColor3sForSelectedBodyParts(state, p2)
		local v8

		if selectHasBodyTryOn(state) then
			v8 = self:combineOutfitTryOnAndEquippedHumanoidDescriptions()
			self:updateHumanoidDescriptionTryOnWithColors(state)
		else
			v8 = self.humanoidDescriptionCurrentlyEquipped:Clone()
		end

		module26.setHumanoidDescriptionColorsFromBodyColor3s(v8, bodyColor3sForSelectedBodyParts)

		local v9 = nil

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
			)
		end

		local success, result = pcall(function()
			return AvatarEditorService:CheckApplyDefaultClothingAsync(v8)
		end)

		if success then
			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
				)
			end

			v9 = result
		else
			if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(module28.Counter.AvatarEditorServiceErrors.CheckApplyDefaultClothing)
			end

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
					result
				)
			end

			if defineFastFlag2 then
				module3(result)
			else
				error(result)
			end
		end

		self.overrideBodyColor3s = bodyColor3sForSelectedBodyParts
		self:updateCharacterFromConnection(v9 or v8)
	end)
	table.insert(self.connections, bodyColorsChangedEventConnection)
end

function class:initAdjustmentChangedConnection()
	if
		module30
		and (self.characterManagerEvents == nil or self.characterManagerEvents.adjustmentChangedEvent == nil)
	then
		module31("CharacterManager_initAdjustmentChangedConnection_characterManagerEvents")
		return
	end

	local adjustmentChangedEventConnection = self.characterManagerEvents.adjustmentChangedEvent:Connect(function(position, rotation, scale)
		local selectedAccessory = self.store:getState().AvatarExperience.AccessoryAdjustment.SelectedAccessory
		local clone = self.lastHumanoidDescriptionApplied:Clone()

		local selectedAccessoryDescription = module24.getSelectedAccessoryDescription(
			clone,
			selectedAccessory
		)

		if selectedAccessoryDescription then
			if position then
				selectedAccessoryDescription.Position = position
			end

			if rotation then
				selectedAccessoryDescription.Rotation = rotation
			end

			if scale then
				selectedAccessoryDescription.Scale = scale
			end

			self:updateCharacterFromConnection(clone)
		end
	end)

	table.insert(self.connections, adjustmentChangedEventConnection)
end

function class:onCurrentSortChangedDeferred()
	self.currentSortUpdatePending = false

	if not (self.disposeCurrentSortEffect and self.currentSortChanged) then
		return
	end

	local state = self.store:getState()

	if state ~= self.lastFlushedState then
		return
	end

	self:update(state, state)
end

function class:createCurrentSortEffect()
	local v8 = false
	return Signals.createEffect(function(p2)
		getLayeredClothingCurrentSortStore(false).getOrderedList(p2)
		getLayeredClothingCurrentSortStore(false).getRemovedList(p2)

		if not v8 then
			v8 = true
			return
		end

		self.currentSortChanged = true

		if not self.currentSortUpdatePending then
			self.currentSortUpdatePending = true

			task.defer(function()
				self:onCurrentSortChangedDeferred()
			end)
		end
	end)
end

function class:start()
	self:maybeInitializeModel(self.store:getState())
	self._currentCharacter.Parent = self.characterRoot

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		self.lastFlushedState = self.store:getState()
		self.disposeCurrentSortEffect = self:createCurrentSortEffect()
	end

	local changedConnection = self.store.changed:connect(function(p2, p3)
		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			self.lastFlushedState = p2
		end

		self:update(p2, p3)

		if fFlagAXCharacterManagerResumeFromLastUpdate then
			self.lastUpdatedState = p2
		end
	end)
	table.insert(self.connections, changedConnection)
	self:initAvatarScalesChangedConnection()
	self:initBodyColorsChangedConnection()
	self:initAdjustmentChangedConnection()

	self.characterModelPool:start()
	self.animationManager:start()

	if fFlagAXSpawnEffectPreview and self.spawnEffectManager then
		self.spawnEffectManager:start()
	end

	self.toolManager:start()

	self:updateHumanoidDescriptionCurrentlyEquipped(self.store:getState())
	self:applyHumanoidDescription(true)
	self.toolManager:update(self.store:getState())

	local state = self.store:getState()
	self:update(state, self.cachedRoduxState)

	if fFlagAXCharacterManagerResumeFromLastUpdate then
		self.lastUpdatedState = state
	end
end

function class:onSceneStartedOutsideAvatarRoute(p3)
	self.animationManager:onSceneStartedOutsideAvatarRoute(p3)
end

function class:updateHumanoidDescriptionTryOnWithColors(p3)
	local v8

	if module18(p3) then
		v8 = module19(p3)
	elseif self.overrideBodyColor3s then
		v8 = self.overrideBodyColor3s
	else
		v8 = selectAvatarPreviewColors(p3)
	end

	module26.setHumanoidDescriptionColorsFromBodyColor3s(self.humanoidDescriptionTryOn, v8)
end

function class:update(p2, p3)
	local shouldUpdateHumanoidDescriptionCurrentlyEquipped = self:shouldUpdateHumanoidDescriptionCurrentlyEquipped(
		p2,
		p3
	)

	if shouldUpdateHumanoidDescriptionCurrentlyEquipped then
		self:updateHumanoidDescriptionCurrentlyEquipped(p2)
	end

	local shouldUpdateHumanoidDescriptionTryOnOutfit = self:shouldUpdateHumanoidDescriptionTryOnOutfit(p2, p3)

	if shouldUpdateHumanoidDescriptionTryOnOutfit then
		module22.updateHumanoidDescriptionUsingOutfitTryOn(p2, self.humanoidDescriptionTryOn)
	end

	local avatarType

	if fFlagAXPhotoboothMomentsPage then
		avatarType = fFlagAXPhotoboothMomentsPage
			and p2.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
			or p2.AvatarExperience.AvatarEditor.Character.AvatarType
	else
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v8 = if fFlagAXPhotoboothMomentsPage then fFlagAXPhotoboothMomentsPage and p3.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType or p3.AvatarExperience.AvatarEditor.Character.AvatarType else p3.AvatarExperience.AvatarEditor.Character.AvatarType
	local v9 = avatarType ~= v8

	if v9 then
		self:switchAvatarType(avatarType)
	end

	local v10 = if fFlagAXPhotoboothMomentsPage then module22.isTryingOnWholeAvatar(p2) else p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	self.isTryingOnLook = v10

	self.isTryingOnMakeupLook = p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId ~= nil

	self.shouldUnequipAccessoriesAndMakeupBeforeTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
		and not self.isTryingOnMakeupLook

	self.shouldUnequipBodyBeforeTryOn = module23.shouldUnequipBodyBeforeTryOn(p2)

	local v11 = p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= p2.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode

	if
		shouldUpdateHumanoidDescriptionCurrentlyEquipped
		or shouldUpdateHumanoidDescriptionTryOnOutfit
		or v9
	then
		self:applyHumanoidDescription(
			shouldUpdateHumanoidDescriptionCurrentlyEquipped,
			shouldUpdateHumanoidDescriptionTryOnOutfit
		)
	end

	if
		v11
		or shouldUpdateHumanoidDescriptionCurrentlyEquipped
		or shouldUpdateHumanoidDescriptionTryOnOutfit
		or v9
	then
		self.toolManager:update(p2)
	end
end

function class:updateNoFace(p2)
	local head = self._currentCharacter:FindFirstChild("Head")

	if not head then
		warn("No head was found on the character!")
		return
	end

	local v8 = not head:FindFirstChildWhichIsA("Decal")

	local v9 = assetTypeIdStringToHumanoidDescriptionProp[assetTypeIdStrings.Face]
	local v10 = p2[v9]
	local v11 = self.lastHumanoidDescriptionApplied[v9]

	if v8 and v10 ~= v11 and v11 ~= 0 then
		self.store:dispatch(module8(Cryo.Dictionary.join(v7)))

		local catalogAnalytics = self.catalogAnalytics
		local latestAvatarRoute = self.latestAvatarRoute

		if catalogAnalytics and latestAvatarRoute and latestAvatarRoute.opaque then
			catalogAnalytics.sendAXCounterV2(module21.Counter.Toasts.NoFaceHead, {
				route = latestAvatarRoute.opaque.name
			})
		end
	end
end

function class:shouldUpdateHumanoidDescriptionCurrentlyEquipped(p3, p4)
	local equippedAssets = p3.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local equippedAssets2 = p4.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local avatarScales = p3.AvatarExperience.AvatarEditor.Character.AvatarScales
	local avatarScales2 = p4.AvatarExperience.AvatarEditor.Character.AvatarScales
	local bodyColors = p3.AvatarExperience.AvatarEditor.Character.BodyColors
	local bodyColors2 = p4.AvatarExperience.AvatarEditor.Character.BodyColors
	local bodyColor3s = p3.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local bodyColor3s2 = p4.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local v8 = equippedAssets ~= equippedAssets2
	local v9 = avatarScales ~= avatarScales2
	local v10 = bodyColors ~= bodyColors2
	local v11 = bodyColor3s ~= bodyColor3s2
	return v8 or v9 or v10 or v11
end

function class:updateHumanoidDescriptionCurrentlyEquipped(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales

	if not equippedAssets then
		logging.warn("CharacterManager: Equipped assets has not been initialized!")
		return
	end

	if module29() then
		module22.resetHumanoidDescriptionProperties(self.humanoidDescriptionCurrentlyEquipped)
	else
		for k, v8 in assetTypeIdStringToHumanoidDescriptionProp do
			self.humanoidDescriptionCurrentlyEquipped[v8] = ""
		end
	end

	self.humanoidDescriptionCurrentlyEquipped:SetAccessories({}, true)

	local v8 = {}

	local v9 = false
	local v10 = false

	if
		equippedAssets
		and (not equippedAssets[assetTypeIdStrings.Head] or Cryo.isEmpty(equippedAssets[assetTypeIdStrings.Head]))
	then
		v9 = true
	elseif
		equippedAssets
		and (not equippedAssets[assetTypeIdStrings.DynamicHead] or Cryo.isEmpty(equippedAssets[assetTypeIdStrings.DynamicHead]))
	then
		v10 = true
	end

	for k, equippedAsset in equippedAssets do
		local v11 = assetTypeIdStringToHumanoidDescriptionProp[k]

		if k == assetTypeIdStrings.Gear or isMakeupAssetType(k) then
			continue
		end

		if module21.AssetTypeIdToAccessoryTypeEnum[k] then
			for k2, v12 in equippedAsset do
				table.insert(v8, module24.createHumanoidDescriptionAccessoryInfo(k, k2, v12))
			end
		elseif
			v11
			and (k ~= assetTypeIdStrings.Head or not v9)
			and (k ~= assetTypeIdStrings.DynamicHead or not v10)
		then
			local keys = Cryo.Dictionary.keys(equippedAsset)

			if #keys == 0 then
				self.humanoidDescriptionCurrentlyEquipped[v11] = 0
			elseif fFlagFixHeadShapeColorSlider and k == module21.AssetTypeIdStrings.DynamicHead then
				module22.applyHeadShapeFromAssetMetadata(
					self.humanoidDescriptionCurrentlyEquipped,
					equippedAsset
				)
			else
				self.humanoidDescriptionCurrentlyEquipped[v11] = table.concat(keys, ",")
			end
		end
	end

	self.humanoidDescriptionCurrentlyEquipped:SetAccessories(v8, true)

	setMakeupDescriptions(self.humanoidDescriptionCurrentlyEquipped, equippedAssets)

	for k, avatarScale in avatarScales do
		self.humanoidDescriptionCurrentlyEquipped[humanoidDescriptionScaleToName[k]] = avatarScale
	end

	self.checkBodyColors = true

	if self.overrideBodyColor3s then
		module26.setHumanoidDescriptionColorsFromBodyColor3s(
			self.humanoidDescriptionCurrentlyEquipped,
			self.overrideBodyColor3s
		)
	else
		module26.setHumanoidDescriptionColorsFromCharacter(
			self.humanoidDescriptionCurrentlyEquipped,
			p2.AvatarExperience
		)
	end
end

function class:shouldUpdateHumanoidDescriptionTryOnOutfit(p2, p3): boolean
	if self.latestAvatarRoute then
		if module24.routeIsProfilePictureEditor(self.latestAvatarRoute) then
			if self.firstCallinPPE then
				self.firstCallinPPE = false
			else
				if fFlagAXUseSignalsForLayeredClothingCurrentSort then
					self.currentSortChanged = false
				end

				return false
			end
		else
			self.firstCallinPPE = true
		end
	end

	local v8 = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems ~= p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v9

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		v9 = self.currentSortChanged == true
		self.currentSortChanged = false
	else
		v9 = p2.AvatarExperience.LayeredClothingSort.CurrentSort ~= p3.AvatarExperience.LayeredClothingSort.CurrentSort
	end

	local v10 = module17(p2) ~= module17(p3)

	if not self.initialTryOnApplied then
		self.initialTryOnApplied = true
		v8 = true
	end

	if v8 or v9 or v10 then
		return true
	end

	if p2.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s == p3.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s then
		return module18(p2) ~= module18(p3)
	end

	return true
end

function class:setAccessoriesForTryOn(object)
	local accessories = object:GetAccessories(true)

	local accessories2 = self.humanoidDescriptionTryOn:GetAccessories(true)
	local v8

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		v8 = getLayeredClothingCurrentSortStore(false).getRemovedList(false)
	else
		v8 = self.store:getState().AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
	end

	local set = {}
	local set2 = {}

	for k, accessory in accessories2 do
		local v10 = assetTypeToAssetCategory[module21.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]]

		set[accessory.AccessoryType] = true

		if v10 then
			set2[v10] = true
		end
	end

	for k, v9 in v8 do
		if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v9] then
			continue
		end

		local accessoryTypeEnum = module21.AssetTypeIdToAccessoryTypeEnum[v9]
		local v10 = assetTypeToAssetCategory[v9]
		set[accessoryTypeEnum] = true

		if v10 then
			set2[v10] = true
		end
	end

	if self.isTryingOnMakeupLook then
		set[module21.AssetTypeIdToAccessoryTypeEnum[assetTypeIdStrings.EyebrowAccessory]] = true
		set[module21.AssetTypeIdToAccessoryTypeEnum[assetTypeIdStrings.EyelashAccessory]] = true
	end

	for k, accessory in accessories do
		local v9 = module21.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]

		local v10 = not set[accessory.AccessoryType]

		local v11 = assetTypeToAssetCategory[v9]

		if v11 then
			v10 = not set2[v11]
		end

		if module22.isDHBundleTryOn(self.store:getState()) and module21.DynamicHeadAssetTypes[v9] then
			v10 = false
		end

		if v10 then
			table.insert(accessories2, accessory)
		end
	end

	if module22.isClassicHeadOrClassicFaceTryOn(self.store:getState()) then
		accessories2 = Cryo.List.filter(accessories2, function(p2): boolean
			local v9 = module21.AccessoryTypeEnumToAssetTypeId[p2.AccessoryType]
			return not module21.DynamicHeadAssetTypes[v9]
		end)
	end

	object:SetAccessories(accessories2, true)
end

function class:getTryOnsBundleOutfitInfo()
	local state = self.store:getState()

	for k, tryOnItem in state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if not (tryOnItem.itemType == module21.ItemType.Bundle and tryOnItem.itemSubType == module21.BundleTypeIdStrings.BodyParts) then
			continue
		end

		local outfitInfoFromBundleId = module24.getOutfitInfoFromBundleId(state, tryOnItem.itemId)

		if outfitInfoFromBundleId then
			return outfitInfoFromBundleId
		end
	end

	return nil
end

function class.makeupAssetsTryOn(p2, parent, p3)
	local makeupDescriptionsFromHumanoidDescription = getMakeupDescriptionsFromHumanoidDescription(p3)

	if #makeupDescriptionsFromHumanoidDescription == 0 then
		return
	end

	local state = p2.store:getState()
	local tryOnItems = state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local makeupDescriptionsFromHumanoidDescription2 = getMakeupDescriptionsFromHumanoidDescription(parent)

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		local orderedList = getLayeredClothingCurrentSortStore(false).getOrderedList(false)

		if #orderedList > 0 then
			makeupDescriptionsFromHumanoidDescription2 = Cryo.List.filter(
				makeupDescriptionsFromHumanoidDescription2,
				function(p4): boolean
					for k, ordered in orderedList do
						if tostring(ordered.id) == tostring(p4.AssetId) then
							return true
						end
					end

					return false
				end
			)
		end
	elseif
		state.AvatarExperience.LayeredClothingSort
		and state.AvatarExperience.LayeredClothingSort.CurrentSort
		and #state.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList > 0
	then
		local orderedList = state.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList

		makeupDescriptionsFromHumanoidDescription2 = Cryo.List.filter(
			makeupDescriptionsFromHumanoidDescription2,
			function(p4): boolean
				for k, ordered in orderedList do
					if tostring(ordered.id) == tostring(p4.AssetId) then
						return true
					end
				end

				return false
			end
		)
	end

	table.sort(makeupDescriptionsFromHumanoidDescription2, function(a, b): boolean
		return a.Order < b.Order
	end)

	local assetIdSet = {}

	for k, v8 in makeupDescriptionsFromHumanoidDescription2 do
		assetIdSet[v8.AssetId] = true
	end

	local v8 = {}

	for k, v9 in makeupDescriptionsFromHumanoidDescription do
		if assetIdSet[v9.AssetId] then
			continue
		end

		local tryOnItem = tryOnItems[getTryOnItemReducerKey(tostring(v9.AssetId), module21.ItemType.Asset)]

		local v10 = if tryOnItem then tryOnItem.order else MAX_MAKEUP_LAYERS
		v9.Order = v10
		table.insert(v8, v9)
	end

	local v9 = not (#makeupDescriptionsFromHumanoidDescription2 + #v8 <= MAX_MAKEUP_LAYERS)
		and { table.unpack(
				makeupDescriptionsFromHumanoidDescription2,
				#makeupDescriptionsFromHumanoidDescription2 + #v8 - MAX_MAKEUP_LAYERS + 1
			) }
		or makeupDescriptionsFromHumanoidDescription2

	for k, v10 in v8 do
		table.insert(v9, v10)
	end

	table.sort(v9, function(a, b): boolean
		if a.Order ~= b.Order then
			return a.Order < b.Order
		end

		local tryOnItemReducerKey = getTryOnItemReducerKey(tostring(a.AssetId), module21.ItemType.Asset)
		local tryOnItemReducerKey2 = getTryOnItemReducerKey(tostring(b.AssetId), module21.ItemType.Asset)

		if not tryOnItems[tryOnItemReducerKey] then
			return true
		end

		if tryOnItems[tryOnItemReducerKey2] then
			return tryOnItems[tryOnItemReducerKey].itemRecency < tryOnItems[tryOnItemReducerKey2].itemRecency
		end

		return false
	end)

	local clones = {}

	for k, v10 in v9 do
		table.insert(clones, v10:Clone())
	end

	destroyMakeupDescriptions(parent)

	for k, v10 in clones do
		v10.Order = k - 1
		v10.Parent = parent
	end
end

function class.singleMakeupAssetTryOn(p2, parent, p3)
	local v8 = getMakeupDescriptionsFromHumanoidDescription(p3)[1]

	if not v8 then
		return
	end

	local tryOnItem = p2.store:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(
		tostring(v8.AssetId),
		module21.ItemType.Asset
	)]

	local makeupDescriptionsFromHumanoidDescription = getMakeupDescriptionsFromHumanoidDescription(parent)

	table.sort(makeupDescriptionsFromHumanoidDescription, function(a, b): boolean
		return a.Order < b.Order
	end)

	for k, v9 in makeupDescriptionsFromHumanoidDescription do
		if v9.AssetId == v8.AssetId then
			return
		end
	end

	if not (#makeupDescriptionsFromHumanoidDescription < MAX_MAKEUP_LAYERS) then
		table.remove(makeupDescriptionsFromHumanoidDescription, 1)
	end

	local order = if tryOnItem then tryOnItem.order else nil
	local v9 = #makeupDescriptionsFromHumanoidDescription

	if order ~= nil then
		v9 = math.max(0, (math.min(order, v9)))
	end

	local v10 = {}

	for k, v11 in makeupDescriptionsFromHumanoidDescription do
		table.insert(v10, v11:Clone())
	end

	table.insert(v10, v9 + 1, v8)

	destroyMakeupDescriptions(parent)

	for k, v11 in v10 do
		v11.Order = k - 1
		v11.Parent = parent
	end
end

function class.lookMakeupTryOn(p2, parent, p3)
	destroyMakeupDescriptions(parent)

	for k, v8 in getMakeupDescriptionsFromHumanoidDescription(p3) do
		local clone = v8:Clone()
		clone.Parent = parent
	end
end

function class:combineTryOnMakeupDescriptionsWithEquipped(p2, p3)
	if self.isTryingOnLook or self.isTryingOnMakeupLook then
		module22.lookMakeupTryOn(p2, p3)
		return
	end

	local state = self.store:getState()
	module22.makeupAssetsTryOn(state, p2, p3)
end

function class:combineOutfitTryOnAndEquippedHumanoidDescriptions()
	local tryOnsBundleOutfitInfo = self:getTryOnsBundleOutfitInfo()

	local result = self.humanoidDescriptionCurrentlyEquipped:Clone()

	if self.shouldUnequipAccessoriesAndMakeupBeforeTryOn then
		result:SetAccessories({}, true)
		result.GraphicTShirt = 0
		result.Shirt = 0
		result.Pants = 0

		if fFlagAXCatalogMakeupSupport then
			destroyMakeupDescriptions(result)
		end
	end

	for k, v8 in assetTypeIdStringToHumanoidDescriptionProp do
		if
			module21.AssetTypeIdToCategory[k] == module21.AssetCategories.Body
			and self.shouldUnequipBodyBeforeTryOn
		then
			result[v8] = 0
		end

		if module21.AssetTypeIdToAccessoryTypeEnum[k] then
			continue
		end

		local v9 = self.humanoidDescriptionTryOn[v8]

		if v9 ~= "" and v9 ~= 0 then
			result[v8] = self.humanoidDescriptionTryOn[v8]
		end
	end

	self:setAccessoriesForTryOn(result)

	self:combineTryOnMakeupDescriptionsWithEquipped(result, self.humanoidDescriptionTryOn)

	if defineFastFlag then
		if tryOnsBundleOutfitInfo then
			for k, scale in tryOnsBundleOutfitInfo.scales do
				result[humanoidDescriptionScaleToName[k]] = scale
			end
		end

		module22.setAvatarTryOnProperties(result, self.store:getState())

		if fFlagEnableHeadShapeForCharacterManager then
			module22.applyHeadShapeToHumanoidDescription(result, self.store:getState())
		end
	end

	local v8 = nil

	if fFlagAXAvatarEditorServiceTelemetryV2 then
		reportAvatarEditorServiceCounter(
			AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
			AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
		)
	end

	local success, result2 = pcall(function()
		return AvatarEditorService:CheckApplyDefaultClothingAsync(result)
	end)

	if success then
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
			)
		end

		v8 = result2
	else
		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module28.Counter.AvatarEditorServiceErrors.CheckApplyDefaultClothing)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.CheckApplyDefaultClothing,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
				result2
			)
		end

		if defineFastFlag2 then
			module3(result2)
		else
			error(result2)
		end
	end

	result = v8 or result

	if defineFastFlag then
		return result
	end

	if tryOnsBundleOutfitInfo then
		for k, scale in tryOnsBundleOutfitInfo.scales do
			result[humanoidDescriptionScaleToName[k]] = scale
		end
	end

	local setAvatarTryOnProperties = module22.setAvatarTryOnProperties
	local v9 = result
	setAvatarTryOnProperties(v9, self.store:getState())

	if fFlagEnableHeadShapeForCharacterManager then
		local applyHeadShapeToHumanoidDescription = module22.applyHeadShapeToHumanoidDescription
		local v10 = result
		applyHeadShapeToHumanoidDescription(v10, self.store:getState())
	end

	return result
end

function class:finishApplyDescription(p2, p3, p4, p5)
	if self.initialHumanoidDescriptionApplied and not p4 then
		self:updateNoFace(p5)
	end

	if not self.initialHumanoidDescriptionApplied then
		local v8 = (tick() - self.startAvatarModelLoadTime) * 1000
		logger:info("Avatar model load time: {} ms", v8)
		self.analytics.Diag:reportStats(v6, v8)
	end

	if self.characterModelPool:isR15() then
		self:adjustHeightToStandOnPlatform(self._currentCharacter)
	end

	if p2 then
		self.store:dispatch(module9())
	elseif p3 then
		self.store:dispatch(module10())
	end

	self.initialHumanoidDescriptionApplied = true

	if self._currentCharacter then
		local boundingBox, v8 = self._currentCharacter:GetBoundingBox()

		if not (module24.isBoundingBoxVectorSane(v8) and module24.isBoundingBoxCFrameSane(boundingBox)) then
			local newAssetIdsWithGeometry = module24.calculateNewAssetIdsWithGeometry(
				p5,
				self.lastHumanoidDescriptionApplied
			)

			if #newAssetIdsWithGeometry > 0 then
				module3("(Avatar Experience) bad bounding box on adding assetIds: " .. table.concat(newAssetIdsWithGeometry, ","))
			end
		end
	end
end

function class:getCurrentCharacter()
	return self._currentCharacter
end

function class:applyHumanoidDescription(p2, p3)
	module4.assert(self.modelInitialized, "applyHumanoidDescription called before initializeModel")

	task.spawn(function()
		if self.destroyed or not self._currentCharacter:IsDescendantOf(game) then
			return
		end

		local lastHumanoidDescriptionApplied = self.lastHumanoidDescriptionApplied
		local combineOutfitTryOnAndEquippedHumanoidDescriptions = self:combineOutfitTryOnAndEquippedHumanoidDescriptions()

		self.checkBodyColors = false

		local v8 = p3 and isHumanoidDescriptionEmpty(self.humanoidDescriptionTryOn)

		self.characterModelPool:maybeUpdateCharacter(combineOutfitTryOnAndEquippedHumanoidDescriptions):andThen(function(currentCharacter, p4)
			self.store:dispatch(module7())

			if currentCharacter ~= self._currentCharacter then
				self.toolManager:unequipTool()
				self._currentCharacter = currentCharacter
				self.store:dispatch(module6(self._currentCharacter))
				self._currentCharacter.Parent = self.characterRoot
				self.toolManager:checkAndEquipTool()
			end

			if
				not p4
				and self.store:getState().AvatarExperience.AvatarScene.Character.WaitingOnLayeredClothingUpdates
			then
				self.store:dispatch(module11())
			end

			self.lastHumanoidDescriptionApplied = combineOutfitTryOnAndEquippedHumanoidDescriptions

			self:finishApplyDescription(p2, p3, v8, lastHumanoidDescriptionApplied)

			self.characterManagerCallbacks.setAppliedDescription(self._currentCharacter.Humanoid.HumanoidDescription)
		end)
	end)
end

function class:switchAvatarType(p2)
	self._currentCharacter = self.characterModelPool:switchAvatarType(p2)
	self.store:dispatch(module6(self._currentCharacter))
	self.store:dispatch(module7())
	self._currentCharacter.Parent = self.characterRoot

	self.toolManager:notifySwitchedAvatarType()
end

function class:adjustHeightToStandOnPlatform(instance)
	local humanoidRootPart = instance.HumanoidRootPart
	local humanoid = instance.Humanoid
	local v8 = humanoidRootPart.Size.y * 0.5 + humanoid.HipHeight

	local components, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19 = humanoidRootPart.CFrame:components()

	humanoidRootPart.CFrame = CFrame.new(components, v8, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19)
end

function class:stop()
	module22.updateHumanoidDescriptionUsingOutfitTryOn(self.store:getState(), self.humanoidDescriptionTryOn)

	self:applyHumanoidDescription(true)

	for k, connection in self.connections do
		connection:disconnect()
	end

	self.connections = {}

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		if self.disposeCurrentSortEffect then
			self.disposeCurrentSortEffect()
			self.disposeCurrentSortEffect = nil
		end

		self.currentSortChanged = false
		self.currentSortUpdatePending = false
		self.lastFlushedState = nil
	end

	self.characterModelPool:stop()
	self.animationManager:stop()

	if fFlagAXSpawnEffectPreview and self.spawnEffectManager then
		self.spawnEffectManager:stop()
	end

	self.toolManager:stop()

	self.initialTryOnApplied = false

	local v8 = if fFlagAXCharacterManagerResumeFromLastUpdate and self.lastUpdatedState then self.lastUpdatedState else self.store:getState()
	self.cachedRoduxState = v8
end

function class:onDestroy()
	self.humanoidDescriptionCurrentlyEquipped:Destroy()
	self.humanoidDescriptionTryOn:Destroy()
	self.lastHumanoidDescriptionApplied:Destroy()
	self.characterRoot:Destroy()
	self.destroyed = true

	self.animationManager:onDestroy()

	if fFlagAXSpawnEffectPreview and self.spawnEffectManager then
		self.spawnEffectManager:onDestroy()
	end

	self.toolManager:onDestroy()

	self.characterModelPool:onDestroy()
	self.store:dispatch(setCurrentCharacter(nil))
	self.store:dispatch(module7())
end

function class:updateAvatarRoute(latestAvatarRoute, p2)
	self.animationManager:updateAvatarRoute(latestAvatarRoute, p2)
	self.toolManager:updateAvatarRoute(latestAvatarRoute, p2)
	self.latestAvatarRoute = latestAvatarRoute

	local routeIsPPEStaticImagePage = module24.routeIsPPEStaticImagePage(latestAvatarRoute)
	local routeIsPPEStaticImagePage2 = module24.routeIsPPEStaticImagePage(p2)

	if routeIsPPEStaticImagePage and not routeIsPPEStaticImagePage2 then
		self:freezeParticles()

		self:watchCharacterToFreezeNewParticles()
	elseif routeIsPPEStaticImagePage2 and not routeIsPPEStaticImagePage then
		self:stopWatchingCharacter()
		self:unfreezeParticles()
	end
end

function class:watchCharacterToFreezeNewParticles()
	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if currentCharacter then
		self.freezeParticlesCharacterConnection = currentCharacter.DescendantAdded:Connect(function(tool)
			if tool:IsA("Tool") then
				RunService.Heartbeat:Wait()
				self:recursiveFreezeParticles(tool)

				particleUtility.FastForwardParticles(tool)
			end
		end)
	end
end

function class:stopWatchingCharacter()
	if self.freezeParticlesCharacterConnection then
		self.freezeParticlesCharacterConnection:Disconnect()
		self.freezeParticlesCharacterConnection = nil
	end
end

function class.instanceIsAParticleEffect(p2, instance)
	return instance:IsA("ParticleEmitter")
		or instance:IsA("Fire")
		or instance:IsA("Smoke")
		or instance:IsA("Sparkles")
end

function class:recursiveFreezeParticles(instance)
	if particleUtility.InstanceIsAParticleEffect(instance) then
		self.frozenParticlesToTimeScale[instance] = instance.TimeScale
		instance.TimeScale = 0
	end

	local children = instance:GetChildren()

	for k, child in children do
		self:recursiveFreezeParticles(child)
	end
end

function class:freezeParticles()
	self.frozenParticlesToTimeScale = {}

	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if currentCharacter then
		self:recursiveFreezeParticles(currentCharacter)
	end
end

function class:unfreezeParticles()
	if self.frozenParticlesToTimeScale then
		for k, v8 in self.frozenParticlesToTimeScale do
			k.TimeScale = v8
		end

		self.frozenParticlesToTimeScale = {}
	end
end

return class
