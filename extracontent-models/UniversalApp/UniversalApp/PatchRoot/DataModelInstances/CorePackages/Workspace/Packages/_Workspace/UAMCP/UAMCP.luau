local tools = require(script.tools)
local t1 = {}

for k, v in pairs(tools) do
	t1[k] = function(p1) -- line: 25
		-- upvalues: v (copy)
		return v.call(p1 or {})
	end
end

function t1.call(s1: string, t2: {[any]: any}?) -- line: 30
	-- upvalues: tools (copy)
	local v8 = tools[s1]

	if not v8 then
		return "ERROR: unknown tool \"" .. tostring(s1) .. "\". Use help() to list tools."
	end

	return v8.call(t2 or {})
end

return t1
