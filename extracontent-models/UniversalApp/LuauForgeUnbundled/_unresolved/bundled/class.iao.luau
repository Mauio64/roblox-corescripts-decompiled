local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local Style = require("@game/CorePackages/Workspace/Packages/Style")

local fFlagAppNavLabelScaling = SharedFlags.FFlagAppNavLabelScaling
local defineFastFlag = game:DefineFastFlag("BuilderSansNavbarFlagSize", false)

local defineFastInt = game:DefineFastInt("BuilderSansNavBarMinSize", 10.08)
local defineFastInt2 = game:DefineFastInt("BuilderSansNavBarMaxSize", 13.86)
local v5 = not defineFastFlag and 10.08 or defineFastInt
local v6 = not defineFastFlag and 12.6 or defineFastInt2
local class = {}
class.__index = class

function class.new()
	local binding, v7 = React.createBinding(v6)

	return (setmetatable({ _textSize = binding, _setTextSize = v7 }, class))
end

function class:getBinding()
	return self._textSize
end

function class:getMinTextSize(p3, p4, p5)
	local value = self._textSize:getValue()
	local vector2 = Vector2.new(2147483647, p5.Y)
	local v7 = Vector2.new(2147483647, p5.Y)

	while v5 < value and v7.X > p5.X do
		v7 = Style.GetTextSize(p3, value, p4, vector2, { addTemporaryPadding = false })

		if v7.X > p5.X then
			value -= 1
		end
	end

	if value < self._textSize:getValue() then
		self._setTextSize(value)
	end

	return value
end

if fFlagAppNavLabelScaling then
	function class:setTextToMaxSize(p3, p4, p5, p6)
		local vector2 = Vector2.new(2147483647, p5.Y)
		local v7 = Vector2.new(2147483647, p5.Y)

		while v5 < p6 and v7.X > p5.X do
			v7 = Style.GetTextSize(p3, p6, p4, vector2, {
				addTemporaryPadding = false
			})

			if v7.X > p5.X then
				p6 -= 1
			end
		end

		self._setTextSize(p6)
	end
end

class.default = class.new()
return class
