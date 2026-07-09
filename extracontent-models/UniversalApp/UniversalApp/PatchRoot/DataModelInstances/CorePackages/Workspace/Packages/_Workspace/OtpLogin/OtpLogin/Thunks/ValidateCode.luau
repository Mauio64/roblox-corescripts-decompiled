local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.dependencies).Promise
local PostValidateCode = require(ParentParent.Requests.PostValidateCode)

require(ParentParent.Common.otpLoginTypes)

local GetFFlagOtpLoginParseJsonErrorBody = require(ParentParent.Flags.GetFFlagOtpLoginParseJsonErrorBody)
local parseOtpErrorBody = require(ParentParent.Utils.parseOtpErrorBody)
local v6 = game:DefineFastFlag("ValidateCodeCheckBodyForOtpErrors", false)

return function(p1, p2) -- line: 11
	-- upvalues: PostValidateCode (copy), Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy), v6 (copy)
	return function() -- line: 12
		-- upvalues: PostValidateCode (copy), p1 (copy), p2 (copy), Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy), v6 (copy)
		return PostValidateCode(p1, p2):andThen(function(p3) -- line: 13
			-- upvalues: Promise (copy)
			return Promise.resolve(p3.responseBody)
		end):catch(function(p4) -- line: 15
			-- upvalues: Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy), v6 (copy)
			if p4.data then
				return Promise.reject(p4.data.errorCode)
			end

			if GetFFlagOtpLoginParseJsonErrorBody() then
				local v11 = parseOtpErrorBody(p4.Body)

				if v11 then
					return Promise.reject(v11)
				end
			end

			if v6 and p4.Body and (type(p4.Body) == "number" or tonumber(p4.Body) ~= nil) then
				return Promise.reject(p4.Body)
			end

			if p4.StatusCode then
				return Promise.reject(p4.StatusCode)
			end

			return Promise.reject()
		end)
	end
end
