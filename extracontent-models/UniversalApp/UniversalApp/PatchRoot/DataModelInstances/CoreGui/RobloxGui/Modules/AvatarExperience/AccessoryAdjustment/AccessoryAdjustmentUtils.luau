local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AccessoryAdjustment.Constants)
local AdjustmentSliderType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local t2 = {
	sliderInfoToVector3s = function(t1: {[any]: any}) -- line: 11
		-- upvalues: AdjustmentSliderType (copy)
		return Vector3.new(t1[AdjustmentSliderType.PositionX], t1[AdjustmentSliderType.PositionY], t1[AdjustmentSliderType.PositionZ]), Vector3.new(t1[AdjustmentSliderType.RotationX], t1[AdjustmentSliderType.RotationY], t1[AdjustmentSliderType.RotationZ]), (Vector3.new(t1[AdjustmentSliderType.Scale], t1[AdjustmentSliderType.Scale], t1[AdjustmentSliderType.Scale]))
	end,
	vector3sToSliderInfo = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3) -- line: 32
		-- upvalues: AdjustmentSliderType (copy)
		return {
			[AdjustmentSliderType.PositionX] = vector3.X,
			[AdjustmentSliderType.PositionY] = vector3.Y,
			[AdjustmentSliderType.PositionZ] = vector3.Z,
			[AdjustmentSliderType.RotationX] = vector3_2.X,
			[AdjustmentSliderType.RotationY] = vector3_2.Y,
			[AdjustmentSliderType.RotationZ] = vector3_2.Z,
			[AdjustmentSliderType.Scale] = vector3_3.X
		}
	end
}

function t2.getEquippedSliderValues(p1, p2) -- line: 51
	-- upvalues: t2 (copy)
	for _, v15 in p1 do
		for v16, v17 in v15 do
			if v16 == p2 then
				local v18 = if not v17.position then Vector3.new() else v17.position
				local v19 = if not v17.rotation then Vector3.new() else v17.rotation
				local v20 = if not v17.scale then Vector3.new(1, 1, 1) else v17.scale

				return t2.vector3sToSliderInfo(v18, v19, v20)
			end
		end
	end

	return nil
end
function t2.getTryOnAdjustments(p3) -- line: 68
	-- upvalues: t2 (copy)
	local v22 = if not p3.position then Vector3.new() else p3.position
	local v23 = if not p3.rotation then Vector3.new() else p3.rotation
	local v24 = if not p3.scale then Vector3.new(1, 1, 1) else p3.scale

	return t2.vector3sToSliderInfo(v22, v23, v24)
end
function t2.getTryOnSliderValues(p4, s1: string) -- line: 78
	-- upvalues: t2 (copy), Constants (copy)
	for _, v28 in p4 do
		if v28.itemType == "Asset" and s1 == v28.itemId then
			return t2.getTryOnAdjustments(v28)
		end

		if v28.itemType == "Bundle" then
			for _, v30 in p4 do
				if v30.bundleInfo and v30.bundleInfo[s1] then
					local v31 = v30.bundleInfo[s1]

					return t2.getTryOnAdjustments(v31)
				end
			end
		end
	end

	return Constants.DefaultSliderValues
end

local function checkTryOnItemForAdjustment(p5) -- line: 98
	return p5.position and p5.position ~= Vector3.new() or (p5.rotation and p5.rotation ~= Vector3.new() or not not p5.scale and (p5.scale ~= Vector3.new(1, 1, 1) or false))
end

function t2.checkTryOnHasAdjustments(p6, s2: string) -- line: 108
	for _, v36 in p6 do
		if v36.itemType == "Asset" and s2 == v36.itemId then
			return v36.position and v36.position ~= Vector3.new() or (v36.rotation and v36.rotation ~= Vector3.new() or not not v36.scale and (v36.scale ~= Vector3.new(1, 1, 1) or false))
		end

		if v36.itemType == "Bundle" then
			for _, v38 in p6 do
				if v38.bundleInfo and v38.bundleInfo[s2] then
					local v39 = v38.bundleInfo[s2]

					return v39.position and v39.position ~= Vector3.new() or (v39.rotation and v39.rotation ~= Vector3.new() or not not v39.scale and (v39.scale ~= Vector3.new(1, 1, 1) or false))
				end
			end
		end
	end

	return false
end
function t2.getSliderValuesWithDefault(p7, p8, p9) -- line: 132
	-- upvalues: t2 (copy), Constants (copy)
	return t2.getEquippedSliderValues(p7, p9) or (t2.getTryOnSliderValues(p8, p9) or Constants.DefaultSliderValues)
end
function t2.checkSliderValuesChanged(p10, p11) -- line: 141
	-- upvalues: Utils (copy)
	local v45 = false

	for v46, v47 in p11 do
		if not Utils.fuzzyEq(p10[v46], v47) then
			v45 = true
		end
	end

	return v45
end
function t2.getAdjustableAccessories(p12, p13) -- line: 155
	-- upvalues: Constants2 (copy), Utils (copy)
	local Accessories = p12:GetAccessories(true)
	local t3 = {}
	local t4 = {}

	for _, v54 in p13 do
		t4[tostring(v54)] = true
	end

	for _, v56 in Accessories do
		if not t4[Constants2.AccessoryTypeEnumToAssetTypeId[v56.AccessoryType]] or v56.IsLayered then
			continue
		end

		local v57 = Utils.getSelectedAccessoryDescription(p12, v56.AssetId)

		if v57 then
			local ok, result = pcall(function() -- line: 169
				-- upvalues: v57 (copy)
				return v57:GetAppliedInstance()
			end)

			if ok then
				local Handle = result:FindFirstChild("Handle")

				if Handle and Handle:IsA("MeshPart") and Handle.HasSkinnedMesh then
					continue
				end
			end
		end

		table.insert(t3, (tostring(v56.AssetId)))
	end

	return t3
end

return t2
