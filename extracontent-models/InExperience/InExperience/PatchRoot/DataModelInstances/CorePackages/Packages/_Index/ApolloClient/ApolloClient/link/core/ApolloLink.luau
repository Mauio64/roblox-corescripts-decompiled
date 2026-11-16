local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local invariant = require(parent.jsutils.invariant)
local invariantError = invariant.InvariantError
local invariant2 = invariant.invariant
local utilities = require(parent.utilities)
local observable = utilities.Observable

require(script.Parent.types)

local utils = require(script.Parent.Parent.utils)
local validateOperation = utils.validateOperation
local createOperation = utils.createOperation
local transformOperation = utils.transformOperation

local class = {}
class.__index = class

local function passthrough(_, p, callback)
	if Boolean.toJSBoolean(callback) then
		return (callback(p))
	end

	return observable.of()
end

local function toLink(callback)
	if typeof(callback) == "function" then
		return class.new(callback)
	end

	return callback
end

local function isTerminating(p): boolean
	local v, _ = debug.info(p.request, "a")
	return v <= 2
end

local object = setmetatable({}, { __index = Error })
object.__index = object

function object.new(p: string?, link)
	local v = Error.new(p)
	v.link = link

	return (setmetatable(v, object))
end

function class.empty()
	return class.new(function(_)
		return observable.of()
	end)
end

function class.from(list)
	if #list == 0 then
		return class.empty()
	end

	return (Array.reduce(Array.map(list, toLink, nil), function(object2, p)
		return object2:concat(p)
	end))
end

function class.split_(callback, callback2, callback3)
	if typeof(callback2) == "function" then
		callback2 = class.new(callback2)
	end

	if not Boolean.toJSBoolean(callback3) or callback3 == nil then
		callback3 = class.new(passthrough)
	end

	if typeof(callback3) == "function" then
		callback3 = class.new(callback3)
	end

	local v, _ = debug.info(callback2.request, "a")

	if v <= 2 then
		local v2, _ = debug.info(callback3.request, "a")

		if v2 <= 2 then
			return class.new(function(_, p)
				if callback(p) then
					local request = callback2:request(p)
					return Boolean.toJSBoolean(request) and request or observable.of()
				end

				local request = callback3:request(p)
				return Boolean.toJSBoolean(request) and request or observable.of()
			end)
		end
	end

	return class.new(function(_, p, p2)
		if callback(p) then
			local request = callback2:request(p, p2)
			return Boolean.toJSBoolean(request) and request or observable.of()
		end

		local request = callback3:request(p, p2)
		return Boolean.toJSBoolean(request) and request or observable.of()
	end)
end

function class:execute(p)
	local request = self:request(createOperation(p.context, transformOperation(validateOperation(p))))
	return Boolean.toJSBoolean(request) and request or observable.of()
end

function class.concat_(callback, callback2)
	if typeof(callback) == "function" then
		callback = class.new(callback)
	end

	local v, _ = debug.info(callback.request, "a")

	if v <= 2 then
		invariant2.warn(object.new("You are calling concat on a terminating link, which will have no effect", callback))

		return callback
	end

	if typeof(callback2) == "function" then
		callback2 = class.new(callback2)
	end

	local v2, _ = debug.info(callback2.request, "a")

	if v2 <= 2 then
		return class.new(function(_, p)
			local request = callback:request(p, function(p2)
				local request = callback2:request(p2)
				return Boolean.toJSBoolean(request) and request or observable.of()
			end)

			return Boolean.toJSBoolean(request) and request or observable.of()
		end)
	end

	return class.new(function(_, p, p2)
		local request = callback:request(p, function(p3)
			local request = callback2:request(p3, p2)
			return Boolean.toJSBoolean(request) and request or observable.of()
		end)

		return Boolean.toJSBoolean(request) and request or observable.of()
	end)
end

function class.new(request)
	local v = {}

	if Boolean.toJSBoolean(request) then
		v.request = request
	end

	return (setmetatable(v, class))
end

function class:split(callback, p, p2)
	return self:concat(class.split_(callback, p, Boolean.toJSBoolean(p2) and p2 or class.new(passthrough)))
end

function class:concat(p)
	return class.concat_(self, p)
end

function class:request(_, _)
	error(invariantError.new("request is not implemented"))
end

function class.onError(_, message, object2)
	if Boolean.toJSBoolean(object2) and object2 ~= nil and Boolean.toJSBoolean(object2.error) then
		object2:error(message)

		return false
	end

	error(message)
end

function class:setOnError(onError)
	self.onError = onError
	return self
end

return { ApolloLink = class }
