local InsertService = game:GetService("InsertService")
local UGCValidationService = game:GetService("UGCValidationService")
local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagAXSupportShoesInItemViewport = require(Modules.AvatarExperience.Flags.GetFFlagAXSupportShoesInItemViewport)
local v7 = game:DefineFastFlag("AXSupportPBRInItemViewport", false)
local v8 = game:DefineFastInt("ItemViewportFallbackCameraMaxDistance", 10000)
local v9 = game:DefineFastInt("ItemViewportFallbackCameraZoomOutFactor", 1100)
local v10 = v8 / 1000
local v11 = v9 / 1000
local t1 = {}

local function waitForChildOfClass(p1, s1: string) -- line: 24
	local s1_2 = p1:FindFirstChildOfClass(s1)

	while not s1_2 do
		p1.ChildAdded:Wait()
		s1_2 = p1:FindFirstChildOfClass(s1)
	end

	return s1_2
end

function t1.getAssetModel(n1: number) -- line: 34
	-- upvalues: v7 (copy), UGCValidationService (copy), InsertService (copy), GetFFlagAXSupportShoesInItemViewport (copy), waitForChildOfClass (copy)
	local Model

	if v7 then
		Model = Instance.new("Model")
		UGCValidationService:FetchAssetWithFormat(`https://assetgame.roblox.com/asset/?id={ n1 }`, "rbx-format/avatar_meshpart_accessory")[1].Parent = Model
	else
		Model = InsertService:LoadAsset((tonumber(n1)))
	end

	local v19

	if GetFFlagAXSupportShoesInItemViewport() then
		v19 = waitForChildOfClass(Model, "Accessory")
	else
		v19 = Model:FindFirstChildOfClass("Accessory")

		while not v19 do
			Model.ChildAdded:Wait()
			v19 = Model:FindFirstChildOfClass("Accessory")
		end
	end

	local v20 = v19.AttachmentPoint:Inverse()

	Model:PivotTo(v20 - v20.Position)

	return Model
end
function t1.getShoesModel(t2: {[any]: any}) -- line: 69
	-- upvalues: Constants (copy), InsertService (copy), waitForChildOfClass (copy)
	local Model = Instance.new("Model")

	for _, v24 in t2 do
		if v24.type == Constants.ItemType.Asset then
			local v25 = InsertService:LoadAsset((tonumber(v24.id)))
			local v26 = waitForChildOfClass(v25, "Accessory")
			local v27 = waitForChildOfClass(v26, "MeshPart")

			v27.Parent = Model

			local v28 = v27:FindFirstChild("LeftFootAttachment") ~= nil
			local v29 = v27:FindFirstChild("RightFootAttachment") ~= nil

			assert(v28 or v29, "Couldn't distinguish between left and right shoe because no foot attachment was found")

			local v30 = 0.05 + v27.Size.X / 2

			v27.CFrame = CFrame.new(if not v28 then v30 else -v30, 0, 0)
			v25:Destroy()
		end
	end

	return Model
end
function t1.getAvatarModel(t3: {[any]: any}, b1: boolean) -- line: 100
	-- upvalues: Constants (copy), Players (copy)
	local num = nil

	for _, v35 in t3 do
		if v35.type == Constants.ItemType.Outfit then
			num = tonumber(v35.id)

			break
		end
	end

	assert(num, "No outfit ID found in bundle items")

	local v37

	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		local HumanoidDescriptionFromOutfitIdAsync = Players:GetHumanoidDescriptionFromOutfitIdAsync(num)

		v37 = Players:CreateHumanoidModelFromDescriptionAsync(HumanoidDescriptionFromOutfitIdAsync, Enum.HumanoidRigType.R15)
	else
		local HumanoidDescriptionFromOutfitId = Players:GetHumanoidDescriptionFromOutfitId(num)

		v37 = Players:CreateHumanoidModelFromDescription(HumanoidDescriptionFromOutfitId, Enum.HumanoidRigType.R15)
	end

	if b1 then
		local Humanoid = v37:FindFirstChildOfClass("Humanoid")

		for _, child in v37:GetChildren() do
			if child ~= Humanoid and Humanoid and Humanoid:GetLimb(child) ~= Enum.Limb.Head then
				child:Destroy()
			end
		end
	end

	v37.Parent = workspace

	local v42 = v37:GetBoundingBox().Position - v37:GetPivot().Position

	v37.Parent = nil
	v37:PivotTo(CFrame.new(-v42))

	return v37
end
function t1.getBundleModel(s2: string, n2: number) -- line: 143
	-- upvalues: Players (copy), Constants (copy)
	local v46

	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		local HumanoidDescriptionFromOutfitIdAsync = Players:GetHumanoidDescriptionFromOutfitIdAsync(n2)

		v46 = Players:CreateHumanoidModelFromDescriptionAsync(HumanoidDescriptionFromOutfitIdAsync, Enum.HumanoidRigType.R15)
	else
		local HumanoidDescriptionFromOutfitId = Players:GetHumanoidDescriptionFromOutfitId(n2)

		v46 = Players:CreateHumanoidModelFromDescription(HumanoidDescriptionFromOutfitId, Enum.HumanoidRigType.R15)
	end

	if s2 == Constants.BundleTypeIdStrings.DynamicHead then
		local Humanoid = v46:FindFirstChildOfClass("Humanoid")

		for _, child in v46:GetChildren() do
			if child ~= Humanoid and Humanoid and Humanoid:GetLimb(child) ~= Enum.Limb.Head then
				child:Destroy()
			end
		end
	end

	v46.Parent = workspace

	local v51 = v46:GetBoundingBox().Position - v46:GetPivot().Position

	v46.Parent = nil
	v46:PivotTo(CFrame.new(-v51))

	return v46
end
function t1.getCameraDistance(p2, n3: number) -- line: 174
	-- upvalues: GetFFlagAXSupportShoesInItemViewport (copy), v11 (copy), v10 (copy)
	local Accessory = p2:FindFirstChildOfClass("Accessory")
	local v55 = Accessory and Accessory:FindFirstChildOfClass("MeshPart") ~= nil
	local Humanoid = p2:FindFirstChildOfClass("Humanoid")
	local v57 = GetFFlagAXSupportShoesInItemViewport() and (p2:FindFirstChild("LeftFootAttachment", true) ~= nil and p2:FindFirstChild("RightFootAttachment", true) ~= nil)
	local v58 = Accessory and Accessory:FindFirstChild("ThumbnailConfiguration")
	local v59 = 1 / math.sin((math.rad(n3 / 2))) * v11

	if v55 or Humanoid or GetFFlagAXSupportShoesInItemViewport() and v57 then
		if Humanoid then
			p2.Parent = workspace
		end

		local _, v61 = p2:GetBoundingBox()

		if Humanoid then
			p2.Parent = nil
		end

		return (v61 / 2).Magnitude / math.sin((math.rad(n3 / 2)))
	end

	if v58 then
		local ThumbnailCameraValue = v58:FindFirstChild("ThumbnailCameraValue")
		local v63 = ThumbnailCameraValue and ThumbnailCameraValue.Value
		local v64 = v63 and v63.Position.Magnitude

		if v64 and v64 < v10 then
			return v64 * v11
		end

		return v59
	end

	return v59
end

return t1
