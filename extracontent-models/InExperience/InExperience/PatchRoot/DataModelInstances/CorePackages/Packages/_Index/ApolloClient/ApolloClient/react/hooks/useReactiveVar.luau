local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useEffect = React.useEffect
local useState = React.useState

require(ParentParent.cache)

local t2 = {
	__value = "nil placeholder"
}

function t1.useReactiveVar(p1) -- line: 25
	-- upvalues: useState (copy), useEffect (copy), t2 (copy)
	local v9 = p1()
	local _, v11 = useState(v9)

	useEffect(function() -- line: 34
		-- upvalues: p1 (copy), v9 (copy), v11 (copy)
		local v12 = p1()

		if v12 ~= v9 then
			v11(v12)

			return
		end

		return p1:onNextChange(v11)
	end, { v9 or t2 })

	return v9
end

return t1
