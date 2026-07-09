local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local AuthCommon = require(AccountRecoveryParent.AuthCommon)
local isStringEmail = AuthCommon.Utils.isStringEmail
local Promise = require(AccountRecoveryParent.Promise)
local EmailIssue = require(AccountRecovery.Enums.EmailIssue)
local IssueCondition = AuthCommon.Enums.IssueCondition
local t1 = {
	[EmailIssue.InvalidEmail] = "Authentication.AccountRecovery.Message.Error.InvalidEmail"
}

local function validateFunctionHelper(p1) -- line: 29
	-- upvalues: EmailIssue (copy), IssueCondition (copy), Promise (copy), isStringEmail (copy)
	return function(_) -- line: 30
		-- upvalues: EmailIssue (copy), IssueCondition (copy), p1 (copy), Promise (copy), isStringEmail (copy)
		local t2 = {
			[EmailIssue.InvalidEmail] = IssueCondition.Resolved
		}

		if p1 == nil or (p1 == "" or string.match(p1, "%S") == nil) then
			for k in pairs(t2) do
				if t2[k] == IssueCondition.Resolved then
					t2[k] = IssueCondition.Problematic
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p1,
				IssueCondition = t2
			})
		end

		local t3 = {
			Input = p1
		}

		if not isStringEmail(p1) then
			t2[EmailIssue.InvalidEmail] = IssueCondition.Problematic
		end

		t3.InputValid = isStringEmail(p1)
		t3.IssueCondition = t2

		return Promise.resolve(t3)
	end
end

return {
	validateFunction = function(_, p4, _, _) -- line: 60
		-- upvalues: EmailIssue (copy), IssueCondition (copy), Promise (copy), isStringEmail (copy)
		return function(_) -- line: 30
			-- upvalues: EmailIssue (copy), IssueCondition (copy), p4 (copy), Promise (copy), isStringEmail (copy)
			local t4 = {
				[EmailIssue.InvalidEmail] = IssueCondition.Resolved
			}

			if p4 == nil or (p4 == "" or string.match(p4, "%S") == nil) then
				for k in pairs(t4) do
					if t4[k] == IssueCondition.Resolved then
						t4[k] = IssueCondition.Problematic
					end
				end

				return Promise.resolve({
					InputValid = false,
					Input = p4,
					IssueCondition = t4
				})
			end

			local t5 = {
				Input = p4
			}

			if not isStringEmail(p4) then
				t4[EmailIssue.InvalidEmail] = IssueCondition.Problematic
			end

			t5.InputValid = isStringEmail(p4)
			t5.IssueCondition = t4

			return Promise.resolve(t5)
		end
	end,
	getIssueMessageList = function() -- line: 15
		-- upvalues: t1 (copy)
		return t1
	end,
	getDefaultIssues = function() -- line: 19
		-- upvalues: t1 (copy), IssueCondition (copy)
		local t6 = {}

		for k in pairs(t1) do
			t6[k] = IssueCondition.Problematic
		end

		return t6
	end
}
