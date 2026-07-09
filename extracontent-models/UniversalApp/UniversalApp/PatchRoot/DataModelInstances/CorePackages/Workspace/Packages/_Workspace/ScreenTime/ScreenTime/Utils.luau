local Parent = script:FindFirstAncestor("ScreenTime").Parent
local ArgCheck = require(Parent.ArgCheck)
local Logging = require(Parent.AppCommonLib).Logging

return {
	globalGetter = nil,
	globalSetter = nil,
	new = function(p1, p2) -- line: 30
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p2.globalGetter, "function", "globalGetter")
		ArgCheck.isType(p2.globalSetter, "function", "globalSetter")

		local t1 = {
			globalGetter = p2.globalGetter,
			globalSetter = p2.globalSetter
		}

		setmetatable(t1, p1)
		p1.__index = p1

		return t1
	end,
	isLockedOut = function(p3) -- line: 45
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p3.globalGetter, "function", "globalGetter")

		return p3.globalGetter("ScreenTime.lockedOut") == "true"
	end,
	setLockedOut = function(p4) -- line: 54
		-- upvalues: Logging (copy), ArgCheck (copy)
		Logging.warn("Utils setLockedOut")
		ArgCheck.isType(p4.globalSetter, "function", "globalSetter")
		p4.globalSetter("ScreenTime.lockedOut", "true")
	end
}
