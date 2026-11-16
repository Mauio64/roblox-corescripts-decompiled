local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/ecV")

local module3 = require("@luauforge/bundled/fDL")
local module4 = require("@luauforge/bundled/fTV")

local usernameIssue = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.UsernameIssue
local issueCondition = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.IssueCondition

local localSignUpDisplayNameValidator = require("@luauforge/bundled/fNq").Util.LocalSignUpDisplayNameValidator

local v5 = {
	[0] = usernameIssue.None,
	[1] = usernameIssue.LengthTooShortOrTooLong,
	[2] = usernameIssue.LengthTooShortOrTooLong,
	[3] = usernameIssue.ContainsInvalidCharacter,
	[4] = usernameIssue.Inappropriate
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

return {
	validateFunction = function(p2, p3, items, p4)
		return function(p5)
			module.isType(p3, "string", "displayName passed into DisplayNameValidator.validateFunction")
			module.isType(
				items,
				"table",
				"previousIssues passed into DisplayNameValidator.validateFunction"
			)

			if p3 == "" then
				return module2.resolve({
					Input = p3,
					InputValid = false,
					IssueCondition = resetNonHiddenIssuesToProblematic(items)
				})
			end

			local joined = Cryo.Dictionary.join(items)

			local locallyValidateDisplayName = localSignUpDisplayNameValidator:locallyValidateDisplayName(p3)
			local flag = false

			for k, v7 in pairs(locallyValidateDisplayName) do
				if v7 then
					flag = true
					break
				end
			end

			if flag then
				for k, item in pairs(items) do
					local v7 = locallyValidateDisplayName[k]

					if item == issueCondition.Hidden and v7 then
						joined[k] = issueCondition.Problematic
					elseif item ~= issueCondition.Hidden then
						joined[k] = v7 == false and issueCondition.Resolved or issueCondition.Problematic
					end
				end

				return module2.resolve({
					Input = p3,
					InputValid = false,
					IssueCondition = joined
				})
			end

			for k, v7 in pairs(joined) do
				joined[k] = v7 == issueCondition.Hidden and issueCondition.Hidden or issueCondition.Resolved
			end

			return module4(p2, p3, p4.birthday):andThen(function(p6)
				return module2.resolve({
					Input = p3,
					InputValid = true,
					IssueCondition = joined
				})
			end, function(p6)
				local jsonDecode = HttpService:JSONDecode(p6.Body)
				local errors = jsonDecode and jsonDecode.errors or {}
				local v7 = nil

				for k, err in pairs(errors) do
					if err.code then
						v7 = v5[err.code]
						break
					end
				end

				if v7 then
					joined[v7] = issueCondition.Problematic
					return module2.resolve({
						Input = p3,
						InputValid = false,
						IssueCondition = joined
					})
				end

				module3("DisplayNameValidator_GetDisplayNamesValid_Failed", 1)
				return module2.resolve({
					Input = p3,
					InputValid = true,
					IssueCondition = joined
				})
			end)
		end
	end,
	getIssueMessageList = function()
		return issueMessageList
	end,
	getDefaultIssues = function()
		local hiddens = {}

		for k in pairs(issueMessageList) do
			hiddens[k] = issueCondition.Hidden
		end

		return hiddens
	end
}
