local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")

local postPasswordValid = AuthCommon.Http.Requests.PostPasswordValid
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")
local passwordIssue = AuthCommon.Enums.PasswordIssue
local issueCondition = AuthCommon.Enums.IssueCondition

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")
local fFlagSignUpPasswordCopyV2 = SharedFlags.FFlagSignUpPasswordCopyV2
local getFFlagPasswordErrorLength = SharedFlags.GetFFlagPasswordErrorLength
local issueMessageList

if fFlagSignUpPasswordCopyV2 then
	issueMessageList = {}

	issueMessageList[passwordIssue.Length] = "Authentication.SignUp.Label.PasswordPlaceholder"
	issueMessageList[passwordIssue.UsernameMatch] = "Authentication.SignUp.Label.PasswordError2.V2"
	issueMessageList[passwordIssue.Simple] = "Authentication.SignUp.Label.PasswordError3.V2"
else
	issueMessageList = {}
	issueMessageList[passwordIssue.Length] = getFFlagPasswordErrorLength()
		and "Authentication.SignUp.PasswordErrorLength"
		or "Authentication.SignUp.Label.PasswordError1"

	issueMessageList[passwordIssue.UsernameMatch] = "Authentication.SignUp.Label.PasswordError2"
	issueMessageList[passwordIssue.Simple] = "Authentication.SignUp.Label.PasswordError3"
end

local function validateFunction(p2, p3, input, p4)
	return function(p5)
		local v5 = {}
		v5[passwordIssue.Length] = issueCondition.Resolved
		v5[passwordIssue.UsernameMatch] = issueCondition.Resolved
		v5[passwordIssue.Simple] = p4[passwordIssue.Simple] ~= issueCondition.Hidden
			and issueCondition.Resolved
			or issueCondition.Hidden

		if p3 ~= nil and input ~= nil and p3 ~= "" and input ~= "" and string.match(input, "%S") ~= nil then
			return postPasswordValid(p2, p3, input):andThen(function(p6)
				local code = p6 and p6.responseBody and p6.responseBody.code

				if type(code) == "number" then
					if code == 2 then
						v5[passwordIssue.Length] = issueCondition.Problematic
					elseif code == 3 then
						v5[passwordIssue.UsernameMatch] = issueCondition.Problematic
					elseif code == 4 or code == 5 then
						v5[passwordIssue.Simple] = issueCondition.Problematic
					end
				else
					warn("JSON failure")
				end

				local v6 = {
					["Input"] = input,
					InputValid = code == 0,
					IssueCondition = v5
				}

				return Promise.resolve(v6)
			end, function(p6)
				return Promise.resolve({
					Input = input,
					InputValid = true,
					IssueCondition = v5
				})
			end)
		end

		for k in pairs(v5) do
			if v5[k] == issueCondition.Resolved then
				v5[k] = issueCondition.Problematic
			end
		end

		return Promise.resolve({
			Input = input,
			InputValid = false,
			IssueCondition = v5
		})
	end
end

local function validateFunctionRefactor(p2, input, p3, options)
	local username = (options or {}).username
	return function(p4)
		local v5 = {}
		v5[passwordIssue.Length] = issueCondition.Resolved
		v5[passwordIssue.UsernameMatch] = issueCondition.Resolved
		v5[passwordIssue.Simple] = p3[passwordIssue.Simple] ~= issueCondition.Hidden
			and issueCondition.Resolved
			or issueCondition.Hidden

		if
			username ~= nil
			and input ~= nil
			and username ~= ""
			and input ~= ""
			and string.match(input, "%S") ~= nil
		then
			return postPasswordValid(p2, username, input):andThen(function(p5)
				local code = p5 and p5.responseBody and p5.responseBody.code

				if type(code) == "number" then
					if code == 2 then
						v5[passwordIssue.Length] = issueCondition.Problematic
					elseif code == 3 then
						v5[passwordIssue.UsernameMatch] = issueCondition.Problematic
					elseif code == 4 or code == 5 then
						v5[passwordIssue.Simple] = issueCondition.Problematic
					end
				else
					warn("JSON failure")
				end

				local v6 = {
					["Input"] = input,
					InputValid = code == 0,
					IssueCondition = v5
				}

				return Promise.resolve(v6)
			end, function(p5)
				return Promise.resolve({
					Input = input,
					InputValid = true,
					IssueCondition = v5
				})
			end)
		end

		for k in pairs(v5) do
			if v5[k] == issueCondition.Resolved then
				v5[k] = issueCondition.Problematic
			end
		end

		return Promise.resolve({
			Input = input,
			InputValid = false,
			IssueCondition = v5
		})
	end
end

return {
	validateFunction = validateFunctionRefactor,
	getIssueMessageList = function()
		return issueMessageList
	end,
	getDefaultIssues = function()
		local problematics = {}

		for k in pairs(issueMessageList) do
			problematics[k] = issueCondition.Problematic
		end

		return problematics
	end
}
