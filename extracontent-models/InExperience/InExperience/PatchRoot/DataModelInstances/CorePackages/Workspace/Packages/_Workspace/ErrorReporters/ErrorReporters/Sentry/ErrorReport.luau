local parent = script:FindFirstAncestor("ErrorReporters").Parent
local Cryo = require(parent.Cryo)
local t = require(parent.t)
require(parent.SentrySdk)
local ProcessErrorStack = require(script.Parent.Parent.ProcessErrorStack)
local Constants = require(script.Parent.Constants)

local optional = t.optional(t.map(t.string, t.some(t.string, t.number, t.boolean)))

local optional2 = t.optional(t.map(t.string, function(p)
	local function checkTypeRecursive(items)
		if type(items) ~= "table" then
			return t.some(t.string, t.number, t.boolean)(items), nil
		end

		for k, item in pairs(items) do
			local v, v2 = checkTypeRecursive(item)

			if not v then
				return false, string.format("error when checking key: %s - %s", k, v2 or "unknown error")
			end
		end

		return true, nil
	end

	local v, v2 = checkTypeRecursive(p)
	return v, v2
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

local ErrorReport = {
	IAttributes = optional,
	IAnnotations = optional2,
	ICustomMetadata = optional3,
	IBreadcrumbs = optional4
}

ErrorReport.__index = ErrorReport

function ErrorReport.validate(p)
	return intersection(p)
end

function ErrorReport.new()
	local v = {
		threads = {},
		attributes = {},
		annotations = {},
		customMetadata = {},
		breadcrumbs = {}
	}

	setmetatable(v, ErrorReport)

	return v
end

function ErrorReport:addAttributes(p)
	if type(p) ~= "table" then
		warn("Cannot add attributes of type: ", (type(p)))
		return
	end

	local attributes = self.attributes

	self.attributes = Cryo.Dictionary.join(attributes, p)
end

function ErrorReport:addAnnotations(p)
	if type(p) ~= "table" then
		warn("Cannot add annotations of type: ", (type(p)))
		return
	end

	local annotations = self.annotations

	self.annotations = Cryo.Dictionary.join(annotations, p)
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

	return if next(result) ~= nil then result else nil
end

function ErrorReport:addCustomMetadata(items)
	if type(items) ~= "table" then
		warn("Cannot add custom metadata of type: ", (type(items)))
		return
	end

	local customMetadata = self.customMetadata

	for k, item in pairs(items) do
		local v = sanitizeCustomMetadataGroup(item)

		if v == nil then
			continue
		end

		local v2 = customMetadata[k]

		if v2 == nil then
			customMetadata[k] = v
		else
			customMetadata[k] = Cryo.Dictionary.join(v2, v)
		end
	end

	self.customMetadata = customMetadata
end

function ErrorReport:addBreadcrumb(data)
	if type(data) ~= "table" then
		warn("Cannot add breadcrumb of type: ", (type(data)))
		return
	end

	local v = {
		type = data.type or "default",
		category = data.category,
		message = data.message,
		data = data.data,
		level = data.level or "info",
		origin = data.origin,
		timestamp = data.timestamp or os.time()
	}

	table.insert(self.breadcrumbs, v)
end

function ErrorReport:addBreadcrumbs(list)
	if type(list) ~= "table" then
		warn("Cannot add breadcrumbs of type: ", (type(list)))
		return
	end

	for _, item in ipairs(list) do
		self:addBreadcrumb(item)
	end
end

function ErrorReport.fromMessageAndStack(message: string, p: string, p2)
	local v = ErrorReport.new()

	v.message = message
	v.level = p2 or Constants.DEFAULT_ERROR_LEVEL

	local stack, v2 = ProcessErrorStack(p)

	for _, v3 in stack do
		if v3.sourceCode and v2[v3.sourceCode] then
			v3.sourceCode = v2[v3.sourceCode].path
		end
	end

	v.threads = {
		main = { name = "main", stack = stack }
	}

	return v
end

function ErrorReport.fromDetails(data)
	local v

	if data.stack then
		v = ErrorReport.fromMessageAndStack(data.message, data.stack, data.level)
	else
		v = ErrorReport.new()
		v.message = data.message
		v.level = data.level or Constants.DEFAULT_ERROR_LEVEL
	end

	if data.annotations then
		v:addAnnotations(data.annotations)
	end

	return v
end

return ErrorReport
