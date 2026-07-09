local Parent = script:FindFirstAncestor("AuthSignup").Parent
local AuthCommon = require(Parent.AuthCommon)
local PostPasswordValid = AuthCommon.Http.Requests.PostPasswordValid
local Promise = require(Parent.Promise)
local PasswordIssue = AuthCommon.Enums.PasswordIssue
local IssueCondition = AuthCommon.Enums.IssueCondition
local GetFFlagPasswordErrorLength = require(Parent.SharedFlags).GetFFlagPasswordErrorLength
local t1 = {
	[PasswordIssue.Length] = not GetFFlagPasswordErrorLength() and "Authentication.SignUp.Label.PasswordError1" or "Authentication.SignUp.PasswordErrorLength",
	[PasswordIssue.UsernameMatch] = "Authentication.SignUp.Label.PasswordError2",
	[PasswordIssue.Simple] = "Authentication.SignUp.Label.PasswordError3"
}

local function validateFunction(p1, p2, p3, p4) -- line: 33
	-- upvalues: PasswordIssue (copy), IssueCondition (copy), Promise (copy), PostPasswordValid (copy)
	return function(_) -- line: 34
		-- upvalues: PasswordIssue (copy), IssueCondition (copy), p4 (copy), p2 (copy), p3 (copy), Promise (copy), PostPasswordValid (copy), p1 (copy)
		local t2 = {
			[PasswordIssue.Length] = IssueCondition.Resolved,
			[PasswordIssue.UsernameMatch] = IssueCondition.Resolved,
			[PasswordIssue.Simple] = p4[PasswordIssue.Simple] ~= IssueCondition.Hidden and IssueCondition.Resolved or IssueCondition.Hidden
		}

		if p2 == nil or (p3 == nil or p2 == "" or p3 == "" or string.match(p3, "%S") == nil) then
			for k in pairs(t2) do
				if t2[k] == IssueCondition.Resolved then
					t2[k] = IssueCondition.Problematic
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p3,
				IssueCondition = t2
			})
		end

		return PostPasswordValid(p1, p2, p3):andThen(function(p6) -- line: 63
			-- upvalues: t2 (copy), PasswordIssue (copy), IssueCondition (copy), p3 (copy), Promise (copy)
			local t3 = {}
			local v30 = p6 and (p6.responseBody and p6.responseBody.code)

			if type(v30) == "number" then
				if v30 == 2 then
					t2[PasswordIssue.Length] = IssueCondition.Problematic
				elseif v30 == 3 then
					t2[PasswordIssue.UsernameMatch] = IssueCondition.Problematic
				elseif v30 == 4 or v30 == 5 then
					t2[PasswordIssue.Simple] = IssueCondition.Problematic
				end
			else
				warn("JSON failure")
			end

			t3.Input = p3
			t3.InputValid = v30 == 0
			t3.IssueCondition = t2

			return Promise.resolve(t3)
		end, function(_) -- line: 85
			-- upvalues: Promise (copy), p3 (copy), t2 (copy)
			return Promise.resolve({
				InputValid = true,
				Input = p3,
				IssueCondition = t2
			})
		end)
	end
end
local function validateFunctionRefactor(p8, p9, p10, p11) -- line: 96
	-- upvalues: PasswordIssue (copy), IssueCondition (copy), Promise (copy), PostPasswordValid (copy)
	local username = (p11 or {}).username

	return function(_) -- line: 34
		-- upvalues: PasswordIssue (copy), IssueCondition (copy), p10 (copy), username (copy), p9 (copy), Promise (copy), PostPasswordValid (copy), p8 (copy)
		local t4 = {
			[PasswordIssue.Length] = IssueCondition.Resolved,
			[PasswordIssue.UsernameMatch] = IssueCondition.Resolved,
			[PasswordIssue.Simple] = p10[PasswordIssue.Simple] ~= IssueCondition.Hidden and IssueCondition.Resolved or IssueCondition.Hidden
		}

		if username == nil or (p9 == nil or username == "" or p9 == "" or string.match(p9, "%S") == nil) then
			for k in pairs(t4) do
				if t4[k] == IssueCondition.Resolved then
					t4[k] = IssueCondition.Problematic
				end
			end

			return Promise.resolve({
				InputValid = false,
				Input = p9,
				IssueCondition = t4
			})
		end

		return PostPasswordValid(p8, username, p9):andThen(function(p13) -- line: 63
			-- upvalues: t4 (copy), PasswordIssue (copy), IssueCondition (copy), p9 (copy), Promise (copy)
			local t5 = {}
			local v34 = p13 and (p13.responseBody and p13.responseBody.code)

			if type(v34) == "number" then
				if v34 == 2 then
					t4[PasswordIssue.Length] = IssueCondition.Problematic
				elseif v34 == 3 then
					t4[PasswordIssue.UsernameMatch] = IssueCondition.Problematic
				elseif v34 == 4 or v34 == 5 then
					t4[PasswordIssue.Simple] = IssueCondition.Problematic
				end
			else
				warn("JSON failure")
			end

			t5.Input = p9
			t5.InputValid = v34 == 0
			t5.IssueCondition = t4

			return Promise.resolve(t5)
		end, function(_) -- line: 85
			-- upvalues: Promise (copy), p9 (copy), t4 (copy)
			return Promise.resolve({
				InputValid = true,
				Input = p9,
				IssueCondition = t4
			})
		end)
	end
end

return {
	validateFunction = validateFunctionRefactor,
	getIssueMessageList = function() -- line: 19
		-- upvalues: t1 (copy)
		return t1
	end,
	getDefaultIssues = function() -- line: 23
		-- upvalues: t1 (copy), IssueCondition (copy)
		local t6 = {}

		for k in pairs(t1) do
			t6[k] = IssueCondition.Problematic
		end

		return t6
	end
}
