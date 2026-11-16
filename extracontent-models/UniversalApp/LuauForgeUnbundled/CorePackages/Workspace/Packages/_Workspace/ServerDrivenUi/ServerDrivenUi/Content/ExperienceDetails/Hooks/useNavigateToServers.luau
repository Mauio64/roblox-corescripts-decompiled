local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Navigation")
local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LinkingProtocol")

local appPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useNavigation = Navigation.useNavigation
local default = LinkingProtocol.LinkingProtocol.default
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxSubscriptionPurchaseApp").Utils.getSubscriptionPurchaseCloseCallback

local function useNavigateToServers(p2)
	local v5 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local v6 = useNavigation()
	local v7

	if fFlagEnableBlackbirdPageCloseCallback then
		v7 = React.useMemo(function()
			if getSubscriptionPurchaseCloseCallback then
				return (getSubscriptionPurchaseCloseCallback())
			end

			return nil
		end, {})
	else
		v7 = nil
	end

	return React.useCallback(function()
		local servers = urlBuilder.game.info.servers({ universeId = p2 })

		pcall(function()
			default:isURLRegistered(servers):andThen(function(p3)
				if p3 then
					if not default:isInternalDlicEnabled() then
						default:detectURL(servers)
						return
					end

					default:detectDeeplinkIntent((default:createInternalDlic(
						servers,
						deepLinkSource.LuaInternal
					)))
				elseif v5 then
					v6.navigate(appPage.GenericWebPage, {
						detail = servers,
						extraProps = fFlagEnableBlackbirdPageCloseCallback and {
							onClose = v7
						} or nil
					})
				end
			end)
		end)
	end, { p2, v5, v6, default, v7 })
end

return useNavigateToServers
