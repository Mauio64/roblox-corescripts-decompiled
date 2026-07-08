local ParentParent = script.Parent.Parent.Parent
local Cryo = require(ParentParent.Parent.Cryo)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local valueToString = require(ParentParent.util.valueToString)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.MAKEUP
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function comparitorMethodImpl(n1: number, n2: number, s1: string) -- line: 32
	-- upvalues: Constants (copy)
	if s1 == Constants.COMPARISON_METHODS.SMALLER then
		return n1 < n2
	end

	if s1 == Constants.COMPARISON_METHODS.SMALLER_EQ then
		return n1 <= n2
	end

	if s1 == Constants.COMPARISON_METHODS.FUZZY_EQ then
		return math.abs(n1 - n2) <= 1E-05
	end

	if s1 == Constants.COMPARISON_METHODS.EXACT_EQ then
		return n1 == n2
	end

	if s1 == Constants.COMPARISON_METHODS.GREATER_EQ then
		return n2 <= n1
	end

	if s1 == Constants.COMPARISON_METHODS.GREATER then
		return n2 < n1
	end

	error("Invalid comparitor method: " .. s1)
end
local function doesPropertyMatchExpectations(p1, p2, s2: string) -- line: 50
	-- upvalues: Cryo (copy), getFFlagUGCValidationEyebrowEyelashSupport (copy), Constants (copy), doesPropertyMatchExpectations (copy), comparitorMethodImpl (copy)
	if p2 == Cryo.None then
		return p1 == nil
	end

	if getFFlagUGCValidationEyebrowEyelashSupport() and typeof(p2) == "table" and s2 == Constants.COMPARISON_METHODS.FOUND_IN then
		local v20 = false

		for _, v22 in p2 do
			v20 = v20 or doesPropertyMatchExpectations(p1, v22, Constants.COMPARISON_METHODS.EXACT_EQ)
		end

		return v20
	end

	if typeof(p1) ~= typeof(p2) then
		return false
	end

	if typeof(p2) == "number" then
		return comparitorMethodImpl(p1, p2, s2)
	end

	if typeof(p2) == "Vector3" then
		return comparitorMethodImpl(p1.X, p2.X, s2) and (comparitorMethodImpl(p1.Y, p2.Y, s2) and comparitorMethodImpl(p1.Z, p2.Z, s2))
	end

	if typeof(p2) == "Color3" then
		return comparitorMethodImpl(p1.R, p2.R, s2) and (comparitorMethodImpl(p1.G, p2.G, s2) and comparitorMethodImpl(p1.B, p2.B, s2))
	end

	return p1 == p2
end
local function extractSubProperty(s3: string, p3) -- line: 84
	if typeof(p3) == "CFrame" and s3 == "PositionMagnitude" then
		return true, p3.Position.Magnitude
	end

	if typeof(p3) == "CFrame" and s3 == "Orientation" then
		return true, (Vector3.new(p3:ToOrientation()))
	end

	if typeof(p3) == "CFrame" and s3 == "Position" then
		return true, p3.Position
	end

	return false
end
local function getAllActiveTestsOnProperty(p4, s4: string, p5, p6) -- line: 96
	-- upvalues: Constants (copy), getAllActiveTestsOnProperty (copy)
	if typeof(p6) ~= "table" then
		return {{
			s4,
			p5,
			p6,
			Constants.COMPARISON_METHODS.FUZZY_EQ
		}}
	end

	for v29, v30 in p6 do
		if v29 ~= Constants.INCLUSION_METHODS.INCLUSION_LIST then
			if v29 ~= Constants.INCLUSION_METHODS.EXCLUSION_LIST or table.find(v30, p4) == nil then
				continue
			end

			return {}
		end

		if table.find(v30, p4) == nil then
			return {}
		end
	end

	local t2 = {}

	for _, v33 in Constants.COMPARISON_METHODS do
		if p6[v33] ~= nil then
			table.insert(t2, {
				s4,
				p5,
				p6[v33],
				v33
			})
		end
	end

	local n3 = 1

	while p6[n3] ~= nil do
		local v35 = getAllActiveTestsOnProperty(p4, s4, p5, p6[n3])

		table.move(v35, 1, #v35, #t2 + 1, t2)
		n3 += 1
	end

	for v36, v37 in p6 do
		local v38, Magnitude

		if typeof(p5) == "CFrame" and v36 == "PositionMagnitude" then
			v38 = true
			Magnitude = p5.Position.Magnitude
		elseif typeof(p5) == "CFrame" and v36 == "Orientation" then
			v38 = true
			Magnitude = Vector3.new(p5:ToOrientation())
		elseif typeof(p5) == "CFrame" and v36 == "Position" then
			v38 = true
			Magnitude = p5.Position
		else
			v38 = false
			Magnitude = nil
		end

		if v38 then
			for _, v41 in (getAllActiveTestsOnProperty(p4, v36, Magnitude, v37)) do
				v41[1] = s4 .. "." .. v41[1]
				table.insert(t2, v41)
			end
		end
	end

	return t2
end

function t1.run(p7, p8) -- line: 149
	-- upvalues: Constants (copy), ErrorSourceStrings (copy), getAllActiveTestsOnProperty (copy), doesPropertyMatchExpectations (copy), valueToString (copy)
	local rootInstance = p8.rootInstance
	local assetType = p8.uploadEnum.assetType
	local descendants = rootInstance:GetDescendants()

	table.insert(descendants, rootInstance)

	for _, v48 in descendants do
		for v49, v50 in Constants.PROPERTIES do
			if v48:IsA(v49) then
				for v51, v52 in v50 do
					local ok, result = pcall(function() -- line: 160
						-- upvalues: v48 (copy), v51 (copy)
						return v48[v51]
					end)

					if not ok then
						p7:fail(ErrorSourceStrings.Keys.PropertyNotFound, {
							PropertyName = v51,
							InstancePath = v48:GetFullName()
						})
					else
						for _, v56 in (getAllActiveTestsOnProperty(assetType, v51, result, v52)) do
							local v57, v58, v59, v60 = table.unpack(v56)

							if not doesPropertyMatchExpectations(v58, v59, v60) then
								p7:fail(ErrorSourceStrings.Keys.PropertyValueInvalid, {
									PropertyName = v57,
									InstancePath = v48:GetFullName(),
									ComparisonMethod = v60,
									ExpectedValue = valueToString(v59)
								})
							end
						end
					end
				end
			end
		end
	end
end

return t1
