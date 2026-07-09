local Parent = script:FindFirstAncestor("ErrorReporters").Parent
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local ProcessErrorStack = require(script.Parent.Parent.ProcessErrorStack)
local Constants = require(script.Parent.Constants)
local v6 = t.optional(t.map(t.string, t.some(t.string, t.number, t.boolean)))
local v7 = t.optional(t.map(t.string, function(p1) -- line: 53
	-- upvalues: t (copy)
	local function checkTypeRecursive(p2) -- line: 54
		-- upvalues: checkTypeRecursive (copy), t (copy)
		if type(p2) == "table" then
			for k, v in pairs(p2) do
				local v52, v53 = checkTypeRecursive(v)

				if not v52 then
					return false, string.format("error when checking key: %s - %s", k, v53 or "unknown error")
				end
			end

			return true, nil
		end

		return t.some(t.string, t.number, t.boolean)(p2), nil
	end

	local v17, v18 = checkTypeRecursive(p1)

	return v17, v18
end))
local v8 = t.map(t.string, t.some(t.string, t.number, t.boolean))
local v9 = t.optional(t.map(t.string, v8))
local v10 = t.strictInterface({
	guessed_frame = t.optional(t.boolean),
	funcName = t.optional(t.string),
	address = t.optional(t.string),
	line = t.optional(t.string),
	column = t.optional(t.string),
	sourceCode = t.optional(t.string),
	library = t.optional(t.string),
	debug_identifier = t.optional(t.string),
	faulted = t.optional(t.boolean),
	registers = t.optional(t.map(t.string, t.some(t.string, t.number)))
})
local v11 = t.strictInterface({
	name = t.optional(t.string),
	fault = t.optional(t.boolean),
	stack = t.optional(t.array(v10))
})
local v12 = t.intersection(t.strictInterface({
	threads = t.map(t.string, v11),
	message = t.optional(t.string),
	level = t.optional(t.string),
	attributes = v6,
	annotations = v7,
	customMetadata = v9
}))
local t1 = {
	IAttributes = v6,
	IAnnotations = v7,
	ICustomMetadata = v9
}

t1.__index = t1

function t1.validate(p3) -- line: 144
	-- upvalues: v12 (copy)
	return v12(p3)
end
function t1.new() -- line: 154
	-- upvalues: t1 (copy)
	local t2 = {
		threads = {},
		attributes = {},
		annotations = {},
		customMetadata = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addAttributes(t3: {[any]: any}, t4: {[any]: any}) -- line: 172
	-- upvalues: Cryo (copy)
	if type(t4) ~= "table" then
		warn("Cannot add attributes of type: ", (type(t4)))

		return
	end

	local attributes = t3.attributes

	t3.attributes = Cryo.Dictionary.join(attributes, t4)
end
function t1.addAnnotations(t5: {[any]: any}, t6: {[any]: any}) -- line: 190
	-- upvalues: Cryo (copy)
	if type(t6) ~= "table" then
		warn("Cannot add annotations of type: ", (type(t6)))

		return
	end

	local annotations = t5.annotations

	t5.annotations = Cryo.Dictionary.join(annotations, t6)
end

local function sanitizeCustomMetadataGroup(p4) -- line: 212
	if type(p4) ~= "table" then
		return nil
	end

	local t7 = {}

	for k, v in pairs(p4) do
		local v31 = type(v)

		if v31 == "string" or v31 == "number" or v31 == "boolean" then
			t7[k] = v
		end
	end

	if next(t7) == nil then
		return nil
	end

	return t7
end

function t1.addCustomMetadata(t8: {[any]: any}, t9: {[any]: any}) -- line: 244
	-- upvalues: sanitizeCustomMetadataGroup (copy), Cryo (copy)
	if type(t9) ~= "table" then
		warn("Cannot add custom metadata of type: ", (type(t9)))

		return
	end

	local customMetadata = t8.customMetadata

	for k, v in pairs(t9) do
		local v37 = sanitizeCustomMetadataGroup(v)

		if v37 ~= nil then
			local v38 = customMetadata[k]

			if v38 ~= nil then
				customMetadata[k] = Cryo.Dictionary.join(v38, v37)
			else
				customMetadata[k] = v37
			end
		end
	end

	t8.customMetadata = customMetadata
end
function t1.fromMessageAndStack(s1: string, s2: string, p5) -- line: 275
	-- upvalues: t1 (copy), Constants (copy), ProcessErrorStack (copy)
	local v42 = t1.new()

	v42.message = s1
	v42.level = p5 or Constants.DEFAULT_ERROR_LEVEL

	local v43, v44 = ProcessErrorStack(s2)

	for _, v46 in v43 do
		if v46.sourceCode and v44[v46.sourceCode] then
			v46.sourceCode = v44[v46.sourceCode].path
		end
	end

	v42.threads = {
		main = {
			name = "main",
			stack = v43
		}
	}

	return v42
end
function t1.fromDetails(t10: {[any]: any}) -- line: 307
	-- upvalues: t1 (copy), Constants (copy)
	local v48

	if t10.stack then
		v48 = t1.fromMessageAndStack(t10.message, t10.stack, t10.level)
	else
		v48 = t1.new()
		v48.message = t10.message
		v48.level = t10.level or Constants.DEFAULT_ERROR_LEVEL
	end

	if t10.annotations then
		v48:addAnnotations(t10.annotations)
	end

	return v48
end

return t1
