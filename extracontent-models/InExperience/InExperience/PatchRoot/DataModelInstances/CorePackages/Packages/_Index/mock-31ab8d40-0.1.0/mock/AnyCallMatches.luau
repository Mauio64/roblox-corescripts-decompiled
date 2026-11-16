local getCalls = require(script.Parent.getCalls)
local cmpLiteralArgs = require(script.Parent.cmpLiteralArgs)
local cmpPredicateArgs = require(script.Parent.cmpPredicateArgs)
local fmtArgs = require(script.Parent.fmtArgs)

local AnyCallMatches = {}

function AnyCallMatches.args(p, callback)
	local calls = getCalls(p)
	local count = #calls

	if count == 0 then
		return false, "mock was not called"
	end

	local v = nil

	for i = 1, count do
		local v2
		v2, v = callback(calls[i].args)

		if v2 then
			return true
		end
	end

	local v2 = v or fmtArgs(calls[count].args) .. " did not match"

	if count > 1 then
		v2 ..= " (+" .. count - 1 .. " other calls)"
	end

	return false, v2
end

function AnyCallMatches.literals(p, ...)
	local v = table.pack(...)
	return AnyCallMatches.args(p, function(p2)
		return cmpLiteralArgs(v, p2)
	end)
end

function AnyCallMatches.predicates(p, ...)
	local v = table.pack(...)
	return AnyCallMatches.args(p, function(p2)
		return cmpPredicateArgs(v, p2)
	end)
end

return AnyCallMatches
