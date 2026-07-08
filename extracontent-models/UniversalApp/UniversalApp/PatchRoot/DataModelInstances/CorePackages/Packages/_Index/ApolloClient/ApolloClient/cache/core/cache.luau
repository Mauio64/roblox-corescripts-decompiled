local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local t1 = {}

require(ParentParentParent.GraphQL)

local wrap = require(ParentParent.optimism).wrap
local getFragmentQueryDocument = require(script.Parent.Parent.Parent.utilities).getFragmentQueryDocument

require(script.Parent.types.DataProxy)
require(script.Parent.types.Cache)

local t2 = {}

t2.__index = t2

function t2.new() -- line: 207
	-- upvalues: t2 (copy), wrap (copy), getFragmentQueryDocument (copy)
	local self = setmetatable({}, t2)

	self.getFragmentDoc = wrap(getFragmentQueryDocument)

	return self
end
function t2.read(_, _) -- line: 217
	error("not implemented abstract method")
end
function t2.write(_, _) -- line: 220
	error("not implemented abstract method")
end
function t2.diff(_, _) -- line: 223
	error("not implemented abstract method")
end
function t2.watch(_, _) -- line: 226
	error("not implemented abstract method")
end
function t2.reset(_) -- line: 229
	error("not implemented abstract method")
end
function t2.evict(_, _) -- line: 233
	error("not implemented abstract method")
end
function t2.restore(_, _) -- line: 237
	error("not implemented abstract method")
end
function t2.extract(_: {[any]: any}, _: boolean?) -- line: 241
	error("not implemented abstract method")
end
function t2.removeOptimistic(_: {[any]: any}, _: string) -- line: 245
	error("not implemented abstract method")
end
function t2.batch(p14, p15) -- line: 249
	local v30 = if typeof(p15.optimistic) ~= "string" then if p15.optimistic ~= false then nil else nil else p15.optimistic

	p14:performTransaction(p15.update, v30)
end
function t2.performTransaction(_: {[any]: any}, _: ((...any) -> ...any), _: string?) -- line: 263
	error("not implemented abstract method")
end
function t2.recordOptimisticTransaction(t6: {[any]: any}, p17: ((...any) -> ...any), s3: string) -- line: 277
	t6:performTransaction(p17, s3)
end
function t2.transformDocument(_, p19) -- line: 281
	return p19
end
function t2.identify(_, _) -- line: 285
end
function t2.gc(_) -- line: 289
	return {}
end
function t2.modify(_, _) -- line: 293
	return false
end
function t2.transformForLink(_, p26) -- line: 297
	return p26
end
function t2.readQuery(t7: {[any]: any}, p27, b2: boolean?) -- line: 301
	-- upvalues: Object (copy), Boolean (copy)
	if b2 == nil then
		b2 = not not p27.optimistic
	end

	return t7:read(Object.assign(table.clone(p27), {
		rootId = Boolean.toJSBoolean(p27.id) and p27.id or "ROOT_QUERY",
		optimistic = b2
	}))
end
function t2.readFragment(t8: {[any]: any}, p28, b3: boolean?) -- line: 320
	-- upvalues: Object (copy)
	if b3 == nil then
		b3 = not not p28.optimistic
	end

	return t8:read(Object.assign({}, p28, {
		query = t8.getFragmentDoc(p28.fragment, p28.fragmentName),
		rootId = p28.id,
		optimistic = b3
	}))
end
function t2.writeQuery(p29, p30) -- line: 338
	-- upvalues: Object (copy)
	local id = p30.id
	local data = p30.data
	local v56 = Object.assign(table.clone(p30), {
		id = Object.None,
		data = Object.None
	})

	return p29:write(Object.assign(v56, {
		dataId = id or "ROOT_QUERY",
		result = data
	}))
end
function t2.writeFragment(p31, p32) -- line: 350
	-- upvalues: Object (copy)
	local id = p32.id
	local data = p32.data
	local fragment = p32.fragment
	local fragmentName = p32.fragmentName
	local v63 = Object.assign(table.clone(p32), {
		id = Object.None,
		data = Object.None,
		fragment = Object.None,
		fragmentName = Object.None
	})

	return p31:write(Object.assign(v63, {
		query = p31.getFragmentDoc(fragment, fragmentName),
		dataId = id,
		result = data
	}))
end

t1.ApolloCache = t2

return t1
