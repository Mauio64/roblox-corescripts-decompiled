local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/t")

local ProcessErrorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/ProcessErrorStack")

local strictInterface = t.strictInterface({
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

local strictInterface2 = t.strictInterface({
	name = t.optional(t.string),
	fault = t.optional(t.boolean),
	stack = t.optional(t.array(strictInterface))
})

local strictInterface3 = t.strictInterface({
	name = t.string,
	registers = t.map(t.string, t.string)
})

local strictInterface4 = t.strictInterface({
	text = t.optional(t.string),
	startLine = t.optional(t.number),
	startColumn = t.optional(t.number),
	startPos = t.optional(t.number),
	path = t.optional(t.string),
	tabWidth = t.optional(t.number)
})

local strictInterface5 = t.strictInterface({
	read = t.boolean,
	write = t.boolean,
	exec = t.boolean
})

local strictInterface6 = t.strictInterface({
	start = t.string,
	size = t.optional(t.number),
	data = t.optional(t.string),
	perms = t.optional(strictInterface5)
})

local strictInterface7 = t.strictInterface({
	start = t.string,
	size = t.number,
	code_file = t.optional(t.string),
	version = t.optional(t.string),
	debug_file = t.optional(t.string),
	debug_identifier = t.optional(t.string),
	debug_file_exists = t.optional(t.boolean)
})

local optional = t.optional(t.map(
	t.string,
	t.some(t.string, t.number, t.boolean)
))

local optional2 = t.optional(t.map(t.string, function(p2)
	local function checkTypeRecursive(items)
		if type(items) ~= "table" then
			return t.some(t.string, t.number, t.boolean)(items)
		end

		for k, item in pairs(items) do
			local v5, v6 = checkTypeRecursive(item)

			if not v5 then
				return false, string.format("error when checking key: %s - %s", k, v6)
			end
		end

		return true
	end

	return checkTypeRecursive(p2)
end))

local intersection = t.intersection(t.strictInterface({
	uuid = t.string,
	timestamp = t.number,
	lang = t.string,
	langVersion = t.string,
	agent = t.string,
	agentVersion = t.string,
	threads = t.map(t.string, strictInterface2),
	mainThread = t.string,
	attributes = optional,
	annotations = optional2,
	symbolication = t.optional(t.literal("minidump")),
	entryThread = t.optional(t.string),
	arch = t.optional(strictInterface3),
	fingerprint = t.optional(t.string),
	classifiers = t.optional(t.array(t.string)),
	sourceCode = t.optional(t.map(t.string, strictInterface4)),
	memory = t.optional(t.array(strictInterface6)),
	modules = t.optional(t.array(strictInterface7))
}), function(p2)
	local threads = p2.threads
	local flag = false

	for k, thread in pairs(threads) do
		local stack = thread.stack

		if stack ~= nil then
			for i, v7 in ipairs(stack) do
				if v7.registers ~= nil then
					flag = true
					break
				end
			end
		end

		if flag then
			break
		end
	end

	if flag and p2.arch == nil then
		return false, "arch must exist if you want to have registers in the stack"
	end

	return true
end)

local v5 = { IAttributes = optional, IAnnotations = optional2 }

v5.__index = v5

function v5:validate()
	return intersection(self)
end

function v5.new()
	local v6 = {
		uuid = HttpService:GenerateGUID(false):lower(),
		timestamp = os.time(),
		lang = "lua",
		langVersion = "Roblox",
		agent = "backtrace-Lua",
		agentVersion = "0.1.0",
		threads = {},
		mainThread = "default"
	}

	setmetatable(v6, v5)

	return v6
end

function v5:addAttributes(p3)
	if type(p3) ~= "table" then
		warn("Cannot add attributes of type: ", (type(p3)))
		return
	end

	local attributes = self.attributes or {}

	self.attributes = Cryo.Dictionary.join(attributes, p3)
end

function v5:addAnnotations(p3)
	if type(p3) ~= "table" then
		warn("Cannot add annotations of type: ", (type(p3)))
		return
	end

	local annotations = self.annotations or {}

	self.annotations = Cryo.Dictionary.join(annotations, p3)
end

function v5:addStackToThread(p3, p4)
	local threads = self.threads

	self.threads = Cryo.Dictionary.join(threads, {
		[p4] = { name = p4, stack = p3 }
	})
end

function v5:addStackToMainThread(p2)
	self:addStackToThread(p2, self.mainThread)
end

function v5.fromMessageAndStack(p2, p3)
	local v6 = v5.new()

	v6:addAttributes({ ["error.message"] = p2 })

	local v7, v8 = ProcessErrorStack(p3)
	v6:addStackToMainThread(v7)
	v6.sourceCode = v8

	local sourceCode = v6.sourceCode
	local v10

	if sourceCode and type(sourceCode) == "table" then
		local keys = Cryo.Dictionary.keys(sourceCode)

		if #keys > 0 then
			local v11 = sourceCode[keys[1]]
			v10 = (not v11 or v11.path == nil) and "" or v11.path
		else
			v10 = ""
		end
	else
		v10 = ""
	end

	v6:addAttributes({ MainSourcePath = v10 })

	return v6
end

function v5.fromDetails(data)
	local result = v5.new()

	result:addAttributes({ ["error.message"] = data.message })

	result.sourceCode = {}
	local v6 = 0

	for i, stack in ipairs(data.stacks) do
		local v7, v8
		v7, v8, v6 = ProcessErrorStack(stack, v6)

		if i == 1 then
			result:addStackToMainThread(v7)
		else
			result:addStackToThread(v7, "stack" .. i)
		end

		result.sourceCode = Cryo.Dictionary.join(result.sourceCode, v8)
	end

	result:addAnnotations(data.annotations)

	local sourceCode = result.sourceCode
	local v8

	if sourceCode and type(sourceCode) == "table" then
		local keys = Cryo.Dictionary.keys(sourceCode)

		if #keys > 0 then
			local v9 = sourceCode[keys[1]]
			v8 = (not v9 or v9.path == nil) and "" or v9.path
		else
			v8 = ""
		end
	else
		v8 = ""
	end

	result:addAttributes({ MainSourcePath = v8 })

	return result
end

return v5
