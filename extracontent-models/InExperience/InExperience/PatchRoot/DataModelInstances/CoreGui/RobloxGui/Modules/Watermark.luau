local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)

local WatermarkComponent = require(script.WatermarkComponent)

local class = {}
class.__index = class

function class.new()
	local self = setmetatable({}, class)

	self.root = Roact.createElement(WatermarkComponent)

	self.element = Roact.mount(self.root, CoreGui, "Watermark")

	return self
end

return class.new()
