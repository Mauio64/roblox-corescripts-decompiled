local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local AuthCommon = require(AuthSignupParent.AuthCommon)
local Cryo = require(AuthSignupParent.Cryo)
local ArgCheck = require(AuthSignupParent.ArgCheck)
local Promise = require(AuthSignupParent.Promise)
local UsernameIssue = AuthCommon.Enums.UsernameIssue
local IssueCondition = AuthCommon.Enums.IssueCondition
local PostUsernameValid = AuthCommon.Http.Requests.PostUsernameValid
local SharedFlags = require(AuthSignupParent.SharedFlags)
local LocalSignUpUsernameValidator = require(AuthSignup.Util.LocalSignUpUsernameValidator)
local GetFFlagFixUsernameValidationAlreadyInUse = SharedFlags.GetFFlagFixUsernameValidationAlreadyInUse
local GetFFlagFixUsernameValidationBackendCriteria = SharedFlags.GetFFlagFixUsernameValidationBackendCriteria
local t1 = {
	[0] = UsernameIssue.None,
	[1] = UsernameIssue.AlreadyInUse,
	[2] = UsernameIssue.Inappropriate,
	[3] = UsernameIssue.LengthTooShortOrTooLong,
	[4] = UsernameIssue.BoundingUnderscore,
	[5] = UsernameIssue.MultipleUnderscores,
	[6] = UsernameIssue.ContainsSpaces,
	[7] = UsernameIssue.ContainsInvalidCharacter,
	[10] = UsernameIssue.ContainsPII
}
local t2 = {
	[UsernameIssue.ContainsInvalidCharacter] = "Authentication.SignUp.Label.UsernameError1",
	[UsernameIssue.LengthTooShortOrTooLong] = "Authentication.SignUp.Label.UsernameError2",
	[UsernameIssue.AlreadyInUse] = "Authentication.SignUp.Label.UsernameError3",
	[UsernameIssue.Inappropriate] = "Authentication.SignUp.Label.UsernameError4",
	[UsernameIssue.BoundingUnderscore] = "Authentication.SignUp.Label.UsernameError5",
	[UsernameIssue.MultipleUnderscores] = "Authentication.SignUp.Label.UsernameError6",
	[UsernameIssue.ContainsPII] = "Authentication.SignUp.Label.UsernameError7"
}

local function resetNonHiddenIssuesToProblematic(p1) -- line: 63
	-- upvalues: Cryo (copy), IssueCondition (copy)
	local v22 = Cryo.Dictionary.join(p1)

	for k, v in pairs(v22) do
		if v ~= IssueCondition.Hidden then
			v22[k] = IssueCondition.Problematic
		end
	end

	return v22
end
local function validateFunction(p2, p3, p4, p5, p6) -- line: 75
	-- upvalues: ArgCheck (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpUsernameValidator (copy), IssueCondition (copy), GetFFlagFixUsernameValidationBackendCriteria (copy), GetFFlagFixUsernameValidationAlreadyInUse (copy), PostUsernameValid (copy), t1 (copy), UsernameIssue (copy)
	return function(_) -- line: 76
		-- upvalues: ArgCheck (copy), p3 (copy), p4 (copy), p5 (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpUsernameValidator (copy), IssueCondition (copy), GetFFlagFixUsernameValidationBackendCriteria (copy), GetFFlagFixUsernameValidationAlreadyInUse (copy), PostUsernameValid (copy), p2 (copy), p6 (copy), t1 (copy), UsernameIssue (copy)
		ArgCheck.isType(p3, "string", "username passed into UsernameValidator.validateFunction")
		ArgCheck.isType(p4, "string", "birthday passed into UsernameValidator.validateFunction")
		ArgCheck.isType(p5, "table", "previousIssues passed into UsernameValidator.validateFunction")

		if p3 == "" then
			return Promise.resolve({
				InputValid = false,
				Input = p3,
				IssueCondition = resetNonHiddenIssuesToProblematic(p5)
			})
		end

		local v38 = Cryo.Dictionary.join(p5)
		local v39 = LocalSignUpUsernameValidator:locallyValidateUsername(p3)
		local v40 = false

		for _, v in pairs(v39) do
			if v then
				v40 = true

				break
			end
		end

		if v40 then
			for k, v in pairs(p5) do
				local v45 = v39[k]

				if v == IssueCondition.Hidden and v45 then
					v38[k] = IssueCondition.Problematic
				elseif v ~= IssueCondition.Hidden then
					if GetFFlagFixUsernameValidationBackendCriteria() and v45 == nil then
						v38[k] = IssueCondition.Hidden
					elseif not GetFFlagFixUsernameValidationAlreadyInUse() or v45 ~= nil then
						v38[k] = v45 == false and IssueCondition.Resolved or IssueCondition.Problematic
					end
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p3,
				IssueCondition = v38
			})
		end

		for k, v in pairs(v38) do
			v38[k] = v == IssueCondition.Hidden and IssueCondition.Hidden or IssueCondition.Resolved
		end

		return PostUsernameValid(p2, p3, p4, p6):andThen(function(p8) -- line: 135
			-- upvalues: t1 (copy), UsernameIssue (copy), v38 (copy), IssueCondition (copy), Promise (copy), p3 (copy)
			local v60 = p8 and (p8.responseBody and p8.responseBody.code)
			local v61 = t1[v60]

			if v61 then
				if v61 == UsernameIssue.ContainsSpaces then
					v38[UsernameIssue.ContainsInvalidCharacter] = IssueCondition.Problematic
				elseif v61 ~= UsernameIssue.None then
					v38[v61] = IssueCondition.Problematic
				end
			else
				warn("UsernameValidator.validateFunction() Received unrecognized response code: ", v60)
			end

			return Promise.resolve({
				Input = p3,
				InputValid = v61 == UsernameIssue.None,
				IssueCondition = v38
			})
		end, function(_) -- line: 157
			-- upvalues: Promise (copy), p3 (copy), v38 (copy)
			return Promise.resolve({
				InputValid = true,
				Input = p3,
				IssueCondition = v38
			})
		end)
	end
end
local function validateFunctionRefactor(p10, p11, p12, p13) -- line: 168
	-- upvalues: ArgCheck (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpUsernameValidator (copy), IssueCondition (copy), GetFFlagFixUsernameValidationBackendCriteria (copy), GetFFlagFixUsernameValidationAlreadyInUse (copy), PostUsernameValid (copy), t1 (copy), UsernameIssue (copy)
	local v34 = p13 or {}
	local birthday = v34.birthday
	local context = v34.context

	return function(_) -- line: 76
		-- upvalues: ArgCheck (copy), p11 (copy), birthday (copy), p12 (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpUsernameValidator (copy), IssueCondition (copy), GetFFlagFixUsernameValidationBackendCriteria (copy), GetFFlagFixUsernameValidationAlreadyInUse (copy), PostUsernameValid (copy), p10 (copy), context (copy), t1 (copy), UsernameIssue (copy)
		ArgCheck.isType(p11, "string", "username passed into UsernameValidator.validateFunction")
		ArgCheck.isType(birthday, "string", "birthday passed into UsernameValidator.validateFunction")
		ArgCheck.isType(p12, "table", "previousIssues passed into UsernameValidator.validateFunction")

		if p11 == "" then
			return Promise.resolve({
				InputValid = false,
				Input = p11,
				IssueCondition = resetNonHiddenIssuesToProblematic(p12)
			})
		end

		local v49 = Cryo.Dictionary.join(p12)
		local v50 = LocalSignUpUsernameValidator:locallyValidateUsername(p11)
		local v51 = false

		for _, v in pairs(v50) do
			if v then
				v51 = true

				break
			end
		end

		if v51 then
			for k, v in pairs(p12) do
				local v56 = v50[k]

				if v == IssueCondition.Hidden and v56 then
					v49[k] = IssueCondition.Problematic
				elseif v ~= IssueCondition.Hidden then
					if GetFFlagFixUsernameValidationBackendCriteria() and v56 == nil then
						v49[k] = IssueCondition.Hidden
					elseif not GetFFlagFixUsernameValidationAlreadyInUse() or v56 ~= nil then
						v49[k] = v56 == false and IssueCondition.Resolved or IssueCondition.Problematic
					end
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p11,
				IssueCondition = v49
			})
		end

		for k, v in pairs(v49) do
			v49[k] = v == IssueCondition.Hidden and IssueCondition.Hidden or IssueCondition.Resolved
		end

		return PostUsernameValid(p10, p11, birthday, context):andThen(function(p15) -- line: 135
			-- upvalues: t1 (copy), UsernameIssue (copy), v49 (copy), IssueCondition (copy), Promise (copy), p11 (copy)
			local v64 = p15 and (p15.responseBody and p15.responseBody.code)
			local v65 = t1[v64]

			if v65 then
				if v65 == UsernameIssue.ContainsSpaces then
					v49[UsernameIssue.ContainsInvalidCharacter] = IssueCondition.Problematic
				elseif v65 ~= UsernameIssue.None then
					v49[v65] = IssueCondition.Problematic
				end
			else
				warn("UsernameValidator.validateFunction() Received unrecognized response code: ", v64)
			end

			return Promise.resolve({
				Input = p11,
				InputValid = v65 == UsernameIssue.None,
				IssueCondition = v49
			})
		end, function(_) -- line: 157
			-- upvalues: Promise (copy), p11 (copy), v49 (copy)
			return Promise.resolve({
				InputValid = true,
				Input = p11,
				IssueCondition = v49
			})
		end)
	end
end

return {
	validateFunction = validateFunctionRefactor,
	getIssueMessageList = function() -- line: 41
		-- upvalues: t2 (copy)
		return t2
	end,
	getDefaultIssues = function() -- line: 45
		-- upvalues: t2 (copy), UsernameIssue (copy), IssueCondition (copy)
		local t3 = {}

		for k in pairs(t2) do
			if k == UsernameIssue.ContainsInvalidCharacter or k == UsernameIssue.LengthTooShortOrTooLong or k == UsernameIssue.AlreadyInUse then
				t3[k] = IssueCondition.Problematic
			else
				t3[k] = IssueCondition.Hidden
			end
		end

		return t3
	end
}
