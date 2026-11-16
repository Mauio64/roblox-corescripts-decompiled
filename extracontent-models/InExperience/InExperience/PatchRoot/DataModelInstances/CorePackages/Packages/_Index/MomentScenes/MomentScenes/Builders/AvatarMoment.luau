require(script.Parent.Parent.Types)
local avatarFloorPosition = require(script.Parent._Utils.avatarFloorPosition)
local frameCamera = require(script.Parent._Utils.frameCamera)
local cameraPath = require(script.Parent._Utils.cameraPath)
local avatarBackground = require(script.Parent._Utils.avatarBackground)
local avatarRig = require(script.Parent._Utils.avatarRig)
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

	local avatar = avatarRig.createAvatar(v2.humanoidDescription, v2.rigType)
	avatar.Name = "Avatar"
	local humanoid = avatar:FindFirstChildOfClass("Humanoid")

	if humanoid ~= nil then
		humanoid.NameOcclusion = Enum.NameOcclusion.OccludeAll
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.NameDisplayDistance = 0
	end

	avatarFloorPosition.positionOnFloor(avatar, 0, CFrame.new())
	avatar.Parent = live3DScene

	local sceneCamera = Instance.new("Camera")
	sceneCamera.Name = "SceneCamera"
	sceneCamera.CameraType = Enum.CameraType.Scriptable
	sceneCamera.FieldOfView = 56
	sceneCamera.Parent = live3DScene

	local cameraPath2 = v.cameraPath or "subtle"
	local resolved = cameraPath.resolve(cameraPath2)
	local v4

	if cameraPath.framingFor(cameraPath2) == "face" then
		v4 = frameCamera.fitStandingFace
	else
		v4 = frameCamera.fitStandingCharacters
	end

	local _, v5, v6 = v4({ avatar }, sceneCamera.FieldOfView)
	sceneCamera.Focus = CFrame.new(v5)

	local emoteId = resolveEmoteId(v, v2.rigType)
	local v7 = avatarRig.playEmote(avatar, emoteId)
	local tracks = v7 == nil and {} or { v7 }

	local function duration() -- 2 equivalent calls inferred from this helper
		local v8 = 0

		for _, v9 in tracks do
			if v8 < v9.Length then
				v8 = v9.Length
			end
		end

		if v8 <= 0 then
			return 0
		end

		return v8 * 4
	end

	local v8 = {
		root = live3DScene,
		tracks = tracks,
		animator = 0,
		getDuration = 0,
		syncVisuals = 0,
		play = 0
	}
	local animator

	if humanoid ~= nil then
		animator = humanoid:FindFirstChildOfClass("Animator")
	end

	v8.animator = animator
	v8.getDuration = duration
	function v8.syncVisuals(p: number)
		local v9 = duration() -- inferred equivalent call
		local v10 = not (v9 > 0) and 0 or p % v9 / v9
		sceneCamera.CFrame = cameraPath.eval(v5, v6, resolved, v10)
	end
	function v8.play(callback)
		if humanoid ~= nil then
			humanoid.AutoRotate = false
		end

		callback()
	end

	local playhead = createPlayhead(v8)
	local v9 = duration() > 0 -- inferred equivalent call
	return {
		root = live3DScene,
		camera = sceneCamera,
		playhead = playhead,
		capabilities = { canUserToggle = v9, hasDuration = v9 },
		dispose = playhead.dispose
	}
end

return buildAvatarMoment
