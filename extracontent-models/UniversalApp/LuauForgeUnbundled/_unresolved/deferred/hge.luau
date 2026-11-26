local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local fitTextLabel = AvatarExperienceDeps.RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

require("@luauforge/bundled/dKT")

local fFlagAXFixEmptyCatalogSearchChrome = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixEmptyCatalogSearchChrome

local extended = Roact.PureComponent:extend("ResultsHeader")

function extended:renderWithStyle(p3)
	local font = p3.Font

	local font2 = font.Body.Font
	local v5 = font.BaseSize * font.Body.RelativeSize

	local font3 = font.Header2.Font
	local v6 = font.BaseSize * font.Header2.RelativeSize

	local theme = p3.Theme
	local color = theme.TextEmphasis.Color
	local transparency = theme.TextEmphasis.Transparency

	local searchInCatalog = self.props.searchInCatalog

	if not searchInCatalog then
		return Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v5) })
	end

	local keyword = searchInCatalog.keyword

	if
		fFlagAXFixEmptyCatalogSearchChrome
		and (typeof(keyword) ~= "string" or keyword:match("%S") == nil)
	then
		return nil
	end

	return withLocalization({
		showingResultsFor = "Feature.GamePage.LabelShowingResultsFor"
	})(function(p4)
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v5),
				LayoutOrder = 1
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2)
				}),
				ShowingResultsText = Roact.createElement(fitTextLabel, {
					width = fitTextLabel.Width.FitToText,
					Text = p4.showingResultsFor,
					LayoutOrder = 1,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextSize = v5,
					TextColor3 = color,
					TextTransparency = transparency,
					Font = font2,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top
				}),
				Keyword = Roact.createElement(fitTextLabel, {
					width = fitTextLabel.Width.FitToText,
					Text = keyword or "",
					LayoutOrder = 2,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextSize = v6,
					TextColor3 = color,
					TextTransparency = transparency,
					Font = font3,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top
				})
			}
		)
	end)
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return { searchInCatalog = p2.Search.SearchesInCatalog[p3.searchUuid] }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
