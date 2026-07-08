local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Object = require(ParentParentParent.LuauPolyfill).Object
local NavigationSymbol = require(ParentParent.NavigationSymbol)
local v5 = NavigationSymbol("POP")
local v6 = NavigationSymbol("POP_TO_TOP")
local v7 = NavigationSymbol("PUSH")
local v8 = NavigationSymbol("RESET")
local v9 = NavigationSymbol("REPLACE")
local v10 = NavigationSymbol("COMPLETE_TRANSITION")
local t1 = {
	Pop = v5,
	PopToTop = v6,
	Push = v7,
	Reset = v8,
	Replace = v9,
	CompleteTransition = v10
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 34
		error(("%q is not a valid member of StackActions"):format((tostring(p2))), 2)
	end
})

function t1.pop(p3) -- line: 40
	-- upvalues: v5 (copy), Object (copy)
	local t2 = {
		type = v5
	}

	if p3 then
		return (Object.assign(t2, p3))
	end

	return t2
end
function t1.popToTop(p4) -- line: 46
	-- upvalues: v6 (copy), Object (copy)
	local t3 = {
		type = v6
	}

	if p4 then
		return (Object.assign(t3, p4))
	end

	return t3
end
function t1.push(p5) -- line: 52
	-- upvalues: v7 (copy), Object (copy)
	local t4 = {
		type = v7
	}

	if p5 then
		return (Object.assign(t4, p5))
	end

	return t4
end
function t1.reset(p6) -- line: 59
	-- upvalues: v8 (copy), Object (copy)
	local t5 = {
		type = v8
	}

	if p6 then
		return (Object.assign(t5, p6))
	end

	return t5
end
function t1.replace(p7) -- line: 65
	-- upvalues: v9 (copy), Object (copy)
	local t6 = {
		preserveFocus = true,
		type = v9
	}

	if p7 then
		return (Object.assign(t6, p7))
	end

	return t6
end
function t1.completeTransition(p8) -- line: 70
	-- upvalues: v10 (copy), Object (copy)
	local t7 = {
		preserveFocus = true,
		type = v10
	}

	if p8 then
		return (Object.assign(t7, p8))
	end

	return t7
end

return t1
