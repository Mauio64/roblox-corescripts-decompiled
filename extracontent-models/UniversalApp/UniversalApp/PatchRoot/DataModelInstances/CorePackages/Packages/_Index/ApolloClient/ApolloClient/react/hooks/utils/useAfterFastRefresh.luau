local parent = script.Parent.Parent.Parent.Parent.Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useRef = React.useRef
return {
	useAfterFastRefresh = function(callback)
		if _G.__DEV__ then
			local v = useRef(false)
			useEffect(function()
				return function()
					v.current = true
				end
			end, {})
			useEffect(function()
				if v.current == true then
					v.current = false
					callback()
				end
			end, {})
		end
	end
}
