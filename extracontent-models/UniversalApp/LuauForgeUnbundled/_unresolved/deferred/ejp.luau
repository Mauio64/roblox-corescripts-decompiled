local module = require("@luauforge/deferred/ejq")

local module2 = require("@luauforge/deferred/ejr")
local useTokens = module2.Hooks.useTokens

local fullscreenPageWithSafeArea = require("@luauforge/deferred/ejs").FullscreenPageWithSafeArea
local module3 = require("@luauforge/deferred/ejt")
local module4 = require("@luauforge/deferred/ejB")
local module5 = require("@luauforge/deferred/ejJ")

local fFlagAppThemeHalloween2026FriendsBackground = require("@luauforge/deferred/ejC").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@luauforge/deferred/ejD").useThemeBackground

return function(p2)
	local renderNavigator = p2.renderNavigator

	local v5 = module5(p2.tabConfig)

	local v6 = useTokens()

	local v7 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	return module.createElement(fullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v6.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v7 and 1 or v6.Color.Surface.Surface_0.Transparency
	}, {
		ConnectionsHubPage = module.createElement(module2.View, {
			tag = "size-full-full col"
		}, {
			ConnectionsHub = module.createElement(module2.View, {
				tag = fFlagAppThemeHalloween2026FriendsBackground and {
					["size-full-0"] = true,
					["auto-y"] = true,
					["gap-small"] = true,
					col = true,
					["bg-surface-0"] = not v7
				} or "size-full-0 auto-y gap-small col bg-surface-0",
				LayoutOrder = 1
			}, {
				Header = module.createElement(module2.View, {
					tag = fFlagAppThemeHalloween2026FriendsBackground and {
						["size-full-0"] = true,
						["auto-y"] = true,
						["align-x-center"] = true,
						["bg-surface-0"] = not v7
					} or "size-full-0 auto-y bg-surface-0 align-x-center",
					layoutOrder = 1
				}, { CoHubHeader = module.createElement(module3) }),
				CoHubTabs = module.createElement(module4, { layoutOrder = 2, tabs = v5 })
			}),
			ConnectionsHubSwitchNavigatorView = module.createElement(
				module2.View,
				{ tag = "size-full-0 auto-y fill", LayoutOrder = 2 },
				{ ConnectionsHubSwitchNavigator = renderNavigator() }
			)
		})
	})
end
