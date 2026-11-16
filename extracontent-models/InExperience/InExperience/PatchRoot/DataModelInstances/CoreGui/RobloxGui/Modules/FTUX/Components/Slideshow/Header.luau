local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization
local parent = script.Parent.Parent.Parent
local FTUXConstants = require(parent.Resources.FTUXConstants)

require(parent.Enums.PlatformEnum)

local function Header(p)
	local v = useStyle()

	local theme = v.Theme
	local font = v.Font
	local panelConstants = FTUXConstants[p.platform].PanelConstants

	local color = theme.BackgroundContrast.Color

	local HEADER_HEIGHT_RATIO = panelConstants.HEADER_HEIGHT_RATIO
	local v2 = panelConstants.CONTENT_PADDING / panelConstants.SLIDESHOW_FRAME_WIDTH
	local v3 = 1 - 2 * v2

	return withLocalization({ headerText = "CoreScripts.VRFTUX.Heading.Header" })(function(p2)
		return React.createElement(
			"Frame",
			{
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, HEADER_HEIGHT_RATIO, 0),
				LayoutOrder = 1
			},
			{
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.26, 0) }),
				HeaderFrame = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1
					},
					{
						Box = React.createElement(
							"Frame",
							{
								Size = UDim2.new(v3, 0, 1, 0),
								Position = UDim2.new(v2, 0, 0, 0),
								BackgroundTransparency = 1
							},
							{
								HeaderText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
									text = p2.headerText,
									fontStyle = font.Header1,
									colorStyle = theme.TextEmphasis,
									textXAlignment = Enum.TextXAlignment.Left,
									size = UDim2.new(1, 0, 1, 0),
									fluidSizing = true,
									automaticSize = Enum.AutomaticSize.XY
								})
							}
						)
					}
				)
			}
		)
	end)
end

return Header
