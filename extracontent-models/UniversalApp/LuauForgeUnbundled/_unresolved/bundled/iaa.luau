local HttpService = game:GetService("HttpService")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module = require("@luauforge/bundled/dPI")
local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local module3 = require("@luauforge/bundled/dYV")

require("@luauforge/bundled/hZh")

local fFlagTCUpdateProfileCTAButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCUpdateProfileCTAButton
local fFlagTCShareLinkErrorModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkErrorModal

local fFlagTCShareLinkWrongRecipient = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkWrongRecipient

local v5 = module.TrustedConnections.TrustedConnectionsStore.get()

local function trustedConnectionModal(p2, p3, p4)
	return {
		{
			{ name = appPage.Home },
			{
				name = appPage.ProfilePlatform,
				detail = p2,
				extraProps = { source = module3.Analytics.Enums.Sources.ShareLink }
			},
			{
				name = appPage.TrustedContactsModal,
				props = {
					userId = p2,
					source = module3.Analytics.Enums.Sources.ShareLink,
					modalVariantOverride = module3.Analytics.Enums.Sources.ShareLinkReceiver,
					tokens = p3,
					onRequestAccepted = fFlagTCUpdateProfileCTAButton and p4 and p4.RefreshProfilePlatformActionInfo and function()
						p4.RefreshProfilePlatformActionInfo((tostring(p2)))
					end or nil
				}
			}
		}
	}
end

local function expiredLinkModal(p2)
	local v8 = { name = appPage.Home }

	local v9 = if fFlagTCShareLinkErrorModal then {
		name = appPage.TrustedFriendsShareLinkErrorModal,
		extraProps = { errorType = ExperienceInviteStatus.Expired, closeModal = p2 }
	} else {
		name = appPage.InviteLinkExpiredModal,
		extraProps = { closeModal = p2 }
	}
	return {
		{ v8, v9 }
	}
end

local function invalidLinkModal(p2, p3)
	local v8 = { name = appPage.Home }

	local v9 = if fFlagTCShareLinkErrorModal then {
		name = appPage.TrustedFriendsShareLinkErrorModal,
		extraProps = {
			errorType = ExperienceInviteStatus.Invalid,
			recipientUserId = p3,
			closeModal = p2
		}
	} else {
		name = appPage.ShareLinkInvalidModal,
		extraProps = { closeModal = p2 }
	}
	return {
		{ v8, v9 }
	}
end

local function getWrongRecipientUserId(p2)
	if type(p2) ~= "table" or type(p2.Body) ~= "string" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p2.Body)
	local v6

	if success and type(result) == "table" and type(result.errors) == "table" then
		v6 = result.errors[1]
	end

	if type(v6) ~= "table" or v6.code ~= 45 or type(v6.fieldData) ~= "table" then
		return nil
	end

	local recipientUserId = v6.fieldData.recipientUserId

	if recipientUserId then
		return (tostring(recipientUserId))
	end

	return nil
end

return function(p2, p3, p4, p5, p6)
	if p2 == ExperienceInviteStatus.Valid then
		local v6, v7 = v5.validateTrustedFriendLink(p3, p4):await()

		if v6 and v7.responseBody.valid then
			if not fFlagTCUpdateProfileCTAButton then
				p6 = nil
			end

			return trustedConnectionModal(p3, p4, p6)
		elseif not v6 and fFlagTCShareLinkWrongRecipient then
			return invalidLinkModal(p5, getWrongRecipientUserId(v7))
		end
	elseif p2 == ExperienceInviteStatus.Expired then
		return expiredLinkModal(p5)
	end

	return invalidLinkModal(p5)
end
