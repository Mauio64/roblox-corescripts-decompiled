local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local UrlBuilder = require(ServerDrivenUiParent.UrlBuilder).UrlBuilder
local AppPage = require(ServerDrivenUiParent.RobloxAppEnums).AppPage
local getAppFeaturePolicies = require(ServerDrivenUiParent.UniversalAppPolicy).getAppFeaturePolicies
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName
local openSduiWebLink = require(ServerDrivenUi.Actions.openSduiWebLink)
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiLinkActionSharedWebLink = SharedFlags.FFlagSduiLinkActionSharedWebLink

local function isWebViewSupported() -- line: 25
	-- upvalues: getAppFeaturePolicies (copy)
	return getAppFeaturePolicies().getWebViewSupport()
end

return function(p1, _, p3) -- line: 29
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiLinkActionSharedWebLink (copy), openSduiWebLink (copy), UrlBuilder (copy), getAppFeaturePolicies (copy), AppPage (copy), SduiCounterName (copy)
	local v18 = p1 and p1.actionParams or nil

	if v18 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.Link
		}, p3.appPage)

		return
	end

	assert(v18, "actionParams must exist")

	local url = v18.url
	local v20 = if not FFlagSduiExperienceDetailsSupport then nil else v18.titleKey

	if typeof(url) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "url",
			name = SduiActionType.Link,
			message = `Invalid or missing url: { url }`
		}, p3.appPage)

		return
	end

	if FFlagSduiLinkActionSharedWebLink then
		openSduiWebLink(p3, url, v20, v18.onWebviewClose)

		return
	end

	local ok, result = pcall(function() -- line: 62
		-- upvalues: UrlBuilder (copy), url (copy)
		return UrlBuilder.fromString((if string.find(url, "/") ~= 1 then url else url:gsub("/", "www:", 1)))()
	end)
	local u23

	if ok then
		u23 = result
	else
		u23 = url
		p3.dependencies.logger.reportError(SduiErrorType.FailedtoParseUrl, {
			name = url,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p3.appPage)
	end

	local linkingProtocol = p3.dependencies.linkingProtocol
	local ok2, result2 = pcall(function() -- line: 77
		-- upvalues: linkingProtocol (copy), u23 (ref), getAppFeaturePolicies (copy), p3 (copy), FFlagSduiExperienceDetailsSupport (copy), v20 (copy), v18 (copy), AppPage (copy), SduiCounterName (copy)
		linkingProtocol:isURLRegistered(u23):andThen(function(p4) -- line: 78
			-- upvalues: linkingProtocol (copy), u23 (ref), getAppFeaturePolicies (copy), p3 (copy), FFlagSduiExperienceDetailsSupport (copy), v20 (copy), v18 (copy), AppPage (copy), SduiCounterName (copy)
			if p4 then
				linkingProtocol:detectURL(u23)

				return
			end

			if getAppFeaturePolicies().getWebViewSupport() then
				local v28 = p3.dependencies.getNavigation()
				local v29 = if not FFlagSduiExperienceDetailsSupport then nil else {
					titleKey = v20
				}

				if FFlagSduiExperienceDetailsSupport and v29 then
					local onWebviewClose = v18.onWebviewClose

					if onWebviewClose then
						function v29.onClose() -- line: 89
							-- upvalues: onWebviewClose (copy)
							onWebviewClose()
						end
					end
				end

				v28.navigate(AppPage.GenericWebPage, {
					detail = u23,
					extraProps = if not FFlagSduiExperienceDetailsSupport then nil else v29
				})

				return
			end

			p3.dependencies.logger.reportCounter(SduiCounterName.WebViewNotSupportedForLink, {
				name = u23
			})
		end)
	end)

	if not ok2 then
		p3.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
			name = url,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p3.appPage)
	end
end
