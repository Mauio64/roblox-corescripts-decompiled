local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
require("@luauforge/bundled/dHL")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local module2 = require("@luauforge/bundled/fuD")
local module3 = require("@luauforge/bundled/dCn")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module4 = require("@luauforge/bundled/gqr")
local module5 = require("@luauforge/bundled/gqs")
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/gqt")

local module6 = require("@luauforge/bundled/gqu")

local module7 = require("@luauforge/bundled/gqv")
local module8 = require("@luauforge/bundled/dMx")
local module9 = require("@luauforge/bundled/fuD")
local isMakeupOrEyebrowEyelashAssetType = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.isMakeupOrEyebrowEyelashAssetType
require("@luauforge/bundled/dHK")

local assetTypeIdStrings = module8.AssetTypeIdStrings

local fFlagAXPhotoboothMomentsPage = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsPage
local module10 = require("@luauforge/bundled/dOc")

local v5 = {}

v5.DefaultAnimations = {
	R15 = { TOOL = 507768375, WAVE_EMOTE = 507770239 },
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
}

function v5.loadAnimationModel(p2, p3, callback)
	if not p2 then
		return nil
	end

	local v6 = nil
	local success, result = pcall(function()
		if p3 and callback then
			v6 = InsertService:LoadLocalAsset("rbxasset://" .. callback(p2))
		else
			local v7 = nil
			local bindableEvent = Instance.new("BindableEvent")

			task.spawn(function()
				local success2, result2 = pcall(function()
					v6 = InsertService:LoadAsset(p2)
				end)

				if not success2 then
					v7 = result2
				end

				bindableEvent:Fire()
			end)

			bindableEvent.Event:Wait()

			if v7 then
				error(v7)
			end
		end
	end)

	if result or not v6 then
		warn(result)
		return nil
	end

	return v6
end

function v5.isSwimAnimation(p2): boolean
	if p2.Parent and p2.Parent.Name == "swim" then
		return true
	end

	return false
end

function v5.createStringValue(parent, name)
	local stringValue = Instance.new("StringValue")
	stringValue.Parent = parent
	stringValue.Name = name
	return stringValue
end

function v5.createAnimation(parent, name, p2)
	local animation = Instance.new("Animation")
	animation.Parent = parent
	animation.AnimationId = "http://www.roblox.com/asset/?id=" .. p2
	animation.Name = name
	return animation
end

function v5.createR6AnimationFolder()
	local folder = Instance.new("Folder")
	v5.createAnimation(v5.createStringValue(folder, "climb"), "ClimbAnim", v5.DefaultAnimations.R6.CLIMB)
	v5.createAnimation(v5.createStringValue(folder, "fall"), "FallAnim", v5.DefaultAnimations.R6.FALL)

	local stringValue = v5.createStringValue(folder, "idle")
	v5.createAnimation(stringValue, "Animation1", v5.DefaultAnimations.R6.IDLE)
	v5.createAnimation(stringValue, "Animation2", v5.DefaultAnimations.R6.IDLE_LOOK_AROUND)

	v5.createAnimation(v5.createStringValue(folder, "jump"), "JumpAnim", v5.DefaultAnimations.R6.JUMP)
	v5.createAnimation(v5.createStringValue(folder, "run"), "RunAnim", v5.DefaultAnimations.R6.RUN)
	v5.createAnimation(v5.createStringValue(folder, "sit"), "SitAnim", v5.DefaultAnimations.R6.SIT)
	v5.createAnimation(
		v5.createStringValue(folder, "toolnone"),
		"ToolNoneAnim",
		v5.DefaultAnimations.R6.TOOL_NONE
	)

	v5.createAnimation(v5.createStringValue(folder, "walk"), "WalkAnim", v5.DefaultAnimations.R6.WALK)
	v5.createAnimation(folder, "Tool", v5.DefaultAnimations.R6.TOOL)
	return folder
end

function v5.convertToStringValues(items, p2)
	for k, item in items do
		if item.ClassName ~= "StringValue" then
			module3(`instance should be StringValue: {p2}`)
			return {}
		end
	end

	return items
end

function v5.convertToAnimations(items)
	for k, item in items do
		if item.ClassName ~= "Animation" then
			module3("instance should be Animation.")
			return {}
		end
	end

	return items
end

function v5.getLowestWeightAnimation(items)
	local v6 = 1e999
	local v7 = nil

	for k, item in next, items do
		local weight = item:FindFirstChild("Weight")
		local v8 = not weight and 1 or weight.Value

		if not (v8 < v6) then
			continue
		end

		v7 = item
		v6 = v8
	end

	return v7
end

function v5.getWeightedAnimations(items, p2)
	local result = {}
	local total = 0

	local v6 = if p2 then v5.getLowestWeightAnimation(items) else nil

	for k, item in next, items do
		local weight = item:FindFirstChild("Weight")
		local v7 = not weight and 1 or weight.Value
		local v8 = p2 and item == v6 and 0 or v7

		if not (v8 > 0) then
			continue
		end

		result[item] = v8
		total += v8
	end

	return result, total
end

function v5.getHumanoidFromCharacter(instance)
	if instance then
		return instance:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

function v5.getAnimatorFromCharacter(p2)
	local humanoidFromCharacter = v5.getHumanoidFromCharacter(p2)

	if humanoidFromCharacter then
		return humanoidFromCharacter:FindFirstChildOfClass("Animator")
	end

	return nil
end

function v5.animationTrackWithConnectionsIsPlaying(p2)
	if not p2 then
		return false
	end

	assert(p2, "animationTrackWithId should be non-nil. Silence type checker.")

	if not p2.animationTrack then
		return false
	end

	assert(
		p2.animationTrack,
		"animationTrackWithId.animationTrack should be non-nil. Silence type checker."
	)

	return p2.animationTrack.IsPlaying
end

function v5.animationTrackWithConnectionsIsPlayingThisAssetId(p2, p3): boolean
	if p2 and p2.assetId == p3 and v5.animationTrackWithConnectionsIsPlaying(p2) then
		return true
	end

	return false
end

function v5.getRandomAnimation(items, p2)
	local v6 = math.random() * p2

	for k, item in next, items do
		if v6 <= item then
			return k
		end

		v6 -= item
	end

	return nil
end

function v5.animatorLoadAnimationTrack(p2, animation, p3)
	local animatorFromCharacter = v5.getAnimatorFromCharacter(p2)

	if not animatorFromCharacter then
		return nil
	end

	if p3 then
		return (module4.new())
	end

	return animatorFromCharacter:LoadAnimation(animation)
end

function v5.animatorLoadTrackerStreamAnimationTrack(p2, p3, p4)
	local animatorFromCharacter = v5.getAnimatorFromCharacter(p2)

	if not animatorFromCharacter then
		return nil
	end

	if p4 then
		return (module5.new())
	end

	assert(Players, "assert Players cannot be nil. Silences type checker")
	assert(Players.LocalPlayer, "assert LocalPlayer is not nil. Silences type checker")

	if game:GetEngineFeature("UseNewLoadStreamAnimationAPI") then
		return animatorFromCharacter:LoadStreamAnimationV2(p3, Players.LocalPlayer, false, false)
	end

	return animatorFromCharacter:LoadStreamAnimationForSelfieView_deprecated(p3, Players.LocalPlayer)
end

function v5.loadAnimStringValuesFromString(p2, p3, p4)
	local v6 = tonumber(p2)

	if not v6 then
		return nil
	end

	assert(v6, "assetIdAsNumber is not nil. Silences type checker")

	local animationModel = v5.loadAnimationModel(v6, p3, p4)

	if not animationModel then
		return nil
	end

	assert(animationModel, "animationModel is not nil. Silence type checker.")

	local r15Anim = animationModel:FindFirstChild("R15Anim")

	if r15Anim then
		return v5.convertToStringValues(r15Anim:GetChildren(), p2)
	end

	local result = {}

	for i, animation in animationModel:GetChildren() do
		if not animation:IsA("Animation") then
			continue
		end

		local stringValue = Instance.new("StringValue")
		stringValue.Name = animation.Name
		animation.Parent = stringValue

		result[#result + 1] = stringValue
	end

	if #result > 0 then
		return result
	end

	return nil
end

v5.getAssetTypeIdStringForCategory = memoize(function(p2)
	if p2 and p2.AssetTypeIdStrings and #p2.AssetTypeIdStrings == 1 then
		return p2.AssetTypeIdStrings[1]
	end

	return nil
end)

v5.hasMissingIds = memoize(function(items, p2): boolean
	if items == nil or not next(items) then
		return false
	end

	for k, item in items do
		if not p2[k] then
			return true
		end
	end

	return false
end)

v5.getEquippedAssetsSummary = memoize(function(items)
	local result = {}

	if not items then
		return result
	end

	for k, item in items do
		if module2.assetTypeIdIsAnimationOrEmote(k) or isMakeupOrEyebrowEyelashAssetType(k) then
			continue
		end

		local set = {}

		for k2, v6 in item do
			set[k2] = true
		end

		result[k] = set
	end

	return result
end)

v5.getEquippedAssetSummariesMatch = memoize(function(p2, p3)
	return tutils.deepEqual(p2, p3)
end)

v5.getOutfitTryOnSummary = memoize(function(p2)
	local result = {}

	if p2 and p2.TryOnItems then
		for k, tryOnItem in p2.TryOnItems do
			if not ((tryOnItem.itemType ~= module8.ItemType.Bundle or tryOnItem.itemSubType ~= module8.BundleTypeIdStrings.Animations) and (tryOnItem.itemType ~= module8.ItemType.Asset or not module2.assetTypeIdIsAnimationOrEmote(tryOnItem.itemSubType))) then
				continue
			end

			if not (tryOnItem.itemType ~= module8.ItemType.Asset or not isMakeupOrEyebrowEyelashAssetType(tryOnItem.itemSubType)) then
				continue
			end

			result[k] = {
				itemType = tryOnItem.itemType,
				itemSubType = tryOnItem.itemSubType
			}
		end
	end

	return result
end)

v5.getOutfitTryOnSummariesMatch = memoize(function(p2, p3)
	return tutils.deepEqual(p2, p3)
end)

v5.getEquippedAssetsSummaryHasNewItems = memoize(function(items, p2): boolean
	for k, item in items do
		local v6 = not p2[k] and {} or p2[k]

		if v5.hasMissingIds(item, v6) then
			return true
		end
	end

	return false
end)

function v5.getOutfitTryOnSummaryHasNewItems(items, p2): boolean
	for k, item in items do
		if not p2[k] then
			return true
		end
	end

	return false
end

function v5:cleanupAnimationTrackWithConnections()
	if not self then
		return
	end

	assert(self, "Assert animationTrackWithConnections is not nil, silence type checker")

	if self.stoppedConnection then
		self.stoppedConnection:Disconnect()
		self.stoppedConnection = nil
	end

	if self.endedConnection then
		self.endedConnection:Disconnect()
		self.endedConnection = nil
	end

	if self.didLoopConnection then
		self.didLoopConnection:Disconnect()
		self.didLoopConnection = nil
	end

	if self.animationTrack then
		self.animationTrack:Stop()
		self.animationTrack:Destroy()
		self.animationTrack = nil
	end
end

function v5.getDidMoveOutOfPPE(p2, p3, p4): boolean
	if not p2 then
		return false
	end

	if not (p3 and p4) then
		return true
	end

	return false
end

function v5.getEquippedIdleAnimation(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v6 = equippedAssets and equippedAssets[assetTypeIdStrings.IdleAnimation]
	return v6 and next(v6) or nil
end

function v5.ableToAnimateHead(p2)
	local v6, v7, v8 = module6(p2)

	if v6 or p2.AvatarExperience.AvatarEditor.Character.AvatarType == module8.AvatarType.R6 then
		return false, v8
	end

	if v7 then
		return true, v8
	end

	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v9 = equippedAssets and equippedAssets[module8.AssetTypeIdStrings.DynamicHead]
	return v9 ~= nil and not Cryo.isEmpty(v9), v8
end

function v5.adjustATWCWeight(p2, p3)
	if p2.animationTrack then
		assert(
			p2.animationTrack,
			"assert animationTrackWithConnections.animationTrack is not nil. Silences Type checker"
		)

		p2.animationTrack:AdjustWeight(p3)
	end
end

function v5.getAllowsTryingEmotesOrAnimations(p2, p3): (boolean, boolean)
	local name = p3.opaque.name
	local categoryInfoFromState = module9.getCategoryInfoFromState(p2, p3)

	if
		categoryInfoFromState.PageType == module8.PageType.AllAnimation
		or name == avatarScreen.CatalogSearch
		or name == avatarScreen.TryOnItem
		or categoryInfoFromState.Id == module8.DefaultCatalogCategoryId
		or module10() and name == avatarScreen.EditEmotes
		or fFlagAXPhotoboothMomentsPage and name == avatarScreen.PhotoboothMomentsPage
	then
		return true, true
	end

	return
		categoryInfoFromState.PageType == module8.PageType.Emotes,
		categoryInfoFromState.PageType == module8.PageType.Animation
end

function v5.canPlayCameraBasedMoodAnimation(p2, p3, p4)
	if not p3 then
		return false, true
	end

	local v6 = module7(p2)
	local lastAnimOrEmoteToggledItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastAnimOrEmoteToggledItem
	local v7 = if lastAnimOrEmoteToggledItem then lastAnimOrEmoteToggledItem.itemId == v6 else false
	local ableToAnimateHead, v8 = v5.ableToAnimateHead(p2)

	return ableToAnimateHead and not (v7 and p4), v8
end

function v5.waitForAnimationAndPosingToResolve(callback)
	task.spawn(function()
		RunService.PreAnimation:Wait()
		RunService.PostSimulation:Wait()
		callback()
	end)
end

return v5
