local CorePackages = game:GetService("CorePackages")

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Constants = require(script.Parent.Parent.TopBar.Constants)

local createLayoutValues = PlayerList.Common.CreateLayoutValues
return function(p)
	return createLayoutValues(p, Constants)
end
