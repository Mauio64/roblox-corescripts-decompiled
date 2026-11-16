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

local function resolveRigType(p: number)
	local success, result = pcall(function()
		local AvatarEditorService = game:GetService("AvatarEditorService")
		return AvatarEditorService:GetOutfitDetailsAsync(p)
	end)

	if not success or typeof(result) ~= "table" then
		warn(`resolveOutfit: outfit {p} details unavailable, assuming R15 ({result})`)
		return r15
	end

	return rigTypeFromName(result.PlayerAvatarType) -- inferred equivalent call
end

local function resolveUserRigType(p: number)
	local success, result = pcall(function()
		return Players:GetCharacterAppearanceInfoAsync(p)
	end)

	if not success or typeof(result) ~= "table" then
		warn(`resolveOutfit: user {p} appearance info unavailable, assuming R15 ({result})`)
		return r15
	end

	return rigTypeFromName(result.playerAvatarType) -- inferred equivalent call
end

local ResolveOutfit = {}

function ResolveOutfit.resolve(p: number)
	local success, result = pcall(function()
		return Players:GetHumanoidDescriptionFromOutfitIdAsync(p)
	end)

	if not success or typeof(result) ~= "Instance" then
		error(`resolveOutfit: outfit {p} did not resolve ({result})`)
	end

	return { rigType = resolveRigType(p), humanoidDescription = result }
end

function ResolveOutfit.resolveUser(p: number)
	local success, result = pcall(function()
		return Players:GetHumanoidDescriptionFromUserIdAsync(p)
	end)

	if not success or typeof(result) ~= "Instance" then
		error(`resolveOutfit: user {p} did not resolve ({result})`)
	end

	return { rigType = resolveUserRigType(p), humanoidDescription = result }
end

ResolveOutfit.rigTypeFromName = rigTypeFromName

function ResolveOutfit.isKnownAvatarType(p: string?): boolean
	return p == "R6" or p == "R15"
end

return ResolveOutfit
