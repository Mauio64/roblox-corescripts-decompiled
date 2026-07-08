local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local useRef = require(ParentParentParent.React).useRef
local equal = require(ParentParent.jsutils.equal)

function t1.useDeepMemo(p1: ((...any) -> ...any), p2) -- line: 26
	-- upvalues: useRef (copy), equal (copy)
	local v8 = useRef(nil)

	if not v8.current or not equal(p2, v8.current.key) then
		v8.current = {
			key = p2,
			value = p1()
		}
	end

	return v8.current.value
end

return t1
