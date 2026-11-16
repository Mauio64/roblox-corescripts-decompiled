local Mutation = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

require(parent.core)

require(script.Parent.types)

local hooks = require(script.Parent.Parent.hooks)
local useMutation = hooks.useMutation

function Mutation.Mutation(p)
	local v, v2 = table.unpack(useMutation(p.mutation, p), 1, 2)

	if Boolean.toJSBoolean(p.children) then
		return p.children(v, v2)
	end

	return nil
end

return Mutation
