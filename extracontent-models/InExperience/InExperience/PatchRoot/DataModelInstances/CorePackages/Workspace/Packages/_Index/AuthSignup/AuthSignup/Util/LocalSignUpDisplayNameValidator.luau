local parent = script:FindFirstAncestor("AuthSignup").Parent
local AuthCommon = require(parent.AuthCommon)
local ArgCheck = require(parent.ArgCheck)

local UsernameIssue = AuthCommon.Enums.UsernameIssue
local LocalSignUpDisplayNameValidator = {}

function LocalSignUpDisplayNameValidator.isLengthTooShortOrTooLong(value): boolean
	ArgCheck.isType(value, "string", "displayName passed into isLengthTooShortOrTooLong")

	local v = string.len(value)
	return v < 3 or v > 20
end

function LocalSignUpDisplayNameValidator.hasBoundingUnderscore(value): boolean
	ArgCheck.isType(value, "string", "displayName passed into hasBoundingUnderscore")

	return string.sub(value, 1, 1) == "_" or string.sub(value, -1) == "_"
end

function LocalSignUpDisplayNameValidator.hasMultipleUnderscores(value): boolean
	ArgCheck.isType(value, "string", "displayName passed into hasMultipleUnderscores")

	local _, v = string.gsub(value, "_", "")
	return v > 1
end

function LocalSignUpDisplayNameValidator.containsInvalidCharacter(p): boolean
	ArgCheck.isType(p, "string", "displayName passed into containsInvalidCharacter")
	return utf8.len(p) == nil
end

function LocalSignUpDisplayNameValidator.locallyValidateDisplayName(data, p)
	ArgCheck.isType(p, "string", "username passed into locallyValidateDisplayName")

	local v = {}

	v[UsernameIssue.LengthTooShortOrTooLong] = data.isLengthTooShortOrTooLong(p)
	v[UsernameIssue.BoundingUnderscore] = data.hasBoundingUnderscore(p)
	v[UsernameIssue.MultipleUnderscores] = data.hasMultipleUnderscores(p)
	v[UsernameIssue.ContainsInvalidCharacter] = data.containsInvalidCharacter(p)

	return v
end

return LocalSignUpDisplayNameValidator
