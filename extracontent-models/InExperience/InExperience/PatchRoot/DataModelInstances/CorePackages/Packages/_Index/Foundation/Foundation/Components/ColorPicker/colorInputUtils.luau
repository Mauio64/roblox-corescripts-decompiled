local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
require(parent.React)

local ColorInputMode = require(Foundation.Enums.ColorInputMode)

return {
	createInputConfigs = function(object, object2, p, p2, handler, handler2, handler3, handler4, _)
		local mapped = Dash.map({ "R", "G", "B" }, function(value: string)
			return {
				key = value,
				component = value:lower(),
				value = object:map(function(p3)
					return p3[value:lower()]
				end),
				handler = handler,
				minimum = 0,
				maximum = 255,
				step = 1
			}
		end)

		local clone = table.clone(mapped)
		table.insert(clone, {
			key = "A",
			value = p2,
			handler = handler4,
			minimum = 0,
			maximum = 1,
			step = 0.01,
			precision = 3
		})

		local mapped2 = Dash.map({ "H", "S", "V" }, function(value: string)
			return {
				key = value,
				component = value:lower(),
				value = object2:map(function(p3)
					return p3[value:lower()]
				end),
				handler = handler2,
				minimum = 0,
				maximum = value == "H" and 360 or nil
			}
		end)

		local v = {
			{
				key = tostring(ColorInputMode.Hex),
				value = p,
				handler = handler3,
				placeholder = "#000000",
				width = UDim.new(1, 0)
			}
		}

		return {
			[ColorInputMode.RGB] = mapped,
			[ColorInputMode.RGBA] = clone,
			[ColorInputMode.HSV] = mapped2,
			[ColorInputMode.Hex] = v
		}
	end
}
