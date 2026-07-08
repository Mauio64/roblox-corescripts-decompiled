local Parent = script:FindFirstAncestor("AppStartup").Parent
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local AppPage = require(Parent.RobloxAppEnums).AppPage
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local default = require(Parent.LoggingProtocol).default
local useProperty = require(Parent.GuiObjectUtils).useProperty

if ThirdPartyUserService and (ThirdPartyUserService.IsSingleSignOnSupported and ThirdPartyUserService:IsSingleSignOnSupported()) then
	return function(_: {[any]: any}) -- line: 17
		-- upvalues: useNavigation (copy), useProperty (copy), ThirdPartyUserService (copy), React (copy), default (copy), AppPage (copy)
		local v9 = useNavigation()
		local v10 = useProperty(ThirdPartyUserService, "HasActiveUser")

		React.useEffect(function() -- line: 21
			-- upvalues: default (copy)
			default:logEventOnce("platform_account_router_page_did_mount")
		end, {})
		React.useEffect(function() -- line: 25
			-- upvalues: v10 (copy), default (copy), v9 (copy), AppPage (copy)
			if v10 then
				default:logEventOnce("platform_account_router_page_did_continue")
				v9.replace(AppPage.SingleSignOnContainer)
			end
		end, {
			v10,
			v9
		})

		return nil
	end
end

return function(_: {[any]: any}) -- line: 34
	-- upvalues: useNavigation (copy), React (copy), default (copy), AppPage (copy)
	local v12 = useNavigation()

	React.useEffect(function() -- line: 36
		-- upvalues: default (copy), v12 (copy), AppPage (copy)
		default:logEventOnce("platform_account_router_page_did_mount")
		default:logEventOnce("platform_account_router_page_did_continue")
		v12.replace(AppPage.Startup)
	end, { v12 })

	return nil
end
