local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/ArgCheck")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")

local usernameIssue = AuthCommon.Enums.UsernameIssue
local issueCondition = AuthCommon.Enums.IssueCondition
local postUsernameValid = AuthCommon.Http.Requests.PostUsernameValid
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")

local LocalSignUpUsernameValidator = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Util/LocalSignUpUsernameValidator")

local fFlagAllowCurrentUsernameOnSignup = SharedFlags.FFlagAllowCurrentUsernameOnSignup
local getFFlagFixUsernameValidationAlreadyInUse = SharedFlags.GetFFlagFixUsernameValidationAlreadyInUse
local getFFlagFixUsernameValidationBackendCriteria = SharedFlags.GetFFlagFixUsernameValidationBackendCriteria

local v5 = {
	[0] = usernameIssue.None,
	[1] = usernameIssue.AlreadyInUse,
	[2] = usernameIssue.Inappropriate,
	[3] = usernameIssue.LengthTooShortOrTooLong,
	[4] = usernameIssue.BoundingUnderscore,
	[5] = usernameIssue.MultipleUnderscores,
	[6] = usernameIssue.ContainsSpaces,
	[7] = usernameIssue.ContainsInvalidCharacter,
	[10] = usernameIssue.ContainsPII
}

local issueMessageList = {
	[usernameIssue.ContainsInvalidCharacter] = "Authentication.SignUp.Label.UsernameError1",
	[usernameIssue.LengthTooShortOrTooLong] = "Authentication.SignUp.Label.UsernameError2",
	[usernameIssue.AlreadyInUse] = "Authentication.SignUp.Label.UsernameError3",
	[usernameIssue.Inappropriate] = "Authentication.SignUp.Label.UsernameError4",
	[usernameIssue.BoundingUnderscore] = "Authentication.SignUp.Label.UsernameError5",
	[usernameIssue.MultipleUnderscores] = "Authentication.SignUp.Label.UsernameError6",
	[usernameIssue.ContainsPII] = "Authentication.SignUp.Label.UsernameError7"
}

local function resetNonHiddenIssuesToProblematic(items)
	local joined = Cryo.Dictionary.join(items)

	for k, v6 in pairs(joined) do
		if v6 ~= issueCondition.Hidden then
			joined[k] = issueCondition.Problematic
		end
	end

	return joined
end

local function validateFunction(p2, p3, p4, items, p5)
	return function(p6)
		ArgCheck.isType(p3, "string", "username passed into UsernameValidator.validateFunction")
		ArgCheck.isType(p4, "string", "birthday passed into UsernameValidator.validateFunction")
		ArgCheck.isType(items, "table", "previousIssues passed into UsernameValidator.validateFunction")

		if p3 == "" then
			return Promise.resolve({
				Input = p3,
				InputValid = false,
				IssueCondition = resetNonHiddenIssuesToProblematic(items)
			})
		end

		local joined = Cryo.Dictionary.join(items)

		local locallyValidateUsername = LocalSignUpUsernameValidator:locallyValidateUsername(p3)
		local flag = false

		for k, v7 in pairs(locallyValidateUsername) do
			if v7 then
				flag = true
				break
			end
		end

		if flag then
			for k, item in pairs(items) do
				local v7 = locallyValidateUsername[k]

				if item == issueCondition.Hidden and v7 then
					joined[k] = issueCondition.Problematic
				elseif item ~= issueCondition.Hidden then
					if getFFlagFixUsernameValidationBackendCriteria() and v7 == nil then
						joined[k] = issueCondition.Hidden
					elseif not getFFlagFixUsernameValidationAlreadyInUse() or v7 ~= nil then
						joined[k] = v7 == false and issueCondition.Resolved or issueCondition.Problematic
					end
				end
			end

			return Promise.resolve({
				Input = p3,
				InputValid = false,
				IssueCondition = joined
			})
		end

		for k, v7 in pairs(joined) do
			joined[k] = v7 == issueCondition.Hidden and issueCondition.Hidden or issueCondition.Resolved
		end

		return postUsernameValid(p2, p3, p4, p5):andThen(function(p7)
			local code = p7 and p7.responseBody and p7.responseBody.code
			local v7 = v5[code]

			if v7 then
				if v7 == usernameIssue.ContainsSpaces then
					joined[usernameIssue.ContainsInvalidCharacter] = issueCondition.Problematic
				elseif v7 ~= usernameIssue.None then
					joined[v7] = issueCondition.Problematic
				end
			else
				warn("UsernameValidator.validateFunction() Received unrecognized response code: ", code)
			end

			return Promise.resolve({
				Input = p3,
				InputValid = v7 == usernameIssue.None,
				IssueCondition = joined
			})
		end, function(p7)
			return Promise.resolve({
				Input = p3,
				InputValid = true,
				IssueCondition = joined
			})
		end)
	end
end

local function isKeptCurrentUsername(value, value2): boolean
	return value2 ~= nil and value2 ~= "" and string.lower(value) == string.lower(value2)
end

local function resolveAlreadyInUseIfKeptCurrentUsername(p2)
	if p2.IssueCondition[usernameIssue.AlreadyInUse] ~= issueCondition.Problematic then
		return p2
	end

	local joined = Cryo.Dictionary.join(p2.IssueCondition)
	joined[usernameIssue.AlreadyInUse] = issueCondition.Resolved
	local v6 = true

	for k, v8 in pairs(joined) do
		if v8 == issueCondition.Problematic then
			v6 = false
			break
		end
	end

	return Cryo.Dictionary.join(p2, { InputValid = v6, IssueCondition = joined })
end

local function validateFunctionRefactor(p2, value, items, options)
	local v6 = options or {}

	local birthday = v6.birthday
	local context = v6.context

	local function fn(p3)
		ArgCheck.isType(value, "string", "username passed into UsernameValidator.validateFunction")
		ArgCheck.isType(birthday, "string", "birthday passed into UsernameValidator.validateFunction")
		ArgCheck.isType(items, "table", "previousIssues passed into UsernameValidator.validateFunction")

		if value == "" then
			return Promise.resolve({
				Input = value,
				InputValid = false,
				IssueCondition = resetNonHiddenIssuesToProblematic(items)
			})
		end

		local joined = Cryo.Dictionary.join(items)

		local locallyValidateUsername = LocalSignUpUsernameValidator:locallyValidateUsername(value)
		local flag = false

		for k, v8 in pairs(locallyValidateUsername) do
			if v8 then
				flag = true
				break
			end
		end

		if flag then
			for k, item in pairs(items) do
				local v8 = locallyValidateUsername[k]

				if item == issueCondition.Hidden and v8 then
					joined[k] = issueCondition.Problematic
				elseif item ~= issueCondition.Hidden then
					if getFFlagFixUsernameValidationBackendCriteria() and v8 == nil then
						joined[k] = issueCondition.Hidden
					elseif not getFFlagFixUsernameValidationAlreadyInUse() or v8 ~= nil then
						joined[k] = v8 == false and issueCondition.Resolved or issueCondition.Problematic
					end
				end
			end

			return Promise.resolve({
				Input = value,
				InputValid = false,
				IssueCondition = joined
			})
		end

		for k, v8 in pairs(joined) do
			joined[k] = v8 == issueCondition.Hidden and issueCondition.Hidden or issueCondition.Resolved
		end

		return postUsernameValid(p2, value, birthday, context):andThen(function(p4)
			local code = p4 and p4.responseBody and p4.responseBody.code
			local v8 = v5[code]

			if v8 then
				if v8 == usernameIssue.ContainsSpaces then
					joined[usernameIssue.ContainsInvalidCharacter] = issueCondition.Problematic
				elseif v8 ~= usernameIssue.None then
					joined[v8] = issueCondition.Problematic
				end
			else
				warn("UsernameValidator.validateFunction() Received unrecognized response code: ", code)
			end

			return Promise.resolve({
				Input = value,
				InputValid = v8 == usernameIssue.None,
				IssueCondition = joined
			})
		end, function(p4)
			return Promise.resolve({
				Input = value,
				InputValid = true,
				IssueCondition = joined
			})
		end)
	end

	if not fFlagAllowCurrentUsernameOnSignup then
		return fn
	end

	local currentUsername = v6.currentUsername
	local v7

	if currentUsername == nil or currentUsername == "" then
		v7 = false
	else
		v7 = string.lower(value) == string.lower(currentUsername)
	end

	if v7 then
		return function(p3)
			return fn(p3):andThen(resolveAlreadyInUseIfKeptCurrentUsername)
		end
	end

	return fn
end

return {
	validateFunction = validateFunctionRefactor,
	getIssueMessageList = function()
		return issueMessageList
	end,
	getDefaultIssues = function()
		local defaultIssues = {}

		for k in pairs(issueMessageList) do
			if
				k == usernameIssue.ContainsInvalidCharacter
				or k == usernameIssue.LengthTooShortOrTooLong
				or k == usernameIssue.AlreadyInUse
			then
				defaultIssues[k] = issueCondition.Problematic
			else
				defaultIssues[k] = issueCondition.Hidden
			end
		end

		return defaultIssues
	end
}
