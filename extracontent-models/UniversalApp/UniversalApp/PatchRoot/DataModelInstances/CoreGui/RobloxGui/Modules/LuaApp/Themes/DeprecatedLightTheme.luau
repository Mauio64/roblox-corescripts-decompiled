local Colors = require(script.Parent.Colors)
local CorePackages = game:GetService("CorePackages")
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local t1 = {
	Color = {
		Background = Colors.Alabaster
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
		Color = Colors.Smoke,
		HoverColor = Colors.Flint,
		OnPressColor = Colors.Smoke,
		DisabledColor = Colors.Smoke,
		Text = {
			Transparency = 0.5,
			Color = Colors.Black
		},
		Border = {
			Hidden = false,
			Transparency = 0.5,
			Color = Colors.Black
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
				Color = Colors.Flint,
				OnColor = Colors.Green
			},
			Content = {
				DisabledTransparency = 0.5,
				Color = Colors.Flint,
				DisabledColor = Colors.Flint
			},
			Background = {
				OnPressTransparency = 0.9,
				OnPressColor = Colors.Black
			}
		},
		Background = {
			Color = Colors.Alabaster
		},
		Title = {
			Transparency = 0,
			DisabledTransparency = 0.5,
			Color = Colors.Flint
		},
		Divider = {
			Color = Colors.Pumice
		},
		Cancel = {
			Color = Colors.Smoke
		}
	},
	AlertWindow = {
		Background = {
			Color = Colors.Alabaster
		},
		Title = {
			Color = Colors.Flint
		},
		Message = {
			Color = Colors.Graphite
		},
		Divider = {
			Color = Colors.Pumice
		}
	},
	GameDetails = {
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
		Title = {
			Font = Enum.Font.SourceSans,
			Color = Colors.Flint
		},
		GameBasicStats = {
			Transparency = 0.5,
			Color = Colors.Black,
			Font = Enum.Font.SourceSans
		}
	},
	ChatTopBar = {
		Background = {
			Transparency = 0,
			Color = Colors.ChatTopBarWhite
		},
		Title = {
			Size = 22,
			Font = Enum.Font.SourceSans,
			Color = Colors.Flint
		},
		Subtitle = {
			Size = 14,
			Font = Enum.Font.SourceSans,
			Color = Colors.Flint
		}
	},
	BottomBar = {
		Background = {
			Transparency = 0,
			Color = Colors.White
		},
		TopBorder = {
			Transparency = 0,
			Color = Colors.Pumice
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
				Color = Colors.White
			},
			AppChrome = {
				Transparency = 0,
				Color = Colors.White
			}
		},
		Inner = {
			Transparency = 0,
			Color = Colors.Flint
		}
	},
	MorePage = {
		Background = {
			Transparency = 0,
			Color = Colors.Alabaster
		},
		List = {
			Background = {
				Transparency = 0,
				Color = Colors.White
			},
			Divider = {
				Transparency = 0,
				Color = Colors.Pumice
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
					Color = Colors.Alabaster
				}
			},
			Text = {
				Size = 19,
				Transparency = 0,
				Font = AppFonts.default:getMedium(),
				Color = Colors.Smoke
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
			Color = Colors.Smoke
		}
	},
	EventsPage = {
		Text = {
			Size = 19,
			Transparency = 0.5,
			Font = AppFonts.default:getDefault(),
			Color = Colors.Black
		}
	},
	PremiumIcon = {
		Transparency = 0,
		Color = Colors.Flint
	}
}

t1.RetryButton = t1.SecondaryButton
t1.Main = {
	Background = {
		Color = Colors.Alabaster
	},
	Foreground = {
		Color = Colors.White
	},
	TitleText = {
		Color = Colors.Flint
	},
	BodyText = {
		Font = AppFonts.default:getDefault(),
		Color = Colors.Smoke
	},
	Divider = {
		Color = Colors.Pumice
	}
}
t1.Buttons = {}
t1.Buttons.AgreementButton = {
	Text = {
		Font = AppFonts.default:getDefault(),
		Color = Colors.Smoke
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
		Color = Colors.Gray4,
		Font = AppFonts.default:getDefault()
	}
}
t1.ScrollingFrameWithScrollBar = {
	ScrollBar = {
		Transparency = 0.7,
		Color = Colors.Black
	}
}

return t1
