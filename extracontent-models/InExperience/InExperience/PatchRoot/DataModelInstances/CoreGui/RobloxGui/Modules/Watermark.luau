local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local WatermarkComponent = require(script.WatermarkComponent)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
	-- upvalues: t1 (copy), Roact (copy), WatermarkComponent (copy), CoreGui (copy)
	local self = setmetatable({}, t1)

	self.root = Roact.createElement(WatermarkComponent)
	self.element = Roact.mount(self.root, CoreGui, "Watermark")

	return self
end

return t1.new()
