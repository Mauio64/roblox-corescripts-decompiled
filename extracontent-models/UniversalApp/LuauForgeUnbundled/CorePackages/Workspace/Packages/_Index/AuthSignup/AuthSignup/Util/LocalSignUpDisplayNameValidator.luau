local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/ArgCheck")

local usernameIssue = AuthCommon.Enums.UsernameIssue

return {
	isLengthTooShortOrTooLong = function(value): boolean
		ArgCheck.isType(value, "string", "displayName passed into isLengthTooShortOrTooLong")

		local v5 = string.len(value)
		return v5 < 3 or v5 > 20
	end,
	hasBoundingUnderscore = function(value): boolean
		ArgCheck.isType(value, "string", "displayName passed into hasBoundingUnderscore")

		return string.sub(value, 1, 1) == "_" or string.sub(value, -1) == "_"
	end,
	hasMultipleUnderscores = function(value): boolean
		ArgCheck.isType(value, "string", "displayName passed into hasMultipleUnderscores")

		local v5, v6 = string.gsub(value, "_", "")
		return v6 > 1
	end,
	containsInvalidCharacter = function(p2): boolean
		ArgCheck.isType(p2, "string", "displayName passed into containsInvalidCharacter")
		return utf8.len(p2) == nil
	end,
	locallyValidateDisplayName = function(self, p2)
		ArgCheck.isType(p2, "string", "username passed into locallyValidateDisplayName")

		local v5 = {}

		v5[usernameIssue.LengthTooShortOrTooLong] = self.isLengthTooShortOrTooLong(p2)
		v5[usernameIssue.BoundingUnderscore] = self.hasBoundingUnderscore(p2)
		v5[usernameIssue.MultipleUnderscores] = self.hasMultipleUnderscores(p2)
		v5[usernameIssue.ContainsInvalidCharacter] = self.containsInvalidCharacter(p2)

		return v5
	end
}
