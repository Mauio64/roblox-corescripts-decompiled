local ParentParent = script.Parent.Parent

require(ParentParent.LuauPolyfill)

local supportsTestSelectors = require(script.Parent.ReactFiberHostConfig).supportsTestSelectors
local t1 = {}
local t2 = {}

function t1.onCommitRoot() -- line: 512
	-- upvalues: supportsTestSelectors (copy), t2 (copy)
	if supportsTestSelectors then
		for _, v6 in t2 do
			v6()
		end
	end
end

return t1
