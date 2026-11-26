local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder").UrlBuilder
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy").getAppFeaturePolicies
local deepLinkSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LinkingProtocol").Enums.DeepLinkSource

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName

local function isWebViewSupported()
	return getAppFeaturePolicies().getWebViewSupport()
end

local function openSduiWebLink(p2, value, p3, callback)
	local success, result = pcall(function()
		local fromString = urlBuilder.fromString
		local v5 = if string.find(value, "/") == 1 then value:gsub("/", "www:", 1) else value
		return fromString(v5)()
	end)

	if not success then
		p2.dependencies.logger.reportError(sduiErrorType.FailedtoParseUrl, {
			name = value,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p2.appPage)
		result = value
	end

	local linkingProtocol = p2.dependencies.linkingProtocol
	local success2, result2 = pcall(function()
		linkingProtocol:isURLRegistered(result):andThen(function(p4)
			if p4 then
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
					p2.dependencies.logger.reportCounter(sduiCounterName.WebViewNotSupportedForLink, {
						name = result
					})

					return
				end

				local navigation = p2.dependencies.getNavigation()
				local v5 = { titleKey = p3 }

				if callback then
					function v5.onClose()
						callback()
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
		p2.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
			name = value,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p2.appPage)
	end
end

return openSduiWebLink
