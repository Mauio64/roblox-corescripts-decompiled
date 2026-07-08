local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Foundation = require(Parent.Foundation)
local HttpRequest = require(Parent.HttpRequest)
local Promise = require(Parent.Promise)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local UrlBuilder = require(Parent.UrlBuilder)
local SharedFlags = require(Parent.SharedFlags)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local getSduiPageEntrySnackbarStore = require(Parent.SduiSharedUtilities).getSduiPageEntrySnackbarStore
local UrlBase = UrlBuilder.UrlBase
local UrlBuilder2 = UrlBuilder.UrlBuilder
local gameCopyExperienceLink = DiscoveryAnalytics.Events.gameCopyExperienceLink
local gameShareExperienceLink = DiscoveryAnalytics.Events.gameShareExperienceLink
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport

local function isDesktopPlatform() -- line: 38
	-- upvalues: UserInputService (copy)
	local Platform = UserInputService:GetPlatform()

	return Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
end
local function logExperienceDetailsShareAnalytics(s1: string, s2: string, s3: string?, s4: string?) -- line: 45
	-- upvalues: Players (copy), UserInputService (copy), gameCopyExperienceLink (copy), gameShareExperienceLink (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	local str = tostring(LocalPlayer.UserId)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP) then
		gameCopyExperienceLink({
			ctx = s2,
			uid = str,
			placeId = s1,
			stamp = s4
		}, s2)

		return
	end

	gameShareExperienceLink({
		shareToAppsflyer = true,
		ctx = s2,
		uid = str,
		placeId = s1,
		shortShareLinkFailed = s3 == nil,
		stamp = s4,
		linkId = s3
	}, s2)
end
local function handleGenericShare(s5: string, t1: {[any]: any}, s6: string, p1) -- line: 77
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), default (copy), UserInputService (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy)
	local v39 = t1 and t1.url
	local v40 = t1 and t1.shareUrlContext

	if v39 == nil then
		p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.Share,
			message = `Missing url in shareLinkData for { s5 } share type`
		}, p1.appPage)

		return
	end

	if v40 == nil then
		p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.Share,
			message = `Missing shareUrlContext in shareLinkData for { s5 } share type`
		}, p1.appPage)

		return
	end

	default:shareUrl({
		context = v40,
		url = v39
	})

	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP) then
		if s6 == nil then
			p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				message = "Missing entryPointKey in SduiShareAction",
				name = SduiActionType.Share
			}, p1.appPage)

			return
		end

		local v42 = p1.dependencies.localization:Format("Feature.GameDetails.Toast.LinkCopied")

		getSduiPageEntrySnackbarStore().show(s6, {
			title = v42,
			icon = Foundation.Enums.IconName.CircleCheck
		})
	end
end
local function fetchShareLinkId(s7: string, t2: {[any]: any}) -- line: 131
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), HttpRequest (copy)
	local v45 = UrlBuilder2.new({
		path = "sharelinks/v1/get-or-create-link",
		base = UrlBase.APIS
	})()
	local json = HttpService:JSONEncode({
		linkType = s7,
		data = HttpService:JSONEncode(t2)
	})

	return HttpRequest.config({
		requestFunction = function(s8: string, s9: string, p2) -- line: 143
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s8, s9, p2)
		end
	})(v45, "POST", {
		postBody = json
	}):andThen(function(p3) -- line: 148
		local v68 = p3.responseBody or p3.result

		if v68 and v68.linkId then
			return v68.linkId
		end

		error("Share link response missing linkId")
	end)
end

return function(p4, p5, p6) -- line: 158
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), Promise (copy), fetchShareLinkId (copy), UrlBuilder2 (copy), default (copy), UserInputService (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), getActionTelemetryFieldValue (copy), logExperienceDetailsShareAnalytics (copy), handleGenericShare (copy)
	local v50 = p4 and p4.actionParams or nil

	if v50 == nil then
		p6.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.Share
		}, p6.appPage)

		return
	end

	if FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport then
		local v51 = v50.shareLinkData or {}
		local v52 = v50.entryPointKey or nil
		local v53 = v51.shareUrlContext or ""
		local v54 = v51.linkType ~= nil
		local u55 = nil
		local str = nil
		local v59

		if v54 then
			local linkType = v51.linkType
			local linkData = v51.linkData

			v59 = if linkData ~= nil then fetchShareLinkId(linkType, linkData):andThen(function(s10: string) -- line: 190
				-- upvalues: u55 (ref), str (ref), UrlBuilder2 (copy), linkType (copy)
				u55 = s10
				str = tostring(DateTime.now().UnixTimestampMillis)

				return UrlBuilder2.sharelinks.shortUrl({
					linkId = s10,
					type = linkType,
					stamp = str
				})
			end) else Promise.reject(`Missing linkData in ShareLinkFetchData (linkType={ linkType })`)
		else
			local url = v51.url

			v59 = if url ~= nil then Promise.resolve(url) else Promise.reject("Missing url in shareLinkData")
		end

		v59:andThen(function(s11: string) -- line: 210
			-- upvalues: default (copy), v53 (copy), UserInputService (copy), v52 (copy), p6 (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), v51 (copy), getActionTelemetryFieldValue (copy), p4 (copy), p5 (copy), logExperienceDetailsShareAnalytics (copy), u55 (ref), str (ref)
			default:shareUrl({
				context = v53,
				url = s11
			})

			local Platform = UserInputService:GetPlatform()

			if (Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)) and v52 then
				local v72 = p6.dependencies.localization:Format("Feature.GameDetails.Toast.LinkCopied")

				getSduiPageEntrySnackbarStore().show(v52, {
					title = v72,
					icon = Foundation.Enums.IconName.CircleCheck
				})
			end

			if v51.linkType == "ExperienceDetails" then
				local v73 = getActionTelemetryFieldValue(p4, p5, "rootPlaceId") or getActionTelemetryFieldValue(p4, p5, "placeId")

				if v73 ~= nil then
					local v74 = getActionTelemetryFieldValue(p4, p5, "ctx") or "ExperienceDetailsShare"

					logExperienceDetailsShareAnalytics(tostring(v73), v74, u55, str)
				end
			end
		end):catch(function(p7) -- line: 240
			-- upvalues: p6 (copy), SduiErrorType (copy), SduiActionType (copy), v52 (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy)
			p6.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
				name = SduiActionType.Share,
				message = tostring(p7)
			}, p6.appPage)

			if v52 then
				local v76 = p6.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")

				getSduiPageEntrySnackbarStore().show(v52, {
					title = v76,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		end)

		return
	end

	local shareLinkType = v50.shareLinkType
	local v62 = v50.shareLinkData or {}
	local v63 = v50.entryPointKey or nil

	handleGenericShare(shareLinkType, v62, v63, p6)
end
