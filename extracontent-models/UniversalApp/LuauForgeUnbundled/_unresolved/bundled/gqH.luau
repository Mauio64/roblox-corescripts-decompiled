local module = require("@luauforge/bundled/gnT")

local module2 = require("@luauforge/bundled/gqI")
local module3 = require("@luauforge/bundled/gqJ")
local issueCondition = module.Enums.IssueCondition

local issueMessageList = {
	[module3.PasswordsNotMatch] = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
}

local function validateFunctionHelper(p2, value)
	return function(p3)
		local v5 = {}
		v5[module3.PasswordsNotMatch] = issueCondition.Resolved

		if p2 == nil or value == nil or p2 == "" or value == "" or string.match(value, "%S") == nil then
			for k in pairs(v5) do
				if v5[k] == issueCondition.Resolved then
					v5[k] = issueCondition.Problematic
				end
			end

			return module2.resolve({
				Input = value,
				InputValid = false,
				IssueCondition = v5
			})
		else
			local v6 = {}
			v6.Input = value

			if value ~= p2 then
				v5[module3.PasswordsNotMatch] = issueCondition.Problematic
			end

			v6.InputValid = value == p2
			v6.IssueCondition = v5

			return module2.resolve(v6)
		end
	end
end

return {
	validateFunction = function(p2, value, p3, options)
		local password = (options or {}).password
		return function(p4)
			local v5 = {}
			v5[module3.PasswordsNotMatch] = issueCondition.Resolved

			if
				password == nil
				or value == nil
				or password == ""
				or value == ""
				or string.match(value, "%S") == nil
			then
				for k in pairs(v5) do
					if v5[k] == issueCondition.Resolved then
						v5[k] = issueCondition.Problematic
					end
				end

				return module2.resolve({
					Input = value,
					InputValid = false,
					IssueCondition = v5
				})
			else
				local v6 = {}
				v6.Input = value

				if value ~= password then
					v5[module3.PasswordsNotMatch] = issueCondition.Problematic
				end

				v6.InputValid = value == password
				v6.IssueCondition = v5

				return module2.resolve(v6)
			end
		end
	end,
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
