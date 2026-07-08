local CorePackages = game:GetService("CorePackages")
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Constants = require(script.Parent.Parent.TopBar.Constants)
local CreateLayoutValues = PlayerList.Common.CreateLayoutValues

return function(p1) -- line: 9
	-- upvalues: CreateLayoutValues (copy), Constants (copy)
	return CreateLayoutValues(p1, Constants)
end
