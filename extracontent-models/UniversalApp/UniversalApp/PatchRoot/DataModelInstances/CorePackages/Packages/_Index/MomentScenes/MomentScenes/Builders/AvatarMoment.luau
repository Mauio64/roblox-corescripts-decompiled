require(script.Parent.Parent.Types)
local avatarFloorPosition = require(script.Parent._Utils.avatarFloorPosition)
local frameCamera = require(script.Parent._Utils.frameCamera)
local cameraPath = require(script.Parent._Utils.cameraPath)
local avatarBackground = require(script.Parent._Utils.avatarBackground)
local avatarRig = require(script.Parent._Utils.avatarRig)
local applyDefaultClothing = require(script.Parent._Utils.applyDefaultClothing)
local createPlayhead = require(script.Parent._Utils.createPlayhead)
local addKeyLight = require(script.addKeyLight)
local addFallbackBackdrop = require(script.addFallbackBackdrop)
local resolveOutfit = require(script.resolveOutfit)
local emotes = require(script.emotes)
local Flags = require(script.Flags)

local function resolveBackgroundAssetId(value: number?) -- 1 equivalent call inferred from this helper
	if typeof(value) == "number" and value > 0 then
		return value
	end

	return avatarBackground.DEFAULT_ASSET_ID
end

local function resolveEmoteId(p, rigType)
	if emotes.isName(p.emote) then
		return emotes.resolve(p.emote, rigType)
	end

	if p.emote ~= nil then
		warn(`AvatarMoment: unknown emote {p.emote}, falling through to emoteId or wave`)
	end

	if typeof(p.emoteId) ~= "number" or not (p.emoteId > 0) then
		return emotes.resolve("wave", rigType)
	end

	if rigType == Enum.HumanoidRigType.R6 then
		warn(`AvatarMoment: emoteId {p.emoteId} plays as authored on an R6 rig, and an R15 clip will not move it. The emote arg resolves per rig.`)
	end

	return p.emoteId
end

local function addBackdrop(live3DScene, backgroundAssetId: number?) -- 1 equivalent call inferred from this helper
	addKeyLight(live3DScene)
	backgroundAssetId = resolveBackgroundAssetId(backgroundAssetId) -- inferred equivalent call
	local v = avatarBackground.attach(live3DScene, backgroundAssetId)

	if v == nil then
		addFallbackBackdrop(live3DScene)
	end

	return v
end

local function positiveId(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) == "number" and value > 0 then
		return value
	end

	return nil
end

local function resolveSnapshot(p)
	local v = positiveId(p.outfitId) -- inferred equivalent call
	local v2 = positiveId(p.userId) -- inferred equivalent call

	if v ~= nil and v2 ~= nil then
		error("AvatarMoment: supply outfitId or userId, not both")
	end

	if v ~= nil then
		return resolveOutfit.resolve(v)
	end

	if v2 ~= nil then
		return resolveOutfit.resolveUser(v2)
	end

	error("AvatarMoment: outfitId or userId (positive number) is required")
end

local function buildAvatarMoment(options)
	local v = options or {}
	local v2

	if Flags.MomentScenesAvatarMomentUserId then
		v2 = resolveSnapshot(v)
	else
		if typeof(v.outfitId) ~= "number" or v.outfitId <= 0 then
			error("AvatarMoment: outfitId (positive number) is required")
		end

		v2 = resolveOutfit.resolve(v.outfitId)
	end

	local live3DScene = Instance.new("Model")
	live3DScene.Name = "Live3DScene"

	local v3 = addBackdrop(live3DScene, v.backgroundAssetId) -- inferred equivalent call

	live3DScene.WorldPivot = CFrame.new()

	if v3 ~= nil then
		avatarBackground.pinToParent(v3, live3DScene)
	end

	local humanoidDescription = v2.humanoidDescription

	if Flags.MomentScenesAvatarMomentDefaultClothing then
		humanoidDescription = applyDefaultClothing(humanoidDescription)
	end

	local avatar = avatarRig.createAvatar(humanoidDescription, v2.rigType)
	avatar.Name = "Avatar"
	local humanoid = avatar:FindFirstChildOfClass("Humanoid")

	if humanoid ~= nil then
		humanoid.NameOcclusion = Enum.NameOcclusion.OccludeAll
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.NameDisplayDistance = 0
	end

	avatarFloorPosition.positionOnFloor(avatar, 0, CFrame.new())
	avatar.Parent = live3DScene
	local v4

	if v2.gearAssetId == nil then
		v4 = nil
	else
		v4 = avatarRig.equipGear(avatar, v2.gearAssetId, v2.rigType)
	end

	local sceneCamera = Instance.new("Camera")
	sceneCamera.Name = "SceneCamera"
	sceneCamera.CameraType = Enum.CameraType.Scriptable
	sceneCamera.FieldOfView = 56
	sceneCamera.Parent = live3DScene

	local cameraPath2 = v.cameraPath or "subtle"
	local resolved = cameraPath.resolve(cameraPath2)
	local v5

	if cameraPath.framingFor(cameraPath2) == "face" then
		v5 = frameCamera.fitStandingFace
	else
		v5 = frameCamera.fitStandingCharacters
	end

	local _, v6, v7 = v5({ avatar }, sceneCamera.FieldOfView)
	sceneCamera.Focus = CFrame.new(v6)

	local emoteId = resolveEmoteId(v, v2.rigType)
	local v8 = avatarRig.playEmote(avatar, emoteId)

	local function duration() -- 2 equivalent calls inferred from this helper
		local v9 = v8 == nil and 0 or v8.Length

		if v9 <= 0 then
			return 0
		end

		return v9 * 4
	end

	local v9 = {
		root = live3DScene,
		tracks = v8 == nil and {} or { v8 },
		animator = 0,
		getDuration = 0,
		syncVisuals = 0,
		play = 0,
		dispose = 0
	}
	local animator

	if humanoid ~= nil then
		animator = humanoid:FindFirstChildOfClass("Animator")
	end

	v9.animator = animator
	v9.getDuration = duration
	function v9.syncVisuals(p: number)
		local v10 = duration() -- inferred equivalent call
		local v11 = not (v10 > 0) and 0 or p % v10 / v10
		sceneCamera.CFrame = cameraPath.eval(v6, v7, resolved, v11)
	end
	function v9.play(callback)
		if humanoid ~= nil then
			humanoid.AutoRotate = false
		end

		callback()
	end
	function v9.dispose(callback)
		if v4 ~= nil then
			v4:Stop(0)
			v4 = nil
		end

		callback()
	end

	local playhead = createPlayhead(v9)
	local v10 = duration() > 0 -- inferred equivalent call
	return {
		root = live3DScene,
		camera = sceneCamera,
		playhead = playhead,
		capabilities = { canUserToggle = v10, hasDuration = v10 },
		dispose = playhead.dispose
	}
end

return buildAvatarMoment
