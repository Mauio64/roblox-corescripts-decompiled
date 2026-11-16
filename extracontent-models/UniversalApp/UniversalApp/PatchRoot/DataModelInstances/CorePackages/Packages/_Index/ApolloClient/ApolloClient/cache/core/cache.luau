local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean

require(parent2.GraphQL)

local optimism = require(parent.optimism)
local wrap = optimism.wrap
local utilities = require(script.Parent.Parent.Parent.utilities)

local getFragmentQueryDocument = utilities.getFragmentQueryDocument
require(script.Parent.types.DataProxy)

require(script.Parent.types.Cache)

local class = {}
class.__index = class
function class.new()
	local self = setmetatable({}, class)

	self.getFragmentDoc = wrap(getFragmentQueryDocument)

	return self
end

function class:read(_)
	error("not implemented abstract method")
end
function class:write(_)
	error("not implemented abstract method")
end
function class.diff(_, _)
	error("not implemented abstract method")
end
function class.watch(_, _)
	error("not implemented abstract method")
end
function class.reset(_)
	error("not implemented abstract method")
end

function class.evict(_, _)
	error("not implemented abstract method")
end

function class.restore(_, _)
	error("not implemented abstract method")
end

function class.extract(_, _: boolean?)
	error("not implemented abstract method")
end

function class.removeOptimistic(_, _: string)
	error("not implemented abstract method")
end

function class:batch(p)
	local optimistic

	if typeof(p.optimistic) == "string" then
		optimistic = p.optimistic
	else
		local _ = p.optimistic == false
	end

	self:performTransaction(p.update, optimistic)
end

function class:performTransaction(_, _: string?)
	error("not implemented abstract method")
end

function class:recordOptimisticTransaction(callback, p: string)
	self:performTransaction(callback, p)
end

function class.transformDocument(_, p)
	return p
end

function class.identify(_, _) end

function class.gc(_)
	return {}
end

function class.modify(_, _): boolean
	return false
end

function class.transformForLink(_, p)
	return p
end

function class:readQuery(p, optimistic: boolean?)
	if optimistic == nil then
		optimistic = p.optimistic and true or false
	end

	return self:read(Object.assign(table.clone(p), {
		rootId = Boolean.toJSBoolean(p.id) and p.id or "ROOT_QUERY",
		optimistic = optimistic
	}))
end

function class:readFragment(data, optimistic: boolean?)
	if optimistic == nil then
		optimistic = data.optimistic and true or false
	end

	return self:read(Object.assign({}, data, {
		query = self.getFragmentDoc(data.fragment, data.fragmentName),
		rootId = data.id,
		optimistic = optimistic
	}))
end

function class:writeQuery(p)
	local id = p.id
	local data = p.data
	local v = Object.assign(table.clone(p), { id = Object.None, data = Object.None })

	return self:write(Object.assign(v, {
		dataId = id or "ROOT_QUERY",
		result = data
	}))
end

function class:writeFragment(data)
	local id = data.id
	local data2 = data.data
	local fragment = data.fragment
	local fragmentName = data.fragmentName
	local v = Object.assign(table.clone(data), {
		id = Object.None,
		data = Object.None,
		fragment = Object.None,
		fragmentName = Object.None
	})

	return self:write(Object.assign(v, {
		query = self.getFragmentDoc(fragment, fragmentName),
		dataId = id,
		result = data2
	}))
end

return { ApolloCache = class }
