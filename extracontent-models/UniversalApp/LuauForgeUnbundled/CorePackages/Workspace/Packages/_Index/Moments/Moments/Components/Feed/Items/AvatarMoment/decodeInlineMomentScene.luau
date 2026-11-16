require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local decodeMomentSceneProto = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/decodeMomentSceneProto")

local function defaultDeserializeInstancesAsync(p2)
	local SerializationService = game:GetService("SerializationService")
	return SerializationService:DeserializeInstancesAsync(p2)
end

local function defaultBase64Decode(p2)
	local EncodingService = game:GetService("EncodingService")
	return EncodingService:Base64Decode(p2)
end

local function defaultDecodeMomentScene(p2)
	return decodeMomentSceneProto(p2)
end

local function defaultDestroyInstance(instance)
	instance:Destroy()
end

local function destroyRoots(items, destroyInstance)
	for k, item in items do
		pcall(function()
			destroyInstance(item)
		end)
	end
end

local function findRecipeValue(items)
	for k, momentScene in items do
		if momentScene.Name ~= "MomentScene" then
			momentScene = momentScene:FindFirstChild("MomentScene", true)
		end

		if momentScene == nil then
			continue
		end

		local momentSceneData = momentScene:FindFirstChild("MomentSceneData")

		if momentSceneData ~= nil and momentSceneData:IsA("StringValue") then
			return momentSceneData
		end
	end

	return nil
end

local function optionalPositiveNumber(value)
	if typeof(value) == "number" and value > 0 then
		return value
	end

	return nil
end

local function parseMomentScenesAsset(items, p2)
	local parseSceneAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentScenes").parseSceneAsset

	for k, item in items do
		local v5 = parseSceneAsset(item)

		if v5.type ~= nil or next(v5.args) ~= nil then
			local kind = v5.type or "AvatarMoment"

			if kind ~= "AvatarMoment" then
				error(`Inline MomentScene type {kind} is not AvatarMoment`)
			end

			local outfitId = v5.args.outfitId

			if typeof(outfitId) ~= "number" or not (outfitId > 0) then
				outfitId = nil
			end

			if outfitId == nil then
				error("Inline MomentScene has no valid outfit id")
			end

			if outfitId ~= p2 then
				error(`MomentScene outfit {outfitId} does not match Post annotation {p2}`)
			end

			return { type = "AvatarMoment", args = v5.args }
		end
	end

	error("Inline MomentScene RBXM has neither MomentScene/MomentSceneData nor a MomentScenes Type/Args folder")
end

local function optionalUtf8String(emote_name)
	local v5

	if typeof(emote_name) == "buffer" then
		v5 = buffer.tostring(emote_name)
	else
		v5 = typeof(emote_name) ~= "string" and "" or emote_name
	end

	if v5 == "" then
		return nil
	end

	if utf8.len(v5) == nil then
		error("MomentScene emote_name is not valid UTF-8")
	end

	return v5
end

local function decodeInlineMomentScene(buf, p2, options)
	if buffer.len(buf) == 0 then
		error("Inline MomentScene RBXM is empty")
	end

	if p2 <= 0 then
		error("Avatar annotation has no valid outfit id")
	end

	local v5 = options or {}

	local deserializeInstancesAsync = v5.deserializeInstancesAsync or defaultDeserializeInstancesAsync

	local base64Decode = v5.base64Decode or defaultBase64Decode
	local decodeMomentScene = v5.decodeMomentScene or defaultDecodeMomentScene
	local destroyInstance = v5.destroyInstance or defaultDestroyInstance
	local v6 = {}

	local success, result = pcall(function()
		v6 = deserializeInstancesAsync(buf)
		local recipeValue = findRecipeValue(v6)

		if recipeValue == nil then
			return parseMomentScenesAsset(v6, p2)
		end

		local value = recipeValue.Value

		if value == "" then
			error("MomentSceneData is empty")
		end

		local v8 = decodeMomentScene((base64Decode(buffer.fromstring(value))))
		local outfit_id = v8.outfit_id

		if typeof(outfit_id) ~= "number" or not (outfit_id > 0) then
			outfit_id = nil
		end

		if outfit_id == nil then
			error("MomentScene recipe has no valid outfit id")
		end

		if outfit_id ~= p2 then
			error(`MomentScene outfit {outfit_id} does not match Post annotation {p2}`)
		end

		local emote_asset_id = v8.emote_asset_id

		if typeof(emote_asset_id) ~= "number" or not (emote_asset_id > 0) then
			emote_asset_id = nil
		end

		local background_asset_id = v8.background_asset_id

		if typeof(background_asset_id) ~= "number" or not (background_asset_id > 0) then
			background_asset_id = nil
		end

		return {
			type = "AvatarMoment",
			args = {
				outfitId = outfit_id,
				emoteId = emote_asset_id,
				backgroundAssetId = background_asset_id,
				emote = optionalUtf8String(v8.emote_name)
			}
		}
	end)

	destroyRoots(v6, destroyInstance)

	if not success then
		error(result)
	end

	return result
end

return decodeInlineMomentScene
