local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/fbS")
local assets = module3.Assets
local preloadAsset = module3.preloadAsset
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module4 = require("@luauforge/deferred/fbW")
local module5 = require("@luauforge/deferred/ekv")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image

local useTokens = Foundation.Hooks.useTokens

preloadAsset("pictograms/education")

local pictogramseducation = assets["pictograms/education"]

local function SchoolLockedPage(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		headerTitle = module5.PageTitle,
		heading = module5.SchoolLockedHeading
	})

	local v7 = pictogramseducation.size / 3 * v5.Config.UI.Scale

	return module.createElement(module4, {
		title = v6.headerTitle,
		onBack = p2.onBack,
		renderTrailing = p2.renderTrailing,
		fillContent = true,
		testId = "schools-locked-page"
	}, {
		Content = module.createElement(
			view,
			{ tag = "col align-x-center align-y-center fill gap-large size-full-0" },
			{
				Hero = module.createElement(image, {
					LayoutOrder = 1,
					Image = pictogramseducation.assetId,
					imageStyle = v5.Color.Content.Emphasis,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromOffset(v7.X, v7.Y),
					testId = "schools-locked-page-hero"
				}),
				HeadingContainer = module.createElement(
					view,
					{
						LayoutOrder = 2,
						tag = "col align-x-center gap-xsmall size-full-0 auto-y"
					},
					{
						Heading = module.createElement(text, {
							LayoutOrder = 1,
							Text = v6.heading,
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
						})
					}
				)
			}
		)
	})
end

return SchoolLockedPage
