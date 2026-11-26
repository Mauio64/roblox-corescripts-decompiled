local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RobloxAppEnums").AppPage
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local default = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/LoggingProtocol").default
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/GuiObjectUtils").useProperty
local isPlatformSingleSignOnSupported = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/AppCommonLib").isPlatformSingleSignOnSupported
local fFlagLuaAppSkipStartupRouteHop = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/SharedFlags").FFlagLuaAppSkipStartupRouteHop

if
	fFlagLuaAppSkipStartupRouteHop and isPlatformSingleSignOnSupported(ThirdPartyUserService)
	or not fFlagLuaAppSkipStartupRouteHop
	and ThirdPartyUserService
	and ThirdPartyUserService.IsSingleSignOnSupported
	and ThirdPartyUserService:IsSingleSignOnSupported()
then
	return function(p2): nil
		local v5 = useNavigation()
		local v6 = useProperty(ThirdPartyUserService, "HasActiveUser")

		React.useEffect(function()
			default:logEventOnce("platform_account_router_page_did_mount")
		end, {})

		React.useEffect(function()
			if v6 then
				default:logEventOnce("platform_account_router_page_did_continue")
				v5.replace(appPage.SingleSignOnContainer)
			end
		end, { v6, v5 })
		return nil
	end
end

return function(p2): nil
	local v5 = useNavigation()
	React.useEffect(function()
		default:logEventOnce("platform_account_router_page_did_mount")
		default:logEventOnce("platform_account_router_page_did_continue")
		v5.replace(appPage.Startup)
	end, { v5 })
	return nil
end
