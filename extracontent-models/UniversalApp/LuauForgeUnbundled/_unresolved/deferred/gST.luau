local CorePackages = game:GetService("CorePackages")

local Players = game:GetService("Players")

local tutils = require(CorePackages.Packages.tutils)
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local emoteUtility = Thumbnailing.EmoteUtility
local Cryo = require(CorePackages.Packages.Cryo)

require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dFs")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions

local module5 = require("@luauforge/deferred/gSU")
local defineFastFlag = game:DefineFastFlag("AXFixMySharedAvatarMutedError", false)
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse

local v5 = {
	{ id = 14461759190, assetTypeId = 29 },
	{ id = 14461763778, assetTypeId = 30 },
	{ id = 14461769598, assetTypeId = 28 },
	{ id = 14461775685, assetTypeId = 31 },
	{ id = 14461780409, assetTypeId = 27 },
	{ id = 14461797943, assetTypeId = 17 }
}

local v6 = {}

function v6.createHumanoidDescriptionFromLook(data)
	local humanoidDescription = Instance.new("HumanoidDescription")

	if data.lookType == "Outfit" then
		humanoidDescription.HeadColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.LeftArmColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.RightArmColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.TorsoColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.LeftLegColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.RightLegColor = BrickColor.new("Medium stone grey").Color

		for k, v7 in v5 do
			humanoidDescription[module.AssetTypeIdStringToHumanoidDescriptionProp[tostring(v7.assetTypeId)]] = v7.id
		end
	end

	local v7 = {}
	local v8 = {}

	if data.lookAssetInfos then
		for k, lookAssetInfo in data.lookAssetInfos do
			local assetType = tostring(lookAssetInfo.assetType)
			local accessoryTypeEnum = module.AssetTypeIdToAccessoryTypeEnum[assetType]

			if accessoryTypeEnum then
				local v9 = {
					AssetId = tonumber(lookAssetInfo.id) or 0,
					Order = 0,
					AccessoryType = 0
				}
				local v10 = if lookAssetInfo.meta then lookAssetInfo.meta.order else nil
				v9.Order = v10
				v9.AccessoryType = accessoryTypeEnum
				table.insert(v7, v9)
			elseif isMakeupAssetType(assetType) then
				if not v8[assetType] then
					v8[assetType] = {}
				end

				local v9 = v8[assetType]
				local id = tostring(lookAssetInfo.id)
				local v11 = if lookAssetInfo.meta then lookAssetInfo.meta.order else nil
				v9[id] = { order = v11 }
			else
				local v9 = module.AssetTypeIdStringToHumanoidDescriptionProp[assetType]

				if v9 then
					humanoidDescription[v9] = lookAssetInfo.id
				end
			end
		end
	end

	if data.lookBundleInfos then
		for k, lookBundleInfo in data.lookBundleInfos do
			for k2, v9 in lookBundleInfo.assetsInBundle do
				if not v9.isIncluded then
					continue
				end

				local assetType = tostring(v9.assetType)
				local accessoryTypeEnum = module.AssetTypeIdToAccessoryTypeEnum[assetType]

				if accessoryTypeEnum then
					local v10 = {
						AssetId = tonumber(v9.id) or 0,
						Order = 0,
						AccessoryType = 0
					}
					local v11 = if v9.meta then v9.meta.order else nil
					v10.Order = v11
					v10.AccessoryType = accessoryTypeEnum
					table.insert(v7, v10)
				elseif isMakeupAssetType(assetType) then
					if not v8[assetType] then
						v8[assetType] = {}
					end

					local v10 = v8[assetType]
					local id = tostring(v9.id)
					local v12 = if v9.meta then v9.meta.order else nil
					v10[id] = { order = v12 }
				else
					local v10 = module.AssetTypeIdStringToHumanoidDescriptionProp[assetType]

					if fFlagParseHeadShapeFromAPIResponse and module.BodyPartNameToEnum[v10] then
						local bodyPartDescription = Instance.new("BodyPartDescription")
						bodyPartDescription.AssetId = v9.id
						bodyPartDescription.Parent = humanoidDescription
						bodyPartDescription.BodyPart = module.BodyPartNameToEnum[v10]

						if v9.meta and v9.meta.headShape then
							bodyPartDescription.HeadShape = v9.meta.headShape == "Default" and ""
								or v9.meta.headShape
						end
					elseif v10 then
						humanoidDescription[v10] = v9.id
					end
				end
			end
		end
	end

	setMakeupDescriptions(humanoidDescription, v8)
	humanoidDescription:SetAccessories(v7, true)

	if data.avatarProperties and data.avatarProperties.bodyColor3s then
		for k, bodyColor3 in data.avatarProperties.bodyColor3s do
			humanoidDescription[module.BodyPartForSkinColoringIdToHumanoidDescription[k]] = Color3.fromHex(bodyColor3)
		end
	else
		humanoidDescription.HeadColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.LeftArmColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.RightArmColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.TorsoColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.LeftLegColor = BrickColor.new("Medium stone grey").Color
		humanoidDescription.RightLegColor = BrickColor.new("Medium stone grey").Color
	end

	if data.avatarProperties and data.avatarProperties.scale then
		for k, v9 in data.avatarProperties.scale do
			humanoidDescription[module.HumanoidDescriptionScaleToName[k]] = v9
		end
	end

	return humanoidDescription
end

function v6.createAvatarModel(p2)
	local humanoidModelFromDescriptionAsync = Players:CreateHumanoidModelFromDescriptionAsync(
		v6.createHumanoidDescriptionFromLook(p2),
		Enum.HumanoidRigType.R15
	)
	local humanoidRootPart = humanoidModelFromDescriptionAsync:WaitForChild("HumanoidRootPart")
	humanoidRootPart.Anchored = true
	humanoidModelFromDescriptionAsync:PivotTo(CFrame.new(0, 1000, 0))
	humanoidModelFromDescriptionAsync.Parent = workspace

	local emoteAssetId = not module5() and p2.displayProperties and p2.displayProperties.emoteAssetId

	if emoteAssetId then
		local keyframesForPose = emoteUtility.LoadKeyframesForPose(
			humanoidModelFromDescriptionAsync,
			tonumber(emoteAssetId),
			10647852134,
			true,
			false
		)
		emoteUtility.ApplyKeyframesForPose(humanoidModelFromDescriptionAsync, keyframesForPose)
	end

	return humanoidModelFromDescriptionAsync
end

function v6.applyPose(p2, p3)
	local keyframesForPose = emoteUtility.LoadKeyframesForPose(p3, tonumber(p2), 10647852134, true, false)
	emoteUtility.ApplyKeyframesForPose(p3, keyframesForPose)
	task.wait()
end

function v6.loadAnimationTrackForAvatar(p2, instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

	if not animator or #animator:GetPlayingAnimationTracks() > 0 then
		return nil
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. p2
	local track = animator:LoadAnimation(animation)
	track.Looped = false
	return track
end

function v6.areLooksDifferent(data, data2)
	if data == data2 then
		return false
	end

	if not (data and data2) then
		return true
	end

	local v7 = not tutils.deepEqual(data.lookAssetInfos, data2.lookAssetInfos)
	local v8 = not tutils.deepEqual(data.lookBundleInfos, data2.lookBundleInfos)
	local v9 = (data.displayProperties and data.displayProperties.emoteAssetId) ~= (data2.displayProperties and data2.displayProperties.emoteAssetId)

	local v10 = not tutils.deepEqual(data.avatarProperties, data2.avatarProperties)

	return v7 or v8 or v9 or v10
end

function v6.hydratedLookToLookDetails(data)
	local v7 = {
		totalPrice = 0,
		totalPremiumPrice = 0,
		lookAssetInfos = {},
		lookBundleInfos = {}
	}
	local v8

	if data.assetsIncludingBundleParts then
		v8 = Cryo.List.join(data.assets, data.assetsIncludingBundleParts)
	else
		v8 = data.assets
	end

	if v8 then
		for k, v9 in v8 do
			if not (not defineFastFlag or v9.assetType) then
				continue
			end

			local success, result = pcall(function()
				return Enum.AssetType[v9.assetType].Value
			end)

			if success then
				v7.lookAssetInfos[tostring(v9.id)] = {
					id = tostring(v9.id),
					itemType = v9.type,
					assetType = result,
					meta = v9.order and { order = v9.order } or nil,
					quantityOwned = 0
				}
			else
				module2(`Incorrect asseType received from hydrated look: "{v9.assetType}" does not map to an Enum.AssetType ({result})`)
			end
		end
	end

	local avatarProperties = data.avatarProperties

	if avatarProperties then
		v7.avatarProperties = {
			bodyColor3s = avatarProperties.bodyColors,
			playerAvatarType = avatarProperties.playerAvatarType,
			scale = avatarProperties.scales
		}
	end

	return v7
end

return v6
