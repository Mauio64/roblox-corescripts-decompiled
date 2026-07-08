local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local UrlBuilder = require(Parent.UrlBuilder)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local NavigationRodux = require(Parent.NavigationRodux)
local ToastRodux = require(Parent.ToastRodux)
local HttpRequest = require(Parent.HttpRequest)

require(Parent.LuauPolyfill)

local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local DiscoveryUtils = require(Parent.DiscoveryUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local function fetchShareLinkId(s1: string) -- line: 44
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), HttpRequest (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy)
	local v34 = UrlBuilder2.new({
		path = "sharelinks/v1/get-or-create-link",
		base = UrlBase.APIS
	})()
	local t1 = {
		linkType = "ExperienceDetails",
		data = {
			universeId = s1
		}
	}
	local json = HttpService:JSONEncode(t1.data)
	local json2 = HttpService:JSONEncode({
		linkType = t1.linkType,
		data = json
	})

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 63
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s2, s3, p1)
		end
	})(v34, "POST", {
		postBody = json2
	}):andThen(function(p2) -- line: 71
		-- upvalues: DiscoveryEventErrorLogger (copy), s1 (copy)
		local v55 = p2.responseBody or p2.result

		if v55 and v55.linkId then
			return v55.linkId
		end

		DiscoveryEventErrorLogger.reportError("FetchShareLinkIdInvalidResponse", "Share link response missing linkId", {
			universeId = s1,
			responseBody = p2.responseBody or p2.result
		})
		error("Failed to fetch share link id")
	end):catch(function(p3) -- line: 87
		-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy), s1 (copy)
		local v57 = if type(p3) ~= "table" or not p3.StatusCode then nil else p3.StatusCode

		logResponseError("sharelinks/v1/get-or-create-link", {
			StatusCode = v57
		})
		DiscoveryEventErrorLogger.reportError("FetchShareLinkIdFailed", "Failed to fetch share link id", {
			universeId = s1,
			statusCode = v57,
			error = tostring(p3)
		})
		error(p3)
	end)
end
local function generateExperienceDetailsShareLinkUrl(s4: string?, s5: string, s6: string) -- line: 99
	-- upvalues: UrlBuilder2 (copy)
	if s4 then
		local str = tostring(DateTime.now().UnixTimestampMillis)

		return UrlBuilder2.sharelinks.shortUrl({
			type = "ExperienceDetails",
			linkId = s4,
			stamp = str
		}), str
	end

	return UrlBuilder2.game.info.appsflyer({
		universeId = s5,
		placeId = s6
	}), nil
end
local function handleCopyLink(s7: string, s8: string, s9: string, p4) -- line: 117
	-- upvalues: fetchShareLinkId (copy), generateExperienceDetailsShareLinkUrl (copy), Players (copy), gameCopyExperienceLink (copy), default (copy), SetCurrentToastMessage (copy), ToastType (copy)
	fetchShareLinkId(s7):andThen(function(p5) -- line: 119
		-- upvalues: generateExperienceDetailsShareLinkUrl (copy), s7 (copy), s8 (copy), Players (copy), gameCopyExperienceLink (copy), s9 (copy), default (copy), p4 (copy), SetCurrentToastMessage (copy), ToastType (copy)
		local v59, v60 = generateExperienceDetailsShareLinkUrl(p5, s7, s8)
		local v61 = Players.LocalPlayer and Players.LocalPlayer.UserId

		gameCopyExperienceLink({
			ctx = s9,
			uid = tostring(v61),
			placeId = s8,
			stamp = v60
		}, s9)
		default:shareUrl({
			context = "GameDetailsMoreWebURL",
			url = v59
		})
		p4(SetCurrentToastMessage({
			toastMessage = "Feature.GameDetails.Toast.LinkCopied",
			toastType = ToastType.SuccessConfirmation
		}))
	end):catch(function(_) -- line: 140
		-- upvalues: p4 (copy), SetCurrentToastMessage (copy), ToastType (copy)
		p4(SetCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
			toastType = ToastType.NetworkingError
		}))
	end)
end
local function useExperienceDetailsShare(s10: string, s11: string?, s12: string) -- line: 153
	-- upvalues: useDispatch (copy), useAppPolicy (copy), React (copy), handleCopyLink (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), fetchShareLinkId (copy), generateExperienceDetailsShareLinkUrl (copy), Players (copy), gameShareExperienceLink (copy), default (copy), UrlBuilder2 (copy)
	local v49 = useDispatch()
	local v50 = useAppPolicy(function(p7) -- line: 159
		return p7.shouldShareToAccountProvider()
	end)

	return React.useCallback(function() -- line: 163
		-- upvalues: s11 (copy), v50 (copy), handleCopyLink (copy), s10 (copy), s12 (copy), v49 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), fetchShareLinkId (copy), generateExperienceDetailsShareLinkUrl (copy), Players (copy), gameShareExperienceLink (copy), default (copy), UrlBuilder2 (copy)
		if not s11 then
			return
		end

		if not v50 then
			handleCopyLink(s10, s11, s12, v49)

			return
		end

		if v50 then
			local t2 = {
				name = AppPage.SdkShare,
				extraProps = {
					context = "GameDetailsMoreWebURL",
					universeId = s10
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t2))

				return
			end

			v49(NavigateDown(t2))

			return
		end

		fetchShareLinkId(s10):andThen(function(p8) -- line: 191
			-- upvalues: generateExperienceDetailsShareLinkUrl (copy), s10 (copy), s11 (copy), Players (copy), gameShareExperienceLink (copy), s12 (copy), default (copy)
			local v66, v67 = generateExperienceDetailsShareLinkUrl(p8, s10, s11)
			local v68 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameShareExperienceLink({
				shareToAppsflyer = true,
				ctx = s12,
				uid = tostring(v68),
				placeId = s11,
				shortShareLinkFailed = not p8,
				stamp = v67,
				linkId = p8
			}, s12)
			default:shareUrl({
				context = "GameDetailsMoreWebURL",
				url = v66
			})
		end):catch(function(_) -- line: 213
			-- upvalues: s10 (copy), s11 (copy), UrlBuilder2 (copy), Players (copy), gameShareExperienceLink (copy), s12 (copy), default (copy)
			local v70 = s10
			local v71 = s11
			local v72 = UrlBuilder2.game.info.appsflyer({
				universeId = v70,
				placeId = v71
			})
			local v73 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameShareExperienceLink({
				shortShareLinkFailed = true,
				shareToAppsflyer = true,
				linkId = nil,
				ctx = s12,
				uid = tostring(v73),
				placeId = s11,
				stamp = nil
			}, s12)
			default:shareUrl({
				context = "GameDetailsMoreWebURL",
				url = v72
			})
		end)
	end, {
		s10,
		s11,
		v50,
		v49,
		s12
	})
end

return useExperienceDetailsShare
