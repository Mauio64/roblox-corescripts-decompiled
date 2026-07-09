local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.dependencies).Promise
local PostSendCode = require(ParentParent.Requests.PostSendCode)

require(ParentParent.Common.otpLoginTypes)

local GetFFlagOtpLoginParseJsonErrorBody = require(ParentParent.Flags.GetFFlagOtpLoginParseJsonErrorBody)
local parseOtpErrorBody = require(ParentParent.Utils.parseOtpErrorBody)

return function(p1, p2) -- line: 9
	-- upvalues: PostSendCode (copy), Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy)
	return function() -- line: 10
		-- upvalues: PostSendCode (copy), p1 (copy), p2 (copy), Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy)
		return PostSendCode(p1, p2):andThen(function(p3) -- line: 11
			-- upvalues: Promise (copy)
			return Promise.resolve(p3.responseBody)
		end):catch(function(p4) -- line: 13
			-- upvalues: Promise (copy), GetFFlagOtpLoginParseJsonErrorBody (copy), parseOtpErrorBody (copy)
			if p4.data then
				return Promise.reject(p4.data.errorCode)
			end

			if GetFFlagOtpLoginParseJsonErrorBody() then
				local v10 = parseOtpErrorBody(p4.Body)

				if v10 then
					return Promise.reject(v10)
				end
			end

			if p4.Body and (type(p4.Body) == "number" or tonumber(p4.Body) ~= nil) then
				return Promise.reject(p4.Body)
			end

			if p4.StatusCode then
				return Promise.reject(p4.StatusCode)
			end

			return Promise.reject()
		end)
	end
end
