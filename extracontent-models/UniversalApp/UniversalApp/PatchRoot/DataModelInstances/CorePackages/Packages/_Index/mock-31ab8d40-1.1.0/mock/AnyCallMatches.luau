local getCalls = require(script.Parent.getCalls)
local cmpLiteralArgs = require(script.Parent.cmpLiteralArgs)
local cmpPredicateArgs = require(script.Parent.cmpPredicateArgs)
local fmtArgs = require(script.Parent.fmtArgs)
local t1 = {
	args = function(p1, p2) -- line: 10
		-- upvalues: getCalls (copy), fmtArgs (copy)
		local v8 = getCalls(p1)
		local v9 = #v8

		if v9 == 0 then
			return false, "mock was not called"
		end

		local v10 = nil

		for i = 1, v9 do
			local v12

			v12, v10 = p2(v8[i].args)

			if v12 then
				return true
			end
		end

		if not v10 then
			v10 = fmtArgs(v8[v9].args) .. " did not match"
		end

		if v9 > 1 then
			v10 ..= " (+" .. v9 - 1 .. " other calls)"
		end

		return false, v10
	end
}

function t1.literals(p3, ...) -- line: 36
	-- upvalues: t1 (copy), cmpLiteralArgs (copy)
	local v14 = table.pack(...)

	return t1.args(p3, function(p4) -- line: 38
		-- upvalues: cmpLiteralArgs (copy), v14 (copy)
		return cmpLiteralArgs(v14, p4)
	end)
end
function t1.predicates(p5, ...) -- line: 43
	-- upvalues: t1 (copy), cmpPredicateArgs (copy)
	local v16 = table.pack(...)

	return t1.args(p5, function(p6) -- line: 45
		-- upvalues: cmpPredicateArgs (copy), v16 (copy)
		return cmpPredicateArgs(v16, p6)
	end)
end

return t1
