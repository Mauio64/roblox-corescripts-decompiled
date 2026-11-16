local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

require(parent2.GraphQL)

local equal = require(parent.jsutils.equal)
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
require(script.Parent.Parent.Parent.core)

local parser = require(script.Parent.Parent.parser)

local parser2 = parser.parser
local operationName = parser.operationName
require(script.Parent.Parent.types.types)

local class = {}
class.__index = class

function class.new(p, p2)
	return (setmetatable({
		["options"] = Boolean.toJSBoolean(p) and p or {},
		context = Boolean.toJSBoolean(p2) and p2 or {}
	}, class))
end

function class.getOptions(p)
	return p.options
end

function class:setOptions(options, flag: boolean?)
	if flag == nil then
		flag = false
	end

	if flag and not equal(self.options, options) then
		self.previousOptions = self.options
	end

	self.options = options
end

function class:unmount()
	self.isMounted = false
end

function class:refreshClient()
	local toJSBoolean = Boolean.toJSBoolean
	local v

	if Boolean.toJSBoolean(self.options) then
		v = self.options.client
	else
		v = self.options
	end

	local client

	if toJSBoolean(v) then
		if Boolean.toJSBoolean(self.options) then
			client = self.options.client
		else
			client = self.options
		end

		if not client then
			if Boolean.toJSBoolean(self.context) then
				client = self.context.client
			else
				client = self.context
			end
		end
	elseif Boolean.toJSBoolean(self.context) then
		client = self.context.client
	else
		client = self.context
	end

	invariant2(
		Boolean.toJSBoolean(client),
		"Could not find \"client\" in the context or passed in as an option. Wrap the root component in an <ApolloProvider>, or pass an ApolloClient instance in via options."
	)
	local isNew

	if client == self.client then
		isNew = false
	else
		self.client = client
		self:cleanup()
		isNew = true
	end

	return { client = self.client, isNew = isNew }
end

function class.verifyDocumentType(_, p, p2)
	local v = parser2(p)
	local v2 = operationName(p2)
	local v3 = operationName(v.type)
	invariant2(
		v.type == p2,
		("Running a %s requires a graphql "):format(v2) .. ("%s, but a %s was used instead."):format(v2, v3)
	)
end

return { OperationData = class }
