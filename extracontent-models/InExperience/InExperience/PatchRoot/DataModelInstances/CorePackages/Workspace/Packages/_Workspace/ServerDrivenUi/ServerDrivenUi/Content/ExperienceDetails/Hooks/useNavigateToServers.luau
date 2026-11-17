local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UrlBuilder = require(parent.UrlBuilder)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local Navigation = require(parent.Navigation)
local LinkingProtocol = require(parent.LinkingProtocol)

local AppPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useNavigation = Navigation.useNavigation
local default = LinkingProtocol.LinkingProtocol.default
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdPageCloseCallback = SharedFlags.FFlagEnableBlackbirdPageCloseCallback

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local getSubscriptionPurchaseCloseCallback = RobloxSubscriptionPurchaseApp.Utils.getSubscriptionPurchaseCloseCallback

local function useNavigateToServers(universeId: string)
	local v = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v2 = useNavigation()
	local onClose

	if FFlagEnableBlackbirdPageCloseCallback then
		onClose = React.useMemo(function()
			if getSubscriptionPurchaseCloseCallback then
				return (getSubscriptionPurchaseCloseCallback())
			end

			return nil
		end, {})
	else
		onClose = nil
	end

	return React.useCallback(function()
		local servers = urlBuilder.game.info.servers({ universeId = universeId })

		pcall(function()
			default:isURLRegistered(servers):andThen(function(p)
				if p then
					if not default:isInternalDlicEnabled() then
						default:detectURL(servers)
						return
					end

					default:detectDeeplinkIntent((default:createInternalDlic(servers, DeepLinkSource.LuaInternal)))
				elseif v then
					v2.navigate(AppPage.GenericWebPage, {
						detail = servers,
						extraProps = FFlagEnableBlackbirdPageCloseCallback and { onClose = onClose } or nil
					})
				end
			end)
		end)
	end, { universeId, v, v2, default, onClose })
end

return useNavigateToServers
