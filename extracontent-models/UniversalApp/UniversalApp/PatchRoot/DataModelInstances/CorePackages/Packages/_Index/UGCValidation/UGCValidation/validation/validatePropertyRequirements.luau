local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Parent.Cryo)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local valueToString = require(ParentParent.util.valueToString)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

local function comparitorMethodImpl(n1: number, n2: number, s1: string) -- line: 45
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
local function doesPropertyMatchExpectations(p1, p2, s2: string) -- line: 63
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
local function validatePropertyValue(p3, p4, s3: string, p5, p6, s4: string) -- line: 98
	-- upvalues: doesPropertyMatchExpectations (copy), Analytics (copy), valueToString (copy)
	if not doesPropertyMatchExpectations(p5, p6, s4) then
		Analytics.reportFailure(Analytics.ErrorType.validateProperties_PropertyMismatch, nil, p3)

		return false, { string.format("Property %s of %s is invalid. Expected to be %s %s.", s3, p4:GetFullName(), s4, valueToString(p6)) }
	end

	return true
end
local function extractSubProperty(s5: string, p7) -- line: 123
	if typeof(p7) == "CFrame" and s5 == "PositionMagnitude" then
		return true, p7.Position.Magnitude
	end

	if typeof(p7) == "CFrame" and s5 == "Orientation" then
		return true, (Vector3.new(p7:ToOrientation()))
	end

	if typeof(p7) == "CFrame" and s5 == "Position" then
		return true, p7.Position
	end

	return false
end
local function getAllActiveTestsOnProperty(p8, s6: string, p9, p10) -- line: 135
	-- upvalues: Constants (copy), getAllActiveTestsOnProperty (copy)
	if typeof(p10) ~= "table" then
		return {{
			s6,
			p9,
			p10,
			Constants.COMPARISON_METHODS.FUZZY_EQ
		}}
	end

	for v35, v36 in p10 do
		if v35 ~= Constants.INCLUSION_METHODS.INCLUSION_LIST then
			if v35 ~= Constants.INCLUSION_METHODS.EXCLUSION_LIST or table.find(v36, p8) == nil then
				continue
			end

			return {}
		end

		if table.find(v36, p8) == nil then
			return {}
		end
	end

	local t1 = {}

	for _, v39 in Constants.COMPARISON_METHODS do
		if p10[v39] ~= nil then
			table.insert(t1, {
				s6,
				p9,
				p10[v39],
				v39
			})
		end
	end

	local n3 = 1

	while p10[n3] ~= nil do
		local v41 = getAllActiveTestsOnProperty(p8, s6, p9, p10[n3])

		table.move(v41, 1, #v41, #t1 + 1, t1)
		n3 += 1
	end

	for v42, v43 in p10 do
		local v44, Magnitude

		if typeof(p9) == "CFrame" and v42 == "PositionMagnitude" then
			v44 = true
			Magnitude = p9.Position.Magnitude
		elseif typeof(p9) == "CFrame" and v42 == "Orientation" then
			v44 = true
			Magnitude = Vector3.new(p9:ToOrientation())
		elseif typeof(p9) == "CFrame" and v42 == "Position" then
			v44 = true
			Magnitude = p9.Position
		else
			v44 = false
			Magnitude = nil
		end

		if v44 then
			for _, v47 in (getAllActiveTestsOnProperty(p8, v42, Magnitude, v43)) do
				v47[1] = s6 .. "." .. v47[1]
				table.insert(t1, v47)
			end
		end
	end

	return t1
end
local function validatePropertyRequirements(p11, p12, p13) -- line: 195
	-- upvalues: FailureReasonsAccumulator (copy), Constants (copy), Analytics (copy), getAllActiveTestsOnProperty (copy), validatePropertyValue (copy)
	if p12 == nil then
		p12 = p13.assetTypeEnum
	end

	local descendants = p11:GetDescendants()

	table.insert(descendants, p11)

	local v52 = FailureReasonsAccumulator.new()

	for _, v54 in descendants do
		for v55, v56 in Constants.PROPERTIES do
			if v54:IsA(v55) then
				for v57, v58 in v56 do
					local ok, result = pcall(function() -- line: 215
						-- upvalues: v54 (copy), v57 (copy)
						return v54[v57]
					end)

					if not ok then
						Analytics.reportFailure(Analytics.ErrorType.validateProperties_PropertyDoesNotExist, nil, p13)
						v52:updateReasons(false, { string.format("Property '%s' not found in '%s'", v57, v54:GetFullName()) })
					else
						for _, v62 in (getAllActiveTestsOnProperty(p12, v57, result, v58)) do
							local v63, v64, v65, v66 = table.unpack(v62)

							v52:updateReasons(validatePropertyValue(p13, v54, v63, v64, v65, v66))
						end
					end
				end
			end
		end
	end

	return v52:getFinalResults()
end

return validatePropertyRequirements
