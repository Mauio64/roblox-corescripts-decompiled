local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/eeP")
local useNavigation = require("@luauforge/deferred/eeQ").useNavigation
local appPage = require("@luauforge/deferred/eeR").AppPage
local useDesignTokens = require("@luauforge/deferred/eeS").useDesignTokens
local fullscreenPageWithSafeArea = require("@luauforge/deferred/eeT").FullscreenPageWithSafeArea

local module3 = require("@luauforge/deferred/eeU")
local module4 = require("@luauforge/deferred/ejk")
local fFlagCreateConnectionsHub = require("@luauforge/deferred/efc").FFlagCreateConnectionsHub

function LUAUFORGE_MODULE_GLOBALS_eeN_AddFriendsScreen(p2)
	local navigateToLuaAppPages = p2.navigateToLuaAppPages
	local v5 = useNavigation()

	local v6 = useDesignTokens()

	local v7 = fFlagCreateConnectionsHub and v5.state.routeName == appPage.CoHubAddConnections

	return module.createElement(module4, {
		renderChild = function(options)
			if v7 then
				return module.createElement(
					module3,
					module2.join(options or {}, {
						navigateToLuaAppPages = navigateToLuaAppPages
					})
				)
			end

			return module.createElement(
				fullscreenPageWithSafeArea,
				{
					includeStatusBar = true,
					BackgroundColor3 = v6.LuaApps.App.Page.BackgroundColor,
					BackgroundTransparency = v6.LuaApps.App.Page.BackgroundTransparency
				},
				{
					AddFriendsScreen = module.createElement(
						module3,
						module2.join(options or {}, {
							navigateToLuaAppPages = navigateToLuaAppPages
						})
					)
				}
			)
		end
	})
end

return LUAUFORGE_MODULE_GLOBALS_eeN_AddFriendsScreen
