local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local useRef = React.useRef
local equal = require(parent.jsutils.equal)
return {
	useDeepMemo = function(callback, p)
		local v = useRef(nil)

		if not (v.current and equal(p, v.current.key)) then
			v.current = { key = p, value = callback() }
		end

		return v.current.value
	end
}
