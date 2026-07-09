local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local mutedError = require(Modules.LuaApp.mutedError)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local MockAnimationTrack = require(Modules.AvatarExperience.Common.MockAnimationTrack)
local MockAnimationStreamTrack = require(Modules.AvatarExperience.Common.MockAnimationStreamTrack)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Managers.AnimationManagerTypes)

local SelectIsTryingOnClassicOrDynamicHead = require(Modules.AvatarExperience.Common.Selectors.SelectIsTryingOnClassicOrDynamicHead)
local SelectOutfitTryOnEmoteAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnEmoteAnimationAssetId)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local isMakeupOrEyebrowEyelashAssetType = AvatarExperienceCommon.Utils.isMakeupOrEyebrowEyelashAssetType

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AssetTypeIdStrings = Constants.AssetTypeIdStrings
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local t1 = {
	DefaultAnimations = {
		R15 = {
			TOOL = 507768375,
			WAVE_EMOTE = 507770239
		},
		R6 = {
			CLIMB = 180436334,
			FALL = 180436148,
			IDLE = 180435571,
			IDLE_LOOK_AROUND = 180435792,
			JUMP = 125750702,
			RUN = 180426354,
			SIT = 178130996,
			TOOL_NONE = 182393478,
			WALK = 180426354,
			TOOL = 182393478
		}
	},
	loadAnimationModel = function(n1: number, b1: boolean, p1) -- line: 77
		-- upvalues: InsertService (copy)
		if not n1 then
			return nil
		end

		local u32 = nil
		local _, result = pcall(function() -- line: 87
			-- upvalues: b1 (copy), p1 (copy), n1 (copy), u32 (ref), InsertService (copy)
			if b1 and p1 then
				local v154 = "rbxasset://" .. p1(n1)

				u32 = InsertService:LoadLocalAsset(v154)

				return
			end

			local u155 = nil
			local BindableEvent = Instance.new("BindableEvent")

			task.spawn(function() -- line: 100
				-- upvalues: u32 (ref), InsertService (copy), n1 (copy), u155 (ref), BindableEvent (copy)
				local ok, result = pcall(function() -- line: 102
					-- upvalues: u32 (ref), InsertService (copy), n1 (copy)
					u32 = InsertService:LoadAsset(n1)
				end)

				if not ok then
					u155 = result
				end

				BindableEvent:Fire()
			end)
			BindableEvent.Event:Wait()

			if u155 then
				error(u155)
			end
		end)

		if result or not u32 then
			warn(result)

			return nil
		end

		return u32
	end,
	isSwimAnimation = function(p2) -- line: 125
		if p2.Parent and p2.Parent.Name == "swim" then
			return true
		end

		return false
	end,
	createStringValue = function(p3, p4) -- line: 133
		local StringValue = Instance.new("StringValue")

		StringValue.Parent = p3
		StringValue.Name = p4

		return StringValue
	end,
	createAnimation = function(p5, s1: string, n2: number) -- line: 140
		local Animation = Instance.new("Animation")

		Animation.Parent = p5
		Animation.AnimationId = "http://www.roblox.com/asset/?id=" .. n2
		Animation.Name = s1

		return Animation
	end
}

function t1.createR6AnimationFolder() -- line: 148
	-- upvalues: t1 (copy)
	local Folder = Instance.new("Folder")

	t1.createAnimation(t1.createStringValue(Folder, "climb"), "ClimbAnim", t1.DefaultAnimations.R6.CLIMB)
	t1.createAnimation(t1.createStringValue(Folder, "fall"), "FallAnim", t1.DefaultAnimations.R6.FALL)

	local v44 = t1.createStringValue(Folder, "idle")

	t1.createAnimation(v44, "Animation1", t1.DefaultAnimations.R6.IDLE)
	t1.createAnimation(v44, "Animation2", t1.DefaultAnimations.R6.IDLE_LOOK_AROUND)
	t1.createAnimation(t1.createStringValue(Folder, "jump"), "JumpAnim", t1.DefaultAnimations.R6.JUMP)
	t1.createAnimation(t1.createStringValue(Folder, "run"), "RunAnim", t1.DefaultAnimations.R6.RUN)
	t1.createAnimation(t1.createStringValue(Folder, "sit"), "SitAnim", t1.DefaultAnimations.R6.SIT)
	t1.createAnimation(t1.createStringValue(Folder, "toolnone"), "ToolNoneAnim", t1.DefaultAnimations.R6.TOOL_NONE)
	t1.createAnimation(t1.createStringValue(Folder, "walk"), "WalkAnim", t1.DefaultAnimations.R6.WALK)
	t1.createAnimation(Folder, "Tool", t1.DefaultAnimations.R6.TOOL)

	return Folder
end
function t1.convertToStringValues(t2: {[any]: any}, s2: string?) -- line: 172
	-- upvalues: mutedError (copy)
	for _, v48 in t2 do
		if v48.ClassName ~= "StringValue" then
			mutedError(`instance should be StringValue: { s2 }`)

			return {}
		end
	end

	return t2
end
function t1.convertToAnimations(t3: {[any]: any}) -- line: 184
	-- upvalues: mutedError (copy)
	for _, v51 in t3 do
		if v51.ClassName ~= "Animation" then
			mutedError("instance should be Animation.")

			return {}
		end
	end

	return t3
end
function t1.getLowestWeightAnimation(p6) -- line: 195
	local v53 = nil
	local n3 = 1e999

	for _, v in next, p6 do
		local Weight = v:FindFirstChild("Weight")
		local v58 = not Weight and 1 or Weight.Value

		if v58 < n3 then
			v53 = v
			n3 = v58
		end
	end

	return v53
end
function t1.getWeightedAnimations(t4: {[any]: any}, b2: boolean?) -- line: 210
	-- upvalues: t1 (copy)
	local t5 = {}
	local n4 = 0
	local v63 = nil

	if b2 then
		v63 = t1.getLowestWeightAnimation(t4)
	end

	for _, v in next, t4 do
		local Weight = v:FindFirstChild("Weight")
		local v67 = not Weight and 1 or Weight.Value

		if b2 and v == v63 then
			v67 = 0
		end

		if v67 > 0 then
			t5[v] = v67
			n4 += v67
		end
	end

	return t5, n4
end
function t1.getHumanoidFromCharacter(p7) -- line: 238
	if p7 then
		return p7:FindFirstChildOfClass("Humanoid")
	end

	return nil
end
function t1.getAnimatorFromCharacter(p8) -- line: 245
	-- upvalues: t1 (copy)
	local v70 = t1.getHumanoidFromCharacter(p8)

	if v70 then
		return v70:FindFirstChildOfClass("Animator")
	end

	return nil
end
function t1.animationTrackWithConnectionsIsPlaying(p9) -- line: 253
	if not p9 then
		return false
	end

	assert(p9, "animationTrackWithId should be non-nil. Silence type checker.")

	if not p9.animationTrack then
		return false
	end

	assert(p9.animationTrack, "animationTrackWithId.animationTrack should be non-nil. Silence type checker.")

	return p9.animationTrack.IsPlaying
end
function t1.animationTrackWithConnectionsIsPlayingThisAssetId(p10, s3: string) -- line: 271
	-- upvalues: t1 (copy)
	if p10 and (s3 == p10.assetId and t1.animationTrackWithConnectionsIsPlaying(p10)) then
		return true
	end

	return false
end
function t1.getRandomAnimation(p11, n5: number) -- line: 285
	local v76 = math.random() * n5

	for k, v in next, p11 do
		if v76 <= v then
			return k
		end

		v76 -= v
	end

	return nil
end
function t1.animatorLoadAnimationTrack(p12, p13, b3: boolean) -- line: 302
	-- upvalues: t1 (copy), MockAnimationTrack (copy)
	local v82 = t1.getAnimatorFromCharacter(p12)

	if v82 then
		if b3 then
			return (MockAnimationTrack.new())
		end

		return v82:LoadAnimation(p13)
	end

	return nil
end
function t1.animatorLoadTrackerStreamAnimationTrack(p14, p15, b4: boolean) -- line: 322
	-- upvalues: t1 (copy), MockAnimationStreamTrack (copy), Players (copy)
	local v86 = t1.getAnimatorFromCharacter(p14)

	if v86 then
		if b4 then
			return (MockAnimationStreamTrack.new())
		end

		assert(Players, "assert Players cannot be nil. Silences type checker")
		assert(Players.LocalPlayer, "assert LocalPlayer is not nil. Silences type checker")

		if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
			return v86:LoadStreamAnimationV2(p15, Players.LocalPlayer, false, false)
		end

		return v86:LoadStreamAnimationForSelfieView_deprecated(p15, Players.LocalPlayer)
	end

	return nil
end
function t1.loadAnimStringValuesFromString(s4: string, b5: boolean, p16) -- line: 352
	-- upvalues: t1 (copy)
	local num = tonumber(s4)

	if not num then
		return nil
	end

	assert(num, "assetIdAsNumber is not nil. Silences type checker")

	local v91 = t1.loadAnimationModel(num, b5, p16)

	if not v91 then
		return nil
	end

	assert(v91, "animationModel is not nil. Silence type checker.")

	local R15Anim = v91:FindFirstChild("R15Anim")

	if R15Anim then
		return t1.convertToStringValues(R15Anim:GetChildren(), s4)
	end

	local t6 = {}

	for _, child in v91:GetChildren() do
		if child:IsA("Animation") then
			local StringValue = Instance.new("StringValue")

			StringValue.Name = child.Name
			child.Parent = StringValue
			t6[#t6 + 1] = StringValue
		end
	end

	if #t6 > 0 then
		return t6
	end

	return nil
end

t1.getAssetTypeIdStringForCategory = memoize(function(p17) -- line: 396
	if p17 and (p17.AssetTypeIdStrings and #p17.AssetTypeIdStrings == 1) then
		return p17.AssetTypeIdStrings[1]
	end

	return nil
end)
t1.hasMissingIds = memoize(function(p18, p19) -- line: 408
	if p18 == nil or not next(p18) then
		return false
	end

	for v100, _ in p18 do
		if not p19[v100] then
			return true
		end
	end

	return false
end)
t1.getEquippedAssetsSummary = memoize(function(p20) -- line: 429
	-- upvalues: Utils (copy), FFlagAXMakeupEquipping (copy), isMakeupOrEyebrowEyelashAssetType (copy)
	local t7 = {}

	if p20 then
		for v104, v105 in p20 do
			if not Utils.assetTypeIdIsAnimationOrEmote(v104) and (not FFlagAXMakeupEquipping or not isMakeupOrEyebrowEyelashAssetType(v104)) then
				local t8 = {}

				for v107, _ in v105 do
					t8[v107] = true
				end

				t7[v104] = t8
			end
		end
	end

	return t7
end)
t1.getEquippedAssetSummariesMatch = memoize(function(p21, p22) -- line: 455
	-- upvalues: tutils (copy)
	return tutils.deepEqual(p21, p22)
end)
t1.getOutfitTryOnSummary = memoize(function(p23) -- line: 467
	-- upvalues: Constants (copy), Utils (copy), FFlagAXMakeupEquipping (copy), isMakeupOrEyebrowEyelashAssetType (copy)
	local t9 = {}

	if p23 and p23.TryOnItems then
		for v113, v114 in p23.TryOnItems do
			if (v114.itemType ~= Constants.ItemType.Bundle or v114.itemSubType ~= Constants.BundleTypeIdStrings.Animations) and (v114.itemType ~= Constants.ItemType.Asset or not Utils.assetTypeIdIsAnimationOrEmote(v114.itemSubType)) and (not FFlagAXMakeupEquipping or v114.itemType ~= Constants.ItemType.Asset or not isMakeupOrEyebrowEyelashAssetType(v114.itemSubType)) then
				t9[v113] = {
					itemType = v114.itemType,
					itemSubType = v114.itemSubType
				}
			end
		end
	end

	return t9
end)
t1.getOutfitTryOnSummariesMatch = memoize(function(p24, p25) -- line: 509
	-- upvalues: tutils (copy)
	return tutils.deepEqual(p24, p25)
end)
t1.getEquippedAssetsSummaryHasNewItems = memoize(function(p26, p27) -- line: 519
	-- upvalues: t1 (copy)
	for v119, v120 in p26 do
		local t10 = {}

		if p27[v119] then
			t10 = p27[v119]
		end

		if t1.hasMissingIds(v120, t10) then
			return true
		end
	end

	return false
end)

function t1.getOutfitTryOnSummaryHasNewItems(p28, p29) -- line: 542
	for v124, _ in p28 do
		if not p29[v124] then
			return true
		end
	end

	return false
end
function t1.cleanupAnimationTrackWithConnections(p30) -- line: 554
	if not p30 then
		return
	end

	assert(p30, "Assert animationTrackWithConnections is not nil, silence type checker")

	if p30.stoppedConnection then
		p30.stoppedConnection:Disconnect()
		p30.stoppedConnection = nil
	end

	if p30.endedConnection then
		p30.endedConnection:Disconnect()
		p30.endedConnection = nil
	end

	if p30.didLoopConnection then
		p30.didLoopConnection:Disconnect()
		p30.didLoopConnection = nil
	end

	if p30.animationTrack then
		p30.animationTrack:Stop()
		p30.animationTrack:Destroy()
		p30.animationTrack = nil
	end
end
function t1.getDidMoveOutOfPPE(b6: boolean, b7: boolean, b8: boolean) -- line: 582
	if b6 then
		if not b7 then
			return true
		end

		if not b8 then
			return true
		end
	end

	return false
end
function t1.getEquippedIdleAnimation(p31) -- line: 598
	-- upvalues: AssetTypeIdStrings (copy)
	local EquippedAssets = p31.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v132 = EquippedAssets and EquippedAssets[AssetTypeIdStrings.IdleAnimation]

	return v132 and next(v132) or nil
end
function t1.ableToAnimateHead(p32) -- line: 611
	-- upvalues: SelectIsTryingOnClassicOrDynamicHead (copy), Constants (copy), Cryo (copy)
	local v134, v135, v136 = SelectIsTryingOnClassicOrDynamicHead(p32)

	if v134 then
		return false, v136
	end

	if p32.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6 then
		return false, v136
	end

	if v135 then
		return true, v136
	end

	local EquippedAssets = p32.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v138 = EquippedAssets and EquippedAssets[Constants.AssetTypeIdStrings.DynamicHead]

	return v138 ~= nil and not Cryo.isEmpty(v138), v136
end
function t1.adjustATWCWeight(p33, n6: number) -- line: 634
	if p33.animationTrack then
		assert(p33.animationTrack, "assert animationTrackWithConnections.animationTrack is not nil. Silences Type checker")
		p33.animationTrack:AdjustWeight(n6)
	end
end
function t1.getAllowsTryingEmotesOrAnimations(p34, p35) -- line: 651
	-- upvalues: Utils2 (copy), Constants (copy), AvatarScreen (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogCategories (copy), GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXPhotoboothFunctionality (copy)
	local name = p35.opaque.name
	local v144 = Utils2.getCategoryInfoFromState(p34, p35)

	if v144.PageType == Constants.PageType.AllAnimation or (name == AvatarScreen.CatalogSearch or name == AvatarScreen.TryOnItem or (if not FFlagAXRemoveCatalogCategoryNavKey then v144.NavigationKey == CatalogCategories.Recommended else v144.Id == Constants.DefaultCatalogCategoryId)) or GetFFlagAXEnableSlotBasedEditor() and name == AvatarScreen.EditEmotes or FFlagAXPhotoboothFunctionality and name == AvatarScreen.Photobooth then
		return true, true
	end

	return v144.PageType == Constants.PageType.Emotes, v144.PageType == Constants.PageType.Animation
end
function t1.canPlayCameraBasedMoodAnimation(p36, b9: boolean, b10: boolean) -- line: 694
	-- upvalues: SelectOutfitTryOnEmoteAnimationAssetId (copy), t1 (copy)
	if not b9 then
		return false, true
	end

	local v148 = SelectOutfitTryOnEmoteAnimationAssetId(p36)
	local LastAnimOrEmoteToggledItem = p36.AvatarExperience.AvatarScene.OutfitTryOn.LastAnimOrEmoteToggledItem
	local v150 = not not LastAnimOrEmoteToggledItem and v148 == LastAnimOrEmoteToggledItem.itemId
	local v151, v152 = t1.ableToAnimateHead(p36)

	return v151 and not (v150 and b10), v152
end
function t1.waitForAnimationAndPosingToResolve(p37: ((...any) -> ...any)) -- line: 716
	-- upvalues: RunService (copy)
	task.spawn(function() -- line: 717
		-- upvalues: RunService (copy), p37 (copy)
		RunService.PreAnimation:Wait()
		RunService.PostSimulation:Wait()
		p37()
	end)
end

return t1
