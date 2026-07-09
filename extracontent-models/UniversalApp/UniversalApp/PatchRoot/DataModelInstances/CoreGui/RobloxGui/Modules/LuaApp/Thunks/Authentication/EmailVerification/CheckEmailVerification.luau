local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local GetVerifiedEmail = require(Modules.LuaApp.Http.Requests.GetVerifiedEmail)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

return function(p1, b1: boolean?, p2) -- line: 25
	-- upvalues: GetVerifiedEmail (copy), Promise (copy), Cryo (copy), SetCentralOverlay (copy), OverlayType (copy)
	return function(p3) -- line: 26
		-- upvalues: GetVerifiedEmail (copy), p1 (copy), b1 (copy), Promise (copy), p2 (copy), Cryo (copy), SetCentralOverlay (copy), OverlayType (copy)
		return GetVerifiedEmail(p1):andThen(function(p4) -- line: 27
			-- upvalues: b1 (copy), Promise (copy), p2 (copy), Cryo (copy), p3 (copy), SetCentralOverlay (copy), OverlayType (copy)
			local verified = p4.responseBody.verified
			local emailAddress = p4.responseBody.emailAddress
			local v15 = emailAddress and emailAddress ~= ""

			if b1 then
				verified = verified or v15
			end

			if verified then
				return Promise.resolve({
					EmailAddress = emailAddress
				})
			end

			local t1 = {
				emailAddress = emailAddress
			}

			if p2 then
				t1 = Cryo.Dictionary.join(t1, p2)
			end

			p3:dispatch(SetCentralOverlay(OverlayType.EmailVerificationUpsellOverlay, t1))

			return Promise.reject()
		end, function(_) -- line: 54
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end
end
