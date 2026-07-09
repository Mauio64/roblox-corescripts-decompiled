local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local FitTextLabel = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local v11 = Roact.PureComponent:extend("ResultsHeader")

function v11.renderWithStyle(p1, p2) -- line: 25
	-- upvalues: Roact (copy), Skeleton (copy), withLocalization (copy), FitTextLabel (copy)
	local p2Font = p2.Font
	local BodyFont = p2Font.Body.Font
	local v17 = p2Font.BaseSize * p2Font.Body.RelativeSize
	local Header2Font = p2Font.Header2.Font
	local v19 = p2Font.BaseSize * p2Font.Header2.RelativeSize
	local Theme = p2.Theme
	local TextEmphasisColor = Theme.TextEmphasis.Color
	local TextEmphasisTransparency = Theme.TextEmphasis.Transparency
	local searchInCatalog = p1.props.searchInCatalog

	if not searchInCatalog then
		return Roact.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v17)
		})
	end

	local keyword = searchInCatalog.keyword

	return withLocalization({
		showingResultsFor = "Feature.GamePage.LabelShowingResultsFor"
	})(function(p3) -- line: 49
		-- upvalues: Roact (copy), v17 (copy), FitTextLabel (copy), TextEmphasisColor (copy), TextEmphasisTransparency (copy), BodyFont (copy), keyword (copy), v19 (copy), Header2Font (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v17)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2)
			}),
			ShowingResultsText = Roact.createElement(FitTextLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				TextWrapped = true,
				width = FitTextLabel.Width.FitToText,
				Text = p3.showingResultsFor,
				Size = UDim2.new(0, 0, 1, 0),
				TextSize = v17,
				TextColor3 = TextEmphasisColor,
				TextTransparency = TextEmphasisTransparency,
				Font = BodyFont,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			Keyword = Roact.createElement(FitTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = true,
				width = FitTextLabel.Width.FitToText,
				Text = keyword or "",
				Size = UDim2.new(0, 0, 1, 0),
				TextSize = v19,
				TextColor3 = TextEmphasisColor,
				TextTransparency = TextEmphasisTransparency,
				Font = Header2Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end
function v11.render(p4) -- line: 97
	-- upvalues: withStyle (copy)
	return withStyle(function(p5) -- line: 98
		-- upvalues: p4 (copy)
		return p4:renderWithStyle(p5)
	end)
end

local function mapStateToProps(p6, p7) -- line: 103
	return {
		searchInCatalog = p6.Search.SearchesInCatalog[p7.searchUuid]
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v11)
