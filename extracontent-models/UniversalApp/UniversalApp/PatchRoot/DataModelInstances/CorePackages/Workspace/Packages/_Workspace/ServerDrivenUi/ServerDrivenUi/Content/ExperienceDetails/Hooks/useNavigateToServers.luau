local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local UrlBuilder = require(Parent.UrlBuilder)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local Navigation = require(Parent.Navigation)
local LinkingProtocol = require(Parent.LinkingProtocol)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder2 = UrlBuilder.UrlBuilder
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useNavigation = Navigation.useNavigation
local default = LinkingProtocol.LinkingProtocol.default
local FFlagEnableBlackbirdPageCloseCallback = require(Parent.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(Parent.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback

local function useNavigateToServers(s1: string) -- line: 24
	-- upvalues: useAppPolicy (copy), useNavigation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), React (copy), getSubscriptionPurchaseCloseCallback (copy), UrlBuilder2 (copy), default (copy), AppPage (copy)
	local v17 = useAppPolicy(function(p1) -- line: 25
		return p1.getWebViewSupport()
	end)
	local v18 = useNavigation()
	local u19 = nil

	if FFlagEnableBlackbirdPageCloseCallback then
		u19 = React.useMemo(function() -- line: 32
			-- upvalues: getSubscriptionPurchaseCloseCallback (copy)
			if getSubscriptionPurchaseCloseCallback then
				return (getSubscriptionPurchaseCloseCallback())
			end

			return nil
		end, {})
	end

	return React.useCallback(function() -- line: 37
		-- upvalues: UrlBuilder2 (copy), s1 (copy), default (copy), v17 (copy), v18 (copy), AppPage (copy), FFlagEnableBlackbirdPageCloseCallback (copy), u19 (ref)
		local v21 = UrlBuilder2.game.info.servers({
			universeId = s1
		})

		pcall(function() -- line: 42
			-- upvalues: default (copy), v21 (copy), v17 (copy), v18 (copy), AppPage (copy), FFlagEnableBlackbirdPageCloseCallback (copy), u19 (ref)
			default:isURLRegistered(v21):andThen(function(p2) -- line: 43
				-- upvalues: default (copy), v21 (copy), v17 (copy), v18 (copy), AppPage (copy), FFlagEnableBlackbirdPageCloseCallback (copy), u19 (ref)
				if p2 then
					default:detectURL(v21)

					return
				end

				if v17 then
					v18.navigate(AppPage.GenericWebPage, {
						detail = v21,
						extraProps = if not FFlagEnableBlackbirdPageCloseCallback then nil else {
							onClose = u19
						}
					})
				end
			end)
		end)
	end, {
		s1,
		v17,
		v18,
		default,
		u19
	})
end

return useNavigateToServers
