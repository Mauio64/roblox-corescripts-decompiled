local InsertService = game:GetService("InsertService")
local ContentProvider = game:GetService("ContentProvider")
local CorePackages = game:GetService("CorePackages")
local FaceAnimatorService = game:GetService("FaceAnimatorService")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/ipE")
local module2 = require("@luauforge/bundled/gUR")
local module3 = require("@luauforge/bundled/gUU")
local module4 = require("@luauforge/bundled/dRg")
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/bundled/fCe")
local module7 = require("@luauforge/bundled/dPR")

local playingSwimAnimation = require("@luauforge/bundled/dKU").Actions.PlayingSwimAnimation
local module8 = require("@luauforge/bundled/dFs")
local Promise = require(CorePackages.Packages.Promise)

require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local module9 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dKT")
local Dash = require(CorePackages.Packages.Dash)

local module10 = require("@luauforge/bundled/ipG")
local module11 = require("@luauforge/bundled/ipF")

local module12 = require("@luauforge/bundled/ipH")

local module13 = require("@luauforge/bundled/ipJ")

local module14 = require("@luauforge/bundled/gUW")
local module15 = require("@luauforge/bundled/dWC")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local animationTrackWithConnectionsTypes = module3.AnimationTrackWithConnectionsTypes

local assetTypeIdStrings = module5.AssetTypeIdStrings
local module16 = require("@luauforge/bundled/fCk")
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.init")

local module17 = require("@luauforge/bundled/dRs")

local fFlagAXPauseSceneWhenSplitPaneCollapsed = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXPauseSceneWhenSplitPaneCollapsed

local fFlagAXPhotoboothMomentsTryOnEmotes = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsTryOnEmotes

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local function getEffectiveAvatarType(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
		or p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local v5 = {
	EnteredAX = "EnteredAX",
	NewEquippedAssets = "NewEquippedAssets",
	NewOutfitTryOn = "NewOutfitTryOn"
}

local class = {}
class.__index = class

function class.new(store, object, avatarRoute)
	local v6 = {}
	setmetatable(v6, class)

	v6.destroyed = false
	v6.started = false

	v6.store = store
	v6.avatarRoute = avatarRoute

	v6.animationTrackWithConnectionsByType = {}
	v6.unresolvedStateTransitions = {}
	v6.shouldMoveToNextValidMainBodyAnimation = false

	v6.stoppedButNotEndedATWCsByName = {}

	local animations = module2.createR6AnimationFolder()
	local animations2 = InsertService:LoadLocalAsset("rbxasset://avatar/animations/humanoidR15AnimateChildren.rbxm")

	v6.animationTrackNameIndex = 0

	module2.createAnimation(animations2, "Tool", module2.DefaultAnimations.R15.TOOL)
	module2.createAnimation(
		module2.createStringValue(animations2, "wave"),
		"WaveAnim",
		module2.DefaultAnimations.R15.WAVE_EMOTE
	)

	animations.Name = "Animations"
	animations2.Name = "Animations"

	object:setupAnimations(animations, animations2)

	v6.currentStateDigest = {}
	v6.currentAssetIdsToLoad = {}
	v6.currentLoadedAssets = {}

	v6.debugLoadAssetsFromFiles = false

	v6.stateSummaryAtLastVersionUpdate = {
		equippedAssetsSummary = {},
		outfitTryOnSummary = {}
	}

	v6.equippedAssetsSummaryTriggeringLookAround = {}
	v6.outfitTryOnSummaryTriggeringLookAround = {}

	return v6
end

function class:setToolManager(toolManager)
	self.toolManager = toolManager
end

function class:start()
	if self.started then
		module8("calling AnimationManager:start when already started")
		return
	end

	self.started = true

	self.shouldMoveToNextValidMainBodyAnimation = false
	self:cleanupAllAnimationTracks()

	self.storeChangedConnection = self.store.changed:connect(function(p2, p3)
		local avatarRoute = self.avatarRoute
		self:update(p2, p3, avatarRoute, avatarRoute)
	end)

	if self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter then
		return
	end

	logging.warn("Tried to start AnimationManager without a character!")
end

function class:onSceneStartedOutsideAvatarRoute(avatarRoute)
	self.avatarRoute = avatarRoute

	if self.loadAssetsPromise then
		self.loadAssetsPromise:cancel()
		self.loadAssetsPromise = nil
	end

	self.unresolvedStateTransitions.didActivateScene = true
	local state = self.store:getState()
	self:update(state, state, avatarRoute, avatarRoute)
end

function class:stop()
	if not self.started then
		module8("calling AnimationManager:stop when not started")
		return
	end

	self.started = false

	if self.loadAssetsPromise then
		self.loadAssetsPromise:cancel()
	end

	self:cleanupAllAnimationTracks()

	if self.storeChangedConnection then
		self.storeChangedConnection:disconnect()
		self.storeChangedConnection = nil
	end
end

function class:onDestroy()
	if self.loadAssetsPromise then
		self.loadAssetsPromise:cancel()
	end

	self.destroyed = true
end

function class:updateAvatarRoute(avatarRoute, p2)
	self.avatarRoute = avatarRoute
	local state = self.store:getState()
	self:update(state, state, avatarRoute, p2)
end

function class:updateCategorySelection()
	local state = self.store:getState()

	self:update(state, state, self.avatarRoute, self.avatarRoute)
end

function class:update(p2, p3, p4, p5)
	if p2.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		local stateDigest = self:createStateDigest(p2, p4)
		local stateTransitions = self:createStateTransitions(p2, p3, p4, p5)

		local assetIdsToLoad = self:getAssetIdsToLoad(stateDigest, p2)

		local shallowEqual = Dash.shallowEqual(self.currentStateDigest, stateDigest)
		local shallowEqual2 = Dash.shallowEqual(self.currentAssetIdsToLoad, assetIdsToLoad)

		self.currentStateDigest = stateDigest
		self.currentAssetIdsToLoad = assetIdsToLoad

		for k, stateTransition in pairs(stateTransitions) do
			if stateTransition then
				self.unresolvedStateTransitions[k] = stateTransition
			end
		end

		local v6 = false

		for k, unresolvedStateTransition in pairs(self.unresolvedStateTransitions) do
			if unresolvedStateTransition then
				v6 = true
				break
			end
		end

		if shallowEqual and shallowEqual2 and not v6 then
			if self.onUpdateFinished then
				self.onUpdateFinished(stateTransitions, stateDigest, assetIdsToLoad, nil)
			end
		else
			if self.loadAssetsPromise then
				if shallowEqual and shallowEqual2 then
					assert(v6, "hasUnresolvedTransition should be true")

					if self.onUpdateFinished then
						self.onUpdateFinished(stateTransitions, stateDigest, assetIdsToLoad, nil)
					end

					return
				end

				self.loadAssetsPromise:cancel()
				self.loadAssetsPromise = nil
			end

			assert(self.loadAssetsPromise == nil, "self.loadAssetsPromise should be nil")
			self.loadAssetsPromise = self:makeLoadAssetsPromise(stateDigest, assetIdsToLoad)

			self.loadAssetsPromise:andThen(function(currentLoadedAssets)
				self.loadAssetsPromise = nil
				self.currentLoadedAssets = currentLoadedAssets

				if self.destroyed then
					return
				end

				assert(Dash.shallowEqual(self.currentStateDigest, stateDigest), "stateDigest should match")
				assert(
					Dash.shallowEqual(self.currentAssetIdsToLoad, assetIdsToLoad),
					"assetIdsToLoad should match"
				)

				self:playLoadedAssets(stateDigest, assetIdsToLoad, currentLoadedAssets)

				if self.onUpdateFinished then
					self.onUpdateFinished(
						stateTransitions,
						stateDigest,
						assetIdsToLoad,
						currentLoadedAssets
					)
				end

				return Promise.resolve()
			end):catch(function(p6)
				self.loadAssetsPromise = nil
				logging.warn("Error in loadAssetsPromise: " .. tostring(p6))

				if self.onUpdateFinished then
					self.onUpdateFinished(stateTransitions, stateDigest, assetIdsToLoad, {})
				end
			end)
		end
	elseif self.onUpdateFinished then
		self.onUpdateFinished(nil, nil, nil, nil)
	end
end

function class:createStateTransitions(p2, p3, p4, p5)
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local currentCharacter2 = p3.AvatarExperience.AvatarScene.Character.CurrentCharacter

	assert(currentCharacter, "currentCharacter should be non-nil. Silence type checker.")

	local routeIsProfilePictureEditor = module6.routeIsProfilePictureEditor(p4)
	local routeIsProfilePictureEditor2 = module6.routeIsProfilePictureEditor(p5)

	local isVisible = p4.isVisible

	return {
		didUpdateCharacter = currentCharacter ~= currentCharacter2,
		didMoveOutOfPPE = module2.getDidMoveOutOfPPE(
			routeIsProfilePictureEditor2,
			routeIsProfilePictureEditor,
			isVisible
		),
		didSomethingThatShouldTriggerLookAround = self:getDidSomethingThatShouldTriggerLookAround(
			currentCharacter,
			p2,
			p3,
			p4,
			p5
		)
	}
end

function class:shouldResumeLookAroundAfterCharacterSwap(p2, p3, p4, p5, p6): boolean
	if not (p3 ~= p4 and self:animationTrackWithConnectionsIsPlaying(animationTrackWithConnectionsTypes.LookAround)) then
		return false
	end

	if
		self.lookAroundReason == "EnteredAX" and p2
		or self.lookAroundReason == "NewEquippedAssets"
		and module2.getEquippedAssetSummariesMatch(p5, self.equippedAssetsSummaryTriggeringLookAround)
	then
		return true
	end

	if self.lookAroundReason == "NewOutfitTryOn" then
		assert(
			self.outfitTryOnSummaryTriggeringLookAround,
			"self.outfitTryOnSummaryTriggeringLookAround should be non-nil"
		)

		if module2.getOutfitTryOnSummariesMatch(p6, self.outfitTryOnSummaryTriggeringLookAround) then
			return true
		end
	end

	return false
end

function class:getDidSomethingThatShouldTriggerLookAround(p2, p3, p4, p5, p6): boolean
	local humanoidFromCharacter = module2.getHumanoidFromCharacter(p2)

	if not humanoidFromCharacter then
		return false
	end

	assert(humanoidFromCharacter, "humanoid should not be nil. Silence type checker")

	if
		Enum.HumanoidRigType.R15 ~= humanoidFromCharacter.RigType
		or module6.routeIsProfilePictureEditor(p5)
	then
		return false
	end

	if fFlagAXPauseSceneWhenSplitPaneCollapsed and self.unresolvedStateTransitions.didActivateScene then
		self.lookAroundReason = "EnteredAX"
		return true
	end

	local isVisible = p5.isVisible
	local isVisible2 = p6.isVisible

	if isVisible and not isVisible2 then
		self.lookAroundReason = "EnteredAX"
		return true
	end

	local currentCharacter = p4.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local characterVersion = p3.AvatarExperience.AvatarScene.Character.CharacterVersion
	local characterVersion2 = p4.AvatarExperience.AvatarScene.Character.CharacterVersion
	local equippedAssets = p3.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local outfitTryOn = p3.AvatarExperience.AvatarScene.OutfitTryOn
	local v6 = characterVersion2 ~= characterVersion
	local equippedAssetsSummary = module2.getEquippedAssetsSummary(equippedAssets)
	local outfitTryOnSummary = module2.getOutfitTryOnSummary(outfitTryOn)

	local equippedAssetsSummary2 = self.stateSummaryAtLastVersionUpdate.equippedAssetsSummary
	local outfitTryOnSummary2 = self.stateSummaryAtLastVersionUpdate.outfitTryOnSummary

	if v6 then
		self.stateSummaryAtLastVersionUpdate.equippedAssetsSummary = equippedAssetsSummary
		self.stateSummaryAtLastVersionUpdate.outfitTryOnSummary = outfitTryOnSummary

		if module2.getEquippedAssetsSummaryHasNewItems(equippedAssetsSummary, equippedAssetsSummary2) then
			self.lookAroundReason = "NewEquippedAssets"
			self.equippedAssetsSummaryTriggeringLookAround = equippedAssetsSummary
			return true
		elseif module2.getOutfitTryOnSummaryHasNewItems(outfitTryOnSummary, outfitTryOnSummary2) then
			self.lookAroundReason = "NewOutfitTryOn"
			self.outfitTryOnSummaryTriggeringLookAround = outfitTryOnSummary
			return true
		end
	end

	if self:shouldResumeLookAroundAfterCharacterSwap(
		isVisible,
		p2,
		currentCharacter,
		equippedAssetsSummary,
		outfitTryOnSummary
	) then
		return true
	end

	return false
end

function class:createStateDigest(p3, data)
	local name = data.opaque.name

	local categoryInfoFromState = module6.getCategoryInfoFromState(p3, data)

	local allowsTryingEmotesOrAnimations, v6 = module2.getAllowsTryingEmotesOrAnimations(p3, data)
	local v7

	if categoryInfoFromState.PageType == module5.PageType.Emotes then
		v7 = name == avatarScreen.AvatarEditor
	else
		v7 = false
	end

	if module17() then
		v7 = v7 or name == avatarScreen.EditEmotes
	end

	local v8

	if categoryInfoFromState.PageType == module5.PageType.Animation then
		v8 = name == avatarScreen.AvatarEditor
	else
		v8 = false
	end

	local v9 = name == avatarScreen.AdjustAccessoryView
	local avatarType

	if fFlagAXPhotoboothMomentsTryOnEmotes then
		avatarType = p3.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
			or p3.AvatarExperience.AvatarEditor.Character.AvatarType
	else
		avatarType = p3.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v10 = not (avatarType == module4.AvatarType.R6) and module10(p3)

	local routeIsProfilePictureEditor = module6.routeIsProfilePictureEditor(data)

	local v11 = routeIsProfilePictureEditor
		and name == avatarScreen.ProfilePictureEditorFinal
		and p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode == module15.FullBody
		and true
		or false

	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	local v12 = currentCharacter and currentCharacter:FindFirstChildOfClass("Tool") and true or false

	local canAnimateCameraBasedMood = categoryInfoFromState.CanAnimateCameraBasedMood == true
	local canPlayCameraBasedMoodAnimation, v13 = module2.canPlayCameraBasedMoodAnimation(
		p3,
		canAnimateCameraBasedMood,
		allowsTryingEmotesOrAnimations
	)

	local testVariable = module7.readTestVariable(module16.EnabledForUser)
	local stateDigest = {
		isInPPE = routeIsProfilePictureEditor,
		isInAX = data.isVisible,
		toolEquipped = module11(p3),
		curCategoryInfo = categoryInfoFromState,
		isAvatarBackground = module6.isAvatarBackground(data.current.name),
		pageAllowsForTryingOnEmotes = allowsTryingEmotesOrAnimations,
		pageAllowsForTryingOnAnimations = v6,
		pageHasBothAnimsAndEmotes = allowsTryingEmotesOrAnimations and v6,
		pageIsEditorEmotes = v7,
		pageIsEditorAnimations = v8,
		excludeIdleAnimation = v9,
		shouldPlayMoodAnimations = v10,
		canPlayCameraBasedMoodAnimation = 0,
		receivedOutfitInfo = 0,
		ppeFinalPageFullView = 0,
		hasTool = 0,
		cameraButtonEnabled = 0
	}

	if not testVariable then
		canPlayCameraBasedMoodAnimation = nil
	end

	stateDigest.canPlayCameraBasedMoodAnimation = canPlayCameraBasedMoodAnimation

	if not testVariable then
		v13 = nil
	end

	stateDigest.receivedOutfitInfo = v13
	stateDigest.ppeFinalPageFullView = v11
	stateDigest.hasTool = v12
	local v14 = if testVariable then p3.AvatarExperience.CameraButton.enabled else nil
	stateDigest.cameraButtonEnabled = v14

	return stateDigest
end

function class:getAssetIdsToLoad(p2, p3)
	if p2.isInPPE then
		return module.getAssetIdsToLoad(p3, p2.shouldPlayMoodAnimations)
	end

	local v6 = {}

	if p2.shouldPlayMoodAnimations then
		local v7 = module12(p3)

		if v7 then
			v6.moodAssetId = v7
		else
			v6.moodAssetId = module9.getEquippedMoodAssetId(p3)
		end
	end

	v6.mainBodyAssetId = self:getMainBodyAssetId(p2, p3)

	return v6
end

function class:getMainBodyAssetId(data, p2)
	local v6

	if fFlagAXPhotoboothMomentsTryOnEmotes then
		v6 = p2.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
			or p2.AvatarExperience.AvatarEditor.Character.AvatarType
	else
		v6 = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	if v6 == module4.AvatarType.R6 then
		return nil
	end

	if data.isAvatarBackground then
		return self:getAvatarBackgroundAssetId(p2)
	end

	local tryOnMainBodyAssetId = self:getTryOnMainBodyAssetId(data, p2)

	if tryOnMainBodyAssetId then
		return tryOnMainBodyAssetId
	end

	if data.pageIsEditorEmotes then
		local v7 = p2.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo[p2.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot]

		if v7 and v7.assetId then
			return v7.assetId
		end
	end

	local v7 = data.pageIsEditorAnimations and module2.getAssetTypeIdStringForCategory(data.curCategoryInfo)

	if v7 then
		local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local v8 = equippedAssets and equippedAssets[v7]
		local v9 = v8 and next(v8) or nil

		if v9 then
			return v9
		end

		return nil
	else
		local equippedIdleAnimation = module2.getEquippedIdleAnimation(p2)

		if equippedIdleAnimation then
			return equippedIdleAnimation
		end

		return nil
	end
end

function class:getAvatarBackgroundAssetId(p3)
	if not p3.AvatarExperience.Common.PlayEmoteInBackground.shouldPlayEmoteInBackground then
		return nil
	end

	for k, v6 in p3.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo do
		if v6.assetId then
			return v6.assetId
		end
	end

	local equippedIdleAnimation = module2.getEquippedIdleAnimation(p3)

	if equippedIdleAnimation then
		return equippedIdleAnimation
	end

	return nil
end

function class:getTryOnMainBodyAssetId(data, p3)
	local tryOn = p3.AvatarExperience.AvatarScene.TryOn
	local outfitTryOn = p3.AvatarExperience.AvatarScene.OutfitTryOn

	local v6 = data.pageAllowsForTryingOnEmotes and module14(p3)

	if v6 then
		if not data.pageHasBothAnimsAndEmotes then
			return v6
		end

		local lastAnimOrEmoteToggledItem = outfitTryOn.LastAnimOrEmoteToggledItem

		if lastAnimOrEmoteToggledItem and lastAnimOrEmoteToggledItem.itemId == v6 then
			return v6
		end
	end

	if
		data.pageAllowsForTryingOnAnimations
		and tryOn.AnimationPreview
		and tryOn.AnimationPreviewAssetTypeIdString ~= assetTypeIdStrings.EmoteAnimation
	then
		return tryOn.AnimationPreview
	end

	local v7 = module13(p3)

	if v7 then
		return v7
	end

	return nil
end

function class.getMultiTryOnTriedOnEmote(p2, p3)
	for k, tryOnItem in p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if tryOnItem.itemSubType == assetTypeIdStrings.EmoteAnimation then
			return tryOnItem.itemId
		end
	end

	return nil
end

function class:makeLoadAssetsPromise(p2, p3)
	return Promise.new(function(callback, p4, callback2)
		callback2(function()
			module.maybeNoteLoadingFinished(self.store)
		end)

		if p2.isInPPE then
			callback(module.makeLoadedAssets(self.store, p2, p3))
			return
		end

		local v6 = {}

		if p3.moodAssetId then
			v6.moodAnimStringValues = module2.loadAnimStringValuesFromString(
				p3.moodAssetId,
				self.debugLoadAssetsFromFiles,
				self.mapAssetIdToFileName
			)
		end

		if p3.mainBodyAssetId then
			v6.mainBodyAnimStringValues = module2.loadAnimStringValuesFromString(
				p3.mainBodyAssetId,
				self.debugLoadAssetsFromFiles,
				self.mapAssetIdToFileName
			)
		end

		local v7 = {}

		if v6.moodAnimStringValues then
			Dash.append(v7, v6.moodAnimStringValues)
		end

		if v6.mainBodyAnimStringValues then
			Dash.append(v7, v6.mainBodyAnimStringValues)
		end

		if #v7 > 0 and not self.debugLoadAssetsFromFiles then
			ContentProvider:PreloadAsync(v7)
		end

		callback(v6)
	end)
end

function class:playLoadedAssets(p2, p3, p4)
	if self.unresolvedStateTransitions.didUpdateCharacter then
		self:cleanupAllAnimationTracks()
		self.unresolvedStateTransitions.didUpdateCharacter = false
	end

	if fFlagAXPauseSceneWhenSplitPaneCollapsed then
		self.unresolvedStateTransitions.didActivateScene = false
	end

	if p2.isInPPE then
		self:stopAnimationsAndMaybeProceedWithPPEPosing()
		return
	end

	if self.unresolvedStateTransitions.didMoveOutOfPPE then
		local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
		local humanoidFromCharacter = module2.getHumanoidFromCharacter(currentCharacter)
		module.undoOldProfilePictureEditorPose(self.store, currentCharacter, humanoidFromCharacter)
	end

	self.unresolvedStateTransitions.didMoveOutOfPPE = false

	self:updateToolAnimation(p2)
	self:updateMoodAnimation(p2, p3, p4)

	if module7.readTestVariable(module16.EnabledForUser) then
		self:updateCameraBasedMoodAnimation(p2)
	end

	if self.unresolvedStateTransitions.didSomethingThatShouldTriggerLookAround then
		self:updateMainBodyAnimationAfterPlayingLookAround(p2, p3, p4)
	else
		self:updateMainBodyAnimation(p2, p3, p4)
	end

	self.unresolvedStateTransitions.didSomethingThatShouldTriggerLookAround = false
end

function class:cleanupAllAnimationTracks()
	for k, animationTrackWithConnectionsType in pairs(animationTrackWithConnectionsTypes) do
		module2.cleanupAnimationTrackWithConnections(self.animationTrackWithConnectionsByType[animationTrackWithConnectionsType])
		self.animationTrackWithConnectionsByType[animationTrackWithConnectionsType] = nil
	end

	for k, stoppedButNotEndedATWC in self.stoppedButNotEndedATWCsByName do
		module2.cleanupAnimationTrackWithConnections(stoppedButNotEndedATWC)
	end

	self.stoppedButNotEndedATWCsByName = {}
end

function class:stopAnimationsAndMaybeProceedWithPPEPosing()
	assert(self.currentStateDigest.isInPPE, "Must be in PPE")
	assert(self.currentStateDigest.isInAX, "Must be in in AX")

	for k, animationTrackWithConnectionsType in pairs(animationTrackWithConnectionsTypes) do
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsType, 0.02)
	end

	self:maybeProceedWithPPEPosing()
end

function class:maybeProceedWithPPEPosing()
	local function maybeProceedWithPPEPosingInner()
		if
			not self.currentStateDigest.isInPPE
			or not self.currentStateDigest.isInAX
			or self.loadAssetsPromise
			or self:animationsAreMovingAvatar()
		then
			return
		end

		local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

		local v6 = currentCharacter and module2.getHumanoidFromCharacter(currentCharacter)

		if v6 then
			module.applyNewProfilePictureEditorPose(
				self.store,
				currentCharacter,
				v6,
				self.currentLoadedAssets.keyframesForPose
			)
		end
	end

	module2.waitForAnimationAndPosingToResolve(function()
		maybeProceedWithPPEPosingInner()
	end)
end

function class.animationTrackWithConnectionsIsPlaying(p2, p3)
	local animationTrackWithConnection = p2.animationTrackWithConnectionsByType[p3]

	if animationTrackWithConnection then
		return module2.animationTrackWithConnectionsIsPlaying(animationTrackWithConnection)
	end

	return false
end

function class:animationsAreMovingAvatar(): boolean
	for k, animationTrackWithConnectionsType in pairs(animationTrackWithConnectionsTypes) do
		if self:animationTrackWithConnectionsIsPlaying(animationTrackWithConnectionsType) then
			return true
		end
	end

	if next(self.stoppedButNotEndedATWCsByName) then
		return true
	end

	return false
end

function class:updateToolAnimation(p2)
	assert(not p2.isInPPE, "Should not be in PPE")

	if not p2.toolEquipped then
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.ToolHold)
		return
	end

	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
	local animations = currentCharacter.Animations

	local v6 = nil
	local v7 = nil

	if animations then
		local tool = animations.Tool

		if tool then
			v6 = module2.animatorLoadAnimationTrack(currentCharacter, tool, self.debugLoadAssetsFromFiles)

			v7 = module9.getAssetIdFromContent(tool.AnimationId)
		end
	end

	if not (v7 and v6) then
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.ToolHold)
		return
	end

	assert(v7, "newToolAnimationAssetId is not nil. Silence type checker")

	local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.ToolHold]

	if module2.animationTrackWithConnectionsIsPlayingThisAssetId(animationTrackWithConnection, v7) then
		return
	end

	self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.ToolHold)

	assert(v6, "toolHoldAnimationTrack is not nil. Silence type checker")

	assert(v7, "newToolAnimationAssetId should be non-nil")

	local v8 = {}
	v8.assetId = v7
	v8.stoppedConnection = v6.Stopped:Connect(function()
		self:handleStoppedConnection(v6, v8)
	end)
	v8.endedConnection = v6.Ended:Connect(function()
		self:handleEndedConnection(v6)
	end)

	v8.animationTrack = v6
	v8.animationTrack.Name = self:getNextAnimationTrackName("ToolHold")
	self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.ToolHold] = v8
	v6:Play(0.1)
	self:recordAnimationTrackProgress(v8.animationTrack.Name, "Playing")
end

function class:updateMoodAnimation(p2, p3, p4)
	assert(not p2.isInPPE, "Should not be in PPE")

	if p3.moodAssetId == nil or p4.moodAnimStringValues == nil then
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.Mood)
		return
	end

	assert(p3.moodAssetId, "assetIdsToLoad.moodAssetId is non-nil. Silence type checker")
	assert(p4.moodAnimStringValues, "loadedAssets.moodAnimStringValues is non-nil. Silence type checker")

	local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.Mood]

	if module2.animationTrackWithConnectionsIsPlayingThisAssetId(
		animationTrackWithConnection,
		p3.moodAssetId
	) then
		return
	end

	self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.Mood)

	assert(p4.moodAnimStringValues, "loadedAssets.moodAnimStringValues is not nil.  Silences type checker")

	local v6 = nil

	local children = if p4.moodAnimStringValues[1] then p4.moodAnimStringValues[1]:GetChildren() else nil

	if children then
		local child = children[1]

		if child then
			assert(child.ClassName == "Animation", "moodAnim should be an animation.")
			local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
			v6 = module2.animatorLoadAnimationTrack(currentCharacter, child, self.debugLoadAssetsFromFiles)
		end
	end

	if not v6 then
		return
	end

	assert(v6, "moodAnimationTrack is not nil. Silences type checker")

	local v7 = {}
	v7.assetId = p3.moodAssetId
	v7.stoppedConnection = v6.Stopped:Connect(function()
		self:handleStoppedConnection(v6, v7)
	end)
	v7.endedConnection = v6.Ended:Connect(function()
		self:handleEndedConnection(v6)
	end)
	v7.animationTrack = v6
	v7.animationTrack.Name = self:getNextAnimationTrackName("Mood")

	assert(
		self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.Mood] == nil,
		"self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.Mood] should be empty"
	)

	self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.Mood] = v7
	v6:Play()
	self:recordAnimationTrackProgress(v7.animationTrack.Name, "Playing")
end

function class:updateCameraBasedMoodAnimation(data)
	assert(not data.isInPPE, "Should not be in PPE")

	local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.CameraStream]

	if data.cameraButtonEnabled then
		if animationTrackWithConnection then
			if data.receivedOutfitInfo and not data.canPlayCameraBasedMoodAnimation then
				module2.adjustATWCWeight(animationTrackWithConnection, 0.0001)
				return
			end

			if module2.animationTrackWithConnectionsIsPlaying(animationTrackWithConnection) then
				module2.adjustATWCWeight(animationTrackWithConnection, 1)
				return
			end
		end

		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.CameraStream)
		local v6 = {}
		local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
		local animatorLoadTrackerStreamAnimationTrack = module2.animatorLoadTrackerStreamAnimationTrack(
			currentCharacter,
			Instance.new("TrackerStreamAnimation"),
			self.debugLoadAssetsFromFiles
		)

		assert(
			animatorLoadTrackerStreamAnimationTrack,
			"cameraBasedMoodAnimationTrack is not nil. If it is ever nil, it should be investigated if a dependent flag is missing"
		)

		v6.animationTrack = animatorLoadTrackerStreamAnimationTrack
		v6.animationTrack.Name = self:getNextAnimationTrackName("CameraBasedMoodAnimation")

		v6.stoppedConnection = animatorLoadTrackerStreamAnimationTrack.Stopped:Connect(function()
			self:handleStoppedConnection(animatorLoadTrackerStreamAnimationTrack, v6)
			self:handleEndedConnection(animatorLoadTrackerStreamAnimationTrack)
		end)

		animatorLoadTrackerStreamAnimationTrack.Priority = Enum.AnimationPriority.Action4

		assert(
			self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.CameraStream] == nil,
			"self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.CameraStream] should be empty"
		)

		self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.CameraStream] = v6
		animatorLoadTrackerStreamAnimationTrack:Play()
		self:recordAnimationTrackProgress(v6.animationTrack.Name, "Playing")

		if data.receivedOutfitInfo and not data.canPlayCameraBasedMoodAnimation then
			module2.adjustATWCWeight(v6, 0.0001)
		end
	else
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.CameraStream)

		FaceAnimatorService:Stop()
	end
end

function class:updateMainBodyAnimationAfterPlayingLookAround(p2, p3, p4)
	assert(not p2.isInPPE, "Should not be in PPE")

	local v6 = p4.mainBodyAnimStringValues
	local v7 = p3.mainBodyAssetId

	if not v6 then
		v6, v7 = self:getFallbackMainBodyAnimStringValuesAndMockAssetId(p2)
	end

	local v8 = nil

	if v6 then
		local weightedAnimations, v9 = module2.getWeightedAnimations(module2.convertToAnimations(v6[1]:GetChildren()))
		local v10 = nil
		local v11 = nil

		for k, weightedAnimation in next, weightedAnimations do
			if not (v10 == nil or weightedAnimation < v11) then
				continue
			end

			v11 = weightedAnimation
			v10 = k
		end

		if v10 then
			local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
			v8 = module2.animatorLoadAnimationTrack(currentCharacter, v10, self.debugLoadAssetsFromFiles)
		end
	end

	if v8 and v7 then
		assert(v8, "lookAroundTrack is not nil. Silences type checker")
		assert(v7, "assetId is not nil. Silences type checker")

		local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.LookAround]

		if module2.animationTrackWithConnectionsIsPlayingThisAssetId(animationTrackWithConnection, v7) then
			return
		end

		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.MainBody)

		v8.Looped = true
		local v9 = {}
		v9.assetId = v7
		v9.stoppedConnection = v8.Stopped:Connect(function()
			self:handleStoppedConnection(v8, v9)
		end)
		v9.endedConnection = v8.Ended:Connect(function()
			self:handleEndedConnection(v8)
		end)
		v9.didLoopConnection = v8.DidLoop:Connect(function()
			if self.destroyed then
				return
			end

			self:recordAnimationTrackProgress(v8.Name, "Looped")

			self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
			self:updateMainBodyAnimation(p2, p3, p4)
		end)
		v9.animationTrack = v8
		v9.animationTrack.Name = self:getNextAnimationTrackName("LookAround")

		assert(
			self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.LookAround] == nil,
			"self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround] should be empty"
		)

		self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.LookAround] = v9

		v8:Play(0.1)
		self:recordAnimationTrackProgress(v9.animationTrack.Name, "Playing")
	else
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
		self:updateMainBodyAnimation(p2, p3, p4)
	end
end

function class:updateMainBodyAnimation(p2, p3, p4)
	assert(not p2.isInPPE, "Should not be in PPE")

	local v6 = p4.mainBodyAnimStringValues
	local v7 = p3.mainBodyAssetId

	if not v6 then
		v6, v7 = self:getFallbackMainBodyAnimStringValuesAndMockAssetId(p2)
	end

	if v6 and v7 and #v6 ~= 0 then
		assert(v6, "animStringValues is not nil. Silences type checker")
		assert(v7, "assetId is not nil.  Silences type checker")

		local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.MainBody]

		local animationTrackWithConnection2 = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.LookAround]

		local animationTrackWithConnectionsIsPlayingThisAssetId = module2.animationTrackWithConnectionsIsPlayingThisAssetId(
			animationTrackWithConnection,
			v7
		)

		local v8 = not p2.excludeIdleAnimation

		if
			animationTrackWithConnectionsIsPlayingThisAssetId and v8
			or module2.animationTrackWithConnectionsIsPlayingThisAssetId(animationTrackWithConnection2, v7)
			and v8
		then
			return
		end

		local v9 = 1

		if self.shouldMoveToNextValidMainBodyAnimation then
			v9 = v9 % #v6 + 1
		end

		local bestMainBodyAnimation, v10 = self:selectBestMainBodyAnimation(v6, v9, p2.excludeIdleAnimation)

		if bestMainBodyAnimation then
			self:playMainBodyAnimation(bestMainBodyAnimation, v6, v7, v10, nil, p2.excludeIdleAnimation)
			return
		end

		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.MainBody)
	else
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
		self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.MainBody)
	end
end

function class:playMainBodyAnimation(p2, p3, p4, p5, value, p6)
	local v6 = value or 0

	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	local animatorLoadAnimationTrack = module2.animatorLoadAnimationTrack(
		currentCharacter,
		p2,
		self.debugLoadAssetsFromFiles
	)

	if not animatorLoadAnimationTrack then
		return
	end

	assert(animatorLoadAnimationTrack, "animationTrack is not nil.  Silences type checker")

	local playingSwimAnimation2 = self.store:getState().AvatarExperience.AvatarScene.Character.PlayingSwimAnimation
	local swimAnimation = module2.isSwimAnimation(p2)

	if playingSwimAnimation2 ~= swimAnimation then
		self.store:dispatch(playingSwimAnimation(swimAnimation))
	end

	animatorLoadAnimationTrack.Looped = true

	local v7 = {}
	v7.assetId = p4
	v7.stoppedConnection = animatorLoadAnimationTrack.Stopped:Connect(function()
		self:handleStoppedConnection(animatorLoadAnimationTrack, v7)
	end)
	v7.endedConnection = animatorLoadAnimationTrack.Ended:Connect(function()
		self:handleEndedConnection(animatorLoadAnimationTrack)
	end)
	v7.didLoopConnection = animatorLoadAnimationTrack.DidLoop:Connect(function()
		if self.destroyed then
			return
		end

		self:recordAnimationTrackProgress(animatorLoadAnimationTrack.Name, "Looped")

		local animationTrackWithConnection = self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.MainBody]

		if animationTrackWithConnection == nil then
			return
		end

		assert(
			animationTrackWithConnection,
			"mainBodyAnimationTrackWithConnections is non nil. Silence type checker"
		)

		if animationTrackWithConnection.animationTrack ~= animatorLoadAnimationTrack then
			return
		end

		if not self.started then
			animatorLoadAnimationTrack:Stop()
			return
		end

		v6 += 1

		local children = p3[p5]:GetChildren()
		local weightedAnimations, v8 = module2.getWeightedAnimations(
			module2.convertToAnimations(children),
			p6
		)

		local v9 = module2.getRandomAnimation(weightedAnimations, v8) or p2

		assert(v9, "newAnimation not nil.  Silences type checker")
		local v10

		if v6 % 4 == 0 then
			if self.shouldMoveToNextValidMainBodyAnimation then
				self.shouldMoveToNextValidMainBodyAnimation = false
			else
				self.shouldMoveToNextValidMainBodyAnimation = true
			end

			v10 = true
		else
			v10 = false
		end

		if v10 or v9 ~= p2 then
			self:playMainBodyAnimation(v9, p3, p4, p5, nil, p6)
		end
	end)

	self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.LookAround)
	self:stopAnimationTrackWithConnections(animationTrackWithConnectionsTypes.MainBody)

	v7.animationTrack = animatorLoadAnimationTrack
	v7.animationTrack.Name = self:getNextAnimationTrackName("MainBody")
	assert(
		self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.MainBody] == nil,
		"self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody] should be empty"
	)

	self.animationTrackWithConnectionsByType[animationTrackWithConnectionsTypes.MainBody] = v7

	animatorLoadAnimationTrack:Play(0.1)
	self:recordAnimationTrackProgress(v7.animationTrack.Name, "Playing")
end

function class:selectBestMainBodyAnimation(p2, p3, p4)
	local nextPlayableWeightedAnimations, v6 = self:findNextPlayableWeightedAnimations(p2, p3, p4)
	local v7, v8 = next(nextPlayableWeightedAnimations)

	if not v7 then
		return nil, v6
	end

	for k, nextPlayableWeightedAnimation in nextPlayableWeightedAnimations do
		if not (v8 < nextPlayableWeightedAnimation) then
			continue
		end

		v7 = k
		v8 = nextPlayableWeightedAnimation
	end

	return v7, v6
end

function class:findNextPlayableWeightedAnimations(list, p3, p4)
	for i = 1, #list do
		local children = if list[p3] then list[p3]:GetChildren() else nil

		if children then
			local convertToAnimations = module2.convertToAnimations(children)

			local weightedAnimations, v6 = module2.getWeightedAnimations(convertToAnimations, p4)

			if v6 > 0 then
				return weightedAnimations, p3
			end
		end

		p3 = p3 % #list + 1
	end

	return {}, p3
end

function class:getFallbackMainBodyAnimStringValuesAndMockAssetId(data)
	local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
	assert(currentCharacter, "currentCharacter is not nil")

	if data.isAvatarBackground then
		local wave = currentCharacter.Animations:FindFirstChild("wave")

		if wave then
			return { wave }, "character_defaultWave"
		end

		return nil, nil
	else
		local v6 = assetTypeIdStrings.IdleAnimation

		if data.pageIsEditorAnimations and data.curCategoryInfo then
			v6 = module2.getAssetTypeIdStringForCategory(data.curCategoryInfo)
		end

		local animStringValuesAssignedToCharacter = self:getAnimStringValuesAssignedToCharacter(
			v6,
			currentCharacter
		)

		local v7 = if animStringValuesAssignedToCharacter and v6 then "character_" .. v6 else nil

		return animStringValuesAssignedToCharacter, v7
	end
end

function class:getAnimStringValuesAssignedToCharacter(p3, instance)
	local avatarType

	if fFlagAXPhotoboothMomentsTryOnEmotes then
		local state = self.store:getState()
		avatarType = state.AvatarExperience.AvatarScene.OutfitTryOn.AvatarType
			or state.AvatarExperience.AvatarEditor.Character.AvatarType
	else
		avatarType = self.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
	end

	local v6 = {}

	if not instance then
		return nil
	end

	assert(instance, "currentCharacter is not nil.  Silences type checker")
	local animations = instance:FindFirstChild("Animations")

	if animations == nil then
		return nil
	end

	assert(animations, "animations is not nil.  Silences type checker")

	if p3 == assetTypeIdStrings.ClimbAnimation then
		table.insert(v6, animations:FindFirstChild("climb"))
	elseif p3 == assetTypeIdStrings.FallAnimation then
		table.insert(v6, animations:FindFirstChild("fall"))
	elseif p3 == assetTypeIdStrings.IdleAnimation then
		table.insert(v6, animations:FindFirstChild("idle"))
	elseif p3 == assetTypeIdStrings.JumpAnimation then
		table.insert(v6, animations:FindFirstChild("jump"))
	elseif p3 == assetTypeIdStrings.RunAnimation then
		table.insert(v6, animations:FindFirstChild("run"))
	elseif p3 == assetTypeIdStrings.WalkAnimation then
		table.insert(v6, animations:FindFirstChild("walk"))
	elseif p3 == assetTypeIdStrings.EmoteAnimation then
		table.insert(v6, animations:FindFirstChild("idle"))
	elseif p3 == assetTypeIdStrings.SwimAnimation then
		if avatarType == module4.AvatarType.R15 then
			table.insert(v6, animations:FindFirstChild("swim"))
			table.insert(v6, animations:FindFirstChild("swimidle"))
		else
			local run = animations:FindFirstChild("run")

			if run then
				local swim = run:Clone()
				swim.Name = "swim"
				table.insert(v6, swim)
			end
		end
	end

	return module2.convertToStringValues(v6)
end

function class:stopAnimationTrackWithConnections(p3, p4)
	local animationTrackWithConnection = self.animationTrackWithConnectionsByType[p3]

	if animationTrackWithConnection then
		if animationTrackWithConnection.didLoopConnection then
			animationTrackWithConnection.didLoopConnection:Disconnect()
		end

		self.animationTrackWithConnectionsByType[p3] = nil

		if module2.animationTrackWithConnectionsIsPlaying(animationTrackWithConnection) then
			assert(
				animationTrackWithConnection,
				"animationTrackWithConnections is not nil. Silences type checker"
			)
			assert(
				animationTrackWithConnection.animationTrack,
				"animationTrackWithConnections.animationTrack is not nil. Silences type checker"
			)

			animationTrackWithConnection.animationTrack:Stop(p4)
		elseif animationTrackWithConnection and animationTrackWithConnection.animationTrack then
			animationTrackWithConnection.animationTrack:Destroy()
		end
	end
end

function class:handleStoppedConnection(p2, p3)
	if self.destroyed then
		return
	end

	self:recordAnimationTrackProgress(p2.Name, "Stopped")

	assert(p2, "animationTrack should be non-nil")
	assert(p2.Name, "animationTrack name should be set")
	assert(
		self.stoppedButNotEndedATWCsByName[p2.Name] == nil,
		"animationTrack should not be in stoppedButNotEndedATWCsByName yet"
	)

	self.stoppedButNotEndedATWCsByName[p2.Name] = p3
end

function class:handleEndedConnection(instance)
	assert(instance, "originalTrack should exist")

	if self.destroyed then
		return
	end

	self:recordAnimationTrackProgress(instance.Name, "Ended")

	if not self.stoppedButNotEndedATWCsByName[instance.Name] then
		logger:info(string.format("\"%s\" missing from self.stoppedButNotEndedATWCsByName: ", instance.Name) .. self:getAnimationTrackRecordString(instance.Name))

		module8("originalTrack missing from self.stoppedButNotEndedATWCsByName")
	end

	instance:Destroy()

	self.stoppedButNotEndedATWCsByName[instance.Name] = nil

	if self.started then
		self:maybeProceedWithPPEPosing()
	end
end

function class:setOnUpdateFinished(onUpdateFinished)
	self.onUpdateFinished = onUpdateFinished
end

function class:setDebugLoadAssetsFromFiles(debugLoadAssetsFromFiles, mapAssetIdToFileName)
	self.debugLoadAssetsFromFiles = debugLoadAssetsFromFiles
	self.mapAssetIdToFileName = mapAssetIdToFileName
end

function class:getNextAnimationTrackName(p3)
	self.animationTrackNameIndex += 1
	return "AnimationTrack_" .. p3 .. "_" .. tostring(self.animationTrackNameIndex)
end

function class:recordAnimationTrackProgress(p3, p4)
	if self.animationTrackNameToHistory == nil then
		self.animationTrackNameToHistory = {}
	end

	local v6 = self.animationTrackNameToHistory[p3]

	if v6 == nil then
		v6 = {}
		self.animationTrackNameToHistory[p3] = v6
	end

	table.insert(v6, p4)
end

function class:getAnimationTrackRecordString(p3)
	local animationTrackRecordString = "Name = " .. p3

	local history = self.animationTrackNameToHistory[p3]

	for k, v6 in history == nil and {} or history do
		animationTrackRecordString ..= ", " .. v6
	end

	return animationTrackRecordString
end

return class
