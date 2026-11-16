local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName

local function isWebViewSupported() -- 1 equivalent call inferred from this helper
	return getAppFeaturePolicies().getWebViewSupport()
end

local function openSduiWebLink(p, name: string, titleKey: string?, callback)
	local success, result = pcall(function()
		local fromString = urlBuilder.fromString
		local v

		if string.find(name, "/") == 1 then
			v = name:gsub("/", "www:", 1)
		else
			v = name
		end

		return fromString(v)()
	end)

	if not success then
		p.dependencies.logger.reportError(SduiErrorType.FailedtoParseUrl, {
			name = name,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p.appPage)
		result = name
	end

	local linkingProtocol = p.dependencies.linkingProtocol
	local success2, result2 = pcall(function()
		linkingProtocol:isURLRegistered(result):andThen(function(p2)
			if p2 then
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
					p.dependencies.logger.reportCounter(SduiCounterName.WebViewNotSupportedForLink, {
						name = result
					})

					return
				end

				local navigation = p.dependencies.getNavigation()
				local extraProps = { titleKey = titleKey }

				if callback then
					function extraProps.onClose()
						callback()
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
		p.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
			name = name,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p.appPage)
	end
end

return openSduiWebLink
