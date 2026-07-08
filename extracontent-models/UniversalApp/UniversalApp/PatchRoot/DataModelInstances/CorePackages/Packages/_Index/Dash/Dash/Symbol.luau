local scriptParent = script.Parent
local v2 = require(scriptParent.class)("Symbol", function(s1: string) -- line: 20
	return {
		name = s1
	}
end)

function v2.toString(p1) -- line: 26
	return ("Symbol(%s)"):format(p1.name)
end

return v2
