local CorePackages = game:GetService("CorePackages")
local Colors = require(script.Parent.Colors)
local ButtonState = require(script.Parent.Parent.Enum.ButtonState)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local t1 = {
	Name = "dark",
	Color = {
		Background = Colors.Slate
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
		Transparency = 1,
		OnPressTransparency = 0.5,
		DisabledTransparency = 0.5,
		Color = Colors.Pumice,
		HoverColor = Colors.White,
		OnPressColor = Colors.Pumice,
		DisabledColor = Colors.Pumice,
		Text = {
			Transparency = 0.3,
			Color = Colors.White
		},
		Border = {
			Hidden = false,
			Transparency = 0.3,
			Color = Colors.White
		}
	},
	IconButton = {
		Fill = {
			Off = {
				Transparency = 0.7,
				Color = Colors.White
			},
			On = {
				Transparency = 1,
				Color = Colors.White
			},
			OnPress = {
				Transparency = 0.85,
				Color = Colors.White
			},
			Loading = {
				Transparency = 0.7,
				Color = Colors.White
			},
			Disabled = {
				Transparency = 0.85,
				Color = Colors.White
			}
		},
		Border = {
			Off = {
				Transparency = 0.3,
				Color = Colors.White
			},
			On = {
				Transparency = 0.3,
				Color = Colors.White
			},
			OnPress = {
				Transparency = 0.85,
				Color = Colors.White
			},
			Loading = {
				Transparency = 0.3,
				Color = Colors.White
			},
			Disabled = {
				Transparency = 0.85,
				Color = Colors.White
			}
		},
		Icon = {
			Off = {
				Transparency = 0.3,
				Color = Colors.White
			},
			On = {
				Transparency = 0,
				Color = Colors.Green
			},
			OnPress = {
				Transparency = 0.7,
				Color = Colors.Green
			},
			Loading = {
				Transparency = 0.5,
				Color = Colors.White
			},
			Disabled = {
				Transparency = 0.7,
				Color = Colors.White
			}
		}
	},
	EmptyStatePage = {
		ErrorMessage = {
			Color = Colors.Graphite
		}
	},
	ShimmerAnimation = {
		Transparency = 0.65,
		Image = "rbxasset://textures/ui/LuaApp/graphic/shimmer_darkTheme.png",
		AspectRatio = 0.876
	},
	ShimmerPanel = {
		Transparency = 0.5,
		Color = Colors.Flint
	},
	ContextualMenu = {
		Cells = {
			Icon = {
				Transparency = 0.3,
				OnTransparency = 0,
				DisabledTransparency = 0.5,
				Color = Colors.White,
				OnColor = Colors.Green
			},
			Content = {
				DisabledTransparency = 0.5,
				Color = Colors.White,
				DisabledColor = Colors.White
			},
			Background = {
				OnPressTransparency = 0.7,
				OnPressColor = Colors.Black
			}
		},
		Background = {
			Color = Colors.Flint
		},
		Title = {
			Transparency = 0,
			DisabledTransparency = 0.5,
			Font = AppFonts.default:getDefault(),
			Color = Colors.White
		},
		Divider = {
			Color = Colors.Graphite
		},
		Cancel = {
			Color = Colors.Pumice
		},
		DarkOverlay = {
			Transparency = 0.7,
			Color = Colors.Black
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
			Color = Colors.Flint
		},
		Title = {
			Color = Colors.White,
			Font = AppFonts.default:getBold()
		},
		Message = {
			Color = Colors.Pumice,
			Font = AppFonts.default:getDefault()
		},
		Divider = {
			Color = Colors.Graphite
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
			Font = AppFonts.default:getDefault(),
			BoldFont = AppFonts.default:getBlack(),
			Color = {
				Main = Colors.White,
				Secondary = Colors.Pumice
			}
		},
		GameCard = {
			Background = {
				Transparency = 0,
				Color = Colors.Flint
			},
			Sponsor = {
				Color = Colors.Graphite,
				TextColor = Colors.White,
				Font = AppFonts.default:getDefault()
			},
			Title = {
				Font = AppFonts.default:getDefault(),
				Color = Colors.White
			},
			GameBasicStats = {
				Transparency = 0.3,
				Color = Colors.White,
				Font = AppFonts.default:getDefault()
			}
		},
		GameBasicStats = {
			Transparency = 0.3,
			Color = Colors.White,
			Font = AppFonts.default:getMedium()
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
				Color = Colors.White
			}
		},
		TopBar = {
			Icon = {
				Color = Colors.White
			}
		},
		LoadingView = {
			BackgroundImage = {
				Image = "rbxasset://textures/ui/LuaApp/graphic/GameDetailsBackground/loadingBkg_base.jpg",
				Size = Vector2.new(500, 500),
				Tint = {
					Transparency = 0.2,
					Color = Colors.Obsidian
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
			Color = Colors.Flint
		},
		Sponsor = {
			Color = Colors.Graphite,
			TextColor = Colors.White,
			Font = Enum.Font.SourceSans
		},
		Title = {
			Font = Enum.Font.SourceSans,
			Color = Colors.White
		},
		GameBasicStats = {
			Transparency = 0.3,
			Color = Colors.White,
			Font = Enum.Font.SourceSans
		}
	},
	ChatTopBar = {
		Background = {
			Transparency = 0,
			Color = Colors.ChatTopBarSlate
		},
		Title = {
			Size = 22,
			Font = Enum.Font.SourceSans,
			Color = Colors.White
		},
		Subtitle = {
			Size = 14,
			Font = Enum.Font.SourceSans,
			Color = Colors.White
		}
	},
	BottomBar = {
		Background = {
			Transparency = 0,
			Color = Colors.Carbon
		},
		TopBorder = {
			Transparency = 0,
			Color = Colors.Graphite
		}
	},
	BottomBarButton = {
		Icon = {
			Off = {
				Transparency = 0.5,
				Color = Colors.White
			},
			On = {
				Transparency = 0,
				Color = Colors.White
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
			Color = Colors.Slate
		},
		Border = {
			Default = {
				Transparency = 1,
				Color = Colors.Slate
			},
			AppChrome = {
				Transparency = 0,
				Color = Colors.Slate
			}
		},
		Inner = {
			Transparency = 0,
			Color = Colors.White
		}
	},
	MorePage = {
		Background = {
			Transparency = 0,
			Color = Colors.Slate
		},
		List = {
			Background = {
				Transparency = 0,
				Color = Colors.Flint
			},
			Divider = {
				Transparency = 0,
				Color = Colors.Graphite
			}
		},
		Button = {
			Background = {
				Default = {
					Transparency = 0,
					Color = Colors.Flint
				},
				Pressed = {
					Transparency = 0,
					Color = Colors.Slate
				}
			},
			Text = {
				Size = 19,
				Transparency = 0,
				Font = AppFonts.default:getMedium(),
				Color = Colors.Pumice
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
			Size = 12,
			Transparency = 0,
			Font = AppFonts.default:getMedium(),
			Color = Colors.Pumice
		}
	},
	EventsPage = {
		Text = {
			Size = 19,
			Transparency = 0.3,
			Font = AppFonts.default:getDefault(),
			Color = Colors.White
		}
	},
	PremiumIcon = {
		Transparency = 0,
		Color = Colors.White
	}
}

t1.RetryButton = t1.SecondaryButton
t1.Main = {
	Background = {
		Color = Colors.Slate
	},
	Foreground = {
		Color = Colors.Flint
	},
	TitleText = {
		Color = Colors.White
	},
	BodyText = {
		Font = AppFonts.default:getDefault(),
		Color = Colors.Pumice
	},
	Divider = {
		Color = Colors.Graphite
	}
}
t1.TopBar = {
	Bar = {
		Color = t1.Main.Background.Color
	},
	Background = {
		Color = t1.Main.Background.Color
	},
	DarkOverlay = {
		Transparency = 0.3,
		Color = Colors.Black
	},
	Text = {
		Transparency = 0,
		Color = t1.Main.TitleText.Color
	},
	Icon = {
		Color = t1.Main.BodyText.Color
	},
	Badge = {
		Color = Colors.White
	},
	BadgeText = {
		Color = Colors.Slate
	},
	Separator = {
		Color = Colors.Obsidian
	}
}
t1.SearchBar = {
	Background = {
		Color = Colors.Black
	},
	Placeholder = {
		Color = Colors.Flint
	},
	Content = {
		Color = Colors.Pumice
	}
}
t1.DropDownList = {
	[ButtonState.Default] = {
		Background = {
			Transparency = 0.3,
			Color = t1.Main.Background.Color
		},
		Content = {
			Transparency = 0.3,
			Color = t1.Main.BodyText.Color
		},
		Border = {
			Color = Colors.Smoke
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Transparency = 0.5
		},
		Content = {
			Transparency = 0.5
		}
	}
}
t1.ListPickerItem = {
	[ButtonState.Default] = {
		Background = {
			Transparency = 0.5,
			Color = Colors.Flint
		},
		Content = {
			Transparency = 0,
			Color = Colors.Pumice
		},
		Separator = {
			Color = Colors.Flint
		}
	},
	[ButtonState.Hover] = {
		Background = {
			Color = Colors.Graphite
		},
		Content = {
			Color = Colors.White
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Transparency = 0.7,
			Color = Colors.Black
		},
		Content = {
			Transparency = 0.7,
			Color = Colors.White
		}
	},
	[ButtonState.Disabled] = {
		Content = {
			Transparency = 0.7,
			Color = Colors.White
		}
	}
}
t1.Buttons = {}
t1.Buttons.CtaButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ButtonState.Default] = {
		Background = {
			Transparency = 0,
			Color = Colors.White
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Colors.Slate
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Transparency = 0.5
		},
		Content = {
			Transparency = 0.5
		}
	},
	[ButtonState.Disabled] = {
		Background = {
			Transparency = 0.5
		},
		Content = {
			Transparency = 0.5
		}
	}
}
t1.Buttons.GrowthButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ButtonState.Default] = {
		Background = {
			Transparency = 0,
			Color = Colors.Green
		},
		Border = {
			Transparency = 1
		},
		Content = {
			Transparency = 0,
			Color = Colors.White
		}
	},
	[ButtonState.Pressed] = {
		Background = {
			Transparency = 0.5
		},
		Content = {
			Transparency = 0.5
		}
	},
	[ButtonState.Disabled] = {
		Background = {
			Transparency = 0.5
		},
		Content = {
			Transparency = 0.5
		}
	}
}
t1.Buttons.SecondaryButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ButtonState.Default] = {
		Background = {
			Transparency = 1
		},
		Border = {
			Transparency = 0.3,
			Color = Colors.White
		},
		Content = {
			Transparency = 0.3,
			Color = Colors.White
		}
	},
	[ButtonState.Pressed] = {
		Border = {
			Transparency = 0.65
		},
		Content = {
			Transparency = 0.65
		}
	},
	[ButtonState.Hover] = {
		Border = {
			Transparency = 0
		},
		Content = {
			Transparency = 0
		}
	},
	[ButtonState.Disabled] = {
		Border = {
			Transparency = 0.65
		},
		Content = {
			Transparency = 0.65
		}
	}
}
t1.Buttons.ControlButton = t1.Buttons.SecondaryButton
t1.Buttons.BuyButton = t1.Buttons.SecondaryButton
t1.Buttons.AlertButton = {
	TextFont = Enum.Font.SourceSansBold,
	[ButtonState.Default] = {
		Background = {
			Transparency = 1
		},
		Border = {
			Transparency = 0.3,
			Color = Colors.Red
		},
		Content = {
			Transparency = 0.3,
			Color = Colors.Red
		}
	},
	[ButtonState.Pressed] = {
		Border = {
			Transparency = 0.65
		},
		Content = {
			Transparency = 0.65
		}
	},
	[ButtonState.Hover] = {
		Border = {
			Transparency = 0
		},
		Content = {
			Transparency = 0
		}
	},
	[ButtonState.Disabled] = {
		Border = {
			Transparency = 0.65
		},
		Content = {
			Transparency = 0.65
		}
	}
}
t1.Buttons.ToggleButton = {
	TextFont = Enum.Font.SourceSans,
	On = {
		[ButtonState.Default] = {
			Background = {
				Transparency = 1
			},
			Border = {
				Transparency = 0.3,
				Color = Colors.White
			},
			Content = {
				Transparency = 0.3,
				Color = Colors.Green
			}
		},
		[ButtonState.Pressed] = {
			Border = {
				Transparency = 0.65
			},
			Content = {
				Transparency = 0.65
			}
		},
		[ButtonState.Hover] = {
			Border = {
				Transparency = 0
			},
			Content = {
				Transparency = 0
			}
		},
		[ButtonState.Disabled] = {
			Border = {
				Transparency = 0.65
			},
			Content = {
				Transparency = 0.65
			}
		}
	},
	Off = t1.Buttons.SecondaryButton
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
		Font = AppFonts.default:getDefault()
	}
}
t1.IconCards = {
	Text = {
		Color = Colors.Pumice,
		Font = AppFonts.default:getDefault()
	}
}
t1.ScrollingFrameWithScrollBar = {
	ScrollBar = {
		Transparency = 0.7,
		Color = Colors.White
	}
}

return t1
