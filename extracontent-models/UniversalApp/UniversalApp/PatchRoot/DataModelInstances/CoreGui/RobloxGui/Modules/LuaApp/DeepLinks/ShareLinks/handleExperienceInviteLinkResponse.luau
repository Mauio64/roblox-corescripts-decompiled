local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol.default
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local dependencies = require(script.Parent.dependencies)
local LinkStatus = require(script.Parent.LinkStatus)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local sendShareLinkLatencyEvent = require(script.Parent.Analytics.sendShareLinkLatencyEvent)
local ShareLinkTypes = require(script.Parent.ShareLinkTypes)

require(script.Parent.Types)

local FFlagShareLinkAddReferredByPlayerIdLaunchParam = require(script.Parent.Flags.FFlagShareLinkAddReferredByPlayerIdLaunchParam)
local t1 = {
	[string.lower(ShareLinkTypes.ExperienceInviteLinkType)] = {
		expiredLinkStr = "ExperienceInviteExpiredLink",
		responseInviteDataPath = "responseBody.experienceInviteData",
		validLinkStr = "ExperienceInviteValidLink",
		linkType = ShareLinkTypes.ExperienceInviteLinkType,
		invalidLinkPage = AppPage.InviteLinkExpiredModal
	},
	[string.lower(ShareLinkTypes.ScreenshotInviteLinkType)] = {
		expiredLinkStr = "ScreenshotInviteExpiredLink",
		responseInviteDataPath = "responseBody.screenshotInviteData",
		validLinkStr = "ScreenshotInviteValidLink",
		linkType = ShareLinkTypes.ScreenshotInviteLinkType,
		invalidLinkPage = AppPage.InviteLinkExpiredModal
	},
	[string.lower(ShareLinkTypes.PrivateServerLinkType)] = {
		expiredLinkStr = "PrivateServerExpiredLink",
		responseInviteDataPath = "responseBody.privateServerInviteData",
		validLinkStr = "PrivateServerValidLink",
		linkType = ShareLinkTypes.PrivateServerLinkType,
		invalidLinkPage = AppPage.ShareLinkInvalidModal
	}
}

return function(p1, p2) -- line: 55
	-- upvalues: t1 (copy), HttpService (copy), getDeepValue (copy), sendShareLinkLatencyEvent (copy), LinkStatus (copy), FFlagShareLinkAddReferredByPlayerIdLaunchParam (copy), default (copy), AppPage (copy), ShareLinkTypes (copy)
	local v15 = t1[string.lower(p1.linkType)]
	local linkType = v15.linkType
	local expiredLinkStr = v15.expiredLinkStr
	local responseInviteDataPath = v15.responseInviteDataPath
	local validLinkStr = v15.validLinkStr
	local invalidLinkPage = v15.invalidLinkPage
	local guid = HttpService:GenerateGUID(false)
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local v23 = getDeepValue(p1, responseInviteDataPath) or {}
	local str = tostring(v23.status)
	local t2 = {
		linkStatus = str,
		linkId = p1.linkId,
		linkType = p1.linkType,
		isViaAppsFlyer = p1.isViaAppsFlyer,
		placeId = v23.placeId,
		joinAttemptId = guid
	}

	shareLinksAnalytics.resolveLink(t2)

	local function v26(s1: string?) -- line: 78
		-- upvalues: shareLinksAnalytics (copy), p1 (copy), str (copy), v23 (copy), sendShareLinkLatencyEvent (copy), linkType (copy)
		shareLinksAnalytics.gameLaunch({
			linkId = p1.linkId,
			linkType = p1.linkType,
			linkStatus = str,
			placeId = v23.placeId,
			joinAttemptId = s1
		})
		sendShareLinkLatencyEvent(linkType, str)
	end

	local v27 = str == LinkStatus.Valid
	local v28 = v23.launchData and v23.launchData ~= ""
	local launchData = v23.launchData
	local v30 = FFlagShareLinkAddReferredByPlayerIdLaunchParam and v23.inviterId

	if v27 then
		local t3 = {
			gameInstanceId = if not v23.inviterId then v23.instanceId else nil,
			userId = if not v23.inviterId then nil else v23.inviterId,
			joinAttemptId = guid,
			linkCode = v23.linkCode,
			launchData = if not v28 then nil else launchData,
			referredByPlayerId = if not v30 then nil else v23.inviterId
		}

		p2.launchGame(v23.placeId, linkType, t3, default, validLinkStr, v26)

		return nil
	end

	local t4 = {{
		name = AppPage.Games
	}}

	if linkType == ShareLinkTypes.ExperienceInviteLinkType or linkType == ShareLinkTypes.ScreenshotInviteLinkType then
		table.insert(t4, {
			name = AppPage.GameDetail,
			detail = tostring(v23.universeId),
			extraProps = {
				mountAsFullView = true,
				mountAnimation = false
			}
		})
	end

	table.insert(t4, {
		name = invalidLinkPage,
		extraProps = {
			launchGame = function() -- line: 107
				-- upvalues: v28 (copy), launchData (copy), v30 (copy), v23 (copy), p2 (copy), linkType (copy), default (copy), expiredLinkStr (copy), v26 (copy)
				local t5 = {
					launchData = if not v28 then nil else launchData,
					referredByPlayerId = if not v30 then nil else v23.inviterId
				}

				p2.launchGame(v23.placeId, linkType, t5, default, expiredLinkStr, v26)
			end,
			closeModal = function(b1: boolean) -- line: 142
				-- upvalues: shareLinksAnalytics (copy), t2 (copy)
				if b1 then
					shareLinksAnalytics.errorJoinDialogButtonClick(t2)

					return
				end

				shareLinksAnalytics.errorDialogButtonClick(t2)
			end,
			universeId = tostring(v23.universeId),
			linkStatus = str
		}
	})

	return {
		{{
			name = AppPage.Games
		}},
		t4
	}
end
