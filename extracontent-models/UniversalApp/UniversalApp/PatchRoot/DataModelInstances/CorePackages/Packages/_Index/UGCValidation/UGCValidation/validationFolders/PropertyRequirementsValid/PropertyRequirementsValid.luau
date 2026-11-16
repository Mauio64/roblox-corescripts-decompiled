local parent = script.Parent.Parent.Parent

local Cryo = require(parent.Parent.Cryo)

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local valueToString = require(parent.util.valueToString)

local PropertyRequirementsValid = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.MAKEUP
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.uploadEnum },
	expectedFailures = {}
}

local function comparitorMethodImpl(p: number, p2: number, p3: string)
	if p3 == Constants.COMPARISON_METHODS.SMALLER then
		return p < p2
	end

	if p3 == Constants.COMPARISON_METHODS.SMALLER_EQ then
		return p <= p2
	end

	if p3 == Constants.COMPARISON_METHODS.FUZZY_EQ then
		return math.abs(p - p2) <= 0.00001
	end

	if p3 == Constants.COMPARISON_METHODS.EXACT_EQ then
		return p == p2
	end

	if p3 == Constants.COMPARISON_METHODS.GREATER_EQ then
		return p2 <= p
	end

	if p3 == Constants.COMPARISON_METHODS.GREATER then
		return p2 < p
	end

	error("Invalid comparitor method: " .. p3)
end

local function doesPropertyMatchExpectations(data, value, p: string)
	if value == Cryo.None then
		return data == nil
	end

	if typeof(value) == "table" and p == Constants.COMPARISON_METHODS.FOUND_IN then
		local v = false

		for _, item in value do
			v = v or doesPropertyMatchExpectations(data, item, Constants.COMPARISON_METHODS.EXACT_EQ)
		end

		return v
	end

	if typeof(data) ~= typeof(value) then
		return false
	end

	if typeof(value) == "number" then
		return comparitorMethodImpl(data, value, p)
	end

	if typeof(value) == "Vector3" then
		return comparitorMethodImpl(data.X, value.X, p)
			and comparitorMethodImpl(data.Y, value.Y, p)
			and comparitorMethodImpl(data.Z, value.Z, p)
	end

	if typeof(value) == "Color3" then
		return comparitorMethodImpl(data.R, value.R, p)
			and comparitorMethodImpl(data.G, value.G, p)
			and comparitorMethodImpl(data.B, value.B, p)
	end

	return data == value
end

local function extractSubProperty(p: string, cframe)
	if typeof(cframe) == "CFrame" and p == "PositionMagnitude" then
		return true, cframe.Position.Magnitude
	end

	if typeof(cframe) == "CFrame" and p == "Orientation" then
		return true, (Vector3.new(cframe:ToOrientation()))
	end

	if typeof(cframe) == "CFrame" and p == "Position" then
		return true, cframe.Position
	end

	return false
end

local function getAllActiveTestsOnProperty(assetType, k: string, result, items)
	if typeof(items) ~= "table" then
		return {
			{ k, result, items, Constants.COMPARISON_METHODS.FUZZY_EQ }
		}
	end

	for k2, list in items do
		if k2 == Constants.INCLUSION_METHODS.INCLUSION_LIST then
			if table.find(list, assetType) == nil then
				return {}
			end
		elseif k2 == Constants.INCLUSION_METHODS.EXCLUSION_LIST and table.find(list, assetType) ~= nil then
			return {}
		end
	end

	local result2 = {}

	for _, v in Constants.COMPARISON_METHODS do
		if items[v] ~= nil then
			table.insert(result2, { k, result, items[v], v })
		end
	end

	local v = 1

	while items[v] ~= nil do
		local v2 = getAllActiveTestsOnProperty(assetType, k, result, items[v])
		table.move(v2, 1, #v2, #result2 + 1, result2)

		v += 1
	end

	for k2, item in items do
		local v2, flag

		if typeof(result) == "CFrame" and k2 == "PositionMagnitude" then
			v2 = result.Position.Magnitude
			flag = true
		elseif typeof(result) == "CFrame" and k2 == "Orientation" then
			v2 = Vector3.new(result:ToOrientation())
			flag = true
		elseif typeof(result) == "CFrame" and k2 == "Position" then
			v2 = result.Position
			flag = true
		else
			flag = false
		end

		if not flag then
			continue
		end

		local v3 = getAllActiveTestsOnProperty(assetType, k2, v2, item)

		for _, v4 in v3 do
			v4[1] = k .. "." .. v4[1]
			table.insert(result2, v4)
		end
	end

	return result2
end

function PropertyRequirementsValid.run(object, p)
	local rootInstance = p.rootInstance
	local assetType = p.uploadEnum.assetType

	local descendants = rootInstance:GetDescendants()
	table.insert(descendants, rootInstance)

	for _, descendant in descendants do
		for className, v in Constants.PROPERTIES do
			if not descendant:IsA(className) then
				continue
			end

			for k, v2 in v do
				local v3 = k
				local success, result = pcall(function()
					return descendant[v3]
				end)

				if success then
					local allActiveTestsOnProperty = getAllActiveTestsOnProperty(assetType, k, result, v2)

					for _, list in allActiveTestsOnProperty do
						local propertyName, v4, v5, comparisonMethod = table.unpack(list)

						if not doesPropertyMatchExpectations(v4, v5, comparisonMethod) then
							object:fail(ErrorSourceStrings.Keys.PropertyValueInvalid, {
								PropertyName = propertyName,
								InstancePath = descendant:GetFullName(),
								ComparisonMethod = comparisonMethod,
								ExpectedValue = valueToString(v5)
							})
						end
					end
				else
					object:fail(ErrorSourceStrings.Keys.PropertyNotFound, {
						PropertyName = k,
						InstancePath = descendant:GetFullName()
					})
				end
			end
		end
	end
end

return PropertyRequirementsValid
