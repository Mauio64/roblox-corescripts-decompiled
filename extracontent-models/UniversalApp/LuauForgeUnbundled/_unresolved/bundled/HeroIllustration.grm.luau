local module = require("@luauforge/bundled/grg")
local module2 = require("@luauforge/bundled/gri")
local module3 = require("@luauforge/bundled/grn")
local view = module2.View
local image = module2.Image
local useTokens = module2.Hooks.useTokens

module3.preloadAsset("pictograms/share_plus")
local pictogramsshare_plus = module3.Assets["pictograms/share_plus"]

local udim = UDim2.fromOffset(320, 180)

local function HeroIllustration(p2)
	local v5 = useTokens()

	return module.createElement(
		view,
		{ tag = "row align-x-center size-full-0 auto-y", LayoutOrder = p2.layoutOrder },
		{
			Image = module.createElement(image, {
				Image = pictogramsshare_plus.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				Size = udim,
				testId = "plus-referral-hero-illustration"
			})
		}
	)
end

return HeroIllustration
