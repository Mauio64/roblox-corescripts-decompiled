local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(ChromeShared.Service)

local useChromeWindowItems = require(ChromeShared.Hooks.useChromeWindowItems)
local WindowHost = require(ChromeShared.Unibar.ComponentHosts.WindowHost)

return function(_)
	local v = useChromeWindowItems()

	local children = {}

	for _, integration in v do
		children["window_" .. integration.integration.id] = React.createElement(WindowHost, {
			position = Service:windowPosition(integration.integration.id),
			integration = integration
		})
	end

	return children
end
