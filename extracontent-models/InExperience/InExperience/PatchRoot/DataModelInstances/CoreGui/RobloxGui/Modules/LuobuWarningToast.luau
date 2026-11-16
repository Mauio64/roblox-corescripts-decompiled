local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)

local LuobuWarningToastComponent = require(script.LuobuWarningToastComponent)
local class = {}

class.__index = class

function class.new()
	local object = setmetatable({}, class)

	object.element = Roact.createElement(LuobuWarningToastComponent)

	object.root = Roact.mount(object.element, CoreGui, "LuobuWarningToast")

	task.delay(10, function()
		Roact.unmount(object.root)
	end)

	return object
end

return class.new()
