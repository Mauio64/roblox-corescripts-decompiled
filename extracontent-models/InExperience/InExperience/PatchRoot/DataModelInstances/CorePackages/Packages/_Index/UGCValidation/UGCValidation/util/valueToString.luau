local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Parent.Cryo)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)
local v4 = game:DefineFastFlag("UGCValidationValueToStringVector3Precision", false)

local function round(p1, p2) -- line: 9
	local v9 = 10 ^ (p2 or 0)

	return math.floor(p1 * v9 + 0.5) / v9
end
local function valueToString(p3) -- line: 14
	-- upvalues: Cryo (copy), v4 (copy), getFFlagUGCValidationEyebrowEyelashSupport (copy), valueToString (copy)
	local v11 = typeof(p3)

	if p3 == Cryo.None then
		return "not defined"
	end

	if v11 == "Vector3" then
		local v12 = not v4 and "%d, %d, %d" or "%g, %g, %g"

		return string.format(v12, math.floor(p3.X * 100 + 0.5) / 100, math.floor(p3.Y * 100 + 0.5) / 100, math.floor(p3.Z * 100 + 0.5) / 100)
	end

	if v11 == "Color3" then
		return string.format("%d, %d, %d", math.floor(p3.r * 255), math.floor(p3.g * 255), (math.floor(p3.b * 255)))
	end

	if getFFlagUGCValidationEyebrowEyelashSupport() and v11 == "table" and p3[1] ~= nil then
		local str = tostring(p3[1])

		for i = 2, #p3 do
			str ..= ", " .. valueToString(p3[i])
		end

		return str
	end

	return (tostring(p3))
end

return valueToString
