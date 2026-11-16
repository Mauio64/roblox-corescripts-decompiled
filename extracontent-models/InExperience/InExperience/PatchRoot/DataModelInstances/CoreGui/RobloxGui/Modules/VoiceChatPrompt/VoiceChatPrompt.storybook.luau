local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local UIBlox = require(CorePackages.Packages.UIBlox)
UIBlox.init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

Roact.setGlobalConfig({ elementTracing = true, propValidation = true })

return {
	roact = Roact,
	mapStory = function(p)
		return function(p2)
			return Roact.createElement(p, p2)
		end
	end
}
