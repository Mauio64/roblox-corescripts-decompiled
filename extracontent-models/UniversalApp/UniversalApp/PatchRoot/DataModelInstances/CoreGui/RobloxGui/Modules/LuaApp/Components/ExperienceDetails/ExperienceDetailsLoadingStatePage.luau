local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useStyle = UIBlox.Core.Style.useStyle

local function ExperienceDetailsLoadingStatePage() -- line: 14
	-- upvalues: useStyle (copy), React (copy), Loading (copy), IconSize (copy)
	local v9 = useStyle()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v9.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v9.Theme.BackgroundDefault.Transparency
	}, {
		LoadingSpinner = React.createElement(Loading, {
			size = IconSize.Medium,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	})
end

return ExperienceDetailsLoadingStatePage
