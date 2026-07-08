local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)

require(FoundationParent.React)

local ColorInputMode = require(Foundation.Enums.ColorInputMode)

return {
	createInputConfigs = function(p1, p2, p3, p4, p5: ((...any) -> ...any), p6: ((...any) -> ...any), p7: ((...any) -> ...any), p8: ((...any) -> ...any), _) -- line: 24
		-- upvalues: Dash (copy), ColorInputMode (copy)
		local v14 = Dash.map({
			"R",
			"G",
			"B"
		}, function(s1: string) -- line: 35
			-- upvalues: p1 (copy), p5 (copy)
			return {
				minimum = 0,
				maximum = 255,
				step = 1,
				key = s1,
				component = s1:lower(),
				value = p1:map(function(p10) -- line: 39
					-- upvalues: s1 (copy)
					return p10[s1:lower()]
				end),
				handler = p5
			}
		end)
		local v15 = table.clone(v14)

		table.insert(v15, {
			key = "A",
			minimum = 0,
			maximum = 1,
			step = 0.01,
			precision = 3,
			value = p4,
			handler = p8
		})

		local v16 = Dash.map({
			"H",
			"S",
			"V"
		}, function(s2: string) -- line: 60
			-- upvalues: p2 (copy), p6 (copy)
			return {
				minimum = 0,
				key = s2,
				component = s2:lower(),
				value = p2:map(function(p11) -- line: 64
					-- upvalues: s2 (copy)
					return p11[s2:lower()]
				end),
				handler = p6,
				maximum = if s2 ~= "H" then nil else 360
			}
		end)
		local t1 = {{
			placeholder = "#000000",
			key = tostring(ColorInputMode.Hex),
			value = p3,
			handler = p7,
			width = UDim.new(1, 0)
		}}

		return {
			[ColorInputMode.RGB] = v14,
			[ColorInputMode.RGBA] = v15,
			[ColorInputMode.HSV] = v16,
			[ColorInputMode.Hex] = t1
		}
	end
}
