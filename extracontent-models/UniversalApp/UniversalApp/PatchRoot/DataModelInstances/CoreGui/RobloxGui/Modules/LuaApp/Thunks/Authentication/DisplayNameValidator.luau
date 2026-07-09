local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(Modules.LuaApp.Promise)
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local GetDisplayNamesValid = require(Modules.LuaApp.Http.Requests.GetDisplayNamesValid)
local UsernameIssue = require(CorePackages.Workspace.Packages.AuthCommon).Enums.UsernameIssue
local IssueCondition = require(CorePackages.Workspace.Packages.AuthCommon).Enums.IssueCondition
local LocalSignUpDisplayNameValidator = require(CorePackages.Workspace.Packages.AuthSignup).Util.LocalSignUpDisplayNameValidator
local t1 = {
	[0] = UsernameIssue.None,
	[1] = UsernameIssue.LengthTooShortOrTooLong,
	[2] = UsernameIssue.LengthTooShortOrTooLong,
	[3] = UsernameIssue.ContainsInvalidCharacter,
	[4] = UsernameIssue.Inappropriate
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

local function resetNonHiddenIssuesToProblematic(p1) -- line: 50
	-- upvalues: Cryo (copy), IssueCondition (copy)
	local v18 = Cryo.Dictionary.join(p1)

	for k, v in pairs(v18) do
		if v ~= IssueCondition.Hidden then
			v18[k] = IssueCondition.Problematic
		end
	end

	return v18
end

return {
	validateFunction = function(p2, p3, p4, p5) -- line: 62
		-- upvalues: ArgCheck (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpDisplayNameValidator (copy), IssueCondition (copy), GetDisplayNamesValid (copy), HttpService (copy), t1 (copy), reportEphemeralCounter (copy)
		return function(_) -- line: 63
			-- upvalues: ArgCheck (copy), p3 (copy), p4 (copy), Promise (copy), resetNonHiddenIssuesToProblematic (copy), Cryo (copy), LocalSignUpDisplayNameValidator (copy), IssueCondition (copy), p5 (copy), GetDisplayNamesValid (copy), p2 (copy), HttpService (copy), t1 (copy), reportEphemeralCounter (copy)
			ArgCheck.isType(p3, "string", "displayName passed into DisplayNameValidator.validateFunction")
			ArgCheck.isType(p4, "table", "previousIssues passed into DisplayNameValidator.validateFunction")

			if p3 == "" then
				return Promise.resolve({
					InputValid = false,
					Input = p3,
					IssueCondition = resetNonHiddenIssuesToProblematic(p4)
				})
			end

			local v26 = Cryo.Dictionary.join(p4)
			local v27 = LocalSignUpDisplayNameValidator:locallyValidateDisplayName(p3)
			local v28 = false

			for _, v in pairs(v27) do
				if v then
					v28 = true

					break
				end
			end

			if v28 then
				for k, v in pairs(p4) do
					local v33 = v27[k]

					if v == IssueCondition.Hidden and v33 then
						v26[k] = IssueCondition.Problematic
					elseif v ~= IssueCondition.Hidden then
						v26[k] = v33 == false and IssueCondition.Resolved or IssueCondition.Problematic
					end
				end

				return Promise.resolve({
					InputValid = false,
					Input = p3,
					IssueCondition = v26
				})
			end

			for k, v in pairs(v26) do
				v26[k] = v == IssueCondition.Hidden and IssueCondition.Hidden or IssueCondition.Resolved
			end

			local birthday = p5.birthday

			return GetDisplayNamesValid(p2, p3, birthday):andThen(function(_) -- line: 119
				-- upvalues: Promise (copy), p3 (copy), v26 (copy)
				return Promise.resolve({
					InputValid = true,
					Input = p3,
					IssueCondition = v26
				})
			end, function(p8) -- line: 125
				-- upvalues: HttpService (copy), t1 (copy), v26 (copy), IssueCondition (copy), Promise (copy), p3 (copy), reportEphemeralCounter (copy)
				local data = HttpService:JSONDecode(p8.Body)
				local v40 = data and data.errors or {}
				local v41 = nil

				for _, v in pairs(v40) do
					if v.code then
						v41 = t1[v.code]

						break
					end
				end

				if v41 then
					v26[v41] = IssueCondition.Problematic

					return Promise.resolve({
						InputValid = false,
						Input = p3,
						IssueCondition = v26
					})
				end

				reportEphemeralCounter("DisplayNameValidator_GetDisplayNamesValid_Failed", 1)

				return Promise.resolve({
					InputValid = true,
					Input = p3,
					IssueCondition = v26
				})
			end)
		end
	end,
	getIssueMessageList = function() -- line: 36
		-- upvalues: t2 (copy)
		return t2
	end,
	getDefaultIssues = function() -- line: 40
		-- upvalues: t2 (copy), IssueCondition (copy)
		local t3 = {}

		for k in pairs(t2) do
			t3[k] = IssueCondition.Hidden
		end

		return t3
	end
}
