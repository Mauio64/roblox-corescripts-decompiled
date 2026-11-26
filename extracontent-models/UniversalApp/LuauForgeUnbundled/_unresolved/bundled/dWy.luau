local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

local function SetLastSuccessfulPoseEmoteAssetId(p2)
	module.isTypeOrNil(
		p2,
		"string",
		"SetLastSuccessfulPoseEmoteAssetId action expects lastSuccessfulPoseEmoteAssetId to be a string or nil"
	)

	return { lastSuccessfulPoseEmoteAssetId = p2 }
end

return Rodux.makeActionCreator("SetLastSuccessfulPoseEmoteAssetId", SetLastSuccessfulPoseEmoteAssetId)
