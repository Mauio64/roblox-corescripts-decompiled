local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local useEffect = React.useEffect
local useRef = React.useRef

function t1.useAfterFastRefresh(p1: ((...any) -> ...any)) -- line: 16
	-- upvalues: useRef (copy), useEffect (copy)
	if _G.__DEV__ then
		local v7 = useRef(false)

		useEffect(function() -- line: 19
			-- upvalues: v7 (copy)
			return function() -- line: 20
				-- upvalues: v7 (copy)
				v7.current = true
			end
		end, {})
		useEffect(function() -- line: 24
			-- upvalues: v7 (copy), p1 (copy)
			if v7.current == true then
				v7.current = false
				p1()
			end
		end, {})
	end
end

return t1
