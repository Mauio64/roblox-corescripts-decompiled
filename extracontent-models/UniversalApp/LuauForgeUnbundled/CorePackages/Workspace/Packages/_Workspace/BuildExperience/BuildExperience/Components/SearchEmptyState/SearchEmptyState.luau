local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FoundationCloudAssets")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local image = Foundation.Image
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/find_people")
local pictogramsfind_people = assets["pictograms/find_people"] or {}

local function SearchEmptyState(p2)
	local v5 = useTokens()
	local testId = p2.testId or "SearchEmptyState"

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col align-x-center align-y-center size-full",
			testId = testId
		},
		{
			Image = React.createElement(image, {
				Image = pictogramsfind_people.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(320 * v5.Config.UI.Scale, 180 * v5.Config.UI.Scale),
				testId = `{testId}.Image`
			})
		}
	)
end

return SearchEmptyState
