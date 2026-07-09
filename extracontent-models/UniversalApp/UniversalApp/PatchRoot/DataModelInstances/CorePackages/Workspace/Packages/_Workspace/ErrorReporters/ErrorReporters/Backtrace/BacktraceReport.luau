local Parent = script:FindFirstAncestor("ErrorReporters").Parent
local HttpService = game:GetService("HttpService")
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local ProcessErrorStack = require(script.Parent.Parent.ProcessErrorStack)
local v6 = t.strictInterface({
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
local v7 = t.strictInterface({
	name = t.optional(t.string),
	fault = t.optional(t.boolean),
	stack = t.optional(t.array(v6))
})
local v8 = t.strictInterface({
	name = t.string,
	registers = t.map(t.string, t.string)
})
local v9 = t.strictInterface({
	text = t.optional(t.string),
	startLine = t.optional(t.number),
	startColumn = t.optional(t.number),
	startPos = t.optional(t.number),
	path = t.optional(t.string),
	tabWidth = t.optional(t.number)
})
local v10 = t.strictInterface({
	read = t.boolean,
	write = t.boolean,
	exec = t.boolean
})
local v11 = t.strictInterface({
	start = t.string,
	size = t.optional(t.number),
	data = t.optional(t.string),
	perms = t.optional(v10)
})
local v12 = t.strictInterface({
	start = t.string,
	size = t.number,
	code_file = t.optional(t.string),
	version = t.optional(t.string),
	debug_file = t.optional(t.string),
	debug_identifier = t.optional(t.string),
	debug_file_exists = t.optional(t.boolean)
})
local v13 = t.optional(t.map(t.string, t.some(t.string, t.number, t.boolean)))
local v14 = t.optional(t.map(t.string, function(p1) -- line: 76
	-- upvalues: t (copy)
	local function checkTypeRecursive(p2) -- line: 77
		-- upvalues: checkTypeRecursive (copy), t (copy)
		if type(p2) == "table" then
			for k, v in pairs(p2) do
				local v71, v72 = checkTypeRecursive(v)

				if not v71 then
					return false, string.format("error when checking key: %s - %s", k, v72)
				end
			end

			return true
		end

		return t.some(t.string, t.number, t.boolean)(p2)
	end

	return checkTypeRecursive(p1)
end))
local v15 = t.intersection(t.strictInterface({
	uuid = t.string,
	timestamp = t.number,
	lang = t.string,
	langVersion = t.string,
	agent = t.string,
	agentVersion = t.string,
	threads = t.map(t.string, v7),
	mainThread = t.string,
	attributes = v13,
	annotations = v14,
	symbolication = t.optional(t.literal("minidump")),
	entryThread = t.optional(t.string),
	arch = t.optional(v8),
	fingerprint = t.optional(t.string),
	classifiers = t.optional(t.array(t.string)),
	sourceCode = t.optional(t.map(t.string, v9)),
	memory = t.optional(t.array(v11)),
	modules = t.optional(t.array(v12))
}), function(p3) -- line: 121
	local v20 = false
	local threads = p3.threads

	for _, v in pairs(threads) do
		local stack = v.stack

		if stack ~= nil then
			for _, v2 in ipairs(stack) do
				if v2.registers ~= nil then
					v20 = true

					break
				end
			end
		end

		if v20 then
			break
		end
	end

	if v20 and p3.arch == nil then
		return false, "arch must exist if you want to have registers in the stack"
	end

	return true
end)
local t1 = {
	IAttributes = v13,
	IAnnotations = v14
}

t1.__index = t1

function t1.validate(p4) -- line: 167
	-- upvalues: v15 (copy)
	return v15(p4)
end
function t1.new() -- line: 172
	-- upvalues: HttpService (copy), t1 (copy)
	local t2 = {
		lang = "lua",
		langVersion = "Roblox",
		agent = "backtrace-Lua",
		agentVersion = "0.1.0",
		mainThread = "default",
		uuid = HttpService:GenerateGUID(false):lower(),
		timestamp = os.time(),
		threads = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addAttributes(p5, p6) -- line: 189
	-- upvalues: Cryo (copy)
	if type(p6) ~= "table" then
		warn("Cannot add attributes of type: ", (type(p6)))

		return
	end

	local v34 = p5.attributes or {}

	p5.attributes = Cryo.Dictionary.join(v34, p6)
end
function t1.addAnnotations(p7, p8) -- line: 202
	-- upvalues: Cryo (copy)
	if type(p8) ~= "table" then
		warn("Cannot add annotations of type: ", (type(p8)))

		return
	end

	local v37 = p7.annotations or {}

	p7.annotations = Cryo.Dictionary.join(v37, p8)
end
function t1.addStackToThread(p9, p10, p11) -- line: 215
	-- upvalues: Cryo (copy)
	local threads = p9.threads

	p9.threads = Cryo.Dictionary.join(threads, {
		[p11] = {
			name = p11,
			stack = p10
		}
	})
end
function t1.addStackToMainThread(p12, p13) -- line: 228
	p12:addStackToThread(p13, p12.mainThread)
end
function t1.fromMessageAndStack(p14, p15) -- line: 232
	-- upvalues: t1 (copy), ProcessErrorStack (copy), Cryo (copy)
	local v46 = t1.new()

	v46:addAttributes({
		["error.message"] = p14
	})

	local v47, v48 = ProcessErrorStack(p15)

	v46:addStackToMainThread(v47)
	v46.sourceCode = v48

	local t3 = {}
	local sourceCode = v46.sourceCode
	local g51 = nil
	local v52 = nil
	local v53 = nil
	local path = nil

	repeat
		if g51 or sourceCode and type(sourceCode) == "table" then
			if not g51 then
				v52 = Cryo.Dictionary.keys(sourceCode)
			end

			if g51 or #v52 > 0 then
				if not g51 then
					v53 = sourceCode[v52[1]]
				end

				if g51 or v53 and v53.path ~= nil then
					if not g51 then
						path = v53.path
					end

					g51 = false
					t3.MainSourcePath = path
					v46:addAttributes(t3)

					return v46
				end
			end
		end

		path = ""
		g51 = true
	until not g51
end
function t1.fromDetails(p16) -- line: 250
	-- upvalues: t1 (copy), ProcessErrorStack (copy), Cryo (copy)
	local v56 = t1.new()

	v56:addAttributes({
		["error.message"] = p16.message
	})
	v56.sourceCode = {}

	local n1 = 0
	local g64 = nil
	local v65 = nil
	local v66 = nil
	local path = nil

	for i, v in ipairs(p16.stacks) do
		local v60, v61

		v60, v61, n1 = ProcessErrorStack(v, n1)

		if i == 1 then
			v56:addStackToMainThread(v60)
		else
			v56:addStackToThread(v60, "stack" .. i)
		end

		v56.sourceCode = Cryo.Dictionary.join(v56.sourceCode, v61)
	end

	v56:addAnnotations(p16.annotations)

	local t4 = {}
	local sourceCode = v56.sourceCode

	repeat
		if g64 or sourceCode and type(sourceCode) == "table" then
			if not g64 then
				v65 = Cryo.Dictionary.keys(sourceCode)
			end

			if g64 or #v65 > 0 then
				if not g64 then
					v66 = sourceCode[v65[1]]
				end

				if g64 or v66 and v66.path ~= nil then
					if not g64 then
						path = v66.path
					end

					g64 = false
					t4.MainSourcePath = path
					v56:addAttributes(t4)

					return v56
				end
			end
		end

		path = ""
		g64 = true
	until not g64
end

return t1
