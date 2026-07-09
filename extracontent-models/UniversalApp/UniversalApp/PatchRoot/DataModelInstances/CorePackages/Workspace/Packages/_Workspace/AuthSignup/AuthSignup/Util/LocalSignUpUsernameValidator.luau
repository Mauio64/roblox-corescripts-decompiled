local Parent = script:FindFirstAncestor("AuthSignup").Parent
local AuthCommon = require(Parent.AuthCommon)
local ArgCheck = require(Parent.ArgCheck)
local UsernameIssue = AuthCommon.Enums.UsernameIssue

return {
	isLengthTooShortOrTooLong = function(p1) -- line: 9
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p1, "string", "username passed into isLengthTooShortOrTooLong")

		local v6 = string.len(p1)

		return v6 < 3 or v6 > 20
	end,
	hasBoundingUnderscore = function(p2) -- line: 16
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p2, "string", "username passed into hasBoundingUnderscore")

		return string.sub(p2, 1, 1) == "_" or string.sub(p2, -1) == "_"
	end,
	hasMultipleUnderscores = function(p3) -- line: 22
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p3, "string", "username passed into hasMultipleUnderscores")

		local _, count = string.gsub(p3, "_", "")

		return count > 1
	end,
	containsInvalidCharacter = function(p4) -- line: 29
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p4, "string", "username passed into containsInvalidCharacter")

		return string.match(p4, "[^_%w]") ~= nil
	end,
	locallyValidateUsername = function(p5, p6) -- line: 35
		-- upvalues: ArgCheck (copy), UsernameIssue (copy)
		ArgCheck.isType(p6, "string", "username passed into locallyValidateUsername")

		return {
			[UsernameIssue.LengthTooShortOrTooLong] = p5.isLengthTooShortOrTooLong(p6),
			[UsernameIssue.BoundingUnderscore] = p5.hasBoundingUnderscore(p6),
			[UsernameIssue.MultipleUnderscores] = p5.hasMultipleUnderscores(p6),
			[UsernameIssue.ContainsInvalidCharacter] = p5.containsInvalidCharacter(p6)
		}
	end
}
