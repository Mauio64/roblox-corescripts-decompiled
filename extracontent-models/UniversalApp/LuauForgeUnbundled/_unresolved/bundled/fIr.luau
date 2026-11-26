local default = require("@luauforge/bundled/bZg").GameProtocol.default
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dFu")

local module2 = require("@luauforge/bundled/fIp")

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local getDeepValue = module2.SocialLibraries.Dictionary.getDeepValue

local module4 = require("@luauforge/bundled/fIt")
local module5 = require("@luauforge/bundled/fIj")
require("@luauforge/bundled/fIx")

local module6 = require("@luauforge/bundled/fIy")

local v5 = {
	[string.lower(module5.ExperienceInviteLinkType)] = {
		expiredLinkStr = "ExperienceInviteExpiredLink",
		linkType = module5.ExperienceInviteLinkType,
		responseInviteDataPath = "responseBody.experienceInviteData",
		validLinkStr = "ExperienceInviteValidLink",
		invalidLinkPage = module.InviteLinkExpiredModal
	},
	[string.lower(module5.ScreenshotInviteLinkType)] = {
		expiredLinkStr = "ScreenshotInviteExpiredLink",
		linkType = module5.ScreenshotInviteLinkType,
		responseInviteDataPath = "responseBody.screenshotInviteData",
		validLinkStr = "ScreenshotInviteValidLink",
		invalidLinkPage = module.InviteLinkExpiredModal
	},
	[string.lower(module5.PrivateServerLinkType)] = {
		expiredLinkStr = "PrivateServerExpiredLink",
		linkType = module5.PrivateServerLinkType,
		responseInviteDataPath = "responseBody.privateServerInviteData",
		validLinkStr = "PrivateServerValidLink",
		invalidLinkPage = module.ShareLinkInvalidModal
	}
}

return function(data, p2)
	local v6 = v5[string.lower(data.linkType)]
	local linkType = v6.linkType
	local expiredLinkStr = v6.expiredLinkStr
	local responseInviteDataPath = v6.responseInviteDataPath
	local validLinkStr = v6.validLinkStr
	local invalidLinkPage = v6.invalidLinkPage
	local guid = HttpService:GenerateGUID(false)

	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local v7 = getDeepValue(data, responseInviteDataPath) or {}
	local status = tostring(v7.status)
	local v8 = {
		linkStatus = status,
		linkId = data.linkId,
		linkType = data.linkType,
		isViaAppsFlyer = data.isViaAppsFlyer,
		placeId = v7.placeId,
		joinAttemptId = guid
	}

	shareLinksAnalytics.resolveLink(v8)

	local function fn(p3)
		shareLinksAnalytics.gameLaunch({
			linkId = data.linkId,
			linkType = data.linkType,
			linkStatus = status,
			placeId = v7.placeId,
			joinAttemptId = p3
		})

		module4(linkType, status)
	end

	local v9 = status == ExperienceInviteStatus.Valid
	local v10 = v7.launchData and v7.launchData ~= ""
	local launchData = v7.launchData
	local inviterId = module6 and v7.inviterId

	if v9 then
		local v12 = if not v7.inviterId then v7.instanceId else nil
		local v13 = if v7.inviterId then v7.inviterId else nil
		local v11 = {
			gameInstanceId = v12,
			userId = v13,
			joinAttemptId = guid,
			linkCode = v7.linkCode,
			launchData = 0,
			referredByPlayerId = 0
		}

		if not v10 then
			launchData = nil
		end

		v11.launchData = launchData
		local v14 = if inviterId then v7.inviterId else nil
		v11.referredByPlayerId = v14

		p2.launchGame(v7.placeId, linkType, v11, default, validLinkStr, fn)

		return nil
	else
		local function fn2()
			local v11 = {
				launchData = if v10 then launchData else nil,
				referredByPlayerId = 0
			}

			local v13 = if inviterId then v7.inviterId else nil
			v11.referredByPlayerId = v13

			p2.launchGame(v7.placeId, linkType, v11, default, expiredLinkStr, fn)
		end

		local v11 = {
			{ name = module.Games }
		}

		if linkType == module5.ExperienceInviteLinkType or linkType == module5.ScreenshotInviteLinkType then
			table.insert(v11, {
				name = module.GameDetail,
				detail = tostring(v7.universeId),
				extraProps = { mountAsFullView = true, mountAnimation = false }
			})
		end

		table.insert(v11, {
			name = invalidLinkPage,
			extraProps = {
				launchGame = fn2,
				closeModal = function(p3)
					if p3 then
						shareLinksAnalytics.errorJoinDialogButtonClick(v8)
					else
						shareLinksAnalytics.errorDialogButtonClick(v8)
					end
				end,
				universeId = tostring(v7.universeId),
				linkStatus = status
			}
		})

		return {
			{
				{ name = module.Games }
			},
			v11
		}
	end
end
