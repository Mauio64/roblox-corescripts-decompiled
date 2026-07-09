local Parent = script:FindFirstAncestor("AbuseReporting").Parent

require(Parent.RobloxAppHooks)
require(Parent.Style)

return function(_, p2) -- line: 10
	return {
		ReportBackground = {
			gradientRotation = 90,
			backgroundColor = p2.Color.Extended.Black.Black_100,
			gradientTransparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(0.5, 0.5),
				NumberSequenceKeypoint.new(1, 1)
			})
		},
		ReportHeader = {
			verticalPadding = 36,
			dividerHeight = 2,
			dividerVerticalPadding = 36,
			size = UDim2.new(0.9, 0, 0, 200),
			titleFontStyle = p2.Typography.HeadingLarge,
			subtitleFontStyle = p2.Typography.HeadingSmall,
			titleTextColor = p2.Color.Content.Emphasis,
			subtitleTextColor = p2.Color.Content.Default,
			dividerColor = p2.Color.Stroke.Emphasis
		},
		ReportActionBar = {
			buttonWidth = 450,
			size = UDim2.new(0.33, 0, 0, 200),
			buttonListHorizontalPadding = p2.Size.Size_200,
			buttonHeight = p2.Size.Size_900
		},
		ReportStep = {
			size = UDim2.new(0.75, 0, 0.7, 0),
			headerFontStyle = p2.Typography.HeadingSmall,
			headerTextColor = p2.Color.Content.Emphasis,
			verticalPadding = UDim.new(0, 24)
		},
		ReportListSelection = {
			listEntrySize = UDim2.new(1, 0, 0, 64)
		},
		ReportSubmission = {
			dividerHeight = 2,
			dividerVerticalPadding = 5,
			entrySize = UDim2.new(0.6, 0, 0, 100),
			entryTitleColor = p2.Color.Content.Default,
			entryTextColor = p2.Color.Content.Emphasis,
			entryFontStyle = p2.Typography.TitleLarge,
			entryInnerVerticalPadding = UDim.new(0, 5),
			dividerColor = p2.Color.Stroke.Emphasis
		}
	}
end
