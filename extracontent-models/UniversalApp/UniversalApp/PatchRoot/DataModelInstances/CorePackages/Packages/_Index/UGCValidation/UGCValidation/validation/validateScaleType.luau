local parent = script.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)

local Analytics = require(parent.Analytics)

local function validateScaleType(p, p2)
	if not p or Constants.AvatarPartScaleTypes[p.Value] then
		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateScaleType_InvalidAvatarPartScaleType, nil, p2)

	assert(p.Parent)

	return
		false,
		{ string.format(
				"The AvatarPartScaleType value in '%s' is invalid. Please, verify the value you are using is either Classic, ProportionsSlender, or ProportionsNormal.",
				p.Parent.Name
			) }
end

return validateScaleType
