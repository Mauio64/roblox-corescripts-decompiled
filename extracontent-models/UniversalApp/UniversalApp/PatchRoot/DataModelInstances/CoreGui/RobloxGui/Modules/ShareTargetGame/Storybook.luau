local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local StyleProviderWithDefaultTheme = require(CorePackages.Workspace.Packages.Style).StyleProviderWithDefaultTheme

return {
	name = "sharetargetgame",
	storyRoot = script,
	middleware = function(p1, p2) -- line: 10
		-- upvalues: CorePackages (copy), Roact (copy), StyleProviderWithDefaultTheme (copy)
		require(CorePackages.Packages.UIBlox).init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

		local v6 = Roact.createElement(StyleProviderWithDefaultTheme, nil, {
			Story = Roact.createElement(p1)
		})
		local v7 = Roact.mount(v6, p2, "StoryRoot")

		return function() -- line: 19
			-- upvalues: Roact (copy), v7 (copy)
			Roact.unmount(v7)
		end
	end
}
