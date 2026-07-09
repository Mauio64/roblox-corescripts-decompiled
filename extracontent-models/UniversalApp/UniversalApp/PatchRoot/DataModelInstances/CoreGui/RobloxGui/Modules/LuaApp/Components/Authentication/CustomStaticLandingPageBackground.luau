local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local LandingPageConstants = require(CorePackages.Workspace.Packages.LandingPage).Constants.LandingPageConstants
local FoundationImage = Foundation.Image
local View = Foundation.View
local t1 = {
	Transparency = 0,
	Color3 = Color3.new(0, 0, 0)
}

local function CustomStaticLandingPageBackground(t2: {[any]: any}) -- line: 20
	-- upvalues: React (copy), View (copy), t1 (copy), FoundationImage (copy), LandingPageConstants (copy)
	return React.createElement(View, {
		tag = "size-full",
		backgroundStyle = t1
	}, {
		BackgroundImage = React.createElement(FoundationImage, {
			tag = "size-full",
			Image = t2.backgroundImage,
			backgroundStyle = t1,
			ScaleType = Enum.ScaleType.Crop
		}, {
			UIGradient = React.createElement("UIGradient", LandingPageConstants.CustomizedLandingPage.BackgroundGradient)
		})
	})
end

return CustomStaticLandingPageBackground
