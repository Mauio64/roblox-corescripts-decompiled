local parent = script:FindFirstAncestor("AuthSignup").Parent
local AuthCommon = require(parent.AuthCommon)

local PostPasswordValid = AuthCommon.Http.Requests.PostPasswordValid
local Promise = require(parent.Promise)
local PasswordIssue = AuthCommon.Enums.PasswordIssue
local IssueCondition = AuthCommon.Enums.IssueCondition

local SharedFlags = require(parent.SharedFlags)
local FFlagSignUpPasswordCopyV2 = SharedFlags.FFlagSignUpPasswordCopyV2
local GetFFlagPasswordErrorLength = SharedFlags.GetFFlagPasswordErrorLength
local issueMessageList

if FFlagSignUpPasswordCopyV2 then
	issueMessageList = {}

	issueMessageList[PasswordIssue.Length] = "Authentication.SignUp.Label.PasswordPlaceholder"
	issueMessageList[PasswordIssue.UsernameMatch] = "Authentication.SignUp.Label.PasswordError2.V2"
	issueMessageList[PasswordIssue.Simple] = "Authentication.SignUp.Label.PasswordError3.V2"
else
	issueMessageList = {}
	issueMessageList[PasswordIssue.Length] = GetFFlagPasswordErrorLength()
		and "Authentication.SignUp.PasswordErrorLength"
		or "Authentication.SignUp.Label.PasswordError1"

	issueMessageList[PasswordIssue.UsernameMatch] = "Authentication.SignUp.Label.PasswordError2"
	issueMessageList[PasswordIssue.Simple] = "Authentication.SignUp.Label.PasswordError3"
end

local function validateFunction(p, username, input, p2) -- 1 equivalent call inferred from this helper
	return function(_)
		local issueCondition = {}
		issueCondition[PasswordIssue.Length] = IssueCondition.Resolved
		issueCondition[PasswordIssue.UsernameMatch] = IssueCondition.Resolved
		issueCondition[PasswordIssue.Simple] = p2[PasswordIssue.Simple] ~= IssueCondition.Hidden
			and IssueCondition.Resolved
			or IssueCondition.Hidden

		if username ~= nil and input ~= nil and username ~= "" and input ~= "" and string.match(input, "%S") ~= nil then
			return PostPasswordValid(p, username, input):andThen(function(p3)
				local code = p3 and p3.responseBody and p3.responseBody.code

				if type(code) == "number" then
					if code == 2 then
						issueCondition[PasswordIssue.Length] = IssueCondition.Problematic
					elseif code == 3 then
						issueCondition[PasswordIssue.UsernameMatch] = IssueCondition.Problematic
					elseif code == 4 or code == 5 then
						issueCondition[PasswordIssue.Simple] = IssueCondition.Problematic
					end
				else
					warn("JSON failure")
				end

				local v = {
					["Input"] = input,
					InputValid = code == 0,
					IssueCondition = issueCondition
				}

				return Promise.resolve(v)
			end, function(_)
				return Promise.resolve({
					Input = input,
					InputValid = true,
					IssueCondition = issueCondition
				})
			end)
		end

		for k in pairs(issueCondition) do
			if issueCondition[k] == IssueCondition.Resolved then
				issueCondition[k] = IssueCondition.Problematic
			end
		end

		return Promise.resolve({
			Input = input,
			InputValid = false,
			IssueCondition = issueCondition
		})
	end
end

local function validateFunctionRefactor(p, input, p2, options)
	return validateFunction(p, (options or {}).username, input, p2) -- inferred equivalent call
end

local PasswordValidator = {}
PasswordValidator.validateFunction = validateFunctionRefactor

function PasswordValidator.getIssueMessageList()
	return issueMessageList
end

function PasswordValidator.getDefaultIssues()
	local problematics = {}

	for k in pairs(issueMessageList) do
		problematics[k] = IssueCondition.Problematic
	end

	return problematics
end

return PasswordValidator
