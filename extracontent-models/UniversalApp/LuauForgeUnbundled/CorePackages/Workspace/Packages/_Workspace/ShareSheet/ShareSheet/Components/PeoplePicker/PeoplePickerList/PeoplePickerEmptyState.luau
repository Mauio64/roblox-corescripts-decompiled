local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/FoundationCloudAssets")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local image = Foundation.Image
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/find_people")
local pictogramsfind_people = assets["pictograms/find_people"] or {}

local function PeoplePickerEmptyState(p2)
	local v5 = useTokens()
	local testId = p2.testId or "people-picker-empty-state"

	return React.createElement(
		view,
		{
			tag = "col align-x-center size-full-0 auto-y padding-y-large",
			testId = testId
		},
		{
			Image = React.createElement(image, {
				Image = pictogramsfind_people.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(320 * v5.Config.UI.Scale, 180 * v5.Config.UI.Scale),
				testId = `{testId}--image`
			})
		}
	)
end

return PeoplePickerEmptyState
