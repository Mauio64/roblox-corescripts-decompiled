local color = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Color
local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local ControlState = require("@game/CorePackages/Packages/_Index/Foundation/Foundation/Enums/ControlState")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts

local classic = {
	Name = "classic",
	Color = { Background = Colors.Gray4 },
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
		Color = Colors.BluePrimary,
		Transparency = 0,
		HoverColor = Colors.BlueHover,
		OnPressColor = Colors.BlueHover,
		OnPressTransparency = 0,
		DisabledColor = Colors.BlueDisabled,
		DisabledTransparency = 0,
		Text = { Color = Colors.White, Transparency = 0 },
		Border = { Hidden = true }
	},
	IconButton = {
		Fill = {
			Off = { Color = Colors.Black, Transparency = 0.9 },
			On = { Color = Colors.Black, Transparency = 1 },
			OnPress = { Color = Colors.Black, Transparency = 0.95 },
			Loading = { Color = Colors.Black, Transparency = 0.9 },
			Disabled = { Color = Colors.Black, Transparency = 0.95 }
		},
		Border = {
			Off = { Color = Colors.Black, Transparency = 0.5 },
			On = { Color = Colors.Black, Transparency = 0.5 },
			OnPress = { Color = Colors.Black, Transparency = 0.75 },
			Loading = { Color = Colors.Black, Transparency = 0.5 },
			Disabled = { Color = Colors.Black, Transparency = 0.75 }
		},
		Icon = {
			Off = { Color = Colors.Black, Transparency = 0.5 },
			On = { Color = Colors.Green, Transparency = 0 },
			OnPress = { Color = Colors.Green, Transparency = 0.5 },
			Loading = { Color = Colors.Black, Transparency = 0.5 },
			Disabled = { Color = Colors.Black, Transparency = 0.5 }
		}
	},
	EmptyStatePage = {
		ErrorMessage = { Color = Colors.Gray3 }
	},
	RetryButton = {
		Color = Colors.Gray1,
		DisabledColor = Colors.Gray3,
		DisabledTransparency = 0
	},
	ShimmerAnimation = {
		Transparency = 0,
		Image = "rbxasset://textures/ui/LuaApp/graphic/shimmer_lightTheme.png",
		AspectRatio = 0.876
	},
	ShimmerPanel = { Color = Colors.Alabaster, Transparency = 0.5 },
	ContextualMenu = {
		Cells = {
			Icon = {
				Color = Colors.Gray1,
				OnColor = Colors.Green,
				Transparency = 0.5,
				OnTransparency = 0,
				DisabledTransparency = 0.5
			},
			Content = {
				Color = Colors.Gray1,
				DisabledColor = Colors.Gray1,
				DisabledTransparency = 0.5
			},
			Background = { OnPressColor = Colors.Black, OnPressTransparency = 0.9 }
		},
		Background = { Color = Colors.White },
		Title = { Color = Colors.Black, Transparency = 0, DisabledTransparency = 0.5 },
		Divider = { Color = Colors.Gray4 },
		Cancel = { Color = Colors.Gray1 },
		DarkOverlay = { Color = Colors.Gray1, Transparency = 0.5 }
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
		Background = { Color = Colors.White },
		Title = { Color = Colors.Black, Font = appFonts.default:getBold() },
		Message = { Color = Colors.Gray1, Font = appFonts.default:getDefault() },
		Divider = { Color = Colors.Gray4 },
		Button = { Font = appFonts.default:getDefault() }
	},
	GameDetails = {
		Background = { Color = Colors.Black, Transparency = 0.3 },
		Text = {
			Font = Enum.Font.SourceSans,
			BoldFont = Enum.Font.SourceSansBold,
			Color = { Main = Colors.White, Secondary = Colors.Pumice }
		},
		GameBasicStats = {
			Color = Colors.White,
			Transparency = 0.3,
			Font = Enum.Font.SourceSans
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
			Text = { Color = Colors.Flint }
		},
		TopBar = {
			Icon = { Color = Colors.Slate }
		},
		LoadingView = {
			BackgroundImage = {
				Image = "rbxasset://textures/ui/LuaApp/graphic/GameDetailsBackground/loadingBkg_base.jpg",
				Size = Vector2.new(500, 500),
				Tint = { Color = Colors.Ash, Transparency = 0.45 }
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
		Background = { Color = Colors.White, Transparency = 0 },
		Sponsor = {
			Color = Colors.Gray3,
			TextColor = Colors.White,
			Font = Enum.Font.SourceSans
		},
		Title = { Font = Enum.Font.SourceSans, Color = Colors.Gray1 },
		GameBasicStats = {
			Color = Colors.Gray2,
			Transparency = 0,
			Font = Enum.Font.SourceSans
		}
	},
	ChatTopBar = {
		Background = { Color = Colors.ChatTopBarBluePressed, Transparency = 0 },
		Title = { Font = Enum.Font.SourceSans, Size = 23, Color = Colors.White },
		Subtitle = { Font = Enum.Font.SourceSans, Size = 15, Color = Colors.White }
	},
	BottomBar = {
		Background = { Color = Colors.White, Transparency = 0 },
		TopBorder = { Color = Colors.Gray4, Transparency = 0 }
	},
	BottomBarButton = {
		Icon = {
			Off = { Color = Colors.Flint, Transparency = 0.5 },
			On = { Color = Colors.Flint, Transparency = 0 }
		},
		Title = { Font = appFonts.default:getMedium(), Size = 14 }
	},
	NumericalBadge = {
		Text = { Font = appFonts.default:getMedium(), Color = Colors.White, Size = 12 },
		Border = {
			Default = { Color = Colors.Red, Transparency = 1 },
			AppChrome = { Color = Colors.Red, Transparency = 1 }
		},
		Inner = { Color = Colors.Red, Transparency = 0 }
	},
	MorePage = {
		Background = { Color = Colors.Gray6, Transparency = 0 },
		List = {
			Background = { Color = Colors.White, Transparency = 0 },
			Divider = { Color = Colors.Gray4, Transparency = 0 }
		},
		Button = {
			Background = {
				Default = { Color = Colors.White, Transparency = 0 },
				Pressed = { Color = Colors.Gray5, Transparency = 0 }
			},
			Text = {
				Font = Enum.Font.SourceSans,
				Size = 23,
				Color = Colors.Black,
				Transparency = 0
			},
			Icon = { Color = Colors.White, Transparency = 0 },
			RightImage = { Color = Colors.White, Transparency = 0 }
		},
		Footer = {
			Font = Enum.Font.SourceSans,
			Size = 18,
			Color = Colors.Black,
			Transparency = 0
		}
	},
	EventsPage = {
		Text = {
			Font = Enum.Font.SourceSans,
			Size = 23,
			Color = Colors.Gray3,
			Transparency = 0
		}
	},
	TencentNoticeCenter = {
		Text = {
			Font = Enum.Font.SourceSans,
			Size = 23,
			Color = Colors.Gray3,
			Transparency = 0
		}
	},
	PremiumIcon = { Color = Colors.Black, Transparency = 0 },
	Main = {
		Background = { Color = Colors.Gray4 },
		Foreground = { Color = Colors.White },
		TitleText = { Color = Colors.Gray1 },
		BodyText = { Font = Enum.Font.SourceSans, Color = Colors.Gray2 },
		Divider = { Color = Colors.Gray4 }
	},
	TopBar = {
		Bar = { Color = Colors.BluePressed },
		Background = { Color = Colors.BluePressed },
		DarkOverlay = { Color = Colors.Black, Transparency = 0.3 },
		Text = { Color = Colors.White, Transparency = 0 },
		Icon = { Color = Colors.White },
		Badge = { Color = Colors.Red },
		BadgeText = { Color = Colors.White },
		Separator = { Color = Colors.BluePressed }
	},
	SearchBar = {
		Background = { Color = Colors.White },
		Placeholder = { Color = Colors.Gray2 },
		Content = { Color = Colors.Gray2 }
	},
	DropDownList = {
		[ControlState.Default] = {
			Background = { Color = Colors.White },
			Content = { Color = Colors.Gray2 },
			Border = { Color = Colors.Black }
		}
	},
	ListPickerItem = {
		[ControlState.Default] = {
			Background = { Color = Colors.White },
			Content = { Color = Colors.Gray2, Transparency = 0 },
			Separator = { Color = Colors.Gray4 }
		},
		[ControlState.Pressed] = {
			Background = { Color = Color3.fromRGB(242, 242, 242) }
		}
	},
	Buttons = {}
}
local buttons = classic.Buttons
buttons.CtaButton = {
	TextFont = Enum.Font.SourceSans,
	[ControlState.Default] = {
		Background = { Color = color.Color3FromHex(178007), Transparency = 0 },
		Border = { Transparency = 1 },
		Content = { Color = color.Color3FromHex(16777215), Transparency = 0 }
	},
	[ControlState.Pressed] = {
		Background = { Color = color.Color3FromHex(4179577) }
	},
	[ControlState.Hover] = {
		Background = { Color = color.Color3FromHex(4179577) }
	},
	[ControlState.Disabled] = {
		Background = { Color = color.Color3FromHex(10740413) }
	}
}

classic.Buttons.GrowthButton = classic.Buttons.CtaButton

local buttons2 = classic.Buttons
buttons2.SecondaryButton = {
	TextFont = Enum.Font.SourceSans,
	[ControlState.Default] = {
		Background = { Color = color.Color3FromHex(41727) },
		Border = { Transparency = 1 },
		Content = { Color = color.Color3FromHex(16777215), Transparency = 0 }
	},
	[ControlState.Pressed] = {
		Background = { Color = color.Color3FromHex(3323391) }
	},
	[ControlState.Hover] = {
		Background = { Color = color.Color3FromHex(3323391) }
	},
	[ControlState.Disabled] = {
		Background = { Color = color.Color3FromHex(10083071) }
	}
}

local buttons3 = classic.Buttons
buttons3.ControlButton = {
	TextFont = Enum.Font.SourceSans,
	[ControlState.Default] = {
		Background = { Color = color.Color3FromHex(16777215) },
		Border = { Transparency = 1 },
		Content = { Color = color.Color3FromHex(1644825), Transparency = 0 }
	},
	[ControlState.Disabled] = {
		Content = { Color = color.Color3FromHex(12105912), Transparency = 0.5 }
	}
}

local buttons4 = classic.Buttons
buttons4.AlertButton = {
	TextFont = Enum.Font.SourceSans,
	[ControlState.Default] = {
		Background = { Color = color.Color3FromHex(14182504) },
		Border = { Transparency = 1 },
		Content = { Color = color.Color3FromHex(16777215), Transparency = 0 }
	},
	[ControlState.Hover] = {
		Background = { Color = color.Color3FromHex(14841462) }
	}
}

local buttons5 = classic.Buttons
buttons5.BuyButtons = {
	TextFont = Enum.Font.SourceSans,
	[ControlState.Default] = {
		Background = { Color = color.Color3FromHex(16777215) },
		Border = { Transparency = 1 },
		Content = { Color = color.Color3FromHex(1644825), Transparency = 0 }
	},
	[ControlState.Pressed] = {
		Background = { Color = color.Color3FromHex(4179577) },
		Content = { Color = color.Color3FromHex(16777215) }
	},
	[ControlState.Hover] = {
		Background = { Color = color.Color3FromHex(4179577) },
		Content = { Color = color.Color3FromHex(16777215) }
	},
	[ControlState.Disabled] = {
		Content = { Color = color.Color3FromHex(16777215), Transparency = 0.5 }
	}
}

local buttons6 = classic.Buttons
buttons6.ToggleButton = {
	TextFont = Enum.Font.SourceSans,
	On = {
		[ControlState.Default] = {
			Background = { Color = color.Color3FromHex(16777215) },
			Border = { Transparency = 1 },
			Content = { Color = color.Color3FromHex(1644825), Transparency = 0 }
		},
		[ControlState.Pressed] = {
			Background = { Color = color.Color3FromHex(14211288) }
		}
	},
	Off = {
		[ControlState.Default] = {
			Background = { Color = color.Color3FromHex(16777215) },
			Border = { Transparency = 1 },
			Content = { Color = color.Color3FromHex(1644825), Transparency = 0 }
		},
		[ControlState.Pressed] = {
			Background = { Color = color.Color3FromHex(14211288) }
		}
	}
}

classic.Buttons.AgreementButton = {
	Text = { Font = appFonts.default:getDefault(), Color = Colors.Pumice }
}

classic.Widget = {
	Header = {
		Text = { Font = appFonts.default:getBold(), Color = Colors.White }
	},
	Background = {
		[formFactor.UNKNOWN] = { Color = Colors.Carbon, Transparency = 0 },
		[formFactor.WIDE] = { Color = Colors.Carbon, Transparency = 0 },
		[formFactor.COMPACT] = { Color = Colors.Black, Transparency = 0.3 }
	},
	ContentText = { Color = Colors.Pumice, Font = Enum.Font.SourceSans }
}

classic.IconCards = {
	Text = { Color = Colors.Pumice, Font = Enum.Font.SourceSans }
}

classic.ScrollingFrameWithScrollBar = {
	ScrollBar = { Color = Colors.Gray3, Transparency = 0.7 }
}

return classic
