local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local UrlBuilder = require(parent.UrlBuilder)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local NavigationRodux = require(parent.NavigationRodux)
local ToastRodux = require(parent.ToastRodux)
local HttpRequest = require(parent.HttpRequest)
require(parent.LuauPolyfill)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local DiscoveryUtils = require(parent.DiscoveryUtils)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags2.FFlagLuaAppAddUniverseIdToEngagementEvents

local function fetchShareLinkId(universeId: string)
	local v = urlBuilder.new({ base = UrlBase.APIS, path = "sharelinks/v1/get-or-create-link" })()

	local v2 = {
		linkType = "ExperienceDetails",
		data = { universeId = universeId }
	}

	local jsonEncode = HttpService:JSONEncode(v2.data)
	local jsonEncode2 = HttpService:JSONEncode({ linkType = v2.linkType, data = jsonEncode })

	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end
	})(v, "POST", { postBody = jsonEncode2 }):andThen(function(p)
		local responseBody = p.responseBody or p.result

		if responseBody and responseBody.linkId then
			return responseBody.linkId
		end

		DiscoveryEventErrorLogger.reportError("FetchShareLinkIdInvalidResponse", "Share link response missing linkId", {
			universeId = universeId,
			responseBody = p.responseBody or p.result
		})

		error("Failed to fetch share link id")
	end):catch(function(message)
		local statusCode

		if type(message) == "table" and message.StatusCode then
			statusCode = message.StatusCode
		end

		logResponseError("sharelinks/v1/get-or-create-link", { StatusCode = statusCode })
		DiscoveryEventErrorLogger.reportError("FetchShareLinkIdFailed", "Failed to fetch share link id", {
			universeId = universeId,
			statusCode = statusCode,
			error = tostring(message)
		})

		error(message)
	end)
end

local function generateExperienceDetailsShareLinkUrl(linkId: string?, universeId: string, placeId: string)
	local v = nil

	if not linkId then
		return urlBuilder.game.info.appsflyer({ universeId = universeId, placeId = placeId }), v
	end

	local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
	return
		urlBuilder.sharelinks.shortUrl({
			linkId = linkId,
			type = "ExperienceDetails",
			stamp = unixTimestampMillis
		}),
		unixTimestampMillis
end

local function handleCopyLink(universeId: string, placeId: string, ctx: string, callback)
	fetchShareLinkId(universeId):andThen(function(linkId)
		local url, stamp = generateExperienceDetailsShareLinkUrl(linkId, universeId, placeId)

		local v = {
			ctx = ctx,
			uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
			placeId = placeId,
			stamp = stamp,
			targetId = 0
		}
		local targetId

		if FFlagLuaAppAddUniverseIdToEngagementEvents then
			targetId = universeId
		end

		v.targetId = targetId
		gameCopyExperienceLink(v, ctx)

		default:shareUrl({ context = "GameDetailsMoreWebURL", url = url })

		callback(SetCurrentToastMessage({
			toastMessage = "Feature.GameDetails.Toast.LinkCopied",
			toastType = ToastType.SuccessConfirmation
		}))
	end):catch(function(_)
		callback(SetCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
			toastType = ToastType.NetworkingError
		}))
	end)
end

local function useExperienceDetailsShare(universeId: string, placeId: string?, ctx: string)
	local v = useDispatch()
	local v2 = useAppPolicy(function(p)
		return p.shouldShareToAccountProvider()
	end)

	return React.useCallback(function()
		if not placeId then
			return
		end

		if not v2 then
			handleCopyLink(universeId, placeId, ctx, v)
			return
		end

		if not v2 then
			fetchShareLinkId(universeId):andThen(function(linkId)
				local url, stamp = generateExperienceDetailsShareLinkUrl(linkId, universeId, placeId)

				local v3 = {
					ctx = ctx,
					uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
					placeId = placeId,
					shortShareLinkFailed = not linkId,
					shareToAppsflyer = true,
					stamp = stamp,
					linkId = linkId,
					targetId = 0
				}
				local targetId

				if FFlagLuaAppAddUniverseIdToEngagementEvents then
					targetId = universeId
				end

				v3.targetId = targetId
				gameShareExperienceLink(v3, ctx)

				default:shareUrl({ url = url, context = "GameDetailsMoreWebURL" })
			end):catch(function(_)
				local appsflyer = urlBuilder.game.info.appsflyer({
					universeId = universeId,
					placeId = placeId
				})

				local v3 = {
					ctx = ctx,
					uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
					placeId = placeId,
					shortShareLinkFailed = true,
					shareToAppsflyer = true,
					stamp = nil,
					linkId = nil,
					targetId = 0
				}
				local targetId

				if FFlagLuaAppAddUniverseIdToEngagementEvents then
					targetId = universeId
				end

				v3.targetId = targetId
				gameShareExperienceLink(v3, ctx)

				default:shareUrl({ url = appsflyer, context = "GameDetailsMoreWebURL" })
			end)

			return
		end

		local v3 = {
			name = AppPage.SdkShare,
			extraProps = { universeId = universeId, context = "GameDetailsMoreWebURL" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3))
		else
			v(NavigateDown(v3))
		end
	end, { universeId, placeId, v2, v, ctx })
end

return useExperienceDetailsShare
