local module = require("@luauforge/bundled/gnT")
local isStringEmail = module.Utils.isStringEmail

local module2 = require("@luauforge/bundled/gqI")
local module3 = require("@luauforge/bundled/gqL")
local issueCondition = module.Enums.IssueCondition

local issueMessageList = {
	[module3.InvalidEmail] = "Authentication.AccountRecovery.Message.Error.InvalidEmail"
}

local function validateFunctionHelper(value)
	return function(p2)
		local v5 = {}
		v5[module3.InvalidEmail] = issueCondition.Resolved

		if value == nil or value == "" or string.match(value, "%S") == nil then
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

			if not isStringEmail(value) then
				v5[module3.InvalidEmail] = issueCondition.Problematic
			end

			v6.InputValid = isStringEmail(value)
			v6.IssueCondition = v5

			return module2.resolve(v6)
		end
	end
end

return {
	validateFunction = function(p2, value, p3, p4)
		return function(p5)
			local v5 = {}
			v5[module3.InvalidEmail] = issueCondition.Resolved

			if value == nil or value == "" or string.match(value, "%S") == nil then
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

				if not isStringEmail(value) then
					v5[module3.InvalidEmail] = issueCondition.Problematic
				end

				v6.InputValid = isStringEmail(value)
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
