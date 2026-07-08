local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local v3 = require(script.Parent.Parent.NavigationSymbol)("JUMP_TO")
local t1 = {
	JumpTo = v3
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 16
		error(("%q is not a valid member of SwitchActions"):format((tostring(p2))), 2)
	end
})

function t1.jumpTo(p3) -- line: 22
	-- upvalues: v3 (copy), Object (copy)
	local t2 = {
		preserveFocus = true,
		type = v3
	}

	if p3 then
		return (Object.assign(t2, p3))
	end

	return t2
end

return t1
