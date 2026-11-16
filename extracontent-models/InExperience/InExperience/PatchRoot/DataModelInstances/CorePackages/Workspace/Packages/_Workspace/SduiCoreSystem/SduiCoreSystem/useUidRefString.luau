local parent = script:FindFirstAncestor("SduiCoreSystem").Parent

local React = require(parent.React)

local count = 0

local function getNextUidKey() -- 1 equivalent call inferred from this helper
	count += 1
	return (tostring(count))
end

local function useUidRefString()
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = getNextUidKey() -- inferred equivalent call
	end

	return ref
end

return useUidRefString
