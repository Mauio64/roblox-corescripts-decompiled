local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local AuthCommon = require(AccountRecoveryParent.AuthCommon)
local Promise = require(AccountRecoveryParent.Promise)
local ConfirmPasswordIssue = require(AccountRecovery.Enums.ConfirmPasswordIssue)
local IssueCondition = AuthCommon.Enums.IssueCondition
local t1 = {
	[ConfirmPasswordIssue.PasswordsNotMatch] = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
}

local function validateFunctionHelper(p1, p2) -- line: 28
	-- upvalues: ConfirmPasswordIssue (copy), IssueCondition (copy), Promise (copy)
	return function(_) -- line: 29
		-- upvalues: ConfirmPasswordIssue (copy), IssueCondition (copy), p1 (copy), p2 (copy), Promise (copy)
		local t2 = {
			[ConfirmPasswordIssue.PasswordsNotMatch] = IssueCondition.Resolved
		}

		if p1 == nil or (p2 == nil or p1 == "" or p2 == "" or string.match(p2, "%S") == nil) then
			for k in pairs(t2) do
				if t2[k] == IssueCondition.Resolved then
					t2[k] = IssueCondition.Problematic
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p2,
				IssueCondition = t2
			})
		end

		local t3 = {
			Input = p2
		}

		if p2 ~= p1 then
			t2[ConfirmPasswordIssue.PasswordsNotMatch] = IssueCondition.Problematic
		end

		t3.InputValid = p2 == p1
		t3.IssueCondition = t2

		return Promise.resolve(t3)
	end
end

return {
	validateFunction = function(_, p5, _, p7) -- line: 65
		-- upvalues: ConfirmPasswordIssue (copy), IssueCondition (copy), Promise (copy)
		local password = (p7 or {}).password

		return function(_) -- line: 29
			-- upvalues: ConfirmPasswordIssue (copy), IssueCondition (copy), password (copy), p5 (copy), Promise (copy)
			local t4 = {
				[ConfirmPasswordIssue.PasswordsNotMatch] = IssueCondition.Resolved
			}

			if password == nil or (p5 == nil or password == "" or p5 == "" or string.match(p5, "%S") == nil) then
				for k in pairs(t4) do
					if t4[k] == IssueCondition.Resolved then
						t4[k] = IssueCondition.Problematic
					end
				end

				return Promise.resolve({
					InputValid = false,
					Input = p5,
					IssueCondition = t4
				})
			end

			local t5 = {
				Input = p5
			}

			if p5 ~= password then
				t4[ConfirmPasswordIssue.PasswordsNotMatch] = IssueCondition.Problematic
			end

			t5.InputValid = p5 == password
			t5.IssueCondition = t4

			return Promise.resolve(t5)
		end
	end,
	getIssueMessageList = function() -- line: 14
		-- upvalues: t1 (copy)
		return t1
	end,
	getDefaultIssues = function() -- line: 18
		-- upvalues: t1 (copy), IssueCondition (copy)
		local t6 = {}

		for k in pairs(t1) do
			t6[k] = IssueCondition.Problematic
		end

		return t6
	end
}
