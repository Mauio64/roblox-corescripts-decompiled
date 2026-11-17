local parent = script:FindFirstAncestor("SponsoredTiles").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local function openWebView(p, detail: string)
	p.navigate(AppPage.GenericWebPage, {
		detail = detail,
		extraProps = { showDomainAsTitle = true }
	})
end

local function openAdClickoutUrl(p, detail: string)
	default:isURLRegistered(detail):catch(function(p2): boolean
		DiscoveryEventErrorLogger.reportError("AdClickout_IsUrlRegisteredFailed", (tostring(p2)))
		return false
	end):andThen(function(p2)
		if not p2 then
			openWebView(p, detail)
			return
		end

		if default:isInternalDlicEnabled() then
			local internalDlic = default:createInternalDlic(detail, DeepLinkSource.LuaInternal)

			if internalDlic == nil or internalDlic == "" then
				DiscoveryEventErrorLogger.reportError("AdClickout_CreateInternalDlicFailed", detail)
			else
				default:detectDeeplinkIntent(internalDlic)
				return
			end
		end

		default:detectURL(detail)
	end):catch(function(p2)
		DiscoveryEventErrorLogger.reportError("AdClickout_DeeplinkFailed", (tostring(p2)))
	end)
end

return openAdClickoutUrl
