local parent = script.Parent.Parent.Parent

local Foundation = require(parent.Foundation)

local blendColors = Foundation.Utility.blendColors

local function getContrastingContentStyle(color: Color3, transparency: number, p, p2, p3)
	local v = blendColors({ Color3 = p.Color3, Transparency = p.Transparency }, {
		Color3 = color,
		Transparency = transparency
	})

	local color3 = p2.Color3
	local color3_2 = p3.Color3

	if v.Color3:GetContrastingColor(color3, color3_2) == color3 then
		return p2
	end

	return p3
end

return getContrastingContentStyle
