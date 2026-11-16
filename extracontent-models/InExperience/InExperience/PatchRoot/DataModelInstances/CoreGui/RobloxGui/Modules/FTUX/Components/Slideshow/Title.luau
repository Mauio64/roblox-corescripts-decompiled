local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization
local parent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(parent.Resources.FTUXSlideshowData)

require(parent.Enums.PlatformEnum)

local function Title(p)
	local v = useStyle()

	local theme = v.Theme
	local font = v.Font

	return withLocalization({ titleText = FTUXSlideshowData[p.platform][p.currentIndex].title })(function(p2)
		return React.createElement(UIBlox.App.Text.StyledTextLabel, {
			text = p2.titleText,
			fontStyle = font.SubHeader1,
			colorStyle = theme.TextEmphasis,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0.031, 0),
			layoutOrder = 1
		})
	end)
end

return Title
