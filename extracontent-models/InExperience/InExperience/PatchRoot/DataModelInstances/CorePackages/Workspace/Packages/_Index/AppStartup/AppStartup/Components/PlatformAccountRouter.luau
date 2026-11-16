local parent = script:FindFirstAncestor("AppStartup").Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty
local AppCommonLib = require(parent.AppCommonLib)
local isPlatformSingleSignOnSupported = AppCommonLib.isPlatformSingleSignOnSupported
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSkipStartupRouteHop = SharedFlags.FFlagLuaAppSkipStartupRouteHop

if
	FFlagLuaAppSkipStartupRouteHop and isPlatformSingleSignOnSupported(ThirdPartyUserService)
	or not FFlagLuaAppSkipStartupRouteHop
	and ThirdPartyUserService
	and ThirdPartyUserService.IsSingleSignOnSupported
	and ThirdPartyUserService:IsSingleSignOnSupported()
then
	return function(_): nil
		local v = useNavigation()
		local v2 = useProperty(ThirdPartyUserService, "HasActiveUser")

		React.useEffect(function()
			default:logEventOnce("platform_account_router_page_did_mount")
		end, {})

		React.useEffect(function()
			if v2 then
				default:logEventOnce("platform_account_router_page_did_continue")
				v.replace(AppPage.SingleSignOnContainer)
			end
		end, { v2, v })
		return nil
	end
end

return function(_): nil
	local v = useNavigation()
	React.useEffect(function()
		default:logEventOnce("platform_account_router_page_did_mount")
		default:logEventOnce("platform_account_router_page_did_continue")
		v.replace(AppPage.Startup)
	end, { v })
	return nil
end
