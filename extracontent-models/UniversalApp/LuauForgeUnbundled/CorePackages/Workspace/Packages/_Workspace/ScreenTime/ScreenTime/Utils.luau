local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/ArgCheck")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/AppCommonLib").Logging

local v5 = { globalGetter = nil, globalSetter = nil }

function v5:new(p3)
	ArgCheck.isType(p3.globalGetter, "function", "globalGetter")
	ArgCheck.isType(p3.globalSetter, "function", "globalSetter")
	local v6 = { globalGetter = p3.globalGetter, globalSetter = p3.globalSetter }

	setmetatable(v6, self)
	self.__index = self
	return v6
end

function v5.isLockedOut(p2): boolean
	ArgCheck.isType(p2.globalGetter, "function", "globalGetter")
	return p2.globalGetter("ScreenTime.lockedOut") == "true"
end

function v5:setLockedOut()
	logging.warn("Utils setLockedOut")
	ArgCheck.isType(self.globalSetter, "function", "globalSetter")
	self.globalSetter("ScreenTime.lockedOut", "true")
end

return v5
