local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local React = require(parent.React)

local Image = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local Assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/find_people")
local pictogramsfind_people = Assets["pictograms/find_people"] or {}

local function PeoplePickerEmptyState(p)
	local v = useTokens()
	local testId = p.testId or "people-picker-empty-state"

	return React.createElement(
		View,
		{ tag = "col align-x-center size-full-0 auto-y padding-y-large", testId = testId },
		{
			Image = React.createElement(Image, {
				Image = pictogramsfind_people.assetId,
				imageStyle = v.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(320 * v.Config.UI.Scale, 180 * v.Config.UI.Scale),
				testId = `{testId}--image`
			})
		}
	)
end

return PeoplePickerEmptyState
