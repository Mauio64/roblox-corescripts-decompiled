local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local landingPageConstants = require("@luauforge/bundled/fMZ").Constants.LandingPageConstants

local image = Foundation.Image
local view = Foundation.View

local v5 = { Color3 = Color3.new(0, 0, 0), Transparency = 0 }

local function CustomStaticLandingPageBackground(p2)
	return React.createElement(view, { tag = "size-full", backgroundStyle = v5 }, {
		BackgroundImage = React.createElement(
			image,
			{
				Image = p2.backgroundImage,
				tag = "size-full",
				backgroundStyle = v5,
				ScaleType = Enum.ScaleType.Crop
			},
			{
				UIGradient = React.createElement(
					"UIGradient",
					landingPageConstants.CustomizedLandingPage.BackgroundGradient
				)
			}
		)
	})
end

return CustomStaticLandingPageBackground
