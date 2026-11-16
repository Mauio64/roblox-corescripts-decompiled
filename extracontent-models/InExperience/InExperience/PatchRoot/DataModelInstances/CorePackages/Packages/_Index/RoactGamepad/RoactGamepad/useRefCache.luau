local parent = script.Parent.Parent
local React = require(parent.React)

local createRefCache = require(script.Parent.createRefCache)

local function useRefCache()
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = createRefCache()
	end

	return ref.current
end

return useRefCache
