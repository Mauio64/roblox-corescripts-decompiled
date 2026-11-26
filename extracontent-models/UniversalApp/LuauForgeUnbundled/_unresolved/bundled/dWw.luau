local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

local function SetEmoteAssetId(p2)
	module.isTypeOrNil(p2, "string", "SetEmoteAssetId action expects emoteAssetId to be a string or nil")
	return { emoteAssetId = p2 }
end

return Rodux.makeActionCreator("SetEmoteAssetId", SetEmoteAssetId)
