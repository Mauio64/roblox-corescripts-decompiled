local Players = game:GetService("Players")

local r15 = Enum.HumanoidRigType.R15

local function rigTypeFromName(playerAvatarType: string?) -- 2 equivalent calls inferred from this helper
	if playerAvatarType ~= "R6" and playerAvatarType ~= "R15" then
		warn(`resolveOutfit: unrecognized PlayerAvatarType {playerAvatarType}, assuming R15`)
	end

	if playerAvatarType == "R6" then
		return Enum.HumanoidRigType.R6
	end

	return r15
end

local function gearAssetIdFromAssets(assets)
	if typeof(assets) ~= "table" then
		return nil
	end

	for _, item in assets do
		if typeof(item) ~= "table" then
			continue
		end

		local assetType = item.AssetType or item.assetType
		local v

		if typeof(assetType) == "table" then
			v = assetType.Id or assetType.id
		end

		if v ~= Enum.AssetType.Gear.Value then
			continue
		end

		local id = item.Id or item.id

		if typeof(id) == "number" and id > 0 then
			return id
		end
	end

	return nil
end

local function resolveDetails(p: number)
	local success, result = pcall(function()
		local AvatarEditorService = game:GetService("AvatarEditorService")
		return AvatarEditorService:GetOutfitDetailsAsync(p)
	end)

	if not success or typeof(result) ~= "table" then
		warn(`resolveOutfit: outfit {p} details unavailable, assuming R15 ({result})`)
		return { rigType = r15, gearAssetId = nil }
	end

	return {
		rigType = rigTypeFromName(result.PlayerAvatarType), -- inferred equivalent call
		gearAssetId = gearAssetIdFromAssets(result.Assets)
	}
end

local function resolveUserDetails(p: number)
	local success, result = pcall(function()
		return Players:GetCharacterAppearanceInfoAsync(p)
	end)

	if not success or typeof(result) ~= "table" then
		warn(`resolveOutfit: user {p} appearance info unavailable, assuming R15 ({result})`)
		return { rigType = r15, gearAssetId = nil }
	end

	return {
		rigType = rigTypeFromName(result.playerAvatarType), -- inferred equivalent call
		gearAssetId = gearAssetIdFromAssets(result.assets)
	}
end

local ResolveOutfit = {}

function ResolveOutfit.resolve(p: number)
	local success, result = pcall(function()
		return Players:GetHumanoidDescriptionFromOutfitIdAsync(p)
	end)

	if not success or typeof(result) ~= "Instance" then
		error(`resolveOutfit: outfit {p} did not resolve ({result})`)
	end

	local details = resolveDetails(p)
	return {
		rigType = details.rigType,
		humanoidDescription = result,
		gearAssetId = details.gearAssetId
	}
end

function ResolveOutfit.resolveUser(p: number)
	local success, result = pcall(function()
		return Players:GetHumanoidDescriptionFromUserIdAsync(p)
	end)

	if not success or typeof(result) ~= "Instance" then
		error(`resolveOutfit: user {p} did not resolve ({result})`)
	end

	local userDetails = resolveUserDetails(p)
	return {
		rigType = userDetails.rigType,
		humanoidDescription = result,
		gearAssetId = userDetails.gearAssetId
	}
end

ResolveOutfit.rigTypeFromName = rigTypeFromName

function ResolveOutfit.isKnownAvatarType(p: string?): boolean
	return p == "R6" or p == "R15"
end

ResolveOutfit.gearAssetIdFromAssets = gearAssetIdFromAssets
return ResolveOutfit
