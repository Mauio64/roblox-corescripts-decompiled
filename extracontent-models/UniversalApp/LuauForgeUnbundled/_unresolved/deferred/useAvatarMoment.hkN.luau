local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module2 = require("@luauforge/deferred/gTO")
local getPhotoboothMomentsStore = module2.Stores.GetPhotoboothMomentsStore
local r6WaveEmoteId = module2.Constants.R6WaveEmoteId
local r15WaveEmoteId = module2.Constants.R15WaveEmoteId
local defaultBackgroundAssetId = module2.Constants.DefaultBackgroundAssetId
local buildAvatarMomentLookRequest = module2.Utils.buildAvatarMomentLookRequest

local useStore = RoactUtils.Hooks.RoactRodux.useStore

local function resolveSceneEmote(p2)
	if p2 == r6WaveEmoteId then
		return nil, "wave"
	end

	return tonumber(p2) or tonumber(r15WaveEmoteId), nil
end

local function useAvatarMoment()
	local v5 = useStore()
	local photoboothMomentsStore = getPhotoboothMomentsStore(false)

	local v6 = useSignalState(photoboothMomentsStore.getActiveOutfitId)
	local v7 = useSignalState(photoboothMomentsStore.getActiveEmoteId)
	local v8 = useSignalState(photoboothMomentsStore.getActiveBackgroundId)

	local v9 = React.useCallback(function()
		local avatarEditor = v5:getState().AvatarExperience.AvatarEditor
		local activeOutfitId = photoboothMomentsStore.getActiveOutfitId(false)
		local v10 = if activeOutfitId ~= "" then avatarEditor.OutfitInfos[activeOutfitId] else nil
		local character = avatarEditor.Character

		local v13 = if v10 then v10.assets else character.EquippedAssets
		local v14 = if v10 then v10.bodyColor3s else character.BodyColor3s
		local v15 = if v10 then v10.scales else character.AvatarScales
		local v16 = if v10 then v10.avatarType else character.AvatarType
		return buildAvatarMomentLookRequest({
			assets = v13,
			bodyColor3s = v14,
			scales = v15,
			avatarType = v16,
			emoteAssetId = photoboothMomentsStore.getActiveEmoteId(false),
			backgroundAssetId = photoboothMomentsStore.getActiveBackgroundId(false)
		})
	end, { v5, photoboothMomentsStore })

	return React.useMemo(function()
		local v10 = tonumber(v6)
		local v11 = v7
		local v12, v13

		if v11 == r6WaveEmoteId then
			v13 = "wave"
		else
			v12 = tonumber(v11) or tonumber(r15WaveEmoteId)
		end

		local v14 = tonumber(v8) or tonumber(defaultBackgroundAssetId)
		local v15 = {
			MomentType = "Avatar",
			AvatarPost = { cameraData = "", getLookRequest = v9 },
			SceneSpec = 0
		}

		local v18 = if v10 == nil and Players.LocalPlayer then Players.LocalPlayer.UserId else nil
		v15.SceneSpec = {
			type = "AvatarMoment",
			args = {
				outfitId = v10,
				userId = v18,
				emoteId = v12,
				emote = v13,
				backgroundAssetId = v14
			}
		}
		return v15
	end, { v6, v7, v8, v9 })
end

return useAvatarMoment
