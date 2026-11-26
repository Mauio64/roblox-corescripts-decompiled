local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ToastRodux")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LuauPolyfill")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryUtils")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase
local appPage = RobloxAppEnums.AppPage
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local function fetchShareLinkId(p2)
	local v5 = urlBuilder.new({
		base = urlBase.APIS,
		path = "sharelinks/v1/get-or-create-link"
	})()

	local v6 = {
		linkType = "ExperienceDetails",
		data = { universeId = p2 }
	}

	local jsonEncode = HttpService:JSONEncode(v6.data)
	local jsonEncode2 = HttpService:JSONEncode({
		linkType = v6.linkType,
		data = jsonEncode
	})

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.RequestInternal(p3, p4, p5)
		end
	})(v5, "POST", { postBody = jsonEncode2 }):andThen(function(p3)
		local responseBody = p3.responseBody or p3.result

		if responseBody and responseBody.linkId then
			return responseBody.linkId
		end

		discoveryEventErrorLogger.reportError(
			"FetchShareLinkIdInvalidResponse",
			"Share link response missing linkId",
			{
				universeId = p2,
				responseBody = p3.responseBody or p3.result
			}
		)

		error("Failed to fetch share link id")
	end):catch(function(message)
		local statusCode = if type(message) == "table" and message.StatusCode then message.StatusCode else nil
		logResponseError("sharelinks/v1/get-or-create-link", { StatusCode = statusCode })
		discoveryEventErrorLogger.reportError("FetchShareLinkIdFailed", "Failed to fetch share link id", {
			universeId = p2,
			statusCode = statusCode,
			error = tostring(message)
		})

		error(message)
	end)
end

local function generateExperienceDetailsShareLinkUrl(p2, p3, p4)
	local v5 = nil

	if not p2 then
		return urlBuilder.game.info.appsflyer({ universeId = p3, placeId = p4 }), v5
	end

	local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
	return
		urlBuilder.sharelinks.shortUrl({
			linkId = p2,
			type = "ExperienceDetails",
			stamp = unixTimestampMillis
		}),
		unixTimestampMillis
end

local function handleCopyLink(p2, p3, p4, callback)
	fetchShareLinkId(p2):andThen(function(p5)
		local v5, v6 = generateExperienceDetailsShareLinkUrl(p5, p2, p3)

		local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
		gameCopyExperienceLink({
			ctx = p4,
			uid = tostring(userId),
			placeId = p3,
			stamp = v6,
			targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then p2 else nil
		}, p4)

		default:shareUrl({ context = "GameDetailsMoreWebURL", url = v5 })

		callback(setCurrentToastMessage({
			toastMessage = "Feature.GameDetails.Toast.LinkCopied",
			toastType = toastType.SuccessConfirmation
		}))
	end):catch(function(p5)
		callback(setCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
			toastType = toastType.NetworkingError
		}))
	end)
end

local function useExperienceDetailsShare(p2, p3, p4)
	local v5 = useDispatch()
	local v6 = useAppPolicy(function(p5)
		return p5.shouldShareToAccountProvider()
	end)

	return React.useCallback(function()
		if not p3 then
			return
		end

		if not v6 then
			handleCopyLink(p2, p3, p4, v5)
			return
		end

		if not v6 then
			fetchShareLinkId(p2):andThen(function(p5)
				local v7, v8 = generateExperienceDetailsShareLinkUrl(p5, p2, p3)

				local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
				gameShareExperienceLink({
					ctx = p4,
					uid = tostring(userId),
					placeId = p3,
					shortShareLinkFailed = not p5,
					shareToAppsflyer = true,
					stamp = v8,
					linkId = p5,
					targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then p2 else nil
				}, p4)

				default:shareUrl({ url = v7, context = "GameDetailsMoreWebURL" })
			end):catch(function(p5)
				local appsflyer = urlBuilder.game.info.appsflyer({
					universeId = p2,
					placeId = p3
				})

				local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
				gameShareExperienceLink({
					ctx = p4,
					uid = tostring(userId),
					placeId = p3,
					shortShareLinkFailed = true,
					shareToAppsflyer = true,
					stamp = nil,
					linkId = nil,
					targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then p2 else nil
				}, p4)

				default:shareUrl({ url = appsflyer, context = "GameDetailsMoreWebURL" })
			end)

			return
		end

		local v7 = {
			name = appPage.SdkShare,
			extraProps = { universeId = p2, context = "GameDetailsMoreWebURL" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v5(navigateDown(v7))
		end
	end, { p2, p3, v6, v5, p4 })
end

return useExperienceDetailsShare
