local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName

local openSduiWebLink = require(ServerDrivenUi.Actions.openSduiWebLink)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiLinkActionSharedWebLink = SharedFlags.FFlagSduiLinkActionSharedWebLink

local function isWebViewSupported() -- 1 equivalent call inferred from this helper
	return getAppFeaturePolicies().getWebViewSupport()
end

return function(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.Link, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local url = actionParams.url
	local titleKey = actionParams.titleKey

	if typeof(url) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.Link,
				message = `Invalid or missing url: {url}`,
				propName = "url"
			},
			p2.appPage
		)
		return
	end

	if FFlagSduiLinkActionSharedWebLink then
		openSduiWebLink(p2, url, titleKey, actionParams.onWebviewClose)
		return
	end

	local success, result = pcall(function()
		local fromString = urlBuilder.fromString
		local v

		if string.find(url, "/") == 1 then
			v = url:gsub("/", "www:", 1)
		else
			v = url
		end

		return fromString(v)()
	end)

	if not success then
		p2.dependencies.logger.reportError(SduiErrorType.FailedtoParseUrl, {
			name = url,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p2.appPage)
		result = url
	end

	local linkingProtocol = p2.dependencies.linkingProtocol
	local success2, result2 = pcall(function()
		linkingProtocol:isURLRegistered(result):andThen(function(p3)
			if p3 then
				if linkingProtocol:isInternalDlicEnabled() then
					linkingProtocol:detectDeeplinkIntent((linkingProtocol:createInternalDlic(
						result,
						DeepLinkSource.LuaInternal
					)))
				else
					linkingProtocol:detectURL(result)
				end
			else
				if not isWebViewSupported() then -- inferred equivalent call
					p2.dependencies.logger.reportCounter(SduiCounterName.WebViewNotSupportedForLink, {
						name = result
					})

					return
				end

				local navigation = p2.dependencies.getNavigation()
				local extraProps = { titleKey = titleKey }
				local onWebviewClose = actionParams.onWebviewClose

				if onWebviewClose then
					function extraProps.onClose()
						onWebviewClose()
					end
				end

				navigation.navigate(AppPage.GenericWebPage, {
					detail = result,
					extraProps = extraProps
				})
			end
		end)
	end)

	if not success2 then
		p2.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
			name = url,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p2.appPage)
	end
end
