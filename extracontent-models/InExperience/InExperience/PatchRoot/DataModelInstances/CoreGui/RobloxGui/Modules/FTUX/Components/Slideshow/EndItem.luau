local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization
local parent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(parent.Resources.FTUXSlideshowData)
local Button = require(parent.Components.Slideshow.Button)

require(parent.Enums.PlatformEnum)

local function EndItem(data)
	local v = useStyle()

	local theme = v.Theme
	local font = v.Font

	local v2 = FTUXSlideshowData[data.platform]

	return withLocalization({ footerText = "CoreScripts.VRFTUX.Label.Footer" })(function(p)
		return data.currentIndex ~= #v2
			and React.createElement(Button, {
				platform = data.platform,
				currentIndex = data.currentIndex,
				increaseCurrentIndex = data.increaseCurrentIndex
			})
			or React.createElement(UIBlox.App.Text.StyledTextLabel, {
				text = p.footerText,
				fontStyle = font.CaptionHeader,
				colorStyle = theme.TextEmphasis,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				size = UDim2.new(1, 0, 1, 0),
				layoutOrder = 2
			})
	end)
end

return EndItem
