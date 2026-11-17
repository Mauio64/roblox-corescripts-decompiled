local parent = script.Parent.Parent
local parent2 = parent.Parent

local Collections = require(parent2.Collections)
local Array = Collections.Array
local Object = Collections.Object
local Boolean = require(parent2.Boolean)
local String = require(parent2.String)
require(parent2.ES7Types)
local inspect = Collections.inspect

local Error = require(parent.Error)
local InstanceOf = require(parent2.InstanceOf)

local v = {
	stderr = {
		isTTY = false,
		columns = 0,
		hasColors = function(...): boolean
			return true
		end
	}
}

function ErrorCaptureStackTrace(p, ...)
	Error.captureStackTrace(p, ...)
end

local function removeColors(p)
	return p
end

local v2 = ""
local v3 = ""
local v4 = ""
local v5 = ""
local v6 = {
	deepStrictEqual = "Expected values to be strictly deep-equal:",
	strictEqual = "Expected values to be strictly equal:",
	strictEqualObject = "Expected \"actual\" to be reference-equal to \"expected\":",
	deepEqual = "Expected values to be loosely deep-equal:",
	notDeepStrictEqual = "Expected \"actual\" not to be strictly deep-equal to:",
	notStrictEqual = "Expected \"actual\" to be strictly unequal to:",
	notStrictEqualObject = "Expected \"actual\" not to be reference-equal to \"expected\":",
	notDeepEqual = "Expected \"actual\" not to be loosely deep-equal to:",
	notIdentical = "Values have same structure but are not reference-equal:",
	notDeepEqualUnequal = "Expected values not to be loosely deep-equal:"
}

local function copyError(p)
	local keys = Object.keys(p)

	local result = {}

	for _, key in keys do
		result[key] = p[key]
	end

	result.message = p.message
	return result
end

local function inspectValue(p) -- 5 equivalent calls inferred from this helper
	return inspect(p, {
		compact = false,
		customInspect = false,
		depth = 1000,
		maxArrayLength = 1e999,
		showHidden = false,
		showProxy = false,
		sorted = true,
		getters = true
	})
end

local function createErrDiff(value, value2, operator)
	local v7 = ""
	local v8 = ""
	local v9 = ""
	local v10 = false
	local v11 = inspectValue(value) -- inferred equivalent call
	local parts = String.split(v11, "\n")
	local parts2 = String.split(inspectValue(value2), "\n") -- inferred equivalent call

	local v12 = 0
	local v13 = ""

	local v14 = operator == "strictEqual"
		and (typeof(value) == "table" and value ~= nil and typeof(value2) == "table" and value2 ~= nil or typeof(value) == "function" and typeof(value2) == "function")
		and "strictEqualObject"
		or operator

	if #parts == 1 and #parts2 == 1 and parts[1] ~= parts2[1] then
		local part = parts[1]

		if Boolean.toJSBoolean(false) then
		end

		local part2 = parts2[1]
		local v15 = string.len(part) + string.len(part2)

		if v15 <= 12 then
			if
				(typeof(value) ~= "table" or value == nil)
				and (typeof(value2) ~= "table" or value2 == nil)
				and (value ~= 0 or value2 ~= 0)
			then
				return ("%s\n\n"):format(v6[v14]) .. ("%s !== %s\n"):format(parts[1], parts2[1])
			end
		elseif v14 ~= "strictEqualObject" and v15 < (not v.stderr.isTTY and 80 or v.stderr.columns) then
			while string.sub(part, v12 + 1, v12 + 1) == string.sub(part2, v12 + 1, v12 + 1) do
				v12 += 1
			end

			if v12 > 2 then
				v13 = ("\n  %s^"):format(string.rep(" ", v12))
				v12 = 0
			end
		end
	end

	local v15 = parts[#parts]
	local v16 = parts2[#parts2]
	local v17

	while true do
		if v15 ~= v16 then
			v17 = v12
			break
		end

		v17 = v12 + 1

		if v12 < 3 then
			v9 = ("\n  %s%s"):format(v15, v9)
		else
			v7 = v15
		end

		table.remove(parts)
		table.remove(parts2)

		if #parts == 0 or #parts2 == 0 then
			break
		end

		v15 = parts[#parts]
		v16 = parts2[#parts2]
		v12 = v17
	end

	local v18 = math.max(#parts, #parts2)

	if v18 == 0 then
		local parts3 = String.split(v11, "\n")

		if #parts3 > 50 then
			parts3[47] = ("%s...%s"):format(v2, v5)

			while #parts3 > 47 do
				table.remove(parts3)
			end
		end

		return ("%s\n\n"):format("Values have same structure but are not reference-equal:") .. ("%s\n"):format(Array.join(parts3, "\n"))
	else
		if v17 >= 5 then
			v9 = ("\n%s...%s%s"):format(v2, v5, v9)
			v10 = true
		end

		if v7 ~= "" then
			v9 = ("\n  %s%s"):format(v7, v9)
			v7 = ""
		end

		local total = 0
		local count = 0
		local v19 = v6[v14] .. ("\n%s+ actual%s %s- expected%s"):format(v3, v5, v4, v5)
		local formatted = (" %s...%s Lines skipped"):format(v2, v5)

		local v20 = ("%s+%s"):format(v3, v5)
		local v21 = #parts2
		local v22

		if #parts < v18 then
			v20 = ("%s-%s"):format(v4, v5)
			v21 = #parts
			v22 = parts2
		else
			v22 = parts
		end

		for i = 1, v18 do
			if v21 < i then
				if count > 2 then
					if count > 3 then
						if count > 4 then
							if count == 5 then
								v8 ..= ("\n  %s"):format(v22[i - 3])
								total += 1
							else
								v8 ..= ("\n%s...%s"):format(v2, v5)
								v10 = true
							end
						end

						v8 ..= ("\n  %s"):format(v22[i - 2])
						total += 1
					end

					v8 ..= ("\n  %s"):format(v22[i - 1])
					total += 1
				end

				count = 0

				if v22 == parts then
					v8 ..= ("\n%s %s"):format(v20, v22[i])
				else
					v7 ..= ("\n%s %s"):format(v20, v22[i])
				end

				total += 1
			else
				local part = parts2[i]
				local v23 = parts[i]
				local v24

				if v23 == part then
					v24 = false
				else
					v24 = not Boolean.toJSBoolean(String.endsWith(v23, ",")) or String.slice(v23, 0, -1) ~= part
				end

				if v24 and String.endsWith(part, ",") and String.slice(part, 0, -1) == v23 then
					v23 ..= ","
					v24 = false
				end

				if v24 then
					if count > 2 then
						if count > 3 then
							if count > 4 then
								if count == 5 then
									v8 ..= ("\n  %s"):format(parts[i - 3])
									total += 1
								else
									v8 ..= ("\n%s...%s"):format(v2, v5)
									v10 = true
								end
							end

							v8 ..= ("\n  %s"):format(parts[i - 2])
							total += 1
						end

						v8 ..= ("\n  %s"):format(parts[i - 1])
						total += 1
					end

					v8 ..= ("\n%s+%s %s"):format(v3, v5, v23)
					v7 ..= ("\n%s-%s %s"):format(v4, v5, part)
					total += 2
					count = 0
				else
					v8 ..= v7
					v7 = ""
					count += 1

					if count <= 2 then
						v8 ..= ("\n  %s"):format(v23)
						total += 1
					end
				end
			end

			if total > 50 and i < v18 - 2 then
				return ("%s%s\n%s\n%s...%s%s\n"):format(v19, formatted, v8, v2, v5, v7) .. ("%s...%s"):format(v2, v5)
			end
		end

		return ("%s%s\n%s%s%s%s"):format(v19, not v10 and "" or formatted, v8, v7, v9, v13)
	end
end

local object = setmetatable({}, { __index = Error })

object.__index = object
function object:__tostring()
	return self:toString()
end

function object.new(data)
	local message = data.message
	local operator = data.operator
	local stackStartFn = data.stackStartFn
	local actual = data.actual
	local expected = data.expected
	local v7

	if message == nil then
		if v.stderr.isTTY then
			if v.stderr:hasColors() then
				v2 = "\27[34m"
				v3 = "\27[32m"
				v5 = "\27[39m"
				v4 = "\27[31m"
			else
				v2 = ""
				v3 = ""
				v5 = ""
				v4 = ""
			end
		end

		if
			typeof(actual) == "table"
			and actual ~= nil
			and typeof(expected) == "table"
			and expected ~= nil
			and Array.indexOf(Object.keys(actual), "stack") ~= -1
			and InstanceOf(actual, Error)
			and Array.indexOf(Object.keys(expected), "stack") ~= -1
			and InstanceOf(expected, Error)
		then
			local keys = Object.keys(actual)
			local v8 = actual
			actual = {}

			for _, key in keys do
				actual[key] = v8[key]
			end

			actual.message = v8.message
			local keys2 = Object.keys(expected)
			local v9 = expected
			expected = {}

			for _, key in keys2 do
				expected[key] = v9[key]
			end

			expected.message = v9.message
		end

		if operator == "deepStrictEqual" or operator == "strictEqual" then
			v7 = setmetatable(Error.new(createErrDiff(actual, expected, operator)), object)
		elseif operator == "notDeepStrictEqual" or operator == "notStrictEqual" then
			local v8 = v6[operator]
			local parts = String.split(inspectValue(actual), "\n") -- inferred equivalent call

			local v9 = operator == "notStrictEqual"
				and (typeof(actual) == "table" and actual ~= nil or typeof(actual) == "function")
				and "Expected \"actual\" not to be reference-equal to \"expected\":"
				or v8

			if #parts > 50 then
				parts[47] = ("%s...%s"):format(v2, v5)

				while #parts > 47 do
					table.remove(parts)
				end
			end

			if #parts == 1 then
				v7 = setmetatable(
					Error.new(("%s%s%s"):format(v9, string.len(parts[1]) > 5 and "\n\n" or " ", parts[1])),
					object
				)
			else
				v7 = setmetatable(Error.new(("%s\n\n%s\n"):format(v9, Array.join(parts, "\n"))), object)
			end
		else
			local v8 = inspectValue(actual) -- inferred equivalent call
			local v9 = inspectValue(expected) -- inferred equivalent call
			local v10 = v6[tostring(operator)]

			if operator == "notDeepEqual" and v8 == v9 then
				local v11 = ("%s\n\n%s"):format(v10, v8)

				if string.len(v11) > 1024 then
					v11 = ("%s..."):format(String.slice(v11, 0, 1021))
				end

				v7 = setmetatable(Error.new(v11), object)
			else
				if string.len(v8) > 512 then
					v8 = ("%s..."):format(String.slice(v8, 0, 509))
				end

				if string.len(v9) > 512 then
					v9 = ("%s..."):format(String.slice(v9, 0, 509))
				end

				if operator == "deepEqual" then
					v8 = ("%s\n\n%s\n\nshould loosely deep-equal\n\n"):format(v10, v8)
				else
					local v11 = v6[("%sUnequal"):format((tostring(operator)))]

					if Boolean.toJSBoolean(v11) then
						v8 = ("%s\n\n%s\n\nshould not loosely deep-equal\n\n"):format(v11, v8)
					else
						v9 = (" %s %s"):format(tostring(operator), v9)
					end
				end

				v7 = setmetatable(Error.new(("%s%s"):format(v8, v9)), object)
			end
		end
	else
		v7 = setmetatable(Error.new((tostring(message))), object)
	end

	v7.generatedMessage = not Boolean.toJSBoolean(message)

	v7.name = "AssertionError [ERR_ASSERTION]"
	v7.code = "ERR_ASSERTION"

	v7.actual = actual
	v7.expected = expected
	v7.operator = operator

	ErrorCaptureStackTrace(v7, stackStartFn or object.new)

	v7.name = "AssertionError"
	return v7
end

function object:toString()
	return ("%s [%s]: %s"):format(self.name, self.code, self.message)
end

object.name = "AssertionError"

return { AssertionError = object }
