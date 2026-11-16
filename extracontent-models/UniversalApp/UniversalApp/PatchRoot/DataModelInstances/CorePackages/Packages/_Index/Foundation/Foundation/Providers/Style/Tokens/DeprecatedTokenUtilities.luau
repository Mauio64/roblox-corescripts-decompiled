local function cloneTokenValue(items)
	if type(items) ~= "table" then
		return items
	end

	local result = {}

	for k, item in items do
		result[k] = cloneTokenValue(item)
	end

	return result
end

return {
	getDeprecatedSemanticTokens = function(data, p: number)
		return (cloneTokenValue({
			Color = {
				Background = {
					Default = data.Color.Surface.Surface_0,
					Contrast = data.Color.Surface.Surface_100,
					Muted = data.Color.Surface.Surface_200,
					OnHover = data.Color.State.Hover,
					OnPress = data.Color.State.Press
				},
				BackgroundUi = {
					Default = data.Color.Surface.Surface_300,
					Contrast = data.Color.OverMedia.OverMedia_0
				},
				Ui = {
					Default = data.Color.Shift.Shift_200,
					Muted = data.Color.Shift.Shift_100,
					Emphasis = data.Color.Shift.Shift_400
				},
				Focus = {
					Start = data.Color.Selection.Start,
					End = data.Color.Selection.End,
					Gradient = data.Color.Selection.Start
				},
				State = {
					Standard = {
						Default = data.Color.State.Idle,
						Hover = data.Color.State.Hover,
						Pressed = data.Color.State.Press
					},
					Inverse = {
						Default = data.Inverse.State.Idle,
						Hover = data.Inverse.State.Hover,
						Pressed = data.Inverse.State.Press
					},
					Darken = {
						Default = data.LightMode.State.Idle,
						Hover = data.LightMode.State.Hover,
						Pressed = data.LightMode.State.Press
					},
					Lighten = {
						Default = data.DarkMode.State.Idle,
						Hover = data.DarkMode.State.Hover,
						Pressed = data.DarkMode.State.Press
					}
				},
				Text = {
					Emphasis = data.Color.Content.Emphasis,
					Default = data.Color.Content.Default,
					Muted = data.Color.Content.Muted,
					Link = data.Color.Content.Link,
					Inverse = data.Inverse.Content.Default
				},
				Icon = {
					Emphasis = data.Color.Content.Emphasis,
					Default = data.Color.Content.Default,
					OnHover = data.Color.Content.Emphasis
				},
				Common = {
					Divider = data.Color.Stroke.Emphasis,
					Overlay = data.Color.Common.Scrim,
					DropShadow = data.Color.Common.Shadow,
					NavigationBar = data.Color.Common.NavigationBar,
					Placeholder = data.Color.Common.Shimmer,
					Badge = data.Color.System.Contrast,
					BadgeContent = data.Inverse.Content.Emphasis,
					Online = data.Color.System.Success,
					Offline = data.Color.System.Neutral,
					Alert = data.Color.System.Alert,
					Success = data.Color.System.Success
				},
				Action = {
					PrimaryBrand = {
						Background = data.Color.ActionEmphasis.Background,
						Content = data.Color.ActionEmphasis.Foreground,
						Border = data.Color.ActionEmphasis.Border
					},
					Primary = {
						Background = data.Color.ActionSubEmphasis.Background,
						Content = data.Color.ActionSubEmphasis.Foreground,
						Border = data.Color.ActionSubEmphasis.Border
					},
					Secondary = {
						Background = data.Color.ActionSubtle.Background,
						Content = data.Color.ActionSubtle.Foreground,
						Border = data.Color.ActionSubtle.Border
					},
					Subtle = {
						Background = data.Color.ActionLink.Background,
						Content = data.Color.ActionLink.Foreground,
						Border = data.Color.ActionLink.Border
					},
					Alert = {
						Background = data.Color.ActionAlert.Background,
						Content = data.Color.ActionAlert.Foreground,
						Border = data.Color.ActionAlert.Border
					}
				}
			},
			Icon = {
				Size = {
					Small = data.Size.Size_400,
					Medium = data.Size.Size_900,
					Large = data.Size.Size_1200,
					XLarge = data.Size.Size_2400,
					XXLarge = p * 192
				}
			},
			Offset = {
				Focus = { Standard = data.Size.Size_150, Inset = data.Size.Size_0 }
			},
			Opacity = {
				State = {
					Lighten = { Hover = 0.88, Pressed = 0.8 },
					Darken = { Hover = 0.88, Pressed = 0.8 }
				}
			},
			Radius = {
				None = data.Radius.None,
				Small = data.Radius.Small,
				Medium = data.Radius.Medium,
				Large = data.Size.Size_300,
				XLarge = data.Radius.Large,
				Circle = data.Radius.Circle
			},
			Stroke = { Input = data.Stroke.Standard, Focus = data.Stroke.Thick },
			Typography = {
				Title = {
					Font = data.Typography.HeadingLarge.Font,
					FontSize = data.Typography.HeadingLarge.FontSize,
					LetterSpacing = data.Typography.HeadingLarge.LetterSpacing,
					LineHeight = data.LineHeight.LineHeight_130
				},
				Header = {
					Font = data.Typography.HeadingSmall.Font,
					FontSize = data.Typography.HeadingSmall.FontSize,
					LetterSpacing = data.Typography.HeadingSmall.LetterSpacing,
					LineHeight = data.Typography.HeadingSmall.LineHeight
				},
				Subheader = {
					Font = data.Typography.TitleLarge.Font,
					FontSize = data.Typography.TitleLarge.FontSize,
					LetterSpacing = data.Typography.TitleLarge.LetterSpacing,
					LineHeight = data.Typography.TitleLarge.LineHeight
				},
				Body = {
					Font = data.Typography.BodyLarge.Font,
					FontSize = data.Typography.BodyLarge.FontSize,
					LetterSpacing = data.Typography.BodyLarge.LetterSpacing,
					LineHeight = data.Typography.BodyLarge.LineHeight
				},
				CaptionHeader = {
					Font = data.Typography.CaptionLarge.Font,
					FontSize = data.FontSize.FontSize_300,
					LetterSpacing = data.Typography.BodyLarge.LetterSpacing,
					LineHeight = data.LineHeight.LineHeight_130
				},
				CaptionBody = {
					Font = data.Typography.BodySmall.Font,
					FontSize = data.Typography.BodySmall.FontSize,
					LetterSpacing = data.Typography.BodySmall.LetterSpacing,
					LineHeight = data.LineHeight.LineHeight_130
				},
				Footer = {
					Font = data.Typography.CaptionSmall.Font,
					FontSize = data.Typography.CaptionSmall.FontSize,
					LetterSpacing = data.Typography.BodyLarge.LetterSpacing,
					LineHeight = data.Typography.CaptionSmall.LineHeight
				}
			}
		}))
	end
}
