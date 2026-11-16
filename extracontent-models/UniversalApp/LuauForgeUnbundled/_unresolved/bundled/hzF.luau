require("@luauforge/bundled/hzG")
require("@luauforge/bundled/hzs")

return function(p2, data)
	return {
		ReportBackground = {
			backgroundColor = data.Color.Extended.Black.Black_100,
			gradientRotation = 90,
			gradientTransparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(0.5, 0.5),
				NumberSequenceKeypoint.new(1, 1)
			})
		},
		ReportHeader = {
			size = UDim2.new(0.9, 0, 0, 200),
			verticalPadding = 36,
			titleFontStyle = data.Typography.HeadingLarge,
			subtitleFontStyle = data.Typography.HeadingSmall,
			titleTextColor = data.Color.Content.Emphasis,
			subtitleTextColor = data.Color.Content.Default,
			dividerColor = data.Color.Stroke.Emphasis,
			dividerHeight = 2,
			dividerVerticalPadding = 36
		},
		ReportActionBar = {
			size = UDim2.new(0.33, 0, 0, 200),
			buttonListHorizontalPadding = data.Size.Size_200,
			buttonHeight = data.Size.Size_900,
			buttonWidth = 450
		},
		ReportStep = {
			size = UDim2.new(0.75, 0, 0.7, 0),
			headerFontStyle = data.Typography.HeadingSmall,
			headerTextColor = data.Color.Content.Emphasis,
			verticalPadding = UDim.new(0, 24)
		},
		ReportListSelection = { listEntrySize = UDim2.new(1, 0, 0, 64) },
		ReportSubmission = {
			entrySize = UDim2.new(0.6, 0, 0, 100),
			entryTitleColor = data.Color.Content.Default,
			entryTextColor = data.Color.Content.Emphasis,
			entryFontStyle = data.Typography.TitleLarge,
			entryInnerVerticalPadding = UDim.new(0, 5),
			dividerColor = data.Color.Stroke.Emphasis,
			dividerHeight = 2,
			dividerVerticalPadding = 5
		}
	}
end
