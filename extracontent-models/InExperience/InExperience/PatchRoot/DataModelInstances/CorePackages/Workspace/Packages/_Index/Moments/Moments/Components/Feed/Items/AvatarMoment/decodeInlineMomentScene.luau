local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(Moments.Components.Feed.FeedTypes)
local decodeMomentSceneProto = require(script.Parent.decodeMomentSceneProto)

local function defaultDeserializeInstancesAsync(buf: buffer)
	local SerializationService = game:GetService("SerializationService")
	return SerializationService:DeserializeInstancesAsync(buf)
end

local function defaultBase64Decode(buf: buffer)
	local EncodingService = game:GetService("EncodingService")
	return EncodingService:Base64Decode(buf)
end

local function defaultDecodeMomentScene(buf: buffer)
	return decodeMomentSceneProto(buf)
end

local function defaultDestroyInstance(instance)
	instance:Destroy()
end

local function destroyRoots(items, destroyInstance)
	for _, item in items do
		pcall(function()
			destroyInstance(item)
		end)
	end
end

local function findRecipeValue(items)
	for _, momentScene in items do
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

local function optionalPositiveNumber(value) -- 4 equivalent calls inferred from this helper
	if typeof(value) == "number" and value > 0 then
		return value
	end

	return nil
end

local function parseMomentScenesAsset(items, p: number)
	local MomentScenes = require(parent.MomentScenes)
	local parseSceneAsset = MomentScenes.parseSceneAsset

	for _, item in items do
		local v = parseSceneAsset(item)

		if v.type ~= nil or next(v.args) ~= nil then
			local kind = v.type or "AvatarMoment"

			if kind ~= "AvatarMoment" then
				error(`Inline MomentScene type {kind} is not AvatarMoment`)
			end

			local v2 = optionalPositiveNumber(v.args.outfitId) -- inferred equivalent call

			if v2 == nil then
				error("Inline MomentScene has no valid outfit id")
			end

			if v2 ~= p then
				error(`MomentScene outfit {v2} does not match Post annotation {p}`)
			end

			return { type = "AvatarMoment", args = v.args }
		end
	end

	error("Inline MomentScene RBXM has neither MomentScene/MomentSceneData nor a MomentScenes Type/Args folder")
end

local function optionalUtf8String(emote_name)
	local v

	if typeof(emote_name) == "buffer" then
		v = buffer.tostring(emote_name)
	else
		v = typeof(emote_name) ~= "string" and "" or emote_name
	end

	if v == "" then
		return nil
	end

	if utf8.len(v) == nil then
		error("MomentScene emote_name is not valid UTF-8")
	end

	return v
end

local function decodeInlineMomentScene(buf: buffer, p: number, options)
	if buffer.len(buf) == 0 then
		error("Inline MomentScene RBXM is empty")
	end

	if p <= 0 then
		error("Avatar annotation has no valid outfit id")
	end

	local v = options or {}

	local deserializeInstancesAsync = v.deserializeInstancesAsync or defaultDeserializeInstancesAsync

	local base64Decode = v.base64Decode or defaultBase64Decode
	local decodeMomentScene = v.decodeMomentScene or defaultDecodeMomentScene
	local destroyInstance = v.destroyInstance or defaultDestroyInstance
	local v2 = {}

	local success, result = pcall(function()
		v2 = deserializeInstancesAsync(buf)
		local recipeValue = findRecipeValue(v2)

		if recipeValue == nil then
			return parseMomentScenesAsset(v2, p)
		end

		local value = recipeValue.Value

		if value == "" then
			error("MomentSceneData is empty")
		end

		local v3 = decodeMomentScene((base64Decode(buffer.fromstring(value))))
		local outfitId = optionalPositiveNumber(v3.outfit_id) -- inferred equivalent call

		if outfitId == nil then
			error("MomentScene recipe has no valid outfit id")
		end

		if outfitId ~= p then
			error(`MomentScene outfit {outfitId} does not match Post annotation {p}`)
		end

		return {
			type = "AvatarMoment",
			args = {
				outfitId = outfitId,
				emoteId = optionalPositiveNumber(v3.emote_asset_id), -- inferred equivalent call
				backgroundAssetId = optionalPositiveNumber(v3.background_asset_id), -- inferred equivalent call
				emote = optionalUtf8String(v3.emote_name)
			}
		}
	end)

	destroyRoots(v2, destroyInstance)

	if not success then
		error(result)
	end

	return result
end

return decodeInlineMomentScene
