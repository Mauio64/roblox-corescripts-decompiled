local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppEnums").AppPage
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryUtils").DiscoveryEventErrorLogger
local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/LinkingProtocol")
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local function openWebView(p2, p3)
	p2.navigate(appPage.GenericWebPage, {
		detail = p3,
		extraProps = { showDomainAsTitle = true }
	})
end

local function openAdClickoutUrl(p2, p3)
	default:isURLRegistered(p3):catch(function(p4): boolean
		discoveryEventErrorLogger.reportError("AdClickout_IsUrlRegisteredFailed", (tostring(p4)))
		return false
	end):andThen(function(p4)
		if not p4 then
			openWebView(p2, p3)
			return
		end

		if default:isInternalDlicEnabled() then
			local internalDlic = default:createInternalDlic(p3, deepLinkSource.LuaInternal)

			if internalDlic == nil or internalDlic == "" then
				discoveryEventErrorLogger.reportError("AdClickout_CreateInternalDlicFailed", p3)
			else
				default:detectDeeplinkIntent(internalDlic)
				return
			end
		end

		default:detectURL(p3)
	end):catch(function(p4)
		discoveryEventErrorLogger.reportError("AdClickout_DeeplinkFailed", (tostring(p4)))
	end)
end

return openAdClickoutUrl
