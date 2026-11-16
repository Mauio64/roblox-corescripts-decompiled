local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent
local AuthCommon = require(parent.AuthCommon)

local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local Promise = require(parent.Promise)

local UsernameIssue = AuthCommon.Enums.UsernameIssue
local IssueCondition = AuthCommon.Enums.IssueCondition
local PostUsernameValid = AuthCommon.Http.Requests.PostUsernameValid
local SharedFlags = require(parent.SharedFlags)

local LocalSignUpUsernameValidator = require(AuthSignup.Util.LocalSignUpUsernameValidator)

local FFlagAllowCurrentUsernameOnSignup = SharedFlags.FFlagAllowCurrentUsernameOnSignup
local GetFFlagFixUsernameValidationAlreadyInUse = SharedFlags.GetFFlagFixUsernameValidationAlreadyInUse
local GetFFlagFixUsernameValidationBackendCriteria = SharedFlags.GetFFlagFixUsernameValidationBackendCriteria

local v = {
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

local issueMessageList = {
	[UsernameIssue.ContainsInvalidCharacter] = "Authentication.SignUp.Label.UsernameError1",
	[UsernameIssue.LengthTooShortOrTooLong] = "Authentication.SignUp.Label.UsernameError2",
	[UsernameIssue.AlreadyInUse] = "Authentication.SignUp.Label.UsernameError3",
	[UsernameIssue.Inappropriate] = "Authentication.SignUp.Label.UsernameError4",
	[UsernameIssue.BoundingUnderscore] = "Authentication.SignUp.Label.UsernameError5",
	[UsernameIssue.MultipleUnderscores] = "Authentication.SignUp.Label.UsernameError6",
	[UsernameIssue.ContainsPII] = "Authentication.SignUp.Label.UsernameError7"
}

local function resetNonHiddenIssuesToProblematic(items)
	local joined = Cryo.Dictionary.join(items)

	for k, v2 in pairs(joined) do
		if v2 ~= IssueCondition.Hidden then
			joined[k] = IssueCondition.Problematic
		end
	end

	return joined
end

local function validateFunction(p, input, birthday, items, context) -- 1 equivalent call inferred from this helper
	return function(_)
		ArgCheck.isType(input, "string", "username passed into UsernameValidator.validateFunction")
		ArgCheck.isType(birthday, "string", "birthday passed into UsernameValidator.validateFunction")
		ArgCheck.isType(items, "table", "previousIssues passed into UsernameValidator.validateFunction")

		if input == "" then
			return Promise.resolve({
				Input = input,
				InputValid = false,
				IssueCondition = resetNonHiddenIssuesToProblematic(items)
			})
		end

		local joined = Cryo.Dictionary.join(items)

		local locallyValidateUsername = LocalSignUpUsernameValidator:locallyValidateUsername(input)
		local flag = false

		for _, v2 in pairs(locallyValidateUsername) do
			if v2 then
				flag = true
				break
			end
		end

		if flag then
			for k, item in pairs(items) do
				local v2 = locallyValidateUsername[k]

				if item == IssueCondition.Hidden and v2 then
					joined[k] = IssueCondition.Problematic
				elseif item ~= IssueCondition.Hidden then
					if GetFFlagFixUsernameValidationBackendCriteria() and v2 == nil then
						joined[k] = IssueCondition.Hidden
					elseif not GetFFlagFixUsernameValidationAlreadyInUse() or v2 ~= nil then
						joined[k] = v2 == false and IssueCondition.Resolved or IssueCondition.Problematic
					end
				end
			end

			return Promise.resolve({ Input = input, InputValid = false, IssueCondition = joined })
		end

		for k, v2 in pairs(joined) do
			joined[k] = v2 == IssueCondition.Hidden and IssueCondition.Hidden or IssueCondition.Resolved
		end

		return PostUsernameValid(p, input, birthday, context):andThen(function(p2)
			local code = p2 and p2.responseBody and p2.responseBody.code
			local v2 = v[code]

			if v2 then
				if v2 == UsernameIssue.ContainsSpaces then
					joined[UsernameIssue.ContainsInvalidCharacter] = IssueCondition.Problematic
				elseif v2 ~= UsernameIssue.None then
					joined[v2] = IssueCondition.Problematic
				end
			else
				warn("UsernameValidator.validateFunction() Received unrecognized response code: ", code)
			end

			return Promise.resolve({
				Input = input,
				InputValid = v2 == UsernameIssue.None,
				IssueCondition = joined
			})
		end, function(_)
			return Promise.resolve({ Input = input, InputValid = true, IssueCondition = joined })
		end)
	end
end

local function isKeptCurrentUsername(value, currentUsername): boolean -- 1 equivalent call inferred from this helper
	return currentUsername ~= nil and currentUsername ~= "" and string.lower(value) == string.lower(currentUsername)
end

local function resolveAlreadyInUseIfKeptCurrentUsername(p)
	if p.IssueCondition[UsernameIssue.AlreadyInUse] ~= IssueCondition.Problematic then
		return p
	end

	local joined = Cryo.Dictionary.join(p.IssueCondition)
	joined[UsernameIssue.AlreadyInUse] = IssueCondition.Resolved
	local inputValid = true

	for _, v2 in pairs(joined) do
		if v2 == IssueCondition.Problematic then
			inputValid = false
			break
		end
	end

	return Cryo.Dictionary.join(p, { InputValid = inputValid, IssueCondition = joined })
end

local function validateFunctionRefactor(p, value, items, options)
	local v2 = options or {}

	local v3 = validateFunction(p, value, v2.birthday, items, v2.context) -- inferred equivalent call

	if not FFlagAllowCurrentUsernameOnSignup then
		return v3
	end

	if isKeptCurrentUsername(value, v2.currentUsername) then -- inferred equivalent call
		return function(p2)
			return v3(p2):andThen(resolveAlreadyInUseIfKeptCurrentUsername)
		end
	end

	return v3
end

local UsernameValidator = {}
UsernameValidator.validateFunction = validateFunctionRefactor

function UsernameValidator.getIssueMessageList()
	return issueMessageList
end

function UsernameValidator.getDefaultIssues()
	local defaultIssues = {}

	for k in pairs(issueMessageList) do
		if
			k == UsernameIssue.ContainsInvalidCharacter
			or k == UsernameIssue.LengthTooShortOrTooLong
			or k == UsernameIssue.AlreadyInUse
		then
			defaultIssues[k] = IssueCondition.Problematic
		else
			defaultIssues[k] = IssueCondition.Hidden
		end
	end

	return defaultIssues
end

return UsernameValidator
