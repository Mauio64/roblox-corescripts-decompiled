local ParentParent = script.Parent.Parent
local console = require(ParentParent.Shared).console
local t1 = {}

local function warnOnce(s1: string, s2: string) -- line: 22
	-- upvalues: t1 (copy), console (copy)
	if not t1[s1] then
		console.warn("The legacy Roact API '%s' is deprecated, and will be removed in a future release.\n\n%s", s1, s2)
	end

	t1[s1] = true
end

return warnOnce
