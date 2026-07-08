local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local createRefCache = require(script.Parent.createRefCache)

local function useRefCache() -- line: 18
	-- upvalues: React (copy), createRefCache (copy)
	local v5 = React.useRef(nil)

	if v5.current == nil then
		v5.current = createRefCache()
	end

	return v5.current
end

return useRefCache
