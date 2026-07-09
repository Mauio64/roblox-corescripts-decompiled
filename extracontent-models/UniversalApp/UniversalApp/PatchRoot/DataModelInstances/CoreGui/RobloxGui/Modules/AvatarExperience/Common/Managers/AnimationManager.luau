local CoreGui = game:GetService("CoreGui")
local InsertService = game:GetService("InsertService")
local ContentProvider = game:GetService("ContentProvider")
local CorePackages = game:GetService("CorePackages")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local Modules = CoreGui.RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local PPEAnimationUtils = require(Modules.AvatarExperience.Common.Managers.PPEAnimationUtils)
local AnimationUtils = require(Modules.AvatarExperience.Common.Managers.AnimationUtils)
local AnimationManagerTypes = require(Modules.AvatarExperience.Common.Managers.AnimationManagerTypes)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local PlayingSwimAnimation = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.PlayingSwimAnimation
local mutedError = require(Modules.LuaApp.mutedError)
local Promise = require(CorePackages.Packages.Promise)

require(CorePackages.Workspace.Packages.AppCommonLib)

local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Dash = require(CorePackages.Packages.Dash)
local SelectShouldPlayMoodAnimationsUsingOutfitTryOn = require(Modules.AvatarExperience.Common.Selectors.SelectShouldPlayMoodAnimationsUsingOutfitTryOn)
local SelectIsToolEquipped = require(Modules.AvatarExperience.Common.Selectors.SelectIsToolEquipped)
local SelectOutfitTryOnMoodAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMoodAnimationAssetId)
local SelectOutfitTryOnIdleAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnIdleAnimationAssetId)
local SelectOutfitTryOnEmoteAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnEmoteAnimationAssetId)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AnimationTrackWithConnectionsTypes = AnimationManagerTypes.AnimationTrackWithConnectionsTypes
local AssetTypeIdStrings = Constants2.AssetTypeIdStrings
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local v30 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.init")
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local _ = {
	EnteredAX = "EnteredAX",
	NewEquippedAssets = "NewEquippedAssets",
	NewOutfitTryOn = "NewOutfitTryOn"
}
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 315
	-- upvalues: t1 (copy), AnimationUtils (copy), InsertService (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.destroyed = false
	t2.started = false
	t2.store = p1
	t2.avatarRoute = p3
	t2.animationTrackWithConnectionsByType = {}
	t2.unresolvedStateTransitions = {}
	t2.shouldMoveToNextValidMainBodyAnimation = false
	t2.stoppedButNotEndedATWCsByName = {}

	local v38 = AnimationUtils.createR6AnimationFolder()
	local v39 = InsertService:LoadLocalAsset("rbxasset://avatar/animations/humanoidR15AnimateChildren.rbxm")

	t2.animationTrackNameIndex = 0
	AnimationUtils.createAnimation(v39, "Tool", AnimationUtils.DefaultAnimations.R15.TOOL)
	AnimationUtils.createAnimation(AnimationUtils.createStringValue(v39, "wave"), "WaveAnim", AnimationUtils.DefaultAnimations.R15.WAVE_EMOTE)
	v38.Name = "Animations"
	v39.Name = "Animations"
	p2:setupAnimations(v38, v39)
	t2.currentStateDigest = {}
	t2.currentAssetIdsToLoad = {}
	t2.currentLoadedAssets = {}
	t2.debugLoadAssetsFromFiles = false
	t2.stateSummaryAtLastVersionUpdate = {
		equippedAssetsSummary = {},
		outfitTryOnSummary = {}
	}
	t2.equippedAssetsSummaryTriggeringLookAround = {}
	t2.outfitTryOnSummaryTriggeringLookAround = {}

	return t2
end
function t1.setToolManager(p4, p5) -- line: 364
	p4.toolManager = p5
end
function t1.start(p6) -- line: 368
	-- upvalues: mutedError (copy), Logging (copy)
	if p6.started then
		mutedError("calling AnimationManager:start when already started")

		return
	end

	p6.started = true
	p6.shouldMoveToNextValidMainBodyAnimation = false
	p6:cleanupAllAnimationTracks()
	p6.storeChangedConnection = p6.store.changed:connect(function(p7, p8) -- line: 378
		-- upvalues: p6 (copy)
		local avatarRoute = p6.avatarRoute

		p6:update(p7, p8, avatarRoute, avatarRoute)
	end)

	if not p6.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter then
		Logging.warn("Tried to start AnimationManager without a character!")

		return
	end
end
function t1.stop(p9) -- line: 390
	-- upvalues: mutedError (copy)
	if not p9.started then
		mutedError("calling AnimationManager:stop when not started")

		return
	end

	p9.started = false

	if p9.loadAssetsPromise then
		p9.loadAssetsPromise:cancel()
	end

	p9:cleanupAllAnimationTracks()

	if p9.storeChangedConnection then
		p9.storeChangedConnection:disconnect()
		p9.storeChangedConnection = nil
	end
end
function t1.onDestroy(p10) -- line: 412
	if p10.loadAssetsPromise then
		p10.loadAssetsPromise:cancel()
	end

	p10.destroyed = true
end
function t1.updateAvatarRoute(p11, p12, p13) -- line: 421
	p11.avatarRoute = p12

	local v48 = p11.store:getState()

	p11:update(v48, v48, p12, p13)
end
function t1.updateCategorySelection(p14) -- line: 427
	local v50 = p14.store:getState()

	p14:update(v50, v50, p14.avatarRoute, p14.avatarRoute)
end
function t1.update(p15, p16, p17, p18, p19) -- line: 433
	-- upvalues: Dash (copy), Promise (copy), Logging (copy)
	if not p16.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		if p15.onUpdateFinished then
			p15.onUpdateFinished(nil, nil, nil, nil)
		end

		return
	end

	local v56 = p15:createStateDigest(p16, p18)
	local v57 = p15:createStateTransitions(p16, p17, p18, p19)
	local v58 = p15:getAssetIdsToLoad(v56, p16)
	local v59 = Dash.shallowEqual(p15.currentStateDigest, v56)
	local v60 = Dash.shallowEqual(p15.currentAssetIdsToLoad, v58)

	p15.currentStateDigest = v56
	p15.currentAssetIdsToLoad = v58

	for k, v in pairs(v57) do
		if v then
			p15.unresolvedStateTransitions[k] = v
		end
	end

	local v63 = false

	for _, v in pairs(p15.unresolvedStateTransitions) do
		if v then
			v63 = true

			break
		end
	end

	if v59 and v60 and not v63 then
		if p15.onUpdateFinished then
			p15.onUpdateFinished(v57, v56, v58, nil)
		end

		return
	end

	if p15.loadAssetsPromise then
		if v59 and v60 then
			assert(v63, "hasUnresolvedTransition should be true")

			if p15.onUpdateFinished then
				p15.onUpdateFinished(v57, v56, v58, nil)
			end

			return
		end

		p15.loadAssetsPromise:cancel()
		p15.loadAssetsPromise = nil
	end

	assert(p15.loadAssetsPromise == nil, "self.loadAssetsPromise should be nil")
	p15.loadAssetsPromise = p15:makeLoadAssetsPromise(v56, v58)
	p15.loadAssetsPromise:andThen(function(p20) -- line: 515
		-- upvalues: p15 (copy), Dash (copy), v56 (copy), v58 (copy), v57 (copy), Promise (copy)
		p15.loadAssetsPromise = nil
		p15.currentLoadedAssets = p20

		if p15.destroyed then
			return
		end

		assert(Dash.shallowEqual(p15.currentStateDigest, v56), "stateDigest should match")
		assert(Dash.shallowEqual(p15.currentAssetIdsToLoad, v58), "assetIdsToLoad should match")
		p15:playLoadedAssets(v56, v58, p20)

		if p15.onUpdateFinished then
			p15.onUpdateFinished(v57, v56, v58, p20)
		end

		return Promise.resolve()
	end):catch(function(p21) -- line: 538
		-- upvalues: p15 (copy), Logging (copy), v57 (copy), v56 (copy), v58 (copy)
		p15.loadAssetsPromise = nil
		Logging.warn("Error in loadAssetsPromise: " .. tostring(p21))

		if p15.onUpdateFinished then
			p15.onUpdateFinished(v57, v56, v58, {})
		end
	end)
end
function t1.createStateTransitions(p22, p23, p24, p25, p26) -- line: 548
	-- upvalues: Utils (copy), AnimationUtils (copy)
	local CurrentCharacter = p23.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local CurrentCharacter2 = p24.AvatarExperience.AvatarScene.Character.CurrentCharacter

	assert(CurrentCharacter, "currentCharacter should be non-nil. Silence type checker.")

	local v73 = Utils.routeIsProfilePictureEditor(p25)
	local v74 = Utils.routeIsProfilePictureEditor(p26)
	local isVisible = p25.isVisible
	local v76 = CurrentCharacter ~= CurrentCharacter2
	local v77 = AnimationUtils.getDidMoveOutOfPPE(v74, v73, isVisible)
	local v78 = p22:getDidSomethingThatShouldTriggerLookAround(CurrentCharacter, p23, p24, p25, p26)

	return {
		didUpdateCharacter = v76,
		didMoveOutOfPPE = v77,
		didSomethingThatShouldTriggerLookAround = v78
	}
end
function t1.shouldResumeLookAroundAfterCharacterSwap(t3: {[any]: any}, b1: boolean, p27, p28, p29, p30) -- line: 590
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), AnimationUtils (copy)
	if p27 == p28 then
		return false
	end

	if not t3:animationTrackWithConnectionsIsPlaying(AnimationTrackWithConnectionsTypes.LookAround) then
		return false
	end

	if t3.lookAroundReason == "EnteredAX" and b1 then
		return true
	end

	if t3.lookAroundReason == "NewEquippedAssets" and AnimationUtils.getEquippedAssetSummariesMatch(p29, t3.equippedAssetsSummaryTriggeringLookAround) then
		return true
	end

	if t3.lookAroundReason == "NewOutfitTryOn" then
		assert(t3.outfitTryOnSummaryTriggeringLookAround, "self.outfitTryOnSummaryTriggeringLookAround should be non-nil")

		if AnimationUtils.getOutfitTryOnSummariesMatch(p30, t3.outfitTryOnSummaryTriggeringLookAround) then
			return true
		end
	end

	return false
end
function t1.getDidSomethingThatShouldTriggerLookAround(t4: {[any]: any}, p31, p32, p33, p34, p35) -- line: 655
	-- upvalues: AnimationUtils (copy), Utils (copy)
	local v91 = AnimationUtils.getHumanoidFromCharacter(p31)

	if not v91 then
		return false
	end

	assert(v91, "humanoid should not be nil. Silence type checker")

	if Enum.HumanoidRigType.R15 ~= v91.RigType then
		return false
	end

	if Utils.routeIsProfilePictureEditor(p34) then
		return false
	end

	local isVisible = p34.isVisible
	local isVisible2 = p35.isVisible

	if isVisible and not isVisible2 then
		t4.lookAroundReason = "EnteredAX"

		return true
	end

	local CurrentCharacter = p33.AvatarExperience.AvatarScene.Character.CurrentCharacter
	local CharacterVersion = p32.AvatarExperience.AvatarScene.Character.CharacterVersion
	local CharacterVersion2 = p33.AvatarExperience.AvatarScene.Character.CharacterVersion
	local EquippedAssets = p32.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local OutfitTryOn = p32.AvatarExperience.AvatarScene.OutfitTryOn
	local v99 = CharacterVersion2 ~= CharacterVersion
	local v100 = AnimationUtils.getEquippedAssetsSummary(EquippedAssets)
	local v101 = AnimationUtils.getOutfitTryOnSummary(OutfitTryOn)
	local equippedAssetsSummary = t4.stateSummaryAtLastVersionUpdate.equippedAssetsSummary
	local outfitTryOnSummary = t4.stateSummaryAtLastVersionUpdate.outfitTryOnSummary

	if v99 then
		t4.stateSummaryAtLastVersionUpdate.equippedAssetsSummary = v100
		t4.stateSummaryAtLastVersionUpdate.outfitTryOnSummary = v101

		if AnimationUtils.getEquippedAssetsSummaryHasNewItems(v100, equippedAssetsSummary) then
			t4.lookAroundReason = "NewEquippedAssets"
			t4.equippedAssetsSummaryTriggeringLookAround = v100

			return true
		end

		if AnimationUtils.getOutfitTryOnSummaryHasNewItems(v101, outfitTryOnSummary) then
			t4.lookAroundReason = "NewOutfitTryOn"
			t4.outfitTryOnSummaryTriggeringLookAround = v101

			return true
		end
	end

	if t4:shouldResumeLookAroundAfterCharacterSwap(isVisible, p31, CurrentCharacter, v100, v101) then
		return true
	end

	return false
end
function t1.createStateDigest(p36, p37, p38) -- line: 759
	-- upvalues: Utils (copy), AnimationUtils (copy), Constants2 (copy), AvatarScreen (copy), GetFFlagAXEnableSlotBasedEditor (copy), Constants (copy), SelectShouldPlayMoodAnimationsUsingOutfitTryOn (copy), PPEThumbnailType (copy), IxpUtils (copy), UniversalAppCameraIXPTest (copy), SelectIsToolEquipped (copy)
	local name = p38.opaque.name
	local v108 = Utils.getCategoryInfoFromState(p37, p38)
	local v109, v110 = AnimationUtils.getAllowsTryingEmotesOrAnimations(p37, p38)
	local v111 = v108.PageType == Constants2.PageType.Emotes and name == AvatarScreen.AvatarEditor

	if GetFFlagAXEnableSlotBasedEditor() then
		v111 = v111 or name == AvatarScreen.EditEmotes
	end

	local v112 = v108.PageType == Constants2.PageType.Animation and name == AvatarScreen.AvatarEditor
	local v113 = name == AvatarScreen.AdjustAccessoryView
	local v114 = p37.AvatarExperience.AvatarEditor.Character.AvatarType ~= Constants.AvatarType.R6 and SelectShouldPlayMoodAnimationsUsingOutfitTryOn(p37)
	local v115 = Utils.routeIsProfilePictureEditor(p38)
	local v116 = false

	if v115 and name == AvatarScreen.ProfilePictureEditorFinal and p37.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode == PPEThumbnailType.FullBody then
		v116 = true
	end

	local v117 = false
	local CurrentCharacter = p36.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if CurrentCharacter and CurrentCharacter:FindFirstChildOfClass("Tool") then
		v117 = true
	end

	local v119 = v108.CanAnimateCameraBasedMood == true
	local v120, v121 = AnimationUtils.canPlayCameraBasedMoodAnimation(p37, v119, v109)
	local v122 = IxpUtils.readTestVariable(UniversalAppCameraIXPTest.EnabledForUser)

	return {
		isInPPE = v115,
		isInAX = p38.isVisible,
		toolEquipped = SelectIsToolEquipped(p37),
		curCategoryInfo = v108,
		isAvatarBackground = Utils.isAvatarBackground(p38.current.name),
		pageAllowsForTryingOnEmotes = v109,
		pageAllowsForTryingOnAnimations = v110,
		pageHasBothAnimsAndEmotes = v109 and v110,
		pageIsEditorEmotes = v111,
		pageIsEditorAnimations = v112,
		excludeIdleAnimation = v113,
		shouldPlayMoodAnimations = v114,
		canPlayCameraBasedMoodAnimation = if not v122 then nil else v120,
		receivedOutfitInfo = if not v122 then nil else v121,
		ppeFinalPageFullView = v116,
		hasTool = v117,
		cameraButtonEnabled = if not v122 then nil else p37.AvatarExperience.CameraButton.enabled
	}
end
function t1.getAssetIdsToLoad(p39, p40, p41) -- line: 844
	-- upvalues: PPEAnimationUtils (copy), SelectOutfitTryOnMoodAnimationAssetId (copy), Utils2 (copy)
	if p40.isInPPE then
		return PPEAnimationUtils.getAssetIdsToLoad(p41, p40.shouldPlayMoodAnimations)
	end

	local t5 = {}

	if p40.shouldPlayMoodAnimations then
		local v127 = SelectOutfitTryOnMoodAnimationAssetId(p41)

		if v127 then
			t5.moodAssetId = v127
		else
			t5.moodAssetId = Utils2.getEquippedMoodAssetId(p41)
		end
	end

	t5.mainBodyAssetId = p39:getMainBodyAssetId(p40, p41)

	return t5
end
function t1.getMainBodyAssetId(p42, p43, p44) -- line: 873
	-- upvalues: Constants (copy), AnimationUtils (copy)
	if p44.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6 then
		return nil
	end

	if p43.isAvatarBackground then
		return p42:getAvatarBackgroundAssetId(p44)
	end

	local v131 = p42:getTryOnMainBodyAssetId(p43, p44)

	if v131 then
		return v131
	end

	if p43.pageIsEditorEmotes then
		local v132 = p44.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo[p44.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot]

		if v132 and v132.assetId then
			return v132.assetId
		end
	end

	if p43.pageIsEditorAnimations then
		local v133 = AnimationUtils.getAssetTypeIdStringForCategory(p43.curCategoryInfo)

		if v133 then
			local EquippedAssets = p44.AvatarExperience.AvatarEditor.Character.EquippedAssets
			local v135 = EquippedAssets and EquippedAssets[v133]
			local v136 = v135 and next(v135) or nil

			if v136 then
				return v136
			end

			return nil
		end
	end

	local v137 = AnimationUtils.getEquippedIdleAnimation(p44)

	if v137 then
		return v137
	end

	return nil
end
function t1.getAvatarBackgroundAssetId(_, p46) -- line: 935
	-- upvalues: AnimationUtils (copy)
	if not p46.AvatarExperience.Common.PlayEmoteInBackground.shouldPlayEmoteInBackground then
		return nil
	end

	for _, v141 in p46.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo do
		if v141.assetId then
			return v141.assetId
		end
	end

	local v142 = AnimationUtils.getEquippedIdleAnimation(p46)

	if v142 then
		return v142
	end

	return nil
end
function t1.getTryOnMainBodyAssetId(_, p48, p49) -- line: 963
	-- upvalues: SelectOutfitTryOnEmoteAnimationAssetId (copy), AssetTypeIdStrings (copy), SelectOutfitTryOnIdleAnimationAssetId (copy)
	local TryOn = p49.AvatarExperience.AvatarScene.TryOn
	local OutfitTryOn = p49.AvatarExperience.AvatarScene.OutfitTryOn

	if p48.pageAllowsForTryingOnEmotes then
		local v148 = SelectOutfitTryOnEmoteAnimationAssetId(p49)

		if v148 then
			if not p48.pageHasBothAnimsAndEmotes then
				return v148
			end

			local LastAnimOrEmoteToggledItem = OutfitTryOn.LastAnimOrEmoteToggledItem

			if LastAnimOrEmoteToggledItem and v148 == LastAnimOrEmoteToggledItem.itemId then
				return v148
			end
		end
	end

	if p48.pageAllowsForTryingOnAnimations and TryOn.AnimationPreview and TryOn.AnimationPreviewAssetTypeIdString ~= AssetTypeIdStrings.EmoteAnimation then
		return TryOn.AnimationPreview
	end

	local v150 = SelectOutfitTryOnIdleAnimationAssetId(p49)

	if v150 then
		return v150
	end

	return nil
end
function t1.getMultiTryOnTriedOnEmote(_, p51) -- line: 1027
	-- upvalues: AssetTypeIdStrings (copy)
	for _, v154 in p51.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v154.itemSubType == AssetTypeIdStrings.EmoteAnimation then
			return v154.itemId
		end
	end

	return nil
end
function t1.makeLoadAssetsPromise(p52, p53, p54) -- line: 1038
	-- upvalues: Promise (copy), PPEAnimationUtils (copy), AnimationUtils (copy), Dash (copy), ContentProvider (copy)
	return Promise.new(function(resolve, _, onCancel) -- line: 1042
		-- upvalues: PPEAnimationUtils (copy), p52 (copy), p53 (copy), p54 (copy), AnimationUtils (copy), Dash (copy), ContentProvider (copy)
		onCancel(function() -- line: 1043
			-- upvalues: PPEAnimationUtils (copy), p52 (copy)
			PPEAnimationUtils.maybeNoteLoadingFinished(p52.store)
		end)

		if p53.isInPPE then
			resolve(PPEAnimationUtils.makeLoadedAssets(p52.store, p53, p54))

			return
		end

		local t6 = {}

		if p54.moodAssetId then
			t6.moodAnimStringValues = AnimationUtils.loadAnimStringValuesFromString(p54.moodAssetId, p52.debugLoadAssetsFromFiles, p52.mapAssetIdToFileName)
		end

		if p54.mainBodyAssetId then
			t6.mainBodyAnimStringValues = AnimationUtils.loadAnimStringValuesFromString(p54.mainBodyAssetId, p52.debugLoadAssetsFromFiles, p52.mapAssetIdToFileName)
		end

		local t7 = {}

		if t6.moodAnimStringValues then
			Dash.append(t7, t6.moodAnimStringValues)
		end

		if t6.mainBodyAnimStringValues then
			Dash.append(t7, t6.mainBodyAnimStringValues)
		end

		if #t7 > 0 and not p52.debugLoadAssetsFromFiles then
			ContentProvider:PreloadAsync(t7)
		end

		resolve(t6)
	end)
end
function t1.playLoadedAssets(p56, p57, p58, p59) -- line: 1095
	-- upvalues: AnimationUtils (copy), PPEAnimationUtils (copy), IxpUtils (copy), UniversalAppCameraIXPTest (copy)
	if p56.unresolvedStateTransitions.didUpdateCharacter then
		p56:cleanupAllAnimationTracks()
		p56.unresolvedStateTransitions.didUpdateCharacter = false
	end

	if p57.isInPPE then
		p56:stopAnimationsAndMaybeProceedWithPPEPosing()

		return
	end

	if p56.unresolvedStateTransitions.didMoveOutOfPPE then
		local CurrentCharacter = p56.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
		local v163 = AnimationUtils.getHumanoidFromCharacter(CurrentCharacter)

		PPEAnimationUtils.undoOldProfilePictureEditorPose(p56.store, CurrentCharacter, v163)
	end

	p56.unresolvedStateTransitions.didMoveOutOfPPE = false
	p56:updateToolAnimation(p57)
	p56:updateMoodAnimation(p57, p58, p59)

	if IxpUtils.readTestVariable(UniversalAppCameraIXPTest.EnabledForUser) then
		p56:updateCameraBasedMoodAnimation(p57)
	end

	if p56.unresolvedStateTransitions.didSomethingThatShouldTriggerLookAround then
		p56:updateMainBodyAnimationAfterPlayingLookAround(p57, p58, p59)
	else
		p56:updateMainBodyAnimation(p57, p58, p59)
	end

	p56.unresolvedStateTransitions.didSomethingThatShouldTriggerLookAround = false
end
function t1.cleanupAllAnimationTracks(p60) -- line: 1143
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), AnimationUtils (copy)
	for _, v in pairs(AnimationTrackWithConnectionsTypes) do
		AnimationUtils.cleanupAnimationTrackWithConnections(p60.animationTrackWithConnectionsByType[v])
		p60.animationTrackWithConnectionsByType[v] = nil
	end

	for _, v168 in p60.stoppedButNotEndedATWCsByName do
		AnimationUtils.cleanupAnimationTrackWithConnections(v168)
	end

	p60.stoppedButNotEndedATWCsByName = {}
end
function t1.stopAnimationsAndMaybeProceedWithPPEPosing(p61) -- line: 1164
	-- upvalues: AnimationTrackWithConnectionsTypes (copy)
	assert(p61.currentStateDigest.isInPPE, "Must be in PPE")
	assert(p61.currentStateDigest.isInAX, "Must be in in AX")

	for _, v in pairs(AnimationTrackWithConnectionsTypes) do
		p61:stopAnimationTrackWithConnections(v, 0.02)
	end

	p61:maybeProceedWithPPEPosing()
end
function t1.maybeProceedWithPPEPosing(p62) -- line: 1183
	-- upvalues: AnimationUtils (copy), PPEAnimationUtils (copy)
	local function maybeProceedWithPPEPosingInner() -- line: 1184
		-- upvalues: p62 (copy), AnimationUtils (copy), PPEAnimationUtils (copy)
		if not p62.currentStateDigest.isInPPE then
			return
		end

		if not p62.currentStateDigest.isInAX then
			return
		end

		if p62.loadAssetsPromise then
			return
		end

		if p62:animationsAreMovingAvatar() then
			return
		end

		local CurrentCharacter = p62.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

		if CurrentCharacter then
			local v319 = AnimationUtils.getHumanoidFromCharacter(CurrentCharacter)

			if v319 then
				PPEAnimationUtils.applyNewProfilePictureEditorPose(p62.store, CurrentCharacter, v319, p62.currentLoadedAssets.keyframesForPose)
			end
		end
	end

	AnimationUtils.waitForAnimationAndPosingToResolve(function() -- line: 1223
		-- upvalues: maybeProceedWithPPEPosingInner (copy)
		maybeProceedWithPPEPosingInner()
	end)
end
function t1.animationTrackWithConnectionsIsPlaying(t8: {[any]: any}, s1: string) -- line: 1228
	-- upvalues: AnimationUtils (copy)
	local v176 = t8.animationTrackWithConnectionsByType[s1]

	if v176 then
		return AnimationUtils.animationTrackWithConnectionsIsPlaying(v176)
	end

	return false
end
function t1.animationsAreMovingAvatar(p63) -- line: 1236
	-- upvalues: AnimationTrackWithConnectionsTypes (copy)
	for _, v in pairs(AnimationTrackWithConnectionsTypes) do
		if p63:animationTrackWithConnectionsIsPlaying(v) then
			return true
		end
	end

	if next(p63.stoppedButNotEndedATWCsByName) then
		return true
	end

	return false
end
function t1.updateToolAnimation(p64, p65) -- line: 1262
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), AnimationUtils (copy), Utils2 (copy)
	assert(not p65.isInPPE, "Should not be in PPE")

	if not p65.toolEquipped then
		p64:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.ToolHold)

		return
	end

	local CurrentCharacter = p64.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
	local Animations = CurrentCharacter.Animations
	local u184 = nil
	local v185 = nil

	if Animations then
		local Tool = Animations.Tool

		if Tool then
			u184 = AnimationUtils.animatorLoadAnimationTrack(CurrentCharacter, Tool, p64.debugLoadAssetsFromFiles)
			v185 = Utils2.getAssetIdFromContent(Tool.AnimationId)
		end
	end

	if not v185 or not u184 then
		p64:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.ToolHold)

		return
	end

	assert(v185, "newToolAnimationAssetId is not nil. Silence type checker")

	local v187 = p64.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.ToolHold]

	if AnimationUtils.animationTrackWithConnectionsIsPlayingThisAssetId(v187, v185) then
		return
	end

	p64:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.ToolHold)
	assert(u184, "toolHoldAnimationTrack is not nil. Silence type checker")
	assert(v185, "newToolAnimationAssetId should be non-nil")

	local t9 = {
		assetId = v185
	}

	t9.stoppedConnection = u184.Stopped:Connect(function() -- line: 1317
		-- upvalues: p64 (copy), u184 (ref), t9 (copy)
		p64:handleStoppedConnection(u184, t9)
	end)
	t9.endedConnection = u184.Ended:Connect(function() -- line: 1320
		-- upvalues: p64 (copy), u184 (ref)
		p64:handleEndedConnection(u184)
	end)
	t9.animationTrack = u184
	t9.animationTrack.Name = p64:getNextAnimationTrackName("ToolHold")
	p64.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.ToolHold] = t9
	u184:Play(0.1)
	p64:recordAnimationTrackProgress(t9.animationTrack.Name, "Playing")
end
function t1.updateMoodAnimation(p66, p67, p68, p69) -- line: 1347
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), AnimationUtils (copy)
	assert(not p67.isInPPE, "Should not be in PPE")

	if p68.moodAssetId == nil or p69.moodAnimStringValues == nil then
		p66:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.Mood)

		return
	end

	assert(p68.moodAssetId, "assetIdsToLoad.moodAssetId is non-nil. Silence type checker")
	assert(p69.moodAnimStringValues, "loadedAssets.moodAnimStringValues is non-nil. Silence type checker")

	local v193 = p66.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.Mood]

	if AnimationUtils.animationTrackWithConnectionsIsPlayingThisAssetId(v193, p68.moodAssetId) then
		return
	end

	p66:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.Mood)
	assert(p69.moodAnimStringValues, "loadedAssets.moodAnimStringValues is not nil.  Silences type checker")

	local u194 = nil
	local children = nil

	if p69.moodAnimStringValues[1] then
		children = p69.moodAnimStringValues[1]:GetChildren()
	end

	if children then
		local v196 = children[1]

		if v196 then
			assert(v196.ClassName == "Animation", "moodAnim should be an animation.")

			local CurrentCharacter = p66.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

			u194 = AnimationUtils.animatorLoadAnimationTrack(CurrentCharacter, v196, p66.debugLoadAssetsFromFiles)
		end
	end

	if not u194 then
		return
	end

	assert(u194, "moodAnimationTrack is not nil. Silences type checker")

	local t10 = {
		assetId = p68.moodAssetId
	}

	t10.stoppedConnection = u194.Stopped:Connect(function() -- line: 1407
		-- upvalues: p66 (copy), u194 (ref), t10 (copy)
		p66:handleStoppedConnection(u194, t10)
	end)
	t10.endedConnection = u194.Ended:Connect(function() -- line: 1410
		-- upvalues: p66 (copy), u194 (ref)
		p66:handleEndedConnection(u194)
	end)
	t10.animationTrack = u194
	t10.animationTrack.Name = p66:getNextAnimationTrackName("Mood")
	assert(p66.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.Mood] == nil, "self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.Mood] should be empty")
	p66.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.Mood] = t10
	u194:Play()
	p66:recordAnimationTrackProgress(t10.animationTrack.Name, "Playing")
end
function t1.updateCameraBasedMoodAnimation(p70, p71) -- line: 1442
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), FaceAnimatorService (copy), AnimationUtils (copy)
	assert(not p71.isInPPE, "Should not be in PPE")

	local v201 = p70.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.CameraStream]

	if not p71.cameraButtonEnabled then
		p70:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.CameraStream)
		FaceAnimatorService:Stop()

		return
	end

	if v201 then
		if p71.receivedOutfitInfo and not p71.canPlayCameraBasedMoodAnimation then
			AnimationUtils.adjustATWCWeight(v201, 0.0001)

			return
		end

		if AnimationUtils.animationTrackWithConnectionsIsPlaying(v201) then
			AnimationUtils.adjustATWCWeight(v201, 1)

			return
		end
	end

	p70:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.CameraStream)

	local t11 = {}
	local CurrentCharacter = p70.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
	local v204 = AnimationUtils.animatorLoadTrackerStreamAnimationTrack(CurrentCharacter, Instance.new("TrackerStreamAnimation"), p70.debugLoadAssetsFromFiles)

	assert(v204, "cameraBasedMoodAnimationTrack is not nil. If it is ever nil, it should be investigated if a dependent flag is missing")
	t11.animationTrack = v204
	t11.animationTrack.Name = p70:getNextAnimationTrackName("CameraBasedMoodAnimation")
	t11.stoppedConnection = v204.Stopped:Connect(function() -- line: 1485
		-- upvalues: p70 (copy), v204 (copy), t11 (copy)
		p70:handleStoppedConnection(v204, t11)
		p70:handleEndedConnection(v204)
	end)
	v204.Priority = Enum.AnimationPriority.Action4
	assert(p70.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.CameraStream] == nil, "self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.CameraStream] should be empty")
	p70.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.CameraStream] = t11
	v204:Play()
	p70:recordAnimationTrackProgress(t11.animationTrack.Name, "Playing")

	if p71.receivedOutfitInfo and not p71.canPlayCameraBasedMoodAnimation then
		AnimationUtils.adjustATWCWeight(t11, 0.0001)
	end
end
function t1.updateMainBodyAnimationAfterPlayingLookAround(p72, p73, p74, p75) -- line: 1517
	-- upvalues: AnimationUtils (copy), AnimationTrackWithConnectionsTypes (copy)
	assert(not p73.isInPPE, "Should not be in PPE")

	local mainBodyAnimStringValues = p75.mainBodyAnimStringValues
	local mainBodyAssetId = p74.mainBodyAssetId

	if not mainBodyAnimStringValues then
		mainBodyAnimStringValues, mainBodyAssetId = p72:getFallbackMainBodyAnimStringValuesAndMockAssetId(p73)
	end

	local u211 = nil

	if mainBodyAnimStringValues then
		local v212, _ = AnimationUtils.getWeightedAnimations(AnimationUtils.convertToAnimations(mainBodyAnimStringValues[1]:GetChildren()))
		local v214 = nil
		local v215 = nil

		for k, v in next, v212 do
			if v214 == nil or v < v215 then
				v214 = k
				v215 = v
			end
		end

		if v214 then
			local CurrentCharacter = p72.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

			u211 = AnimationUtils.animatorLoadAnimationTrack(CurrentCharacter, v214, p72.debugLoadAssetsFromFiles)
		end
	end

	if not u211 or not mainBodyAssetId then
		p72:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
		p72:updateMainBodyAnimation(p73, p74, p75)

		return
	end

	assert(u211, "lookAroundTrack is not nil. Silences type checker")
	assert(mainBodyAssetId, "assetId is not nil. Silences type checker")

	local v219 = p72.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround]

	if AnimationUtils.animationTrackWithConnectionsIsPlayingThisAssetId(v219, mainBodyAssetId) then
		return
	end

	p72:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
	p72:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.MainBody)
	u211.Looped = true

	local t12 = {
		assetId = mainBodyAssetId
	}

	t12.stoppedConnection = u211.Stopped:Connect(function() -- line: 1587
		-- upvalues: p72 (copy), u211 (ref), t12 (copy)
		p72:handleStoppedConnection(u211, t12)
	end)
	t12.endedConnection = u211.Ended:Connect(function() -- line: 1590
		-- upvalues: p72 (copy), u211 (ref)
		p72:handleEndedConnection(u211)
	end)
	t12.didLoopConnection = u211.DidLoop:Connect(function() -- line: 1593
		-- upvalues: p72 (copy), u211 (ref), AnimationTrackWithConnectionsTypes (copy), p73 (copy), p74 (copy), p75 (copy)
		if p72.destroyed then
			return
		end

		p72:recordAnimationTrackProgress(u211.Name, "Looped")
		p72:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
		p72:updateMainBodyAnimation(p73, p74, p75)
	end)
	t12.animationTrack = u211
	t12.animationTrack.Name = p72:getNextAnimationTrackName("LookAround")
	assert(p72.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround] == nil, "self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround] should be empty")
	p72.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround] = t12
	u211:Play(0.1)
	p72:recordAnimationTrackProgress(t12.animationTrack.Name, "Playing")
end
function t1.updateMainBodyAnimation(p76, p77, p78, p79) -- line: 1619
	-- upvalues: AnimationTrackWithConnectionsTypes (copy), AnimationUtils (copy)
	assert(not p77.isInPPE, "Should not be in PPE")

	local mainBodyAnimStringValues = p79.mainBodyAnimStringValues
	local mainBodyAssetId = p78.mainBodyAssetId

	if not mainBodyAnimStringValues then
		mainBodyAnimStringValues, mainBodyAssetId = p76:getFallbackMainBodyAnimStringValuesAndMockAssetId(p77)
	end

	if not mainBodyAnimStringValues or not mainBodyAssetId or #mainBodyAnimStringValues == 0 then
		p76:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
		p76:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.MainBody)

		return
	end

	assert(mainBodyAnimStringValues, "animStringValues is not nil. Silences type checker")
	assert(mainBodyAssetId, "assetId is not nil.  Silences type checker")

	local v227 = p76.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody]
	local v228 = p76.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.LookAround]
	local v229 = AnimationUtils.animationTrackWithConnectionsIsPlayingThisAssetId(v227, mainBodyAssetId)
	local v230 = not p77.excludeIdleAnimation

	if v229 and v230 then
		return
	end

	if AnimationUtils.animationTrackWithConnectionsIsPlayingThisAssetId(v228, mainBodyAssetId) and v230 then
		return
	end

	local n1 = 1

	if p76.shouldMoveToNextValidMainBodyAnimation then
		n1 = n1 % #mainBodyAnimStringValues + 1
	end

	local v232, v233 = p76:selectBestMainBodyAnimation(mainBodyAnimStringValues, n1, p77.excludeIdleAnimation)

	if v232 then
		p76:playMainBodyAnimation(v232, mainBodyAnimStringValues, mainBodyAssetId, v233, nil, p77.excludeIdleAnimation)

		return
	end

	p76:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
	p76:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.MainBody)
end
function t1.playMainBodyAnimation(t13: {[any]: any}, p80, t14: {[any]: any}, s2: string, n2: number, n3: number?, b2: boolean?) -- line: 1699
	-- upvalues: AnimationUtils (copy), PlayingSwimAnimation (copy), AnimationTrackWithConnectionsTypes (copy)
	local u241 = n3 or 0
	local CurrentCharacter = t13.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter
	local v243 = AnimationUtils.animatorLoadAnimationTrack(CurrentCharacter, p80, t13.debugLoadAssetsFromFiles)

	if not v243 then
		return
	end

	assert(v243, "animationTrack is not nil.  Silences type checker")

	local PlayingSwimAnimation2 = t13.store:getState().AvatarExperience.AvatarScene.Character.PlayingSwimAnimation
	local v245 = AnimationUtils.isSwimAnimation(p80)

	if PlayingSwimAnimation2 ~= v245 then
		t13.store:dispatch(PlayingSwimAnimation(v245))
	end

	v243.Looped = true

	local t15 = {
		assetId = s2
	}

	t15.stoppedConnection = v243.Stopped:Connect(function() -- line: 1729
		-- upvalues: t13 (copy), v243 (copy), t15 (copy)
		t13:handleStoppedConnection(v243, t15)
	end)
	t15.endedConnection = v243.Ended:Connect(function() -- line: 1732
		-- upvalues: t13 (copy), v243 (copy)
		t13:handleEndedConnection(v243)
	end)
	t15.didLoopConnection = v243.DidLoop:Connect(function() -- line: 1735
		-- upvalues: t13 (copy), v243 (copy), AnimationTrackWithConnectionsTypes (copy), u241 (ref), t14 (copy), n2 (copy), AnimationUtils (copy), b2 (copy), p80 (copy), s2 (copy)
		if t13.destroyed then
			return
		end

		t13:recordAnimationTrackProgress(v243.Name, "Looped")

		local v320 = t13.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody]

		if v320 == nil then
			return
		end

		assert(v320, "mainBodyAnimationTrackWithConnections is non nil. Silence type checker")

		if v320.animationTrack ~= v243 then
			return
		end

		if not t13.started then
			v243:Stop()

			return
		end

		u241 += 1

		local children = t14[n2]:GetChildren()
		local v322, v323 = AnimationUtils.getWeightedAnimations(AnimationUtils.convertToAnimations(children), b2)
		local v324 = AnimationUtils.getRandomAnimation(v322, v323) or p80

		assert(v324, "newAnimation not nil.  Silences type checker")

		local v325 = false

		if u241 % 4 == 0 then
			if t13.shouldMoveToNextValidMainBodyAnimation then
				t13.shouldMoveToNextValidMainBodyAnimation = false
			else
				t13.shouldMoveToNextValidMainBodyAnimation = true
			end

			v325 = true
		end

		if v325 or v324 ~= p80 then
			t13:playMainBodyAnimation(v324, t14, s2, n2, nil, b2)
		end
	end)
	t13:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.LookAround)
	t13:stopAnimationTrackWithConnections(AnimationTrackWithConnectionsTypes.MainBody)
	t15.animationTrack = v243
	t15.animationTrack.Name = t13:getNextAnimationTrackName("MainBody")
	assert(t13.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody] == nil, "self.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody] should be empty")
	t13.animationTrackWithConnectionsByType[AnimationTrackWithConnectionsTypes.MainBody] = t15
	v243:Play(0.1)
	t13:recordAnimationTrackProgress(t15.animationTrack.Name, "Playing")
end
function t1.selectBestMainBodyAnimation(t16: {[any]: any}, t17: {[any]: any}, n4: number, b3: boolean?) -- line: 1823
	local v251, v252 = t16:findNextPlayableWeightedAnimations(t17, n4, b3)
	local v253, v254 = next(v251)

	if not v253 then
		return nil, v252
	end

	for v255, v256 in v251 do
		if v254 < v256 then
			v253 = v255
			v254 = v256
		end
	end

	return v253, v252
end
function t1.findNextPlayableWeightedAnimations(_: {[any]: any}, t19: {[any]: any}, n5: number, b4: boolean?) -- line: 1845
	-- upvalues: AnimationUtils (copy)
	for _ = 1, #t19 do
		local v262 = if not t19[n5] then nil else t19[n5]:GetChildren()

		if v262 then
			local v263 = AnimationUtils.convertToAnimations(v262)
			local v264, v265 = AnimationUtils.getWeightedAnimations(v263, b4)

			if v265 > 0 then
				return v264, n5
			end
		end

		n5 = n5 % #t19 + 1
	end

	return {}, n5
end
function t1.getFallbackMainBodyAnimStringValuesAndMockAssetId(p81, p82) -- line: 1886
	-- upvalues: AssetTypeIdStrings (copy), AnimationUtils (copy)
	local CurrentCharacter = p81.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	assert(CurrentCharacter, "currentCharacter is not nil")

	if p82.isAvatarBackground then
		local wave = CurrentCharacter.Animations:FindFirstChild("wave")

		if wave then
			return { wave }, "character_defaultWave"
		end

		return nil, nil
	end

	local IdleAnimation = AssetTypeIdStrings.IdleAnimation

	if p82.pageIsEditorAnimations and p82.curCategoryInfo then
		IdleAnimation = AnimationUtils.getAssetTypeIdStringForCategory(p82.curCategoryInfo)
	end

	local v271 = p81:getAnimStringValuesAssignedToCharacter(IdleAnimation, CurrentCharacter)
	local v272 = nil

	if v271 and IdleAnimation then
		v272 = "character_" .. IdleAnimation
	end

	return v271, v272
end
function t1.getAnimStringValuesAssignedToCharacter(t20: {[any]: any}, p83, p84) -- line: 1919
	-- upvalues: AssetTypeIdStrings (copy), Constants (copy), AnimationUtils (copy)
	local AvatarType = t20.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
	local t21 = {}

	if not p84 then
		return nil
	end

	assert(p84, "currentCharacter is not nil.  Silences type checker")

	local Animations = p84:FindFirstChild("Animations")

	if Animations == nil then
		return nil
	end

	assert(Animations, "animations is not nil.  Silences type checker")

	if p83 == AssetTypeIdStrings.ClimbAnimation then
		table.insert(t21, Animations:FindFirstChild("climb"))
	elseif p83 == AssetTypeIdStrings.FallAnimation then
		table.insert(t21, Animations:FindFirstChild("fall"))
	elseif p83 == AssetTypeIdStrings.IdleAnimation then
		table.insert(t21, Animations:FindFirstChild("idle"))
	elseif p83 == AssetTypeIdStrings.JumpAnimation then
		table.insert(t21, Animations:FindFirstChild("jump"))
	elseif p83 == AssetTypeIdStrings.RunAnimation then
		table.insert(t21, Animations:FindFirstChild("run"))
	elseif p83 == AssetTypeIdStrings.WalkAnimation then
		table.insert(t21, Animations:FindFirstChild("walk"))
	elseif p83 == AssetTypeIdStrings.EmoteAnimation then
		table.insert(t21, Animations:FindFirstChild("idle"))
	elseif p83 == AssetTypeIdStrings.SwimAnimation then
		if AvatarType == Constants.AvatarType.R15 then
			table.insert(t21, Animations:FindFirstChild("swim"))
			table.insert(t21, Animations:FindFirstChild("swimidle"))
		else
			local run = Animations:FindFirstChild("run")

			if run then
				local clone = run:Clone()

				clone.Name = "swim"
				table.insert(t21, clone)
			end
		end
	end

	return AnimationUtils.convertToStringValues(t21)
end
function t1.stopAnimationTrackWithConnections(t22: {[any]: any}, s3: string, n6: number?) -- line: 1967
	-- upvalues: AnimationUtils (copy)
	local v284 = t22.animationTrackWithConnectionsByType[s3]

	if v284 then
		if v284.didLoopConnection then
			v284.didLoopConnection:Disconnect()
		end

		t22.animationTrackWithConnectionsByType[s3] = nil

		if AnimationUtils.animationTrackWithConnectionsIsPlaying(v284) then
			assert(v284, "animationTrackWithConnections is not nil. Silences type checker")
			assert(v284.animationTrack, "animationTrackWithConnections.animationTrack is not nil. Silences type checker")
			v284.animationTrack:Stop(n6)

			return
		end

		if v284 and v284.animationTrack then
			v284.animationTrack:Destroy()
		end
	end
end
function t1.handleStoppedConnection(t23: {[any]: any}, p85, p86) -- line: 1997
	if t23.destroyed then
		return
	end

	t23:recordAnimationTrackProgress(p85.Name, "Stopped")
	assert(p85, "animationTrack should be non-nil")
	assert(p85.Name, "animationTrack name should be set")
	assert(t23.stoppedButNotEndedATWCsByName[p85.Name] == nil, "animationTrack should not be in stoppedButNotEndedATWCsByName yet")
	t23.stoppedButNotEndedATWCsByName[p85.Name] = p86
end
function t1.handleEndedConnection(t24: {[any]: any}, p87) -- line: 2016
	-- upvalues: v30 (copy), mutedError (copy)
	assert(p87, "originalTrack should exist")

	if t24.destroyed then
		return
	end

	t24:recordAnimationTrackProgress(p87.Name, "Ended")

	if not t24.stoppedButNotEndedATWCsByName[p87.Name] then
		local v290 = string.format("\"%s\" missing from self.stoppedButNotEndedATWCsByName: ", p87.Name) .. t24:getAnimationTrackRecordString(p87.Name)

		v30:info(v290)
		mutedError("originalTrack missing from self.stoppedButNotEndedATWCsByName")
	end

	p87:Destroy()
	t24.stoppedButNotEndedATWCsByName[p87.Name] = nil

	if t24.started then
		t24:maybeProceedWithPPEPosing()
	end
end
function t1.setOnUpdateFinished(t25: {[any]: any}, p88: ((...any) -> ...any)) -- line: 2053
	t25.onUpdateFinished = p88
end
function t1.setDebugLoadAssetsFromFiles(t26: {[any]: any}, b5: boolean, p89) -- line: 2057
	t26.debugLoadAssetsFromFiles = b5
	t26.mapAssetIdToFileName = p89
end
function t1.getNextAnimationTrackName(t27: {[any]: any}, s4: string) -- line: 2065
	t27.animationTrackNameIndex = t27.animationTrackNameIndex + 1

	return "AnimationTrack_" .. s4 .. "_" .. tostring(t27.animationTrackNameIndex)
end
function t1.recordAnimationTrackProgress(t28: {[any]: any}, s5: string, s6: string) -- line: 2070
	if t28.animationTrackNameToHistory == nil then
		t28.animationTrackNameToHistory = {}
	end

	local v301 = t28.animationTrackNameToHistory[s5]

	if v301 == nil then
		v301 = {}
		t28.animationTrackNameToHistory[s5] = v301
	end

	table.insert(v301, s6)
end
function t1.getAnimationTrackRecordString(t29: {[any]: any}, s7: string) -- line: 2082
	local v304 = "Name = " .. s7
	local v305 = t29.animationTrackNameToHistory[s7]

	if v305 == nil then
		v305 = {}
	end

	for _, v307 in v305 do
		v304 ..= ", " .. v307
	end

	return v304
end

return t1
