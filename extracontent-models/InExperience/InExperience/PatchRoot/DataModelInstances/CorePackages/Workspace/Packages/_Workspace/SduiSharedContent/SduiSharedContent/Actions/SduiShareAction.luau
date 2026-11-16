local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local Foundation = require(parent.Foundation)
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local UrlBuilder = require(parent.UrlBuilder)

local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore
local UrlBase = UrlBuilder.UrlBase
local urlBuilder = UrlBuilder.UrlBuilder

local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local function isDesktopPlatform(): boolean -- 2 equivalent calls inferred from this helper
	local platform = UserInputService:GetPlatform()
	return platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.UWP
end

local function logExperienceDetailsShareAnalytics(placeId: string, ctx: string, linkId: string?, stamp: string?, targetId: string?)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	local userId = tostring(localPlayer.UserId)

	if isDesktopPlatform() then -- inferred equivalent call
		if not FFlagLuaAppAddUniverseIdToEngagementEvents then
			targetId = nil
		end

		gameCopyExperienceLink({
			ctx = ctx,
			uid = userId,
			placeId = placeId,
			stamp = stamp,
			targetId = targetId
		}, ctx)
	else
		local v = {
			ctx = ctx,
			uid = userId,
			placeId = placeId,
			shortShareLinkFailed = linkId == nil,
			shareToAppsflyer = true,
			stamp = stamp,
			linkId = linkId,
			targetId = nil
		}

		if not FFlagLuaAppAddUniverseIdToEngagementEvents then
			targetId = nil
		end

		v.targetId = targetId
		gameShareExperienceLink(v, ctx)
	end
end

local function fetchShareLinkId(linkType: string, linkData)
	local v = urlBuilder.new({ base = UrlBase.APIS, path = "sharelinks/v1/get-or-create-link" })()

	local jsonEncode = HttpService:JSONEncode({
		linkType = linkType,
		data = HttpService:JSONEncode(linkData)
	})

	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end
	})(v, "POST", { postBody = jsonEncode }):andThen(function(p)
		local responseBody = p.responseBody or p.result

		if responseBody and responseBody.linkId then
			return responseBody.linkId
		end

		error("Share link response missing linkId")
	end)
end

return function(p, p2, p3)
	local actionParams

	if p then
		actionParams = p.actionParams or nil
	end

	if actionParams == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.Share, message = "Missing actionParams" },
			p3.appPage
		)
		return
	end

	local shareLinkData = actionParams.shareLinkData or {}
	local entryPointKey = actionParams.entryPointKey or nil
	local shareUrlContext = shareLinkData.shareUrlContext or ""

	local v = nil
	local unixTimestampMillis = nil
	local v2

	if shareLinkData.linkType ~= nil then
		local linkType = shareLinkData.linkType
		local linkData = shareLinkData.linkData

		if linkData == nil then
			v2 = Promise.reject(`Missing linkData in ShareLinkFetchData (linkType={linkType})`)
		else
			v2 = fetchShareLinkId(linkType, linkData):andThen(function(linkId: string)
				v = linkId
				unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
				return urlBuilder.sharelinks.shortUrl({
					linkId = linkId,
					type = linkType,
					stamp = unixTimestampMillis
				})
			end)
		end
	else
		local url = shareLinkData.url

		if url == nil then
			v2 = Promise.reject("Missing url in shareLinkData")
		else
			v2 = Promise.resolve(url)
		end
	end

	v2:andThen(function(url: string)
		default:shareUrl({ context = shareUrlContext, url = url })

		if isDesktopPlatform() and entryPointKey then -- inferred equivalent call
			local formatted = p3.dependencies.localization:Format("Feature.GameDetails.Toast.LinkCopied")
			getSduiPageEntrySnackbarStore().show(entryPointKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.CircleCheck
			})
		end

		if shareLinkData.linkType == "ExperienceDetails" then
			local v3 = getActionTelemetryFieldValue(p, p2, "rootPlaceId")
				or getActionTelemetryFieldValue(p, p2, "placeId")

			if v3 ~= nil then
				local ctx = getActionTelemetryFieldValue(p, p2, "ctx") or "ExperienceDetailsShare"

				if FFlagLuaAppAddUniverseIdToEngagementEvents then
					local v4 = getActionTelemetryFieldValue(p, p2, "universeId")

					if v4 == nil and type(shareLinkData.linkData) == "table" then
						v4 = shareLinkData.linkData.universeId
					end

					local placeId = tostring(v3)

					local linkId = v
					local stamp = unixTimestampMillis
					local v5

					if v4 ~= nil then
						v5 = tostring(v4)
					end

					logExperienceDetailsShareAnalytics(placeId, ctx, linkId, stamp, v5)
				else
					logExperienceDetailsShareAnalytics(tostring(v3), ctx, v, unixTimestampMillis)
				end
			end
		end
	end):catch(function(p4)
		p3.dependencies.logger.reportError(
			SduiErrorType.FailedToExecuteAction,
			{ name = SduiActionType.Share, message = tostring(p4) },
			p3.appPage
		)

		if entryPointKey then
			local formatted = p3.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")
			getSduiPageEntrySnackbarStore().show(entryPointKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.TriangleExclamation
			})
		end
	end)
end
