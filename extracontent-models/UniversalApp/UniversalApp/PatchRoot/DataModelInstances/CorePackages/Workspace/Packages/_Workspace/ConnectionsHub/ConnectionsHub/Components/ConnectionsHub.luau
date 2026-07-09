local ConnectionsHub = script:FindFirstAncestor("ConnectionsHub")
local ConnectionsHubParent = ConnectionsHub.Parent
local React = require(ConnectionsHubParent.React)
local Foundation = require(ConnectionsHubParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FullscreenPageWithSafeArea = require(ConnectionsHubParent.AppBlox).FullscreenPageWithSafeArea
local ConnectionsHubHeader = require(ConnectionsHub.Components.ConnectionsHubHeader)
local ConnectionsHubTabs = require(ConnectionsHub.Components.ConnectionsHubTabs)
local useMakeTabs = require(ConnectionsHub.Hooks.useMakeTabs)

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useMakeTabs (copy), useTokens (copy), React (copy), FullscreenPageWithSafeArea (copy), Foundation (copy), ConnectionsHubHeader (copy), ConnectionsHubTabs (copy)
	local renderNavigator = t1.renderNavigator
	local v12 = useMakeTabs(t1.tabConfig)
	local v13 = useTokens()

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v13.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v13.Color.Surface.Surface_0.Transparency
	}, {
		ConnectionsHubPage = React.createElement(Foundation.View, {
			tag = "size-full-full col"
		}, {
			ConnectionsHub = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y gap-small col bg-surface-0",
				LayoutOrder = 1
			}, {
				Header = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y bg-surface-0 align-x-center",
					layoutOrder = 1
				}, {
					CoHubHeader = React.createElement(ConnectionsHubHeader)
				}),
				CoHubTabs = React.createElement(ConnectionsHubTabs, {
					layoutOrder = 2,
					tabs = v12
				})
			}),
			ConnectionsHubSwitchNavigatorView = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y fill",
				LayoutOrder = 2
			}, {
				ConnectionsHubSwitchNavigator = renderNavigator()
			})
		})
	})
end
