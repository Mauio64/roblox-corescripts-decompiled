local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

require(CorePackages.Packages.UIBlox).init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))
Roact.setGlobalConfig({
	elementTracing = true,
	propValidation = true
})

return {
	roact = Roact,
	mapStory = function(p1) -- line: 14
		-- upvalues: Roact (copy)
		return function(p2) -- line: 15
			-- upvalues: Roact (copy), p1 (copy)
			return Roact.createElement(p1, p2)
		end
	end
}
