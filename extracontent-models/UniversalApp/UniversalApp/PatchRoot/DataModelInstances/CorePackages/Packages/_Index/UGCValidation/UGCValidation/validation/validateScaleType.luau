local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)

local function validateScaleType(p1, p2) -- line: 12
	-- upvalues: Constants (copy), Analytics (copy)
	if not p1 then
		return true
	end

	if not Constants.AvatarPartScaleTypes[p1.Value] then
		Analytics.reportFailure(Analytics.ErrorType.validateScaleType_InvalidAvatarPartScaleType, nil, p2)
		assert(p1.Parent)

		return false, { string.format("The AvatarPartScaleType value in '%s' is invalid. Please, verify the value you are using is either Classic, ProportionsSlender, or ProportionsNormal.", p1.Parent.Name) }
	end

	return true
end

return validateScaleType
