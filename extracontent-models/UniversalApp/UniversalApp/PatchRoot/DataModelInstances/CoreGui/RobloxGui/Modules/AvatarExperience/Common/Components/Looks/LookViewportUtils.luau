local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Modules = CoreGui.RobloxGui.Modules
local tutils = require(CorePackages.Packages.tutils)
local EmoteUtility = require(CorePackages.Packages.Thumbnailing).EmoteUtility
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local mutedError = require(Modules.LuaApp.mutedError)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local GetFFlagAXLookViewportCameraAlignment = require(Modules.AvatarExperience.Flags.GetFFlagAXLookViewportCameraAlignment)
local v15 = game:DefineFastFlag("AXFixMySharedAvatarMutedError", false)
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagAXCommunityAvatarsMakeupEquipping = AvatarExperienceFlags.FFlagAXCommunityAvatarsMakeupEquipping
local t1 = {
	{
		id = 14461759190,
		assetTypeId = 29
	},
	{
		id = 14461763778,
		assetTypeId = 30
	},
	{
		id = 14461769598,
		assetTypeId = 28
	},
	{
		id = 14461775685,
		assetTypeId = 31
	},
	{
		id = 14461780409,
		assetTypeId = 27
	},
	{
		id = 14461797943,
		assetTypeId = 17
	}
}
local t3 = {
	createHumanoidDescriptionFromLook = function(p1) -- line: 39
		-- upvalues: t1 (copy), Constants (copy), FFlagAXCommunityAvatarsMakeupEquipping (copy), isMakeupAssetType (copy), FFlagParseHeadShapeFromAPIResponse (copy), setMakeupDescriptions (copy)
		local HumanoidDescription = Instance.new("HumanoidDescription")

		if p1.lookType == "Outfit" then
			HumanoidDescription.HeadColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.LeftArmColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.RightArmColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.TorsoColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.LeftLegColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.RightLegColor = BrickColor.new("Medium stone grey").Color

			for _, v23 in t1 do
				HumanoidDescription[Constants.AssetTypeIdStringToHumanoidDescriptionProp[tostring(v23.assetTypeId)]] = v23.id
			end
		end

		local t2 = {}
		local v25 = if not FFlagAXCommunityAvatarsMakeupEquipping then nil else {}

		if p1.lookAssetInfos then
			for _, v27 in p1.lookAssetInfos do
				local str = tostring(v27.assetType)
				local v29 = Constants.AssetTypeIdToAccessoryTypeEnum[str]

				if v29 then
					table.insert(t2, {
						AssetId = tonumber(v27.id) or 0,
						Order = if not v27.meta then nil else v27.meta.order,
						AccessoryType = v29
					})
				elseif FFlagAXCommunityAvatarsMakeupEquipping and isMakeupAssetType(str) then
					if not v25[str] then
						v25[str] = {}
					end

					v25[str][tostring(v27.id)] = {
						order = if not v27.meta then nil else v27.meta.order
					}
				elseif FFlagAXCommunityAvatarsMakeupEquipping then
					local v30 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[str]

					if v30 then
						HumanoidDescription[v30] = v27.id
					end
				else
					HumanoidDescription[Constants.AssetTypeIdStringToHumanoidDescriptionProp[str]] = v27.id
				end
			end
		end

		if p1.lookBundleInfos then
			for _, v32 in p1.lookBundleInfos do
				for _, v34 in v32.assetsInBundle do
					if v34.isIncluded then
						local str = tostring(v34.assetType)
						local v36 = Constants.AssetTypeIdToAccessoryTypeEnum[str]

						if v36 then
							table.insert(t2, {
								AssetId = tonumber(v34.id) or 0,
								Order = if not v34.meta then nil else v34.meta.order,
								AccessoryType = v36
							})
						elseif FFlagAXCommunityAvatarsMakeupEquipping and isMakeupAssetType(str) then
							if not v25[str] then
								v25[str] = {}
							end

							v25[str][tostring(v34.id)] = {
								order = if not v34.meta then nil else v34.meta.order
							}
						else
							local v37 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[str]

							if FFlagParseHeadShapeFromAPIResponse and Constants.BodyPartNameToEnum[v37] then
								local BodyPartDescription = Instance.new("BodyPartDescription")

								BodyPartDescription.AssetId = v34.id
								BodyPartDescription.Parent = HumanoidDescription
								BodyPartDescription.BodyPart = Constants.BodyPartNameToEnum[v37]

								if v34.meta and v34.meta.headShape then
									BodyPartDescription.HeadShape = if v34.meta.headShape ~= "Default" then v34.meta.headShape else ""
								end
							elseif FFlagAXCommunityAvatarsMakeupEquipping then
								if v37 then
									HumanoidDescription[v37] = v34.id
								end
							else
								HumanoidDescription[v37] = v34.id
							end
						end
					end
				end
			end
		end

		if FFlagAXCommunityAvatarsMakeupEquipping then
			setMakeupDescriptions(HumanoidDescription, v25)
		end

		HumanoidDescription:SetAccessories(t2, true)

		if p1.avatarProperties and p1.avatarProperties.bodyColor3s then
			for v39, v40 in p1.avatarProperties.bodyColor3s do
				HumanoidDescription[Constants.BodyPartForSkinColoringIdToHumanoidDescription[v39]] = Color3.fromHex(v40)
			end
		else
			HumanoidDescription.HeadColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.LeftArmColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.RightArmColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.TorsoColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.LeftLegColor = BrickColor.new("Medium stone grey").Color
			HumanoidDescription.RightLegColor = BrickColor.new("Medium stone grey").Color
		end

		if p1.avatarProperties and p1.avatarProperties.scale then
			for v41, v42 in p1.avatarProperties.scale do
				HumanoidDescription[Constants.HumanoidDescriptionScaleToName[v41]] = v42
			end
		end

		return HumanoidDescription
	end
}

function t3.createAvatarModel(p2) -- line: 172
	-- upvalues: t3 (copy), Players (copy), GetFFlagAXLookViewportCameraAlignment (copy), EmoteUtility (copy)
	local v44 = t3.createHumanoidDescriptionFromLook(p2)
	local v45 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:CreateHumanoidModelFromDescription(v44, Enum.HumanoidRigType.R15) else Players:CreateHumanoidModelFromDescriptionAsync(v44, Enum.HumanoidRigType.R15)

	v45:WaitForChild("HumanoidRootPart").Anchored = true
	v45:PivotTo(CFrame.new(0, 1000, 0))
	v45.Parent = workspace

	if not GetFFlagAXLookViewportCameraAlignment() then
		local v46 = p2.displayProperties and p2.displayProperties.emoteAssetId

		if v46 then
			local v47 = EmoteUtility.LoadKeyframesForPose(v45, tonumber(v46), 10647852134, true, false)

			EmoteUtility.ApplyKeyframesForPose(v45, v47)
		end
	end

	return v45
end
function t3.applyPose(s1: string, p3) -- line: 200
	-- upvalues: EmoteUtility (copy)
	local v50 = EmoteUtility.LoadKeyframesForPose(p3, tonumber(s1), 10647852134, true, false)

	EmoteUtility.ApplyKeyframesForPose(p3, v50)
	task.wait()
end
function t3.loadAnimationTrackForAvatar(s2: string, p4) -- line: 207
	local Humanoid = p4:FindFirstChildOfClass("Humanoid")
	local v54 = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

	if not v54 or #v54:GetPlayingAnimationTracks() > 0 then
		return nil
	end

	local Animation = Instance.new("Animation")

	Animation.AnimationId = "rbxassetid://" .. s2

	local track = v54:LoadAnimation(Animation)

	track.Looped = false

	return track
end
function t3.areLooksDifferent(p5, p6) -- line: 223
	-- upvalues: tutils (copy)
	if p5 == p6 then
		return false
	end

	if not p5 or not p6 then
		return true
	end

	local v59 = tutils.deepEqual(p5.lookAssetInfos, p6.lookAssetInfos)
	local v60 = tutils.deepEqual(p5.lookBundleInfos, p6.lookBundleInfos)
	local v61 = (p5.displayProperties and p5.displayProperties.emoteAssetId) ~= (p6.displayProperties and p6.displayProperties.emoteAssetId)
	local v62 = tutils.deepEqual(p5.avatarProperties, p6.avatarProperties)
	local v63 = not v59

	if not v63 then
		v63 = not v60

		if not v63 then
			v63 = v61

			if not v63 then
				v63 = not v62
			end
		end
	end

	return v63
end
function t3.hydratedLookToLookDetails(p7) -- line: 243
	-- upvalues: Cryo (copy), v15 (copy), mutedError (copy)
	local t4 = {
		totalPrice = 0,
		totalPremiumPrice = 0,
		lookAssetInfos = {},
		lookBundleInfos = {}
	}
	local v66 = if not p7.assetsIncludingBundleParts then p7.assets else Cryo.List.join(p7.assets, p7.assetsIncludingBundleParts)

	if v66 then
		for _, v68 in v66 do
			if not v15 or v68.assetType then
				local ok, result = pcall(function() -- line: 260
					-- upvalues: v68 (copy)
					return Enum.AssetType[v68.assetType].Value
				end)

				if ok then
					t4.lookAssetInfos[tostring(v68.id)] = {
						quantityOwned = 0,
						id = tostring(v68.id),
						itemType = v68.type,
						assetType = result,
						meta = if not v68.order then nil else {
							order = v68.order
						}
					}
				else
					mutedError(`Incorrect asseType received from hydrated look: "{ v68.assetType }" does not map to an Enum.AssetType ({ result })`)
				end
			end
		end
	end

	local avatarProperties = p7.avatarProperties

	if avatarProperties then
		t4.avatarProperties = {
			bodyColor3s = avatarProperties.bodyColors,
			playerAvatarType = avatarProperties.playerAvatarType,
			scale = avatarProperties.scales
		}
	end

	return t4
end

return t3
