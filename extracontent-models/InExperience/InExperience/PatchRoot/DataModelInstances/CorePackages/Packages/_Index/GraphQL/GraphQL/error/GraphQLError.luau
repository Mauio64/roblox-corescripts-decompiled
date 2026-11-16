local parent = script.Parent.Parent
local language = parent.language
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local HttpService = game:GetService("HttpService")

local isObjectLike = require(parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike

require(language.ast)

require(language.source)

local location = require(language.location)

local getLocation = location.getLocation
local printLocation = require(language.printLocation)
local printLocation2 = printLocation.printLocation
local printSourceLocation = printLocation.printSourceLocation

local printError
local undefinedIfEmpty

local object = setmetatable({}, { __index = Error })

object.__index = object
function object.__tostring(p)
	return printError(p)
end

function object.new(p: string, p2, p3, p4, p5, originalError, p6)
	local v = Error.new(p)

	v.name = "GraphQLError"
	v.originalError = originalError

	local v2 = undefinedIfEmpty

	if not Array.isArray(p2) then
		p2 = p2 and { p2 } or nil
	end

	v.nodes = v2(p2)

	local locs = {}

	if v.nodes then
		for _, node in ipairs(v.nodes) do
			local loc = node.loc

			if loc ~= nil then
				table.insert(locs, loc)
			end
		end
	end

	local v3 = undefinedIfEmpty(locs)
	local source

	if p3 then
		source = p3
	elseif v3 ~= nil then
		source = v3[1].source
	end

	v.source = source
	local positions

	if p4 then
		positions = p4
	elseif v3 then
		positions = Array.map(v3, function(p7)
			return p7.start
		end)
	end

	v.positions = positions
	local mapped

	if p4 and p3 then
		mapped = Array.map(p4, function(p7)
			return getLocation(p3, p7)
		end)
	elseif v3 then
		mapped = Array.map(v3, function(p7)
			return getLocation(p7.source, p7.start)
		end)
	end

	v.locations = mapped

	v.path = p5 or nil
	local extensions

	if originalError then
		extensions = originalError.extensions
	end

	if p6 == nil and isObjectLike2(extensions) then
		v.extensions = Object.assign({}, extensions)
	else
		v.extensions = p6 or nil
	end

	if originalError and originalError.stack then
		v.stack = originalError.stack
	end

	return (setmetatable(v, object))
end

function object.toString(p)
	return printError(p)
end

function object.toJSON(data)
	local v = { "message" }

	if data.locations ~= nil then
		table.insert(v, "locations")
	end

	if data.path ~= nil then
		table.insert(v, "path")
	end

	if data.extensions ~= nil then
		table.insert(v, "extensions")
	end

	return "{" .. Array.join(Array.map(v, function(p)
		return HttpService:JSONEncode(p) .. ":" .. HttpService:JSONEncode(data[p])
	end), ",") .. "}"
end

undefinedIfEmpty = function(locs)
	return if not (locs == nil or #locs == 0) then locs else nil
end

printError = function(data)
	local v = data.message

	if data.nodes == nil then
		if data.source ~= nil and data.locations ~= nil then
			for i = 1, #data.locations do
				local location2 = data.locations[i]
				v ..= "\n\n" .. printSourceLocation(data.source, location2)
			end
		end
	else
		for i = 1, #data.nodes do
			local node = data.nodes[i]

			if node.loc ~= nil then
				v ..= "\n\n" .. printLocation2(node.loc)
			end
		end
	end

	return v
end

return { printError = printError, GraphQLError = object }
