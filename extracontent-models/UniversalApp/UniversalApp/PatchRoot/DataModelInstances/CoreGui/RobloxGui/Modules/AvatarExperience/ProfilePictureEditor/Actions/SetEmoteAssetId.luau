local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local function SetEmoteAssetId(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isTypeOrNil(p1, "string", "SetEmoteAssetId action expects emoteAssetId to be a string or nil")

	return {
		emoteAssetId = p1
	}
end

return (Rodux.makeActionCreator(script.Name, SetEmoteAssetId))
