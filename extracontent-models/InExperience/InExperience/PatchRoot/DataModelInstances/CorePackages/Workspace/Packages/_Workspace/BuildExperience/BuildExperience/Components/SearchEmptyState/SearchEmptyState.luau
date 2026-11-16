local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local React = require(parent.React)

local Image = Foundation.Image
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local Assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/find_people")
local pictogramsfind_people = Assets["pictograms/find_people"] or {}

local function SearchEmptyState(p)
	local v = useTokens()
	local testId = p.testId or "SearchEmptyState"

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col align-x-center align-y-center size-full",
			testId = testId
		},
		{
			Image = React.createElement(Image, {
				Image = pictogramsfind_people.assetId,
				imageStyle = v.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(320 * v.Config.UI.Scale, 180 * v.Config.UI.Scale),
				testId = `{testId}.Image`
			})
		}
	)
end

return SearchEmptyState
