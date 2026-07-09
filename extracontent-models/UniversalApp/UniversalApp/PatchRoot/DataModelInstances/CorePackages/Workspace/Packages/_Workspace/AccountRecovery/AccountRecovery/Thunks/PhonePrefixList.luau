local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")

require(AccountRecoveryParent.Http)

local GetPhonePrefixList = require(AccountRecovery.Requests.GetPhonePrefixList)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)

return function(p1) -- line: 12
	-- upvalues: GetPhonePrefixList (copy), Constants (copy), HttpService (copy)
	return function() -- line: 13
		-- upvalues: GetPhonePrefixList (copy), p1 (copy), Constants (copy), HttpService (copy)
		return GetPhonePrefixList(p1):andThen(function(p2) -- line: 14
			-- upvalues: Constants (copy)
			if p2 and (p2.responseBody and p2.responseBody ~= "") then
				local responseBody = p2.responseBody
				local v9 = nil

				for i, v in ipairs(responseBody) do
					if v.isDefault == true then
						v9 = i

						break
					end
				end

				if v9 and v9 ~= 1 then
					local v12 = responseBody[v9]

					table.remove(responseBody, v9)
					table.insert(responseBody, 1, v12)
				end

				return {
					isError = false,
					data = responseBody
				}
			end

			return {
				isError = true,
				errorCode = 0,
				errorKey = Constants.UnknownErrorKey
			}
		end, function(p3) -- line: 41
			-- upvalues: HttpService (copy), Constants (copy)
			local n1 = 0

			if p3.Body then
				n1 = HttpService:JSONDecode(p3.Body).errors[1].code
			end

			local UnknownErrorKey = Constants.UnknownErrorKey

			return {
				isError = true,
				errorCode = n1,
				errorKey = UnknownErrorKey
			}
		end)
	end
end
