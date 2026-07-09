local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local function SetLastSuccessfulPoseEmoteAssetId(s1: string?) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isTypeOrNil(s1, "string", "SetLastSuccessfulPoseEmoteAssetId action expects lastSuccessfulPoseEmoteAssetId to be a string or nil")

	return {
		lastSuccessfulPoseEmoteAssetId = s1
	}
end

return Rodux.makeActionCreator(script.Name, SetLastSuccessfulPoseEmoteAssetId)
