local parent = script.Parent.Parent
local Cryo = require(parent.Parent.Cryo)

local getFFlagUGCValidationEyebrowEyelashSupport = require(parent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

local defineFastFlag = game:DefineFastFlag("UGCValidationValueToStringVector3Precision", false)

local function round(p, value) -- 3 equivalent calls inferred from this helper
	local v = 10 ^ (value or 0)
	return math.floor(p * v + 0.5) / v
end

local function valueToString(p)
	local typeName = typeof(p)

	if p == Cryo.None then
		return "not defined"
	end

	if typeName == "Vector3" then
		return string.format(
			defineFastFlag and "%g, %g, %g" or "%d, %d, %d",
			round(p.X, 2), -- inferred equivalent call
			round(p.Y, 2), -- inferred equivalent call
			round(p.Z, 2) -- inferred equivalent call
		)
	elseif typeName == "Color3" then
		return string.format("%d, %d, %d", math.floor(p.r * 255), math.floor(p.g * 255), (math.floor(p.b * 255)))
	end

	if not getFFlagUGCValidationEyebrowEyelashSupport() or typeName ~= "table" or p[1] == nil then
		return (tostring(p))
	end

	local v = tostring(p[1])

	for i = 2, #p do
		v ..= ", " .. valueToString(p[i])
	end

	return v
end

return valueToString
