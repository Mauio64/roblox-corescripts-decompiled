local parent = script.Parent.Parent
local React = require(parent.React)

local function forwardRefValue(callback, current) -- 2 equivalent calls inferred from this helper
	if type(callback) == "function" then
		callback(current)
	elseif type(callback) == "table" then
		callback.current = current
	end
end

local function useComposedRef(callback, callback2)
	return (React.useCallback(function(current)
		forwardRefValue(callback, current) -- inferred equivalent call
		forwardRefValue(callback2, current) -- inferred equivalent call
	end, { callback, callback2 }))
end

return useComposedRef
