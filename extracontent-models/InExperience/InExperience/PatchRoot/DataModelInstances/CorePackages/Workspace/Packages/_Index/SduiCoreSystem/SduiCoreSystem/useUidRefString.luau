local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local React = require(Parent.React)
local n1 = 0

local function getNextUidKey() -- line: 8
	-- upvalues: n1 (ref)
	n1 += 1

	return (tostring(n1))
end
local function useUidRefString() -- line: 13
	-- upvalues: React (copy), n1 (ref)
	local v6 = React.useRef(nil)

	if v6.current == nil then
		n1 += 1
		v6.current = tostring(n1)
	end

	return v6
end

return useUidRefString
