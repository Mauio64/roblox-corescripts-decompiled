local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(ChromeShared.Service)
local useChromeWindowItems = require(ChromeShared.Hooks.useChromeWindowItems)
local WindowHost = require(ChromeShared.Unibar.ComponentHosts.WindowHost)

return function(_) -- line: 13
	-- upvalues: useChromeWindowItems (copy), React (copy), WindowHost (copy), Service (copy)
	local t1 = {}

	for _, v10 in (useChromeWindowItems()) do
		t1["window_" .. v10.integration.id] = React.createElement(WindowHost, {
			position = Service:windowPosition(v10.integration.id),
			integration = v10
		})
	end

	return t1
end
