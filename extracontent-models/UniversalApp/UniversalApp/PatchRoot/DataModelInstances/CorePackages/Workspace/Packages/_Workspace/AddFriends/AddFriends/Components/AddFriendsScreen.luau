local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local useNavigation = require(Parent.Navigation).useNavigation
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useDesignTokens = require(Parent.Style).useDesignTokens
local FullscreenPageWithSafeArea = require(Parent.AppBlox).FullscreenPageWithSafeArea
local AddFriendsContainer = require(script.Parent.AddFriendsContainer)
local AddFriendsLayerExposure = require(script.Parent.AddFriendsLayerExposure)
local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub

function AddFriendsScreen(t1: {[any]: any}) -- line: 22
	-- upvalues: useNavigation (copy), useDesignTokens (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), React (copy), AddFriendsLayerExposure (copy), AddFriendsContainer (copy), Dash (copy), FullscreenPageWithSafeArea (copy)
	local navigateToLuaAppPages = t1.navigateToLuaAppPages
	local v13 = useNavigation()
	local v14 = useDesignTokens()
	local v15 = FFlagCreateConnectionsHub and v13.state.routeName == AppPage.CoHubAddConnections

	return React.createElement(AddFriendsLayerExposure, {
		renderChild = function(p1) -- line: 31
			-- upvalues: v15 (copy), React (copy), AddFriendsContainer (copy), Dash (copy), navigateToLuaAppPages (copy), FullscreenPageWithSafeArea (copy), v14 (copy)
			if v15 then
				return React.createElement(AddFriendsContainer, Dash.join(p1 or {}, {
					navigateToLuaAppPages = navigateToLuaAppPages
				}))
			end

			return React.createElement(FullscreenPageWithSafeArea, {
				includeStatusBar = true,
				BackgroundColor3 = v14.LuaApps.App.Page.BackgroundColor,
				BackgroundTransparency = v14.LuaApps.App.Page.BackgroundTransparency
			}, {
				AddFriendsScreen = React.createElement(AddFriendsContainer, Dash.join(p1 or {}, {
					navigateToLuaAppPages = navigateToLuaAppPages
				}))
			})
		end
	})
end

return AddFriendsScreen
