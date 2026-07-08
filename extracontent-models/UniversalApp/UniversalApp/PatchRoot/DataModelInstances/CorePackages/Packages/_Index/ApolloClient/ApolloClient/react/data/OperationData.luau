local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Boolean = require(ParentParentParent.LuauPolyfill).Boolean

require(ParentParentParent.GraphQL)

local equal = require(ParentParent.jsutils.equal)
local invariant = require(ParentParent.jsutils.invariant).invariant

require(script.Parent.Parent.Parent.core)

local parser = require(script.Parent.Parent.parser)
local parser2 = parser.parser
local operationName = parser.operationName

require(script.Parent.Parent.types.types)

local t2 = {}

t2.__index = t2

function t2.new(p1, p2) -- line: 39
	-- upvalues: Boolean (copy), t2 (copy)
	return (setmetatable({
		options = Boolean.toJSBoolean(p1) and p1 or {},
		context = Boolean.toJSBoolean(p2) and p2 or {}
	}, t2))
end
function t2.getOptions(p3) -- line: 46
	return p3.options
end
function t2.setOptions(t3: {[any]: any}, p4, b1: boolean?) -- line: 50
	-- upvalues: equal (copy)
	if b1 == nil then
		b1 = false
	end

	if b1 and not equal(t3.options, p4) then
		t3.previousOptions = t3.options
	end

	t3.options = p4
end
function t2.unmount(p5) -- line: 60
	p5.isMounted = false
end
function t2.refreshClient(p6) -- line: 64
	-- upvalues: Boolean (copy), invariant (copy)
	local v19 = Boolean.toJSBoolean((if not Boolean.toJSBoolean(p6.options) then p6.options else p6.options.client)) and (if not Boolean.toJSBoolean(p6.options) then p6.options else p6.options.client) or if not Boolean.toJSBoolean(p6.context) then p6.context else p6.context.client

	invariant(Boolean.toJSBoolean(v19), "Could not find \"client\" in the context or passed in as an option. Wrap the root component in an <ApolloProvider>, or pass an ApolloClient instance in via options.")

	local v20 = false

	if v19 ~= p6.client then
		v20 = true
		p6.client = v19
		p6:cleanup()
	end

	return {
		client = p6.client,
		isNew = v20
	}
end
function t2.verifyDocumentType(_, p8, p9) -- line: 99
	-- upvalues: parser2 (copy), operationName (copy), invariant (copy)
	local v24 = parser2(p8)
	local v25 = operationName(p9)
	local v26 = operationName(v24.type)

	invariant(p9 == v24.type, ("Running a %s requires a graphql "):format(v25) .. ("%s, but a %s was used instead."):format(v25, v26))
end

t1.OperationData = t2

return t1
