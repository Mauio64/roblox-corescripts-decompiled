local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local parent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(parent.Resources.FTUXSlideshowData)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
require(parent.Enums.PlatformEnum)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local function Description(p)
	local v = useStyle()

	local theme = v.Theme
	local font = v.Font

	local text = FTUXSlideshowData[p.platform][p.currentIndex].text

	return withLocalization(text)(function(p2)
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0.4, 0),
				Position = UDim2.new(0, 0, 0, 0),
				LayoutOrder = 2,
				BackgroundTransparency = 1
			},
			React.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LuauPolyfill.Array.map(text, function(_, layoutOrder)
				return (React.createElement(UIBlox.App.Text.StyledTextLabel, {
					text = p2[layoutOrder],
					fontStyle = font.CaptionBody,
					colorStyle = theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					size = UDim2.new(1, 0, 1 / #text, 0),
					layoutOrder = layoutOrder
				}))
			end)
		)
	end)
end

return Description
