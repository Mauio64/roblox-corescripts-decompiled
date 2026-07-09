local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local function IncrementPPEVersion(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "userdata", "IncrementPPEVersion action expects thumbnailType to be userdata")

	return {
		thumbnailType = p1
	}
end

return Rodux.makeActionCreator(script.Name, IncrementPPEVersion)
