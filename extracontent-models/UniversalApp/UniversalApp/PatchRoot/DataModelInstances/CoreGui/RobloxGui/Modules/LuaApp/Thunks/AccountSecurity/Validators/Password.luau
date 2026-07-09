local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PostPasswordValid = require(Modules.LuaApp.Http.Requests.PostPasswordValid)
local t1 = {
	[1] = "Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.WeakPassword",
	[2] = "Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.ShortPassword",
	[3] = "Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.PasswordSameAsUsername",
	[4] = "Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.ForbiddenPassword",
	[5] = "Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.DumbStrings"
}
local t2 = {}

for _, v in pairs(t1) do
	t2[v] = v
end

return {
	localizationKeys = t2,
	validator = function(p1, p2, p3) -- line: 20
		-- upvalues: PostPasswordValid (copy), t1 (copy)
		return function(p4) -- line: 21
			-- upvalues: PostPasswordValid (copy), p1 (copy), p3 (copy), t1 (copy), p2 (copy)
			return PostPasswordValid(p1, p3, p4):andThen(function(p5) -- line: 23
				-- upvalues: t1 (copy), p2 (copy)
				local v12 = t1[p5 and (p5.responseBody and p5.responseBody.code)]

				if v12 ~= nil then
					return p2[v12]
				end

				return nil
			end):catch(function(_) -- line: 34
				return nil
			end)
		end
	end
}
