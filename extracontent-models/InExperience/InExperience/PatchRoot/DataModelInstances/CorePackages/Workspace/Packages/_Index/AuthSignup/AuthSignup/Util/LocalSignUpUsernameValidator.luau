local parent = script:FindFirstAncestor("AuthSignup").Parent
local AuthCommon = require(parent.AuthCommon)
local ArgCheck = require(parent.ArgCheck)
local UsernameIssue = AuthCommon.Enums.UsernameIssue
local LocalSignUpUsernameValidator = {}

function LocalSignUpUsernameValidator.isLengthTooShortOrTooLong(value): boolean
	ArgCheck.isType(value, "string", "username passed into isLengthTooShortOrTooLong")

	local v = string.len(value)
	return v < 3 or v > 20
end

function LocalSignUpUsernameValidator.hasBoundingUnderscore(value): boolean
	ArgCheck.isType(value, "string", "username passed into hasBoundingUnderscore")

	return string.sub(value, 1, 1) == "_" or string.sub(value, -1) == "_"
end

function LocalSignUpUsernameValidator.hasMultipleUnderscores(value): boolean
	ArgCheck.isType(value, "string", "username passed into hasMultipleUnderscores")

	local _, v = string.gsub(value, "_", "")
	return v > 1
end

function LocalSignUpUsernameValidator.containsInvalidCharacter(value): boolean
	ArgCheck.isType(value, "string", "username passed into containsInvalidCharacter")

	return string.match(value, "[^_%w]") ~= nil
end

function LocalSignUpUsernameValidator.locallyValidateUsername(data, p)
	ArgCheck.isType(p, "string", "username passed into locallyValidateUsername")

	local v = {}

	v[UsernameIssue.LengthTooShortOrTooLong] = data.isLengthTooShortOrTooLong(p)
	v[UsernameIssue.BoundingUnderscore] = data.hasBoundingUnderscore(p)
	v[UsernameIssue.MultipleUnderscores] = data.hasMultipleUnderscores(p)
	v[UsernameIssue.ContainsInvalidCharacter] = data.containsInvalidCharacter(p)

	return v
end

return LocalSignUpUsernameValidator
