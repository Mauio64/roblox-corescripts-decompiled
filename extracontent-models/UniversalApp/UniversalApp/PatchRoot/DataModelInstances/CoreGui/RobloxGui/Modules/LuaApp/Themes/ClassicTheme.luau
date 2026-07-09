local CorePackages = game:GetService("CorePackages")
local Color = require(CorePackages.Workspace.Packages.AppCommonLib).Color
local Colors = require(script.Parent.Colors)
local ButtonState = require(script.Parent.Parent.Enum.ButtonState)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local t1 = {
	Name = "classic",
	Color = {
		Background = Colors.Gray4
	},
	ContextPrimaryButton = {
		Transparency = 0,
		DisabledTransparency = 0.5,
		LoadingTransparency = 0.5,
		OnPressTransparency = 0.5,
		Color = Colors.Green,
		DisabledColor = Colors.Green,
		OnPressColor = Colors.Green,
		Text = {
			Transparency = 0,
			Color = Colors.White
		},
		Border = {
			Hidden = true
		}
	},
	SecondaryButton = {
		Transparency = 0,
		OnPressTransparency = 0,
		DisabledTransparency = 0,
		Color = Colors.BluePrimary,
		HoverColor = Colors.BlueHover,
		OnPressColor = Colors.BlueHover,
		DisabledColor = Colors.BlueDisabled,
		Text = {
			Transparency = 0,
			Color = Colors.White
		},
		Border = {
			Hidden = true
		}
	},
	IconButton = {
		Fill = {
			Off = {
				Transparency = 0.9,
				Color = Colors.Black
			},
			On = {
				Transparency = 1,
				Color = Colors.Black
			},
			OnPress = {
				Transparency = 0.95,
				Color = Colors.Black
			},
			Loading = {
				Transparency = 0.9,
				Color = Colors.Black
			},
			Disabled = {
				Transparency = 0.95,
				Color = Colors.Black
			}
		},
		Border = {
			Off = {
				Transparency = 0.5,
				Color = Colors.Black
			},
			On = {
				Transparency = 0.5,
				Color = Colors.Black
			},
			OnPress = {
				Transparency = 0.75,
				Color = Colors.Black
			},
			Loading = {
				Transparency = 0.5,
				Color = Colors.Black
			},
			Disabled = {
				Transparency = 0.75,
				Color = Colors.Black
			}
		},
		Icon = {
			Off = {
				Transparency = 0.5,
				Color = Colors.Black
			},
			On = {
				Transparency = 0,
				Color = Colors.Green
			},
			OnPress = {
				Transparency = 0.5,
				Color = Colors.Green
			},
			Loading = {
				Transparency = 0.5,
				Color = Colors.Black
			},
			Disabled = {
				Transparency = 0.5,
				Color = Colors.Black
			}
		}
	},
	EmptyStatePage = {
		ErrorMessage = {
			Color = Colors.Gray3
		}
	},
	RetryButton = {
		DisabledTransparency = 0,
		Color = Colors.Gray1,
		DisabledColor = Colors.Gray3
	},
	ShimmerAnimation = {
		Transparency = 0,
		Image = "rbxasset://textures/ui/LuaApp/graphic/shimmer_lightTheme.png",
		AspectRatio = 0.876
	},
	ShimmerPanel = {
		Transparency = 0.5,
		Color = Colors.Alabaster
	},
	ContextualMenu = {
		Cells = {
			Icon = {
				Transparency = 0.5,
				OnTransparency = 0,
				DisabledTransparency = 0.5,
				Color = Colors.Gray1,
				OnColor = Colors.Green
			},
			Content = {
				DisabledTransparency = 0.5,
				Color = Colors.Gray1,
				DisabledColor = Colors.Gray1
			},
			Background = {
				OnPressTransparency = 0.9,
				OnPressColor = Colors.Black
			}
		},
		Background = {
			Color = Colors.White
		},
		Title = {
			Transparency = 0,
			DisabledTransparency = 0.5,
			Color = Colors.Black
		},
		Divider = {
			Color = Colors.Gray4
		},
		Cancel = {
			Color = Colors.Gray1
		},
		DarkOverlay = {
			Transparency = 0.5,
			Color = Colors.Gray1
		}
	},
	Authentication = {
		WeChatButton = {
			Text = {
				Size = 18,
				Font = AppFonts.default:getBold(),
				Color = Colors.White
			},
			Background = {
				Color = Colors.Green2
			}
		}
	},
	AlertWindow = {
		Background = {
			Color = Colors.White
		},
		Title = {
			Color = Colors.Black,
			Font = AppFonts.default:getBold()
		},
		Message = {
			Color = Colors.Gray1,
			Font = AppFonts.default:getDefault()
		},
		Divider = {
			Color = Colors.Gray4
		},
		Button = {
			Font = AppFonts.default:getDefault()
		}
	},
	GameDetails = {
		Background = {
			Transparency = 0.3,
			Color = Colors.Black
		},
		Text = {
			Font = Enum.Font.SourceSans,
			BoldFont = Enum.Font.SourceSansBold,
			Color = {
				Main = Colors.White,
				Secondary = Colors.Pumice
			}
		},
		GameBasicStats = {
			Transparency = 0.3,
			Color = Colors.White,
			Font = Enum.Font.SourceSans
		},
		GameInfoList = {
			DividerColor = Colors.Graphite,
			Cells = {
				Background = {
					Color = Colors.Black,
					Transparency = {
						Default = 1,
						Pressed = 0.7
					}
				}
			}
		},
		Rating = {
			Background = {
				Transparency = 0.7,
				Color = Colors.White
			}
		},
		Carousel = {
			Text = {
				Color = Colors.Flint
			}
		},
		TopBar = {
			Icon = {
				Color = Colors.Slate
			}
		},
		LoadingView = {
			BackgroundImage = {
				Image = "rbxasset://textures/ui/LuaApp/graphic/GameDetailsBackground/loadingBkg_base.jpg",
				Size = Vector2.new(500, 500),
				Tint = {
					Transparency = 0.45,
					Color = Colors.Ash
				}
			}
		},
		SocialMediaButton = {
			Transparency = 0,
			OnPressTransparency = 0.5
		}
	},
	GameMediaAccordion = {
		Item = {
			BackgroundTransparency = 0.5,
			BackgroundColor = Colors.Flint
		},
		FakeItem = {
			Loading = {
				BaseTransparency = 0.5,
				TransparencyStep = 0.25,
				Color = Colors.Flint
			},
			Loaded = {
				BaseTransparency = 0.5,
				TransparencyStep = 0.25,
				Color = Colors.White
			}
		},
		VideoIconColor = Colors.White
	},
	GameCard = {
		Background = {
			Transparency = 0,
			Color = Colors.White
		},
		Sponsor = {
			Color = Colors.Gray3,
			TextColor = Colors.White,
			Font = Enum.Font.SourceSans
		},
		Title = {
			Font = Enum.Font.SourceSans,
			Color = Colors.Gray1
		},
		GameBasicStats = {
			Transparency = 0,
			Color = Colors.Gray2,
			Font = Enum.Font.SourceSans
		}
	},
	ChatTopBar = {
		Background = {
			Transparency = 0,
			Color = Colors.ChatTopBarBluePressed
		},
		Title = {
			Size = 23,
			Font = Enum.Font.SourceSans,
			Color = Colors.White
		},
		Subtitle = {
			Size = 15,
			Font = Enum.Font.SourceSans,
			Color = Colors.White
		}
	},
	BottomBar = {
		Background = {
			Transparency = 0,
			Color = Colors.White
		},
		TopBorder = {
			Transparency = 0,
			Color = Colors.Gray4
		}
	},
	BottomBarButton = {
		Icon = {
			Off = {
				Transparency = 0.5,
				Color = Colors.Flint
			},
			On = {
				Transparency = 0,
				Color = Colors.Flint
			}
		},
		Title = {
			Size = 14,
			Font = AppFonts.default:getMedium()
		}
	},
	NumericalBadge = {
		Text = {
			Size = 12,
			Font = AppFonts.default:getMedium(),
			Color = Colors.White
		},
		Border = {
			Default = {
				Transparency = 1,
				Color = Colors.Red
			},
			AppChrome = {
				Transparency = 1,
				Color = Colors.Red
			}
		},
		Inner = {
			Transparency = 0,
			Color = Colors.Red
		}
	},
	MorePage = {
		Background = {
			Transparency = 0,
			Color = Colors.Gray6
		},
		List = {
			Background = {
				Transparency = 0,
				Color = Colors.White
			},
			Divider = {
				Transparency = 0,
				Color = Colors.Gray4
			}
		},
		Button = {
			Background = {
				Default = {
					Transparency = 0,
					Color = Colors.White
				},
				Pressed = {
					Transparency = 0,
					Color = Colors.Gray5
				}
			},
			Text = {
				Size = 23,
				Transparency = 0,
				Font = Enum.Font.SourceSans,
				Color = Colors.Black
			},
			Icon = {
				Transparency = 0,
				Color = Colors.White
			},
			RightImage = {
				Transparency = 0,
				Color = Colors.White
			}
		},
		Footer = {
			Size = 18,
			Transparency = 0,
			Font = Enum.Font.SourceSans,
			Color = Colors.Black
		}
	},
	EventsPage = {
		Text = {
			Size = 23,
			Transparency = 0,
			Font = Enum.Font.SourceSans,
			Color = Colors.Gray3
		}
	},
	TencentNoticeCenter = {
		Text = {
			Size = 23,
			Transparency = 0,
			Font = Enum.Font.SourceSans,
			Color = Colors.Gray3
		}
	},
	PremiumIcon = {
		Transparency = 0,
		Color = Colors.Black
	},
	Main = {
		Background = {
			Color = Colors.Gray4
		},
		Foreground = {
			Color = Colors.White
		},
		TitleText = {
			Color = Colors.Gray1
		},
		BodyText = {
			Font = Enum.Font.SourceSans,
			Color = Colors.Gray2
		},
		Divider = {
			Color = Colors.Gray4
		}
	},
	TopBar = {
		Bar = {
			Color = Colors.BluePressed
		},
		Background = {
			Color = Colors.BluePressed
		},
		DarkOverlay = {
			Transparency = 0.3,
			Color = Colors.Black
		},
		Text = {
			Transparency = 0,
			Color = Colors.White
		},
		Icon = {
			Color = Colors.White
		},
		Badge = {
			Color = Colors.Red
		},
		BadgeText = {
			Color = Colors.White
		},
		Separator = {
			Color = Colors.BluePressed
		}
	},
	SearchBar = {
		Background = {
			Color = Colors.White
		},
		Placeholder = {
			Color = Colors.Gray2
		},
		Content = {
			Color = Colors.Gray2
		}
	},
	DropDownList = {
		[ButtonState.Default] = {
			Background = {
				Color = Colors.White
			},
			Content = {
				Color = Colors.Gray2
			},
			Border = {
				Color = Colors.Black
			}
		}
	},
	ListPickerItem = {
		[ButtonState.Default] = {
			Background = {
				Color = Colors.White
			},
			Content = {
				Transparency = 0,
				Color = Colors.Gray2
			},
			Separator = {
				Color = Colors.Gray4
			}
		},
		[ButtonState.Pressed] = {
			Background = {
				Color = Color3.fromRGB(242, 242, 242)
			}
		}
	},
	Buttons = {}
}

t1.Buttons.CtaButton = {
	TextFont = Enum.Font.SourceSans,
	[ButtonState.Default] = {
		Background = {
			Transparency = 0,
			Color = Color.Color3FromHex(178007)
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Color.Color3FromHex(16777215)
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Color = Color.Color3FromHex(4179577)
		}
	},
	[ButtonState.Hover] = {
		Background = {
			Color = Color.Color3FromHex(4179577)
		}
	},
	[ButtonState.Disabled] = {
		Background = {
			Color = Color.Color3FromHex(10740413)
		}
	}
}
t1.Buttons.GrowthButton = t1.Buttons.CtaButton
t1.Buttons.SecondaryButton = {
	TextFont = Enum.Font.SourceSans,
	[ButtonState.Default] = {
		Background = {
			Color = Color.Color3FromHex(41727)
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Color.Color3FromHex(16777215)
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Color = Color.Color3FromHex(3323391)
		}
	},
	[ButtonState.Hover] = {
		Background = {
			Color = Color.Color3FromHex(3323391)
		}
	},
	[ButtonState.Disabled] = {
		Background = {
			Color = Color.Color3FromHex(10083071)
		}
	}
}
t1.Buttons.ControlButton = {
	TextFont = Enum.Font.SourceSans,
	[ButtonState.Default] = {
		Background = {
			Color = Color.Color3FromHex(16777215)
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Color.Color3FromHex(1644825)
		}
	},
	[ButtonState.Disabled] = {
		Content = {
			Transparency = 0.5,
			Color = Color.Color3FromHex(12105912)
		}
	}
}
t1.Buttons.AlertButton = {
	TextFont = Enum.Font.SourceSans,
	[ButtonState.Default] = {
		Background = {
			Color = Color.Color3FromHex(14182504)
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Color.Color3FromHex(16777215)
		}
	},
	[ButtonState.Hover] = {
		Background = {
			Color = Color.Color3FromHex(14841462)
		}
	}
}
t1.Buttons.BuyButtons = {
	TextFont = Enum.Font.SourceSans,
	[ButtonState.Default] = {
		Background = {
			Color = Color.Color3FromHex(16777215)
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Color.Color3FromHex(1644825)
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Color = Color.Color3FromHex(4179577)
		},
		Content = {
			Color = Color.Color3FromHex(16777215)
		}
	},
	[ButtonState.Hover] = {
		Background = {
			Color = Color.Color3FromHex(4179577)
		},
		Content = {
			Color = Color.Color3FromHex(16777215)
		}
	},
	[ButtonState.Disabled] = {
		Content = {
			Transparency = 0.5,
			Color = Color.Color3FromHex(16777215)
		}
	}
}
t1.Buttons.ToggleButton = {
	TextFont = Enum.Font.SourceSans,
	On = {
		[ButtonState.Default] = {
			Background = {
				Color = Color.Color3FromHex(16777215)
			},
			Border = {
				Transparency = 1
			},
			Content = {
				Transparency = 0,
				Color = Color.Color3FromHex(1644825)
			}
		},
		[ButtonState.Pressed] = {
			Background = {
				Color = Color.Color3FromHex(14211288)
			}
		}
	},
	Off = {
		[ButtonState.Default] = {
			Background = {
				Color = Color.Color3FromHex(16777215)
			},
			Border = {
				Transparency = 1
			},
			Content = {
				Transparency = 0,
				Color = Color.Color3FromHex(1644825)
			}
		},
		[ButtonState.Pressed] = {
			Background = {
				Color = Color.Color3FromHex(14211288)
			}
		}
	}
}
t1.Buttons.AgreementButton = {
	Text = {
		Font = AppFonts.default:getDefault(),
		Color = Colors.Pumice
	}
}
t1.Widget = {
	Header = {
		Text = {
			Font = AppFonts.default:getBold(),
			Color = Colors.White
		}
	},
	Background = {
		[FormFactor.UNKNOWN] = {
			Transparency = 0,
			Color = Colors.Carbon
		},
		[FormFactor.WIDE] = {
			Transparency = 0,
			Color = Colors.Carbon
		},
		[FormFactor.COMPACT] = {
			Transparency = 0.3,
			Color = Colors.Black
		}
	},
	ContentText = {
		Color = Colors.Pumice,
		Font = Enum.Font.SourceSans
	}
}
t1.IconCards = {
	Text = {
		Color = Colors.Pumice,
		Font = Enum.Font.SourceSans
	}
}
t1.ScrollingFrameWithScrollBar = {
	ScrollBar = {
		Transparency = 0.7,
		Color = Colors.Gray3
	}
}

return t1
