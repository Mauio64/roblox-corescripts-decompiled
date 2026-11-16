local v = { Color3 = Color3.new(), Transparency = 0 }

local v2 = { Font = Enum.Font.Unknown, FontSize = 0, LineHeight = 0, LetterSpacing = 0 }

return {
	Global = {
		Size_0 = 0,
		Size_25 = 0,
		Size_50 = 0,
		Size_75 = 0,
		Size_100 = 0,
		Size_125 = 0,
		Size_150 = 0,
		Size_175 = 0,
		Size_200 = 0,
		Size_250 = 0,
		Size_300 = 0,
		Size_350 = 0,
		Size_400 = 0,
		Size_450 = 0,
		Size_500 = 0,
		Size_600 = 0,
		Size_700 = 0,
		Size_800 = 0,
		Size_900 = 0,
		Size_1000 = 0,
		Size_1100 = 0,
		Size_1200 = 0,
		Size_1300 = 0,
		Size_1400 = 0,
		Space_0 = 0,
		Space_25 = 0,
		Space_50 = 0,
		Space_75 = 0,
		Space_100 = 0,
		Space_125 = 0,
		Space_150 = 0,
		Space_175 = 0,
		Space_200 = 0,
		Space_250 = 0,
		Space_300 = 0,
		Space_400 = 0,
		Space_500 = 0,
		Space_600 = 0,
		Space_800 = 0,
		Space_1000 = 0,
		FontSize_25 = 0,
		FontSize_50 = 0,
		FontSize_75 = 0,
		FontSize_100 = 0,
		FontSize_200 = 0,
		FontSize_300 = 0,
		FontSize_400 = 0,
		FontSize_500 = 0,
		FontSize_600 = 0,
		FontSize_700 = 0,
		FontSize_800 = 0,
		FontSize_900 = 0,
		FontSize_1000 = 0,
		Family = { Standard = "" },
		Weight_300 = "",
		Weight_400 = "",
		Weight_600 = "",
		Weight_700 = "",
		Weight_900 = "",
		LetterSpacing = { Default = 0, Tight = 0, Loose = 0 },
		LineHeight_100 = 0,
		LineHeight_200 = 0,
		LineHeight_300 = 0,
		LineHeight_400 = 0,
		Stroke_50 = 0,
		Stroke_100 = 0,
		Stroke_150 = 0,
		Stroke_200 = 0,
		Stroke_250 = 0,
		Stroke_300 = 0,
		Stroke_400 = 0,
		Opacity_0 = 0,
		Opacity_8 = 0,
		Opacity_12 = 0,
		Opacity_16 = 0,
		Opacity_32 = 0,
		Opacity_68 = 0,
		Opacity_84 = 0,
		Opacity_88 = 0,
		Opacity_92 = 0,
		Opacity_100 = 0,
		Color = {
			Black = v,
			White = v,
			Green = v,
			Red = v,
			Blue = v,
			Carbon = v,
			Flint = v,
			Graphite = v,
			Obsidian = v,
			Pumice = v,
			Slate = v,
			Alabaster = v,
			Ash = v,
			Chalk = v,
			Smoke = v,
			None = v
		}
	},
	Semantic = {
		Typography = {
			Title = v2,
			Header = v2,
			Subheader = v2,
			Body = v2,
			CaptionHeader = v2,
			CaptionBody = v2,
			Footer = v2
		},
		Color = {
			Background = {
				Default = v,
				Contrast = v,
				Muted = v,
				OnHover = v,
				OnPress = v
			},
			BackgroundUi = { Default = v, Contrast = v },
			Ui = { Default = v, Muted = v, Emphasis = v },
			Text = {
				Default = v,
				Muted = v,
				Emphasis = v,
				Link = v,
				Inverse = v
			},
			Icon = { Default = v, Emphasis = v, OnHover = v },
			Action = {
				Primary = { Background = v, Border = v, Content = v },
				PrimaryBrand = { Background = v, Border = v, Content = v },
				Secondary = { Background = v, Border = v, Content = v },
				Alert = { Background = v, Border = v, Content = v },
				Subtle = { Background = v, Border = v, Content = v }
			},
			State = {
				Standard = { Default = v, Hover = v, Pressed = v },
				Lighten = { Default = v, Hover = v, Pressed = v },
				Inverse = { Default = v, Hover = v, Pressed = v },
				Darken = { Default = v, Hover = v, Pressed = v }
			},
			Focus = { Start = v, End = v, Gradient = v },
			Common = {
				Divider = v,
				Overlay = v,
				DropShadow = v,
				NavigationBar = v,
				Badge = v,
				BadgeContent = v,
				Placeholder = v,
				Online = v,
				Offline = v,
				Alert = v,
				Success = v
			}
		},
		Radius = {
			None = 0,
			Small = 0,
			Medium = 0,
			Large = 0,
			XLarge = 0,
			Circle = 0
		},
		Icon = {
			Size = {
				Small = 0,
				Medium = 0,
				Large = 0,
				XLarge = 0,
				XxLarge = 0
			}
		},
		Stroke = { Input = 0, Focus = 0 },
		Offset = {
			Focus = { Standard = 0, Inset = 0 }
		},
		Opacity = {
			State = {
				Lighten = { Hover = 0, Pressed = 0 },
				Darken = { Hover = 0, Pressed = 0 }
			}
		}
	},
	Component = {
		VerticalTile = {
			Base = {
				Container = {
					Background = v,
					BorderWidth = 0,
					BorderColor = v,
					DropShadow = { X = 0, Y = 0, Blur = 0, Color = v },
					BorderRadius = {
						LeadingTop = 0,
						TrailingTop = 0,
						TrailingBottom = 0,
						LeadingBottom = 0
					}
				},
				ContentTop = {
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				},
				ContentBottom = {
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				}
			}
		},
		PlayerTileSmall = {
			Base = {
				Container = {
					Gap = 0,
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				},
				Image = {
					Size = 0,
					BackgroundColor = v,
					BorderColor = v,
					BorderRadius = 0,
					BorderWidth = 0
				},
				Status = { Size = 0, BackgroundColor = v, BorderColor = v, BorderWidth = 0 },
				Content = { Gap = 0, Typography = v2, ContentColor = v },
				Icon = { Size = 0 },
				Presence = { ContentColor = v }
			}
		},
		Facepile = {
			Container = { Gap = 0 },
			FaceGroup = { Gap = 0 },
			Face = {
				BackgroundColor = v,
				BorderWidth = 0,
				BorderColor = v,
				BorderRadius = 0,
				Width = 0,
				Height = 0
			},
			Badge = {
				BackgroundColor = v,
				BorderWidth = 0,
				BorderColor = v,
				BorderRadius = 0,
				Spacing = 0,
				Height = 0,
				MinWidth = 0,
				ContentColor = v,
				Typography = v2
			},
			Label = { ContentColor = v, Typography = v2 }
		},
		ControllerBar = {
			BackgroundColor = v,
			BorderRadius = {
				LeadingTop = 0,
				TrailingTop = 0,
				TrailingBottom = 0,
				LeadingBottom = 0
			},
			Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 },
			Gap = 0
		},
		ControllerBarShortcut = {
			Container = { Gap = 0, ContentColor = v },
			Icon = { Size = 0 },
			Label = { Typography = v2 }
		},
		SelectionCursor = {
			BorderWidth = 0,
			Offset = 0,
			Inset = 0,
			Gradient = { Start = v, End = v }
		},
		StateLayer = {
			Base = { BorderWidth = 0 },
			Standard = {
				Initialize = { Color = v },
				Default = { Color = v },
				Hover = { Color = v },
				Pressed = { Color = v },
				Selected = { Color = v },
				SelectedPressed = { Color = v },
				Disabled = { Color = v }
			},
			Lighten = {
				Initialize = { Color = v },
				Default = { Color = v },
				Hover = { Color = v },
				Pressed = { Color = v },
				Selected = { Color = v },
				SelectedPressed = { Color = v },
				Disabled = { Color = v }
			},
			Inverse = {
				Initialize = { Color = v },
				Default = { Color = v },
				Hover = { Color = v },
				Pressed = { Color = v },
				Selected = { Color = v },
				SelectedPressed = { Color = v },
				Disabled = { Color = v }
			},
			Darken = {
				Initialize = { Color = v },
				Default = { Color = v },
				Hover = { Color = v },
				Pressed = { Color = v },
				Selected = { Color = v },
				SelectedPressed = { Color = v },
				Disabled = { Color = v }
			}
		},
		MenuCell = {
			Base = {
				Container = {
					Height = 0,
					ContentColor = v,
					BackgroundColor = v,
					BorderColor = v,
					BorderRadius = {
						TopLeading = 0,
						TopTrailing = 0,
						BottomTrailing = 0,
						BottomLeading = 0
					},
					BorderWidth = 0,
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				},
				IconFrame = { Size = 0 },
				TextFrame = {
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				},
				Text = { Typography = v2 },
				CheckFrame = { Size = 0 }
			},
			Divider = {
				Container = { BorderWidth = 0 }
			},
			Disabled = {
				Container = { ContentColor = v }
			},
			HasRoundBottom = {
				Container = {
					BorderRadius = { BottomTrailing = 0, BottomLeading = 0 }
				}
			},
			HasRoundTop = {
				Container = {
					BorderRadius = { TopLeading = 0, TopTrailing = 0 }
				}
			}
		},
		BaseMenu = { BorderRadius = 0, BackgroundColor = v },
		StatGroup = { Gap = 0 },
		StatItem = {
			Container = { Gap = 0, ContentColor = v },
			Icon = { Size = 0 },
			Label = { Typography = v2 }
		},
		MediaTile = {
			Container = { BorderRadius = 0 },
			Icon = { Size = 0 }
		},
		StatWidget = {
			Container = { Gap = 0, ContentColor = v },
			Icon = { Size = 0 },
			DataGroup = { Gap = 0 },
			Data = { Typography = v2 },
			Label = { Typography = v2 }
		},
		RateCount = {
			Container = { Spacing = 0, Gap = 0, BorderRadius = 0, BackgroundColor = v },
			ButtonGroup = { Gap = 0 }
		},
		PlayerCount = {
			Container = { Spacing = 0, BorderRadius = 0, BackgroundColor = v }
		},
		VerticalScrollView = {
			Base = {
				Handle = { BackgroundColor = v, ContentColor = v, BorderRadius = 0 },
				Icon = { Size = 0 },
				Track = {
					Opacity = 0,
					Spacing = { Top = 0, Bottom = 0 }
				}
			},
			Compact = {
				Handle = { Width = 0 },
				Track = { Width = 0 }
			},
			Wide = {
				Handle = { Width = 0 },
				Track = { Width = 0 }
			},
			Gamepad = {
				Handle = { Width = 0 },
				Track = { Width = 0 }
			}
		},
		TextField = {
			Base = {
				Field = {
					BorderColor = v,
					BorderRadius = 0,
					Typography = v2,
					Spacing = { Leading = 0, Trailing = 0 },
					Gap = 0,
					Opacity = 0
				},
				PlaceholderText = { ContentColor = v },
				FieldValue = { ContentColor = v },
				IconLeading = { ContentColor = v, Size = 0 }
			},
			Error = {
				Field = { BorderColor = v }
			},
			Disabled = {
				Field = { Opacity = 0 }
			}
		},
		InputLabel = {
			Base = {
				Typography = v2,
				ContentColor = v,
				Spacing = { Bottom = 0 },
				Opacity = 0
			},
			Disabled = { Opacity = 0 }
		},
		HelperText = {
			Base = {
				Typography = v2,
				ContentColor = v,
				Padding = { Top = 0 },
				Opacity = 0
			},
			Error = { ContentColor = v }
		}
	}
}
