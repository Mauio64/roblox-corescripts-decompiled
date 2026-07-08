local prettyPrint = require(script.Parent.prettyPrint)
local t1 = {
	outputFunction = print
}

function t1.middleware(p1, p2) -- line: 10
	-- upvalues: t1 (copy), prettyPrint (copy)
	return function(p3) -- line: 11
		-- upvalues: p1 (copy), t1 (copy), prettyPrint (copy), p2 (copy)
		local v6 = p1(p3)

		t1.outputFunction(("Action dispatched: %s\nState changed to: %s"):format(prettyPrint(p3), prettyPrint(p2:getState())))

		return v6
	end
end

return t1
