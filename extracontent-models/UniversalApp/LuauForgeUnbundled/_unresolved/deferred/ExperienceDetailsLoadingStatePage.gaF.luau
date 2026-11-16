local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local useStyle = UIBlox.Core.Style.useStyle

local function ExperienceDetailsLoadingStatePage()
	local v5 = useStyle()

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v5.Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0
		},
		{
			LoadingSpinner = React.createElement(loading, {
				size = iconSize.Medium,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		}
	)
end

return ExperienceDetailsLoadingStatePage
