local module = require("@luauforge/bundled/egs")
local AccountInformationPatterns = require("@game/CorePackages/Packages/_Index/UrlBuilder/UrlBuilder/UrlPatterns/AccountInformationPatterns")
local module3 = require("@luauforge/bundled/hRN")
local module4 = require("@luauforge/bundled/gXb")
local module5 = require("@luauforge/bundled/ggi")
local module6 = require("@luauforge/bundled/ggp")
local module7 = require("@luauforge/bundled/fzS")

local fFlagAddReasonToEveryLogout = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddReasonToEveryLogout

local fFlagLogoutPhoneVerificationUpsellCopy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLogoutPhoneVerificationUpsellCopy

return function(p2, p3)
	return function(object)
		return AccountInformationPatterns(p2):andThen(function(p4)
			local phone = p4.responseBody.phone
			local countryCode = p4.responseBody.countryCode
			local prefix = p4.responseBody.prefix

			if phone and phone ~= "" then
				return module.resolve({ phone, countryCode, prefix })
			end

			return module3(p2):andThen(function(p5)
				local emailAddress = p5.responseBody.emailAddress

				if emailAddress and emailAddress ~= "" then
					return module.resolve({ EmailAddress = emailAddress })
				end

				object:dispatch(module4({
					onSuccess = function()
						if fFlagAddReasonToEveryLogout then
							object:dispatch(module5(p2, p3, module6.PhoneUpsellLogOut))
						else
							object:dispatch(module5(p2, p3))
						end
					end,
					eventContext = module7.Context.VerificationUpsell,
					origin = module7.Origin.Logout,
					addPhoneTitleKey = "Feature.VerificationUpsell.Heading.FinishAccountSetup",
					addPhoneDescriptionKey = fFlagLogoutPhoneVerificationUpsellCopy and "Feature.VerificationUpsell.Description.LogoutAddPhoneTextV3" or "Feature.VerificationUpsell.Description.LogoutAddPhoneTextV2",
					addPhoneLegalTextKey = fFlagLogoutPhoneVerificationUpsellCopy and "Feature.VerificationUpsell.Description.AddPhoneBody" or nil,
					addPhoneButtonKey = fFlagLogoutPhoneVerificationUpsellCopy and "Feature.AccountSettings.Action.Verify" or nil,
					extraButtonTextKey = "Feature.VerificationUpsell.Action.Logout",
					shouldShowVerificationText = if fFlagLogoutPhoneVerificationUpsellCopy then false else nil,
					alwaysShowAddPhoneLegalText = fFlagLogoutPhoneVerificationUpsellCopy and true or nil,
					onExtraButtonClick = function()
						if fFlagAddReasonToEveryLogout then
							object:dispatch(module5(p2, p3, module6.PhoneUpsellLogOut))
						else
							object:dispatch(module5(p2, p3))
						end
					end
				}))

				return module.reject()
			end, function(p5)
				return module.resolve()
			end)
		end, function(p4)
			return module.resolve()
		end)
	end
end
