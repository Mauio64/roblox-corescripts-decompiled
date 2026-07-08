local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local LuobuWarningToastComponent = require(script.LuobuWarningToastComponent)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
	-- upvalues: t1 (copy), Roact (copy), LuobuWarningToastComponent (copy), CoreGui (copy)
	local self = setmetatable({}, t1)

	self.element = Roact.createElement(LuobuWarningToastComponent)
	self.root = Roact.mount(self.element, CoreGui, "LuobuWarningToast")
	task.delay(10, function() -- line: 18
		-- upvalues: Roact (copy), self (copy)
		Roact.unmount(self.root)
	end)

	return self
end

return t1.new()
