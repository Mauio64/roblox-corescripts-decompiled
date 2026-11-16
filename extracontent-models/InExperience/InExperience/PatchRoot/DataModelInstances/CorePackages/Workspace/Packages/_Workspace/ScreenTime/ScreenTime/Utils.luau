local parent = script:FindFirstAncestor("ScreenTime").Parent
local ArgCheck = require(parent.ArgCheck)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local Utils = { globalGetter = nil, globalSetter = nil }

function Utils:new(p)
	ArgCheck.isType(p.globalGetter, "function", "globalGetter")
	ArgCheck.isType(p.globalSetter, "function", "globalSetter")
	local v = { globalGetter = p.globalGetter, globalSetter = p.globalSetter }

	setmetatable(v, self)
	self.__index = self
	return v
end

function Utils.isLockedOut(p): boolean
	ArgCheck.isType(p.globalGetter, "function", "globalGetter")
	return p.globalGetter("ScreenTime.lockedOut") == "true"
end

function Utils.setLockedOut(p)
	Logging.warn("Utils setLockedOut")
	ArgCheck.isType(p.globalSetter, "function", "globalSetter")
	p.globalSetter("ScreenTime.lockedOut", "true")
end

return Utils
