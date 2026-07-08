local ParentParent = script.Parent.Parent
local Array = require(ParentParent.Array)
local Boolean = require(ParentParent.Boolean)
local Object = require(ParentParent.Object)
local String = require(ParentParent.String)
local Error = require(ParentParent.Error)
local instanceof = require(ParentParent.instanceof)
local inspect = require(ParentParent.util.inspect)

require(ParentParent.types)

local t1 = {
	stderr = {
		isTTY = false,
		columns = 0,
		hasColors = function(...) -- line: 24
			return true
		end
	}
}

function ErrorCaptureStackTrace(...) -- line: 31
end

local function removeColors(p1) -- line: 34
	return p1
end

local s1 = ""
local s2 = ""
local s3 = ""
local s4 = ""
local t2 = {
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

local function copyError(p2) -- line: 62
	-- upvalues: Object (copy)
	local t3 = {}

	for _, v24 in (Object.keys(p2)) do
		t3[v24] = p2[v24]
	end

	t3.message = p2.message

	return t3
end
local function inspectValue(p3) -- line: 73
	-- upvalues: inspect (copy)
	return inspect(p3, {
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
local function createErrDiff(p4, p5, p6) -- line: 88
	-- upvalues: inspect (copy), String (copy), Boolean (copy), t2 (copy), t1 (copy), s1 (ref), s4 (ref), Array (copy), s2 (ref), s3 (ref)
	local s5 = ""
	local s6 = ""
	local s7 = ""
	local v32 = false
	local v33 = inspect(p4, {
		compact = false,
		customInspect = false,
		depth = 1000,
		maxArrayLength = 1e999,
		showHidden = false,
		showProxy = false,
		sorted = true,
		getters = true
	})
	local v34 = String.split(v33, "\n")
	local v35 = String.split(inspect(p5, {
		compact = false,
		customInspect = false,
		depth = 1000,
		maxArrayLength = 1e999,
		showHidden = false,
		showProxy = false,
		sorted = true,
		getters = true
	}), "\n")
	local n1 = 0
	local s8 = ""

	if p6 == "strictEqual" and (typeof(p4) == "table" and p4 ~= nil and typeof(p5) == "table" and p5 ~= nil or typeof(p4) == "function" and typeof(p5) == "function") then
		p6 = "strictEqualObject"
	end

	if #v34 == 1 and #v35 == 1 and v34[1] ~= v35[1] then
		local v38 = v34[1]
		local v39 = if not Boolean.toJSBoolean(false) then v35[1] else v35[1]
		local v40 = string.len(v38) + string.len(v39)

		if v40 <= 12 then
			if (typeof(p4) ~= "table" or p4 == nil) and (typeof(p5) ~= "table" or p5 == nil) and (p4 ~= 0 or p5 ~= 0) then
				return ("%s\n\n"):format(t2[p6]) .. ("%s !== %s\n"):format(v34[1], v35[1])
			end
		elseif p6 ~= "strictEqualObject" and v40 < (not t1.stderr.isTTY and 80 or t1.stderr.columns) then
			while string.sub(v38, n1 + 1, n1 + 1) == string.sub(v39, n1 + 1, n1 + 1) do
				n1 += 1
			end

			if n1 > 2 then
				s8 = ("\n  %s^"):format(string.rep(" ", n1))
				n1 = 0
			end
		end
	end

	local v41 = v34[#v34]
	local v42 = v35[#v35]

	while v41 == v42 do
		local v43 = n1 + 1

		if n1 < 3 then
			s7 = ("\n  %s%s"):format(v41, s7)
		else
			s5 = v41
		end

		table.remove(v34)
		table.remove(v35)
		n1 = v43

		if #v34 == 0 or #v35 == 0 then
			break
		end

		v41 = v34[#v34]
		v42 = v35[#v35]
		n1 = v43
	end

	local v44 = math.max(#v34, #v35)

	if v44 == 0 then
		local v45 = String.split(v33, "\n")

		if #v45 > 50 then
			v45[47] = ("%s...%s"):format(s1, s4)

			while #v45 > 47 do
				table.remove(v45)
			end
		end

		return ("%s\n\n"):format("Values have same structure but are not reference-equal:") .. ("%s\n"):format(Array.join(v45, "\n"))
	end

	if n1 >= 5 then
		s7 = ("\n%s...%s%s"):format(s1, s4, s7)
		v32 = true
	end

	if s5 ~= "" then
		s7 = ("\n  %s%s"):format(s5, s7)
		s5 = ""
	end

	local n2 = 0
	local n3 = 0
	local v48 = t2[p6] .. ("\n%s+ actual%s %s- expected%s"):format(s2, s4, s3, s4)
	local v49 = (" %s...%s Lines skipped"):format(s1, s4)
	local v50 = v34
	local v51 = ("%s+%s"):format(s2, s4)
	local v52 = #v35

	if v44 > #v34 then
		v50 = v35
		v51 = ("%s-%s"):format(s3, s4)
		v52 = #v34
	end

	for i = 1, v44 do
		if v52 < i then
			if n3 > 2 then
				if n3 > 3 then
					if n3 > 4 then
						if n3 == 5 then
							s6 ..= ("\n  %s"):format(v50[i - 3])
							n2 += 1
						else
							s6 ..= ("\n%s...%s"):format(s1, s4)
							v32 = true
						end
					end

					s6 ..= ("\n  %s"):format(v50[i - 2])
					n2 += 1
				end

				s6 ..= ("\n  %s"):format(v50[i - 1])
				n2 += 1
			end

			n3 = 0

			if v50 == v34 then
				s6 ..= ("\n%s %s"):format(v51, v50[i])
			else
				s5 ..= ("\n%s %s"):format(v51, v50[i])
			end

			n2 += 1
		else
			local v54 = v35[i]
			local v55 = v34[i]
			local v56 = v55 ~= v54 and (not Boolean.toJSBoolean(String.endsWith(v55, ",")) or v54 ~= String.slice(v55, 0, -1))

			if v56 and String.endsWith(v54, ",") and v55 == String.slice(v54, 0, -1) then
				v56 = false
				v55 ..= ","
			end

			if v56 then
				if n3 > 2 then
					if n3 > 3 then
						if n3 > 4 then
							if n3 == 5 then
								s6 ..= ("\n  %s"):format(v34[i - 3])
								n2 += 1
							else
								s6 ..= ("\n%s...%s"):format(s1, s4)
								v32 = true
							end
						end

						s6 ..= ("\n  %s"):format(v34[i - 2])
						n2 += 1
					end

					s6 ..= ("\n  %s"):format(v34[i - 1])
					n2 += 1
				end

				n3 = 0
				s6 ..= ("\n%s+%s %s"):format(s2, s4, v55)
				s5 ..= ("\n%s-%s %s"):format(s3, s4, v54)
				n2 += 2
			else
				s6 ..= s5
				s5 = ""
				n3 += 1

				if n3 <= 2 then
					s6 ..= ("\n  %s"):format(v55)
					n2 += 1
				end
			end
		end

		if n2 > 50 and i < v44 - 2 then
			return ("%s%s\n%s\n%s...%s%s\n"):format(v48, v49, s6, s1, s4, s5) .. ("%s...%s"):format(s1, s4)
		end
	end

	return ("%s%s\n%s%s%s%s"):format(v48, not v32 and "" or v49, s6, s5, s7, s8)
end

local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.__tostring(p7) -- line: 368
	return p7:toString()
end
function self.new(t4: {[any]: any}) -- line: 381
	-- upvalues: Error (copy), self (copy), t1 (copy), s1 (ref), s2 (ref), s4 (ref), s3 (ref), Array (copy), Object (copy), instanceof (copy), createErrDiff (copy), t2 (copy), String (copy), inspect (copy), Boolean (copy)
	local message = t4.message
	local operator = t4.operator
	local stackStartFn = t4.stackStartFn
	local actual = t4.actual
	local expected = t4.expected
	local v64

	if message ~= nil then
		v64 = setmetatable(Error.new((tostring(message))), self)
	else
		if t1.stderr.isTTY then
			if t1.stderr:hasColors() then
				s1 = "\027[34m"
				s2 = "\027[32m"
				s4 = "\027[39m"
				s3 = "\027[31m"
			else
				s1 = ""
				s2 = ""
				s4 = ""
				s3 = ""
			end
		end

		if typeof(actual) == "table" and actual ~= nil and typeof(expected) == "table" and expected ~= nil and Array.indexOf(Object.keys(actual), "stack") ~= -1 and instanceof(actual, Error) and Array.indexOf(Object.keys(expected), "stack") ~= -1 and instanceof(expected, Error) then
			local t5 = {}

			for _, v67 in (Object.keys(actual)) do
				t5[v67] = actual[v67]
			end

			t5.message = actual.message
			actual = t5

			local t6 = {}

			for _, v70 in (Object.keys(expected)) do
				t6[v70] = expected[v70]
			end

			t6.message = expected.message
			expected = t6
		end

		if operator == "deepStrictEqual" or operator == "strictEqual" then
			v64 = setmetatable(Error.new(createErrDiff(actual, expected, operator)), self)
		elseif operator == "notDeepStrictEqual" or operator == "notStrictEqual" then
			local v71 = t2[operator]
			local v72 = String.split(inspect(actual, {
				compact = false,
				customInspect = false,
				depth = 1000,
				maxArrayLength = 1e999,
				showHidden = false,
				showProxy = false,
				sorted = true,
				getters = true
			}), "\n")

			if operator == "notStrictEqual" and (typeof(actual) == "table" and actual ~= nil or typeof(actual) == "function") then
				v71 = "Expected \"actual\" not to be reference-equal to \"expected\":"
			end

			if #v72 > 50 then
				v72[47] = ("%s...%s"):format(s1, s4)

				while #v72 > 47 do
					table.remove(v72)
				end
			end

			v64 = if #v72 ~= 1 then setmetatable(Error.new(("%s\n\n%s\n"):format(v71, Array.join(v72, "\n"))), self) else setmetatable(Error.new(("%s%s%s"):format(v71, not (string.len(v72[1]) > 5) and " " or "\n\n", v72[1])), self)
		else
			local v73 = inspect(actual, {
				compact = false,
				customInspect = false,
				depth = 1000,
				maxArrayLength = 1e999,
				showHidden = false,
				showProxy = false,
				sorted = true,
				getters = true
			})
			local v74 = inspect(expected, {
				compact = false,
				customInspect = false,
				depth = 1000,
				maxArrayLength = 1e999,
				showHidden = false,
				showProxy = false,
				sorted = true,
				getters = true
			})
			local v75 = t2[tostring(operator)]

			if operator == "notDeepEqual" and v73 == v74 then
				local v76 = ("%s\n\n%s"):format(v75, v73)

				if string.len(v76) > 1024 then
					v76 = ("%s..."):format(String.slice(v76, 0, 1021))
				end

				v64 = setmetatable(Error.new(v76), self)
			else
				if string.len(v73) > 512 then
					v73 = ("%s..."):format(String.slice(v73, 0, 509))
				end

				if string.len(v74) > 512 then
					v74 = ("%s..."):format(String.slice(v74, 0, 509))
				end

				if operator == "deepEqual" then
					v73 = ("%s\n\n%s\n\nshould loosely deep-equal\n\n"):format(v75, v73)
				else
					local v77 = t2[("%sUnequal"):format((tostring(operator)))]

					if Boolean.toJSBoolean(v77) then
						v73 = ("%s\n\n%s\n\nshould not loosely deep-equal\n\n"):format(v77, v73)
					else
						v74 = (" %s %s"):format(tostring(operator), v74)
					end
				end

				v64 = setmetatable(Error.new(("%s%s"):format(v73, v74)), self)
			end
		end
	end

	v64.generatedMessage = not Boolean.toJSBoolean(message)
	v64.name = "AssertionError [ERR_ASSERTION]"
	v64.code = "ERR_ASSERTION"
	v64.actual = actual
	v64.expected = expected
	v64.operator = operator
	ErrorCaptureStackTrace(v64, stackStartFn)
	v64.name = "AssertionError"

	return v64
end
function self.toString(p8) -- line: 550
	return ("%s [%s]: %s"):format(p8.name, p8.code, p8.message)
end

self.name = "AssertionError"

return {
	AssertionError = self
}
