local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Collections = require(ParentParentParent.Collections)
local Array = Collections.Array
local Object = Collections.Object
local Boolean = require(ParentParentParent.Boolean)
local String = require(ParentParentParent.String)

require(ParentParentParent.ES7Types)

local inspect = Collections.inspect
local Error = require(ParentParent.Error)
local InstanceOf = require(ParentParentParent.InstanceOf)
local t1 = {
	stderr = {
		isTTY = false,
		columns = 0,
		hasColors = function(...) -- line: 48
			return true
		end
	}
}

function ErrorCaptureStackTrace(p1, ...) -- line: 55
	-- upvalues: Error (copy)
	Error.captureStackTrace(p1, ...)
end

local function removeColors(p2) -- line: 60
	return p2
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

local function copyError(p3) -- line: 88
	-- upvalues: Object (copy)
	local t3 = {}

	for _, v27 in (Object.keys(p3)) do
		t3[v27] = p3[v27]
	end

	t3.message = p3.message

	return t3
end
local function inspectValue(p4) -- line: 99
	-- upvalues: inspect (copy)
	return inspect(p4, {
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
local function createErrDiff(p5, p6, p7) -- line: 114
	-- upvalues: inspect (copy), String (copy), Boolean (copy), t2 (copy), t1 (copy), s1 (ref), s4 (ref), Array (copy), s2 (ref), s3 (ref)
	local s5 = ""
	local s6 = ""
	local s7 = ""
	local v35 = false
	local v36 = inspect(p5, {
		compact = false,
		customInspect = false,
		depth = 1000,
		maxArrayLength = 1e999,
		showHidden = false,
		showProxy = false,
		sorted = true,
		getters = true
	})
	local v37 = String.split(v36, "\n")
	local v38 = String.split(inspect(p6, {
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

	if p7 == "strictEqual" and (typeof(p5) == "table" and p5 ~= nil and typeof(p6) == "table" and p6 ~= nil or typeof(p5) == "function" and typeof(p6) == "function") then
		p7 = "strictEqualObject"
	end

	if #v37 == 1 and #v38 == 1 and v37[1] ~= v38[1] then
		local v41 = v37[1]
		local v42 = if not Boolean.toJSBoolean(false) then v38[1] else v38[1]
		local v43 = string.len(v41) + string.len(v42)

		if v43 <= 12 then
			if (typeof(p5) ~= "table" or p5 == nil) and (typeof(p6) ~= "table" or p6 == nil) and (p5 ~= 0 or p6 ~= 0) then
				return ("%s\n\n"):format(t2[p7]) .. ("%s !== %s\n"):format(v37[1], v38[1])
			end
		elseif p7 ~= "strictEqualObject" and v43 < (not t1.stderr.isTTY and 80 or t1.stderr.columns) then
			while string.sub(v41, n1 + 1, n1 + 1) == string.sub(v42, n1 + 1, n1 + 1) do
				n1 += 1
			end

			if n1 > 2 then
				s8 = ("\n  %s^"):format(string.rep(" ", n1))
				n1 = 0
			end
		end
	end

	local v44 = v37[#v37]
	local v45 = v38[#v38]

	while v44 == v45 do
		local v46 = n1 + 1

		if n1 < 3 then
			s7 = ("\n  %s%s"):format(v44, s7)
		else
			s5 = v44
		end

		table.remove(v37)
		table.remove(v38)
		n1 = v46

		if #v37 == 0 or #v38 == 0 then
			break
		end

		v44 = v37[#v37]
		v45 = v38[#v38]
		n1 = v46
	end

	local v47 = math.max(#v37, #v38)

	if v47 == 0 then
		local v48 = String.split(v36, "\n")

		if #v48 > 50 then
			v48[47] = ("%s...%s"):format(s1, s4)

			while #v48 > 47 do
				table.remove(v48)
			end
		end

		return ("%s\n\n"):format("Values have same structure but are not reference-equal:") .. ("%s\n"):format(Array.join(v48, "\n"))
	end

	if n1 >= 5 then
		s7 = ("\n%s...%s%s"):format(s1, s4, s7)
		v35 = true
	end

	if s5 ~= "" then
		s7 = ("\n  %s%s"):format(s5, s7)
		s5 = ""
	end

	local n2 = 0
	local n3 = 0
	local v51 = t2[p7] .. ("\n%s+ actual%s %s- expected%s"):format(s2, s4, s3, s4)
	local v52 = (" %s...%s Lines skipped"):format(s1, s4)
	local v53 = v37
	local v54 = ("%s+%s"):format(s2, s4)
	local v55 = #v38

	if v47 > #v37 then
		v53 = v38
		v54 = ("%s-%s"):format(s3, s4)
		v55 = #v37
	end

	for i = 1, v47 do
		if v55 < i then
			if n3 > 2 then
				if n3 > 3 then
					if n3 > 4 then
						if n3 == 5 then
							s6 ..= ("\n  %s"):format(v53[i - 3])
							n2 += 1
						else
							s6 ..= ("\n%s...%s"):format(s1, s4)
							v35 = true
						end
					end

					s6 ..= ("\n  %s"):format(v53[i - 2])
					n2 += 1
				end

				s6 ..= ("\n  %s"):format(v53[i - 1])
				n2 += 1
			end

			n3 = 0

			if v53 == v37 then
				s6 ..= ("\n%s %s"):format(v54, v53[i])
			else
				s5 ..= ("\n%s %s"):format(v54, v53[i])
			end

			n2 += 1
		else
			local v57 = v38[i]
			local v58 = v37[i]
			local v59 = v58 ~= v57 and (not Boolean.toJSBoolean(String.endsWith(v58, ",")) or v57 ~= String.slice(v58, 0, -1))

			if v59 and String.endsWith(v57, ",") and v58 == String.slice(v57, 0, -1) then
				v59 = false
				v58 ..= ","
			end

			if v59 then
				if n3 > 2 then
					if n3 > 3 then
						if n3 > 4 then
							if n3 == 5 then
								s6 ..= ("\n  %s"):format(v37[i - 3])
								n2 += 1
							else
								s6 ..= ("\n%s...%s"):format(s1, s4)
								v35 = true
							end
						end

						s6 ..= ("\n  %s"):format(v37[i - 2])
						n2 += 1
					end

					s6 ..= ("\n  %s"):format(v37[i - 1])
					n2 += 1
				end

				n3 = 0
				s6 ..= ("\n%s+%s %s"):format(s2, s4, v58)
				s5 ..= ("\n%s-%s %s"):format(s3, s4, v57)
				n2 += 2
			else
				s6 ..= s5
				s5 = ""
				n3 += 1

				if n3 <= 2 then
					s6 ..= ("\n  %s"):format(v58)
					n2 += 1
				end
			end
		end

		if n2 > 50 and i < v47 - 2 then
			return ("%s%s\n%s\n%s...%s%s\n"):format(v51, v52, s6, s1, s4, s5) .. ("%s...%s"):format(s1, s4)
		end
	end

	return ("%s%s\n%s%s%s%s"):format(v51, not v35 and "" or v52, s6, s5, s7, s8)
end

local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.__tostring(p8) -- line: 394
	return p8:toString()
end
function self.new(t4: {[any]: any}) -- line: 407
	-- upvalues: Error (copy), self (copy), t1 (copy), s1 (ref), s2 (ref), s4 (ref), s3 (ref), Array (copy), Object (copy), InstanceOf (copy), createErrDiff (copy), t2 (copy), String (copy), inspect (copy), Boolean (copy)
	local message = t4.message
	local operator = t4.operator
	local stackStartFn = t4.stackStartFn
	local actual = t4.actual
	local expected = t4.expected
	local v67

	if message ~= nil then
		v67 = setmetatable(Error.new((tostring(message))), self)
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

		if typeof(actual) == "table" and actual ~= nil and typeof(expected) == "table" and expected ~= nil and Array.indexOf(Object.keys(actual), "stack") ~= -1 and InstanceOf(actual, Error) and Array.indexOf(Object.keys(expected), "stack") ~= -1 and InstanceOf(expected, Error) then
			local t5 = {}

			for _, v70 in (Object.keys(actual)) do
				t5[v70] = actual[v70]
			end

			t5.message = actual.message
			actual = t5

			local t6 = {}

			for _, v73 in (Object.keys(expected)) do
				t6[v73] = expected[v73]
			end

			t6.message = expected.message
			expected = t6
		end

		if operator == "deepStrictEqual" or operator == "strictEqual" then
			v67 = setmetatable(Error.new(createErrDiff(actual, expected, operator)), self)
		elseif operator == "notDeepStrictEqual" or operator == "notStrictEqual" then
			local v74 = t2[operator]
			local v75 = String.split(inspect(actual, {
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
				v74 = "Expected \"actual\" not to be reference-equal to \"expected\":"
			end

			if #v75 > 50 then
				v75[47] = ("%s...%s"):format(s1, s4)

				while #v75 > 47 do
					table.remove(v75)
				end
			end

			v67 = if #v75 ~= 1 then setmetatable(Error.new(("%s\n\n%s\n"):format(v74, Array.join(v75, "\n"))), self) else setmetatable(Error.new(("%s%s%s"):format(v74, not (string.len(v75[1]) > 5) and " " or "\n\n", v75[1])), self)
		else
			local v76 = inspect(actual, {
				compact = false,
				customInspect = false,
				depth = 1000,
				maxArrayLength = 1e999,
				showHidden = false,
				showProxy = false,
				sorted = true,
				getters = true
			})
			local v77 = inspect(expected, {
				compact = false,
				customInspect = false,
				depth = 1000,
				maxArrayLength = 1e999,
				showHidden = false,
				showProxy = false,
				sorted = true,
				getters = true
			})
			local v78 = t2[tostring(operator)]

			if operator == "notDeepEqual" and v76 == v77 then
				local v79 = ("%s\n\n%s"):format(v78, v76)

				if string.len(v79) > 1024 then
					v79 = ("%s..."):format(String.slice(v79, 0, 1021))
				end

				v67 = setmetatable(Error.new(v79), self)
			else
				if string.len(v76) > 512 then
					v76 = ("%s..."):format(String.slice(v76, 0, 509))
				end

				if string.len(v77) > 512 then
					v77 = ("%s..."):format(String.slice(v77, 0, 509))
				end

				if operator == "deepEqual" then
					v76 = ("%s\n\n%s\n\nshould loosely deep-equal\n\n"):format(v78, v76)
				else
					local v80 = t2[("%sUnequal"):format((tostring(operator)))]

					if Boolean.toJSBoolean(v80) then
						v76 = ("%s\n\n%s\n\nshould not loosely deep-equal\n\n"):format(v80, v76)
					else
						v77 = (" %s %s"):format(tostring(operator), v77)
					end
				end

				v67 = setmetatable(Error.new(("%s%s"):format(v76, v77)), self)
			end
		end
	end

	v67.generatedMessage = not Boolean.toJSBoolean(message)
	v67.name = "AssertionError [ERR_ASSERTION]"
	v67.code = "ERR_ASSERTION"
	v67.actual = actual
	v67.expected = expected
	v67.operator = operator
	ErrorCaptureStackTrace(v67, stackStartFn or self.new)
	v67.name = "AssertionError"

	return v67
end
function self.toString(p9) -- line: 576
	return ("%s [%s]: %s"):format(p9.name, p9.code, p9.message)
end

self.name = "AssertionError"

return {
	AssertionError = self
}
