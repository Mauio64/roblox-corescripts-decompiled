local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FFlagAppNavLabelScaling = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppNavLabelScaling
local v5 = game:DefineFastFlag("BuilderSansNavbarFlagSize", false)
local v6 = game:DefineFastInt("BuilderSansNavBarMinSize", 10.08)
local v7 = game:DefineFastInt("BuilderSansNavBarMaxSize", 13.86)
local v8 = not v5 and 10.08 or v6
local v9 = not v5 and 12.6 or v7
local t1 = {}

t1.__index = t1

function t1.new() -- line: 45
	-- upvalues: React (copy), v9 (copy), t1 (copy)
	local v11, v12 = React.createBinding(v9)

	return (setmetatable({
		_textSize = v11,
		_setTextSize = v12
	}, t1))
end
function t1.getBinding(p1) -- line: 57
	return p1._textSize
end
function t1.getMinTextSize(t2: {[any]: any}, s1: string, p2, vector2: Vector2) -- line: 61
	-- upvalues: v8 (copy), TextService (copy)
	local v18 = t2._textSize:getValue()
	local vector2_2 = Vector2.new(2147483647, vector2.Y)
	local vector2_3 = Vector2.new(2147483647, vector2.Y)

	while v18 > v8 and vector2_3.X > vector2.X do
		vector2_3 = TextService:GetTextSize(s1, v18, p2, vector2_2)

		if vector2_3.X > vector2.X then
			v18 -= 1
		end
	end

	if v18 < t2._textSize:getValue() then
		t2._setTextSize(v18)
	end

	return v18
end

if FFlagAppNavLabelScaling then
	function t1.setTextToMaxSize(t3: {[any]: any}, s2: string, p3, vector2: Vector2, n1: number) -- line: 82
		-- upvalues: v8 (copy), TextService (copy)
		local vector2_4 = Vector2.new(2147483647, vector2.Y)
		local vector2_5 = Vector2.new(2147483647, vector2.Y)

		while n1 > v8 and vector2_5.X > vector2.X do
			vector2_5 = TextService:GetTextSize(s2, n1, p3, vector2_4)

			if vector2_5.X > vector2.X then
				n1 -= 1
			end
		end

		t3._setTextSize(n1)
	end
end

t1.default = t1.new()

return t1
