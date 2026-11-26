local InsertService = game:GetService("InsertService")
local UGCValidationService = game:GetService("UGCValidationService")
local Players = game:GetService("Players")

local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel").Enums.ItemTypeEnum

local defineFastFlag = game:DefineFastFlag("AXSupportPBRInItemViewport", false)

local defineFastInt = game:DefineFastInt("ItemViewportFallbackCameraMaxDistance", 10000)
local defineFastInt2 = game:DefineFastInt("ItemViewportFallbackCameraZoomOutFactor", 1100)

local v5 = defineFastInt / 1000
local v6 = defineFastInt2 / 1000

local function waitForChildOfClass(instance, className)
	local v8 = instance:FindFirstChildOfClass(className)

	while not v8 do
		instance.ChildAdded:Wait()
		v8 = instance:FindFirstChildOfClass(className)
	end

	return v8
end

return {
	getAssetModel = function(p2)
		local v8

		if defineFastFlag then
			v8 = Instance.new("Model")

			local fetchAssetWithFormat = UGCValidationService:FetchAssetWithFormat(
				`https://assetgame.roblox.com/asset/?id={p2}`,
				"rbx-format/avatar_meshpart_accessory"
			)

			fetchAssetWithFormat[1].Parent = v8
		else
			v8 = InsertService:LoadAsset((tonumber(p2)))
		end

		local inverse = waitForChildOfClass(v8, "Accessory").AttachmentPoint:Inverse()
		v8:PivotTo(inverse - inverse.Position)

		return v8
	end,
	getShoesModel = function(items)
		local model = Instance.new("Model")

		for k, item in items do
			if item.type ~= itemTypeEnum.Asset then
				continue
			end

			local asset = InsertService:LoadAsset((tonumber(item.id)))
			local v9 = waitForChildOfClass(waitForChildOfClass(asset, "Accessory"), "MeshPart")
			v9.Parent = model

			local v10 = v9:FindFirstChild("LeftFootAttachment") ~= nil
			local v11 = v9:FindFirstChild("RightFootAttachment") ~= nil
			assert(
				v10 or v11,
				"Couldn't distinguish between left and right shoe because no foot attachment was found"
			)

			local v12 = 0.05 + v9.Size.X / 2
			local newCFrame = CFrame.new

			if v10 then
				v12 = -v12
			end

			v9.CFrame = newCFrame(v12, 0, 0)

			asset:Destroy()
		end

		return model
	end,
	getAvatarModel = function(items, p2)
		local id = nil

		for k, item in items do
			if item.type == itemTypeEnum.Outfit then
				id = tonumber(item.id)
				break
			end
		end

		assert(id, "No outfit ID found in bundle items")

		local humanoidModelFromDescriptionAsync = Players:CreateHumanoidModelFromDescriptionAsync(
			Players:GetHumanoidDescriptionFromOutfitIdAsync(id),
			Enum.HumanoidRigType.R15
		)

		if p2 then
			local humanoid = humanoidModelFromDescriptionAsync:FindFirstChildOfClass("Humanoid")

			for i, child in humanoidModelFromDescriptionAsync:GetChildren() do
				if child ~= humanoid and humanoid and humanoid:GetLimb(child) ~= Enum.Limb.Head then
					child:Destroy()
				end
			end
		end

		humanoidModelFromDescriptionAsync.Parent = workspace
		local v9 = humanoidModelFromDescriptionAsync:GetBoundingBox().Position - humanoidModelFromDescriptionAsync:GetPivot().Position
		humanoidModelFromDescriptionAsync.Parent = nil
		humanoidModelFromDescriptionAsync:PivotTo(CFrame.new(-v9))
		return humanoidModelFromDescriptionAsync
	end,
	getCameraDistance = function(self, p2)
		local accessory = self:FindFirstChildOfClass("Accessory")
		local v8 = accessory and accessory:FindFirstChildOfClass("MeshPart") ~= nil
		local humanoid = self:FindFirstChildOfClass("Humanoid")
		local v9

		if self:FindFirstChild("LeftFootAttachment", true) == nil then
			v9 = false
		else
			v9 = self:FindFirstChild("RightFootAttachment", true) ~= nil
		end

		local thumbnailConfiguration = accessory and accessory:FindFirstChild("ThumbnailConfiguration")
		local v10 = 1 / math.sin((math.rad(p2 / 2))) * v6

		if v8 or humanoid or v9 then
			if humanoid then
				self.Parent = workspace
			end

			local boundingBox, v11 = self:GetBoundingBox()

			if humanoid then
				self.Parent = nil
			end

			return (v11 / 2).Magnitude / math.sin((math.rad(p2 / 2)))
		else
			if not thumbnailConfiguration then
				return v10
			end

			local thumbnailCameraValue = thumbnailConfiguration:FindFirstChild("ThumbnailCameraValue")
			local value = thumbnailCameraValue and thumbnailCameraValue.Value
			local magnitude = value and value.Position.Magnitude

			if magnitude and magnitude < v5 then
				return magnitude * v6
			end

			return v10
		end
	end
}
