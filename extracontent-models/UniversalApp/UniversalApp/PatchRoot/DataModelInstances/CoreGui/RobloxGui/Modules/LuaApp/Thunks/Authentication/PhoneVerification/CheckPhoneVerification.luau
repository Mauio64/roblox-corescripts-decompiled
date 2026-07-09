local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(Modules.LuaApp.Promise)
local GetPhoneNumber = require(Modules.LuaApp.Http.Requests.GetPhoneNumber)
local GetVerifiedEmail = require(Modules.LuaApp.Http.Requests.GetVerifiedEmail)
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local FFlagAddReasonToEveryLogout = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddReasonToEveryLogout
local FFlagLogoutPhoneVerificationUpsellCopy = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLogoutPhoneVerificationUpsellCopy

return function(p1, p2) -- line: 25
	-- upvalues: GetPhoneNumber (copy), Promise (copy), GetVerifiedEmail (copy), OpenPhoneUpsellModal (copy), FFlagAddReasonToEveryLogout (copy), Logout (copy), luaLogoutReasonNames (copy), EventStreamConstants (copy), FFlagLogoutPhoneVerificationUpsellCopy (copy)
	return function(p3) -- line: 26
		-- upvalues: GetPhoneNumber (copy), p1 (copy), Promise (copy), GetVerifiedEmail (copy), OpenPhoneUpsellModal (copy), FFlagAddReasonToEveryLogout (copy), Logout (copy), p2 (copy), luaLogoutReasonNames (copy), EventStreamConstants (copy), FFlagLogoutPhoneVerificationUpsellCopy (copy)
		return GetPhoneNumber(p1):andThen(function(p4) -- line: 27
			-- upvalues: Promise (copy), GetVerifiedEmail (copy), p1 (copy), p3 (copy), OpenPhoneUpsellModal (copy), FFlagAddReasonToEveryLogout (copy), Logout (copy), p2 (copy), luaLogoutReasonNames (copy), EventStreamConstants (copy), FFlagLogoutPhoneVerificationUpsellCopy (copy)
			local phone = p4.responseBody.phone
			local countryCode = p4.responseBody.countryCode
			local prefix = p4.responseBody.prefix

			if phone and phone ~= "" then
				return Promise.resolve({
					phone,
					countryCode,
					prefix
				})
			end

			return GetVerifiedEmail(p1):andThen(function(p5) -- line: 40
				-- upvalues: Promise (copy), p3 (copy), OpenPhoneUpsellModal (copy), FFlagAddReasonToEveryLogout (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy), EventStreamConstants (copy), FFlagLogoutPhoneVerificationUpsellCopy (copy)
				local emailAddress = p5.responseBody.emailAddress

				if emailAddress and emailAddress ~= "" then
					return Promise.resolve({
						EmailAddress = emailAddress
					})
				end

				p3:dispatch(OpenPhoneUpsellModal({
					addPhoneTitleKey = "Feature.VerificationUpsell.Heading.FinishAccountSetup",
					extraButtonTextKey = "Feature.VerificationUpsell.Action.Logout",
					onSuccess = function() -- line: 52
						-- upvalues: FFlagAddReasonToEveryLogout (copy), p3 (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy)
						if FFlagAddReasonToEveryLogout then
							p3:dispatch(Logout(p1, p2, luaLogoutReasonNames.PhoneUpsellLogOut))

							return
						end

						p3:dispatch(Logout(p1, p2))
					end,
					eventContext = EventStreamConstants.Context.VerificationUpsell,
					origin = EventStreamConstants.Origin.Logout,
					addPhoneDescriptionKey = not FFlagLogoutPhoneVerificationUpsellCopy and "Feature.VerificationUpsell.Description.LogoutAddPhoneTextV2" or "Feature.VerificationUpsell.Description.LogoutAddPhoneTextV3",
					addPhoneLegalTextKey = if not FFlagLogoutPhoneVerificationUpsellCopy then nil else "Feature.VerificationUpsell.Description.AddPhoneBody",
					addPhoneButtonKey = if not FFlagLogoutPhoneVerificationUpsellCopy then nil else "Feature.AccountSettings.Action.Verify",
					shouldShowVerificationText = not FFlagLogoutPhoneVerificationUpsellCopy and nil,
					alwaysShowAddPhoneLegalText = not not FFlagLogoutPhoneVerificationUpsellCopy or nil,
					onExtraButtonClick = function() -- line: 76
						-- upvalues: FFlagAddReasonToEveryLogout (copy), p3 (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy)
						if FFlagAddReasonToEveryLogout then
							p3:dispatch(Logout(p1, p2, luaLogoutReasonNames.PhoneUpsellLogOut))

							return
						end

						p3:dispatch(Logout(p1, p2))
					end
				}))

				return Promise.reject()
			end, function(_) -- line: 88
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end)
		end, function(_) -- line: 94
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end
end
