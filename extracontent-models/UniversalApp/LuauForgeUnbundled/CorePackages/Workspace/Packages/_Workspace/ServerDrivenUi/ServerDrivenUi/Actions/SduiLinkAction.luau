local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder").UrlBuilder
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy").getAppFeaturePolicies
local deepLinkSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LinkingProtocol").Enums.DeepLinkSource

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName

local openSduiWebLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSduiWebLink")

local fFlagSduiLinkActionSharedWebLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiLinkActionSharedWebLink

local function isWebViewSupported()
	return getAppFeaturePolicies().getWebViewSupport()
end

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.Link, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local url = actionParams.url
	local titleKey = actionParams.titleKey

	if typeof(url) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.Link,
				message = `Invalid or missing url: {url}`,
				propName = "url"
			},
			p4.appPage
		)
		return
	end

	if fFlagSduiLinkActionSharedWebLink then
		openSduiWebLink(p4, url, titleKey, actionParams.onWebviewClose)
		return
	end

	local success, result = pcall(function()
		local fromString = urlBuilder.fromString
		local v5 = if string.find(url, "/") == 1 then url:gsub("/", "www:", 1) else url
		return fromString(v5)()
	end)

	if not success then
		p4.dependencies.logger.reportError(sduiErrorType.FailedtoParseUrl, {
			name = url,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p4.appPage)
		result = url
	end

	local linkingProtocol = p4.dependencies.linkingProtocol
	local success2, result2 = pcall(function()
		linkingProtocol:isURLRegistered(result):andThen(function(p5)
			if p5 then
				if not linkingProtocol:isInternalDlicEnabled() then
					linkingProtocol:detectURL(result)
					return
				end

				linkingProtocol:detectDeeplinkIntent((linkingProtocol:createInternalDlic(
					result,
					deepLinkSource.LuaInternal
				)))
			else
				if not getAppFeaturePolicies().getWebViewSupport() then
					p4.dependencies.logger.reportCounter(sduiCounterName.WebViewNotSupportedForLink, {
						name = result
					})

					return
				end

				local navigation = p4.dependencies.getNavigation()
				local v5 = { titleKey = titleKey }
				local onWebviewClose = actionParams.onWebviewClose

				if onWebviewClose then
					function v5.onClose()
						onWebviewClose()
					end
				end

				navigation.navigate(appPage.GenericWebPage, {
					detail = result,
					extraProps = v5
				})
			end
		end)
	end)

	if not success2 then
		p4.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
			name = url,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p4.appPage)
	end
end
