local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Promise")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UrlBuilder")

local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities").getSduiPageEntrySnackbarStore
local urlBase = UrlBuilder.UrlBase
local urlBuilder = UrlBuilder.UrlBuilder

local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local function isDesktopPlatform(): boolean
	local platform = UserInputService:GetPlatform()
	return platform == Enum.Platform.Windows
		or platform == Enum.Platform.OSX
		or platform == Enum.Platform.UWP
end

local function logExperienceDetailsShareAnalytics(p2, p3, p4, unixTimestampMillis, targetId)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	local userId = tostring(localPlayer.UserId)
	local platform = UserInputService:GetPlatform()

	if
		platform == Enum.Platform.Windows
		or platform == Enum.Platform.OSX
		or platform == Enum.Platform.UWP
	then
		if not fFlagLuaAppAddUniverseIdToEngagementEvents then
			targetId = nil
		end

		gameCopyExperienceLink({
			ctx = p3,
			uid = userId,
			placeId = p2,
			stamp = unixTimestampMillis,
			targetId = targetId
		}, p3)
	else
		local v6 = {
			ctx = p3,
			uid = userId,
			placeId = p2,
			shortShareLinkFailed = p4 == nil,
			shareToAppsflyer = true,
			stamp = unixTimestampMillis,
			linkId = p4,
			targetId = nil
		}

		if not fFlagLuaAppAddUniverseIdToEngagementEvents then
			targetId = nil
		end

		v6.targetId = targetId
		gameShareExperienceLink(v6, p3)
	end
end

local function fetchShareLinkId(linkType, linkData)
	local v5 = urlBuilder.new({
		base = urlBase.APIS,
		path = "sharelinks/v1/get-or-create-link"
	})()

	local jsonEncode = HttpService:JSONEncode({
		linkType = linkType,
		data = HttpService:JSONEncode(linkData)
	})

	return HttpRequest.config({
		requestFunction = function(p2, p3, p4)
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end
	})(v5, "POST", { postBody = jsonEncode }):andThen(function(p2)
		local responseBody = p2.responseBody or p2.result

		if responseBody and responseBody.linkId then
			return responseBody.linkId
		end

		error("Share link response missing linkId")
	end)
end

return function(p2, p3, p4)
	local actionParams = if p2 then p2.actionParams or nil else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.Share, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local shareLinkData = actionParams.shareLinkData or {}
	local entryPointKey = actionParams.entryPointKey or nil
	local shareUrlContext = shareLinkData.shareUrlContext or ""

	local v6 = nil
	local unixTimestampMillis = nil
	local v7

	if shareLinkData.linkType ~= nil then
		local linkType = shareLinkData.linkType
		local linkData = shareLinkData.linkData

		if linkData == nil then
			v7 = Promise.reject(`Missing linkData in ShareLinkFetchData (linkType={linkType})`)
		else
			v7 = fetchShareLinkId(linkType, linkData):andThen(function(p5)
				v6 = p5
				unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
				return urlBuilder.sharelinks.shortUrl({
					linkId = p5,
					type = linkType,
					stamp = unixTimestampMillis
				})
			end)
		end
	else
		local url = shareLinkData.url

		if url == nil then
			v7 = Promise.reject("Missing url in shareLinkData")
		else
			v7 = Promise.resolve(url)
		end
	end

	v7:andThen(function(p5)
		default:shareUrl({ context = shareUrlContext, url = p5 })
		local platform = UserInputService:GetPlatform()

		if
			(platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.UWP)
			and entryPointKey
		then
			local formatted = p4.dependencies.localization:Format("Feature.GameDetails.Toast.LinkCopied")
			getSduiPageEntrySnackbarStore().show(entryPointKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.CircleCheck
			})
		end

		if shareLinkData.linkType == "ExperienceDetails" then
			local v8 = getActionTelemetryFieldValue(p2, p3, "rootPlaceId")
				or getActionTelemetryFieldValue(p2, p3, "placeId")

			if v8 ~= nil then
				local v9 = getActionTelemetryFieldValue(p2, p3, "ctx") or "ExperienceDetailsShare"

				if fFlagLuaAppAddUniverseIdToEngagementEvents then
					local v10 = getActionTelemetryFieldValue(p2, p3, "universeId")

					if v10 == nil and type(shareLinkData.linkData) == "table" then
						v10 = shareLinkData.linkData.universeId
					end

					local v12 = tostring(v8)

					local v13 = v6
					local v14 = unixTimestampMillis
					local v15 = if v10 ~= nil then tostring(v10) else nil
					logExperienceDetailsShareAnalytics(v12, v9, v13, v14, v15)
				else
					logExperienceDetailsShareAnalytics(tostring(v8), v9, v6, unixTimestampMillis)
				end
			end
		end
	end):catch(function(p5)
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = sduiActionType.Share, message = tostring(p5) },
			p4.appPage
		)

		if entryPointKey then
			local formatted = p4.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")
			getSduiPageEntrySnackbarStore().show(entryPointKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.TriangleExclamation
			})
		end
	end)
end
