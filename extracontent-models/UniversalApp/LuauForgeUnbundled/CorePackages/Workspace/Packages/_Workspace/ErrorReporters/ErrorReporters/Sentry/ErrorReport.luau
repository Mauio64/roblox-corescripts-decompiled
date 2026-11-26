local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/t")
require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/SentrySdk")
local ProcessErrorStack = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/ProcessErrorStack")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/Constants")

local optional = t.optional(t.map(
	t.string,
	t.some(t.string, t.number, t.boolean)
))

local optional2 = t.optional(t.map(t.string, function(p2)
	local function checkTypeRecursive(items)
		if type(items) ~= "table" then
			return t.some(t.string, t.number, t.boolean)(items), nil
		end

		for k, item in pairs(items) do
			local v5, v6 = checkTypeRecursive(item)

			if not v5 then
				return false, string.format("error when checking key: %s - %s", k, v6 or "unknown error")
			end
		end

		return true, nil
	end

	local v5, v6 = checkTypeRecursive(p2)
	return v5, v6
end))

local mapped = t.map(t.string, t.some(t.string, t.number, t.boolean))
local optional3 = t.optional(t.map(t.string, mapped))

local interface = t.interface({
	type = t.optional(t.string),
	category = t.optional(t.string),
	message = t.optional(t.string),
	data = t.optional(t.table),
	level = t.optional(t.string),
	timestamp = t.optional(t.number),
	origin = t.optional(t.string)
})

local optional4 = t.optional(t.array(interface))

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

local intersection = t.intersection(t.strictInterface({
	threads = t.map(t.string, strictInterface2),
	message = t.optional(t.string),
	level = t.optional(t.string),
	attributes = optional,
	annotations = optional2,
	tags = t.optional(t.map(t.string, t.string)),
	customMetadata = optional3,
	breadcrumbs = optional4,
	timestamp = t.optional(t.number)
}))

local v5 = {
	IAttributes = optional,
	IAnnotations = optional2,
	ICustomMetadata = optional3,
	IBreadcrumbs = optional4
}

v5.__index = v5

function v5:validate()
	return intersection(self)
end

function v5.new()
	local v6 = {
		threads = {},
		attributes = {},
		annotations = {},
		customMetadata = {},
		breadcrumbs = {}
	}

	setmetatable(v6, v5)

	return v6
end

function v5:addAttributes(p3)
	if type(p3) ~= "table" then
		warn("Cannot add attributes of type: ", (type(p3)))
		return
	end

	local attributes = self.attributes

	self.attributes = Cryo.Dictionary.join(attributes, p3)
end

function v5:addAnnotations(p3)
	if type(p3) ~= "table" then
		warn("Cannot add annotations of type: ", (type(p3)))
		return
	end

	local annotations = self.annotations

	self.annotations = Cryo.Dictionary.join(annotations, p3)
end

local function sanitizeCustomMetadataGroup(item)
	if type(item) ~= "table" then
		return nil
	end

	local result = {}

	for k, item2 in pairs(item) do
		local typeName = type(item2)

		if typeName == "string" or typeName == "number" or typeName == "boolean" then
			result[k] = item2
		end
	end

	if next(result) == nil then
		return nil
	end

	return result
end

function v5:addCustomMetadata(items)
	if type(items) ~= "table" then
		warn("Cannot add custom metadata of type: ", (type(items)))
		return
	end

	local customMetadata = self.customMetadata

	for k, item in pairs(items) do
		local v6 = sanitizeCustomMetadataGroup(item)

		if v6 == nil then
			continue
		end

		local v7 = customMetadata[k]

		if v7 == nil then
			customMetadata[k] = v6
		else
			customMetadata[k] = Cryo.Dictionary.join(v7, v6)
		end
	end

	self.customMetadata = customMetadata
end

function v5:addBreadcrumb(data)
	if type(data) ~= "table" then
		warn("Cannot add breadcrumb of type: ", (type(data)))
		return
	end

	local v6 = {
		type = data.type or "default",
		category = data.category,
		message = data.message,
		data = data.data,
		level = data.level or "info",
		origin = data.origin,
		timestamp = data.timestamp or os.time()
	}

	table.insert(self.breadcrumbs, v6)
end

function v5:addBreadcrumbs(list)
	if type(list) ~= "table" then
		warn("Cannot add breadcrumbs of type: ", (type(list)))
		return
	end

	for i, item in ipairs(list) do
		self:addBreadcrumb(item)
	end
end

function v5.fromMessageAndStack(message, p2, p3)
	local v6 = v5.new()

	v6.message = message
	v6.level = p3 or Constants.DEFAULT_ERROR_LEVEL

	local v7, v8 = ProcessErrorStack(p2)

	for k, v9 in v7 do
		if v9.sourceCode and v8[v9.sourceCode] then
			v9.sourceCode = v8[v9.sourceCode].path
		end
	end

	v6.threads = {
		main = { name = "main", stack = v7 }
	}

	return v6
end

function v5.fromDetails(data)
	local v6

	if data.stack then
		v6 = v5.fromMessageAndStack(data.message, data.stack, data.level)
	else
		v6 = v5.new()
		v6.message = data.message
		v6.level = data.level or Constants.DEFAULT_ERROR_LEVEL
	end

	if data.annotations then
		v6:addAnnotations(data.annotations)
	end

	return v6
end

return v5
