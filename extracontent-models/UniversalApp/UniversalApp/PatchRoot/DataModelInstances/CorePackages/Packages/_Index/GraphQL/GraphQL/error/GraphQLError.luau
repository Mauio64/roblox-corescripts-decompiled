local ParentParent = script.Parent.Parent
local language = ParentParent.language
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local HttpService = game:GetService("HttpService")
local isObjectLike = require(ParentParent.jsutils.isObjectLike).isObjectLike

require(language.ast)
require(language.source)

local getLocation = require(language.location).getLocation
local printLocation = require(language.printLocation)
local printLocation2 = printLocation.printLocation
local printSourceLocation = printLocation.printSourceLocation
local printError = nil
local undefinedIfEmpty = nil
local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.__tostring(p1) -- line: 45
	-- upvalues: printError (ref)
	return printError(p1)
end
function self.new(s1: string, p2, p3, p4, p5, p6, t1: {[any]: any}?) -- line: 124
	-- upvalues: Error (copy), undefinedIfEmpty (ref), Array (copy), getLocation (copy), isObjectLike (copy), Object (copy), self (copy)
	local v25 = Error.new(s1)

	v25.name = "GraphQLError"
	v25.originalError = p6
	v25.nodes = undefinedIfEmpty(if not Array.isArray(p2) then if not p2 then nil else { p2 } else p2)

	local t2 = {}

	if v25.nodes then
		for _, v in ipairs(v25.nodes) do
			local loc = v.loc

			if loc ~= nil then
				table.insert(t2, loc)
			end
		end
	end

	local v30 = undefinedIfEmpty(t2)

	v25.source = if not p3 then if v30 ~= nil then v30[1].source else nil else p3
	v25.positions = if not p4 then if v30 then Array.map(v30, function(p7) -- line: 165
		return p7.start
	end) else nil else p4
	v25.locations = if not p4 or not p3 then if not v30 then nil else Array.map(v30, function(p8) -- line: 174
		-- upvalues: getLocation (copy)
		return getLocation(p8.source, p8.start)
	end) else Array.map(p4, function(p9) -- line: 170
		-- upvalues: getLocation (copy), p3 (copy)
		return getLocation(p3, p9)
	end)
	v25.path = p5 or nil

	local v31 = if p6 then p6.extensions else nil

	if t1 == nil and isObjectLike(v31) then
		v25.extensions = Object.assign({}, v31)
	else
		v25.extensions = t1 or nil
	end

	if p6 and p6.stack then
		v25.stack = p6.stack
	end

	return (setmetatable(v25, self))
end
function self.toString(p10) -- line: 209
	-- upvalues: printError (ref)
	return printError(p10)
end
function self.toJSON(p11) -- line: 214
	-- upvalues: Array (copy), HttpService (copy)
	local t3 = { "message" }

	if p11.locations ~= nil then
		table.insert(t3, "locations")
	end

	if p11.path ~= nil then
		table.insert(t3, "path")
	end

	if p11.extensions ~= nil then
		table.insert(t3, "extensions")
	end

	return "{" .. Array.join(Array.map(t3, function(p12) -- line: 231
		-- upvalues: HttpService (copy), p11 (copy)
		return HttpService:JSONEncode(p12) .. ":" .. HttpService:JSONEncode(p11[p12])
	end), ",") .. "}"
end
function undefinedIfEmpty(p13) -- line: 239
	if p13 == nil or #p13 == 0 then
		return nil
	end

	return p13
end
function printError(t4: {[any]: any}) -- line: 243
	-- upvalues: printLocation2 (copy), printSourceLocation (copy)
	local message = t4.message

	if t4.nodes ~= nil then
		for i = 1, #t4.nodes do
			local v39 = t4.nodes[i]

			if v39.loc ~= nil then
				message ..= "\n\n" .. printLocation2(v39.loc)
			end
		end

		return message
	end

	if t4.source ~= nil and t4.locations ~= nil then
		for i = 1, #t4.locations do
			local v41 = t4.locations[i]

			message ..= "\n\n" .. printSourceLocation(t4.source, v41)
		end
	end

	return message
end

return {
	printError = printError,
	GraphQLError = self
}
