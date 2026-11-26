local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local ControlState = require("@game/CorePackages/Packages/_Index/Foundation/Foundation/Enums/ControlState")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts

local dark = {
	Name = "dark",
	Color = { Background = Colors.Slate },
	ContextPrimaryButton = {
		Color = Colors.Green,
		Transparency = 0,
		DisabledColor = Colors.Green,
		DisabledTransparency = 0.5,
		LoadingTransparency = 0.5,
		OnPressColor = Colors.Green,
		OnPressTransparency = 0.5,
		Text = { Color = Colors.White, Transparency = 0 },
		Border = { Hidden = true }
	},
	SecondaryButton = {
		Color = Colors.Pumice,
		Transparency = 1,
		HoverColor = Colors.White,
		OnPressColor = Colors.Pumice,
		OnPressTransparency = 0.5,
		DisabledColor = Colors.Pumice,
		DisabledTransparency = 0.5,
		Text = { Color = Colors.White, Transparency = 0.3 },
		Border = { Hidden = false, Color = Colors.White, Transparency = 0.3 }
	},
	IconButton = {
		Fill = {
			Off = { Color = Colors.White, Transparency = 0.7 },
			On = { Color = Colors.White, Transparency = 1 },
			OnPress = { Color = Colors.White, Transparency = 0.85 },
			Loading = { Color = Colors.White, Transparency = 0.7 },
			Disabled = { Color = Colors.White, Transparency = 0.85 }
		},
		Border = {
			Off = { Color = Colors.White, Transparency = 0.3 },
			On = { Color = Colors.White, Transparency = 0.3 },
			OnPress = { Color = Colors.White, Transparency = 0.85 },
			Loading = { Color = Colors.White, Transparency = 0.3 },
			Disabled = { Color = Colors.White, Transparency = 0.85 }
		},
		Icon = {
			Off = { Color = Colors.White, Transparency = 0.3 },
			On = { Color = Colors.Green, Transparency = 0 },
			OnPress = { Color = Colors.Green, Transparency = 0.7 },
			Loading = { Color = Colors.White, Transparency = 0.5 },
			Disabled = { Color = Colors.White, Transparency = 0.7 }
		}
	},
	EmptyStatePage = {
		ErrorMessage = { Color = Colors.Graphite }
	},
	ShimmerAnimation = {
		Transparency = 0.65,
		Image = "rbxasset://textures/ui/LuaApp/graphic/shimmer_darkTheme.png",
		AspectRatio = 0.876
	},
	ShimmerPanel = { Color = Colors.Flint, Transparency = 0.5 },
	ContextualMenu = {
		Cells = {
			Icon = {
				Color = Colors.White,
				OnColor = Colors.Green,
				Transparency = 0.3,
				OnTransparency = 0,
				DisabledTransparency = 0.5
			},
			Content = {
				Color = Colors.White,
				DisabledColor = Colors.White,
				DisabledTransparency = 0.5
			},
			Background = { OnPressColor = Colors.Black, OnPressTransparency = 0.7 }
		},
		Background = { Color = Colors.Flint },
		Title = {
			Font = appFonts.default:getDefault(),
			Color = Colors.White,
			Transparency = 0,
			DisabledTransparency = 0.5
		},
		Divider = { Color = Colors.Graphite },
		Cancel = { Color = Colors.Pumice },
		DarkOverlay = { Color = Colors.Black, Transparency = 0.7 }
	},
	Authentication = {
		WeChatButton = {
			Text = {
				Font = appFonts.default:getBold(),
				Size = 18,
				Color = Colors.White
			},
			Background = { Color = Colors.Green2 }
		}
	},
	AlertWindow = {
		Background = { Color = Colors.Flint },
		Title = { Color = Colors.White, Font = appFonts.default:getBold() },
		Message = { Color = Colors.Pumice, Font = appFonts.default:getDefault() },
		Divider = { Color = Colors.Graphite },
		Button = { Font = appFonts.default:getDefault() }
	},
	GameDetails = {
		Background = { Color = Colors.Black, Transparency = 0.3 },
		Text = {
			Font = appFonts.default:getDefault(),
			BoldFont = appFonts.default:getBlack(),
			Color = { Main = Colors.White, Secondary = Colors.Pumice }
		},
		GameCard = {
			Background = { Color = Colors.Flint, Transparency = 0 },
			Sponsor = {
				Color = Colors.Graphite,
				TextColor = Colors.White,
				Font = appFonts.default:getDefault()
			},
			Title = { Font = appFonts.default:getDefault(), Color = Colors.White },
			GameBasicStats = {
				Color = Colors.White,
				Transparency = 0.3,
				Font = appFonts.default:getDefault()
			}
		},
		GameBasicStats = {
			Color = Colors.White,
			Transparency = 0.3,
			Font = appFonts.default:getMedium()
		},
		GameInfoList = {
			DividerColor = Colors.Graphite,
			Cells = {
				Background = {
					Color = Colors.Black,
					Transparency = { Default = 1, Pressed = 0.7 }
				}
			}
		},
		Rating = {
			Background = { Color = Colors.White, Transparency = 0.7 }
		},
		Carousel = {
			Text = { Color = Colors.White }
		},
		TopBar = {
			Icon = { Color = Colors.White }
		},
		LoadingView = {
			BackgroundImage = {
				Image = "rbxasset://textures/ui/LuaApp/graphic/GameDetailsBackground/loadingBkg_base.jpg",
				Size = Vector2.new(500, 500),
				Tint = { Color = Colors.Obsidian, Transparency = 0.2 }
			}
		},
		SocialMediaButton = { Transparency = 0, OnPressTransparency = 0.5 }
	},
	GameMediaAccordion = {
		Item = { BackgroundColor = Colors.Flint, BackgroundTransparency = 0.5 },
		FakeItem = {
			Loading = {
				Color = Colors.Flint,
				BaseTransparency = 0.5,
				TransparencyStep = 0.25
			},
			Loaded = {
				Color = Colors.White,
				BaseTransparency = 0.5,
				TransparencyStep = 0.25
			}
		},
		VideoIconColor = Colors.White
	},
	GameCard = {
		Background = { Color = Colors.Flint, Transparency = 0 },
		Sponsor = {
			Color = Colors.Graphite,
			TextColor = Colors.White,
			Font = Enum.Font.SourceSans
		},
		Title = { Font = Enum.Font.SourceSans, Color = Colors.White },
		GameBasicStats = {
			Color = Colors.White,
			Transparency = 0.3,
			Font = Enum.Font.SourceSans
		}
	},
	ChatTopBar = {
		Background = { Color = Colors.ChatTopBarSlate, Transparency = 0 },
		Title = { Font = Enum.Font.SourceSans, Size = 22, Color = Colors.White },
		Subtitle = { Font = Enum.Font.SourceSans, Size = 14, Color = Colors.White }
	},
	BottomBar = {
		Background = { Color = Colors.Carbon, Transparency = 0 },
		TopBorder = { Color = Colors.Graphite, Transparency = 0 }
	},
	BottomBarButton = {
		Icon = {
			Off = { Color = Colors.White, Transparency = 0.5 },
			On = { Color = Colors.White, Transparency = 0 }
		},
		Title = { Font = appFonts.default:getMedium(), Size = 14 }
	},
	NumericalBadge = {
		Text = { Font = appFonts.default:getMedium(), Color = Colors.Slate, Size = 12 },
		Border = {
			Default = { Color = Colors.Slate, Transparency = 1 },
			AppChrome = { Color = Colors.Slate, Transparency = 0 }
		},
		Inner = { Color = Colors.White, Transparency = 0 }
	},
	MorePage = {
		Background = { Color = Colors.Slate, Transparency = 0 },
		List = {
			Background = { Color = Colors.Flint, Transparency = 0 },
			Divider = { Color = Colors.Graphite, Transparency = 0 }
		},
		Button = {
			Background = {
				Default = { Color = Colors.Flint, Transparency = 0 },
				Pressed = { Color = Colors.Slate, Transparency = 0 }
			},
			Text = {
				Font = appFonts.default:getMedium(),
				Size = 19,
				Color = Colors.Pumice,
				Transparency = 0
			},
			Icon = { Color = Colors.White, Transparency = 0 },
			RightImage = { Color = Colors.White, Transparency = 0 }
		},
		Footer = {
			Font = appFonts.default:getMedium(),
			Size = 12,
			Color = Colors.Pumice,
			Transparency = 0
		}
	},
	EventsPage = {
		Text = {
			Font = appFonts.default:getDefault(),
			Size = 19,
			Color = Colors.White,
			Transparency = 0.3
		}
	},
	PremiumIcon = { Color = Colors.White, Transparency = 0 }
}

dark.RetryButton = dark.SecondaryButton

dark.Main = {
	Background = { Color = Colors.Slate },
	Foreground = { Color = Colors.Flint },
	TitleText = { Color = Colors.White },
	BodyText = { Font = appFonts.default:getDefault(), Color = Colors.Pumice },
	Divider = { Color = Colors.Graphite }
}

dark.TopBar = {
	Bar = { Color = dark.Main.Background.Color },
	Background = { Color = dark.Main.Background.Color },
	DarkOverlay = { Color = Colors.Black, Transparency = 0.3 },
	Text = { Color = dark.Main.TitleText.Color, Transparency = 0 },
	Icon = { Color = dark.Main.BodyText.Color },
	Badge = { Color = Colors.White },
	BadgeText = { Color = Colors.Slate },
	Separator = { Color = Colors.Obsidian }
}

dark.SearchBar = {
	Background = { Color = Colors.Black },
	Placeholder = { Color = Colors.Flint },
	Content = { Color = Colors.Pumice }
}

dark.DropDownList = {
	[ControlState.Default] = {
		Background = { Color = dark.Main.Background.Color, Transparency = 0.3 },
		Content = { Color = dark.Main.BodyText.Color, Transparency = 0.3 },
		Border = { Color = Colors.Smoke }
	},
	[ControlState.Pressed] = {
		Background = { Transparency = 0.5 },
		Content = { Transparency = 0.5 }
	}
}

dark.ListPickerItem = {
	[ControlState.Default] = {
		Background = { Color = Colors.Flint, Transparency = 0.5 },
		Content = { Color = Colors.Pumice, Transparency = 0 },
		Separator = { Color = Colors.Flint }
	},
	[ControlState.Hover] = {
		Background = { Color = Colors.Graphite },
		Content = { Color = Colors.White }
	},
	[ControlState.Pressed] = {
		Background = { Color = Colors.Black, Transparency = 0.7 },
		Content = { Color = Colors.White, Transparency = 0.7 }
	},
	[ControlState.Disabled] = {
		Content = { Color = Colors.White, Transparency = 0.7 }
	}
}

dark.Buttons = {}
local buttons = dark.Buttons
buttons.CtaButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ControlState.Default] = {
		Background = { Color = Colors.White, Transparency = 0 },
		Border = { Transparency = 1 },
		Content = { Color = Colors.Slate, Transparency = 0 }
	},
	[ControlState.Pressed] = {
		Background = { Transparency = 0.5 },
		Content = { Transparency = 0.5 }
	},
	[ControlState.Disabled] = {
		Background = { Transparency = 0.5 },
		Content = { Transparency = 0.5 }
	}
}

local buttons2 = dark.Buttons
buttons2.GrowthButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ControlState.Default] = {
		Background = { Color = Colors.Green, Transparency = 0 },
		Border = { Transparency = 1 },
		Content = { Color = Colors.White, Transparency = 0 }
	},
	[ControlState.Pressed] = {
		Background = { Transparency = 0.5 },
		Content = { Transparency = 0.5 }
	},
	[ControlState.Disabled] = {
		Background = { Transparency = 0.5 },
		Content = { Transparency = 0.5 }
	}
}

local buttons3 = dark.Buttons
buttons3.SecondaryButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ControlState.Default] = {
		Background = { Transparency = 1 },
		Border = { Color = Colors.White, Transparency = 0.3 },
		Content = { Color = Colors.White, Transparency = 0.3 }
	},
	[ControlState.Pressed] = {
		Border = { Transparency = 0.65 },
		Content = { Transparency = 0.65 }
	},
	[ControlState.Hover] = {
		Border = { Transparency = 0 },
		Content = { Transparency = 0 }
	},
	[ControlState.Disabled] = {
		Border = { Transparency = 0.65 },
		Content = { Transparency = 0.65 }
	}
}

dark.Buttons.ControlButton = dark.Buttons.SecondaryButton
dark.Buttons.BuyButton = dark.Buttons.SecondaryButton

local buttons4 = dark.Buttons
buttons4.AlertButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ControlState.Default] = {
		Background = { Transparency = 1 },
		Border = { Color = Colors.Red, Transparency = 0.3 },
		Content = { Color = Colors.Red, Transparency = 0.3 }
	},
	[ControlState.Pressed] = {
		Border = { Transparency = 0.65 },
		Content = { Transparency = 0.65 }
	},
	[ControlState.Hover] = {
		Border = { Transparency = 0 },
		Content = { Transparency = 0 }
	},
	[ControlState.Disabled] = {
		Border = { Transparency = 0.65 },
		Content = { Transparency = 0.65 }
	}
}

local buttons5 = dark.Buttons
buttons5.ToggleButton = {
	TextFont = Enum.Font.SourceSans,
	On = {
		[ControlState.Default] = {
			Background = { Transparency = 1 },
			Border = { Color = Colors.White, Transparency = 0.3 },
			Content = { Color = Colors.Green, Transparency = 0.3 }
		},
		[ControlState.Pressed] = {
			Border = { Transparency = 0.65 },
			Content = { Transparency = 0.65 }
		},
		[ControlState.Hover] = {
			Border = { Transparency = 0 },
			Content = { Transparency = 0 }
		},
		[ControlState.Disabled] = {
			Border = { Transparency = 0.65 },
			Content = { Transparency = 0.65 }
		}
	},
	Off = dark.Buttons.SecondaryButton
}

dark.Buttons.AgreementButton = {
	Text = { Font = appFonts.default:getDefault(), Color = Colors.Pumice }
}

dark.Widget = {
	Header = {
		Text = { Font = appFonts.default:getBold(), Color = Colors.White }
	},
	Background = {
		[formFactor.UNKNOWN] = { Color = Colors.Carbon, Transparency = 0 },
		[formFactor.WIDE] = { Color = Colors.Carbon, Transparency = 0 },
		[formFactor.COMPACT] = { Color = Colors.Black, Transparency = 0.3 }
	},
	ContentText = { Color = Colors.Pumice, Font = appFonts.default:getDefault() }
}

dark.IconCards = {
	Text = { Color = Colors.Pumice, Font = appFonts.default:getDefault() }
}

dark.ScrollingFrameWithScrollBar = {
	ScrollBar = { Color = Colors.White, Transparency = 0.7 }
}

return dark
