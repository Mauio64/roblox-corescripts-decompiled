return function(p)
	return {
		VerticalTile = {
			Base = {
				Container = {
					Background = {
						Color3 = Color3.new(0.22353, 0.23137, 0.23922),
						Transparency = 0
					},
					BorderWidth = 1 * p,
					BorderColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 },
					DropShadow = {
						X = 0,
						Y = 4 * p,
						Blur = 8 * p,
						Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.5 }
					},
					BorderRadius = {
						LeadingTop = 8 * p,
						TrailingTop = 8 * p,
						TrailingBottom = 8 * p,
						LeadingBottom = 8 * p
					}
				},
				ContentTop = {
					Spacing = { Top = 0, Trailing = 0, Bottom = 0, Leading = 0 }
				},
				ContentBottom = {
					Spacing = {
						Top = 8 * p,
						Trailing = 8 * p,
						Bottom = 8 * p,
						Leading = 8 * p
					}
				}
			}
		},
		PlayerTileSmall = {
			Base = {
				Container = {
					Gap = 8 * p,
					Spacing = {
						Top = 8 * p,
						Trailing = 8 * p,
						Bottom = 8 * p,
						Leading = 8 * p
					}
				},
				Image = {
					Size = 96 * p,
					BackgroundColor = {
						Color3 = Color3.new(0.22353, 0.23137, 0.23922),
						Transparency = 0
					},
					BorderColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 },
					BorderRadius = 9999,
					BorderWidth = 3 * p
				},
				Status = {
					Size = 16 * p,
					BackgroundColor = {
						Color3 = Color3.new(0, 0.70588, 0.42745),
						Transparency = 0
					},
					BorderColor = {
						Color3 = Color3.new(0.13725, 0.1451, 0.15294),
						Transparency = 0
					},
					BorderWidth = 2.5 * p
				},
				Content = {
					Gap = 2 * p,
					Typography = {
						Font = Enum.Font.GothamMedium,
						FontSize = 12 * p,
						LineHeight = 1.15,
						LetterSpacing = 0
					},
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }
				},
				Icon = {
					Size = 16 * p
				},
				Presence = {
					ContentColor = {
						Color3 = Color3.new(0.74118, 0.7451, 0.7451),
						Transparency = 0
					}
				}
			}
		},
		Facepile = {
			Container = {
				Gap = 4 * p
			},
			FaceGroup = {
				Gap = -6 * p
			},
			Face = {
				BackgroundColor = {
					Color3 = Color3.new(0.74118, 0.7451, 0.7451),
					Transparency = 0
				},
				BorderWidth = 2 * p,
				BorderColor = {
					Color3 = Color3.new(0.22353, 0.23137, 0.23922),
					Transparency = 0
				},
				BorderRadius = 9999,
				Width = 16 * p,
				Height = 16 * p
			},
			Badge = {
				BackgroundColor = {
					Color3 = Color3.new(0, 0.70588, 0.42745),
					Transparency = 0
				},
				BorderWidth = 2 * p,
				BorderColor = {
					Color3 = Color3.new(0.22353, 0.23137, 0.23922),
					Transparency = 0
				},
				BorderRadius = 9999,
				Spacing = 4 * p,
				Height = 16 * p,
				MinWidth = 16 * p,
				ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 },
				Typography = {
					Font = Enum.Font.GothamMedium,
					FontSize = 10 * p,
					LineHeight = 1.2,
					LetterSpacing = 0
				}
			},
			Label = {
				ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.3 },
				Typography = {
					Font = Enum.Font.Gotham,
					FontSize = 12 * p,
					LineHeight = 1.15,
					LetterSpacing = 0
				}
			}
		},
		ControllerBar = {
			BackgroundColor = {
				Color3 = Color3.new(0.06667, 0.07059, 0.07843),
				Transparency = 0.2
			},
			BorderRadius = {
				LeadingTop = 9999,
				TrailingTop = 9999,
				TrailingBottom = 9999,
				LeadingBottom = 9999
			},
			Spacing = {
				Top = 8 * p,
				Trailing = 12 * p,
				Bottom = 8 * p,
				Leading = 12 * p
			},
			Gap = 16 * p
		},
		ControllerBarShortcut = {
			Container = {
				Gap = 4 * p,
				ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }
			},
			Icon = {
				Size = 36 * p
			},
			Label = {
				Typography = {
					Font = Enum.Font.GothamMedium,
					FontSize = 12 * p,
					LineHeight = 1.15,
					LetterSpacing = 0
				}
			}
		},
		SelectionCursor = {
			BorderWidth = 2 * p,
			Offset = 6 * p,
			Inset = 0,
			Gradient = {
				Start = { Color3 = Color3.new(1, 1, 1), Transparency = 0 },
				End = {
					Color3 = Color3.new(0.39608, 0.4, 0.40784),
					Transparency = 0
				}
			}
		},
		StateLayer = {
			Base = {
				BorderWidth = 1 * p
			},
			Standard = {
				Initialize = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Default = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Hover = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.88 }
				},
				Pressed = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 }
				},
				Selected = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				SelectedPressed = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 }
				},
				Disabled = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				}
			},
			Lighten = {
				Initialize = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Default = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Hover = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.88 }
				},
				Pressed = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 }
				},
				Selected = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				SelectedPressed = {
					Color = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 }
				},
				Disabled = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				}
			},
			Inverse = {
				Initialize = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Default = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Hover = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.88 }
				},
				Pressed = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.8 }
				},
				Selected = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				SelectedPressed = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.8 }
				},
				Disabled = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				}
			},
			Darken = {
				Initialize = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Default = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				Hover = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.88 }
				},
				Pressed = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.8 }
				},
				Selected = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				},
				SelectedPressed = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 0.8 }
				},
				Disabled = {
					Color = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
				}
			}
		},
		MenuCell = {
			Base = {
				Container = {
					Height = 56 * p,
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 },
					BackgroundColor = {
						Color3 = Color3.new(0.22353, 0.23137, 0.23922),
						Transparency = 0
					},
					BorderColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 },
					BorderRadius = {
						TopLeading = 0,
						TopTrailing = 0,
						BottomTrailing = 0,
						BottomLeading = 0
					},
					BorderWidth = 0,
					Spacing = {
						Top = 0,
						Trailing = 12 * p,
						Bottom = 0,
						Leading = 12 * p
					}
				},
				IconFrame = {
					Size = 32 * p
				},
				TextFrame = {
					Spacing = {
						Top = 0,
						Trailing = 12 * p,
						Bottom = 0,
						Leading = 12 * p
					}
				},
				Text = {
					Typography = {
						Font = Enum.Font.GothamMedium,
						FontSize = 16 * p,
						LineHeight = 1.25,
						LetterSpacing = 0
					}
				},
				CheckFrame = {
					Size = 32 * p
				}
			},
			Divider = {
				Container = {
					BorderWidth = 1 * p
				}
			},
			Disabled = {
				Container = {
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.5 }
				}
			},
			HasRoundBottom = {
				Container = {
					BorderRadius = {
						BottomTrailing = 8 * p,
						BottomLeading = 8 * p
					}
				}
			},
			HasRoundTop = {
				Container = {
					BorderRadius = {
						TopLeading = 8 * p,
						TopTrailing = 8 * p
					}
				}
			}
		},
		BaseMenu = {
			BorderRadius = 8 * p,
			BackgroundColor = {
				Color3 = Color3.new(0.22353, 0.23137, 0.23922),
				Transparency = 0
			}
		},
		StatGroup = {
			Gap = 8 * p
		},
		StatItem = {
			Container = {
				Gap = 2 * p,
				ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.3 }
			},
			Icon = {
				Size = 16 * p
			},
			Label = {
				Typography = {
					Font = Enum.Font.Gotham,
					FontSize = 12 * p,
					LineHeight = 1.15,
					LetterSpacing = 0
				}
			}
		},
		MediaTile = {
			Container = {
				BorderRadius = 8 * p
			},
			Icon = {
				Size = 36 * p
			}
		},
		StatWidget = {
			Container = {
				Gap = 8 * p,
				ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }
			},
			Icon = {
				Size = 48 * p
			},
			DataGroup = { Gap = 0 },
			Data = {
				Typography = {
					Font = Enum.Font.GothamBlack,
					FontSize = 34 * p,
					LineHeight = 1.2,
					LetterSpacing = 0
				}
			},
			Label = {
				Typography = {
					Font = Enum.Font.GothamMedium,
					FontSize = 16 * p,
					LineHeight = 1.25,
					LetterSpacing = 0
				}
			}
		},
		RateCount = {
			Container = {
				Spacing = 8 * p,
				Gap = 8 * p,
				BorderRadius = 8 * p,
				BackgroundColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.7 }
			},
			ButtonGroup = {
				Gap = 8 * p
			}
		},
		PlayerCount = {
			Container = {
				Spacing = 8 * p,
				BorderRadius = 0,
				BackgroundColor = { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
			}
		},
		VerticalScrollView = {
			Base = {
				Handle = {
					BackgroundColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.7 },
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 },
					BorderRadius = 9999
				},
				Icon = {
					Size = 36 * p
				},
				Track = {
					Opacity = 0,
					Spacing = {
						Top = 4 * p,
						Bottom = 4 * p
					}
				}
			},
			Compact = {
				Handle = {
					Width = 2 * p
				},
				Track = {
					Width = 12 * p
				}
			},
			Wide = {
				Handle = {
					Width = 8 * p
				},
				Track = {
					Width = 16 * p
				}
			},
			Gamepad = {
				Handle = {
					Width = 16 * p
				},
				Track = {
					Width = 16 * p
				}
			}
		},
		TextField = {
			Base = {
				Field = {
					BorderColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.8 },
					BorderRadius = 8 * p,
					Typography = {
						Font = Enum.Font.Gotham,
						FontSize = 16 * p,
						LineHeight = 1.25,
						LetterSpacing = 0
					},
					Spacing = {
						Leading = 12 * p,
						Trailing = 12 * p
					},
					Gap = 8 * p,
					Opacity = 1
				},
				PlaceholderText = {
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.3 }
				},
				FieldValue = {
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }
				},
				IconLeading = {
					ContentColor = { Color3 = Color3.new(1, 1, 1), Transparency = 0.3 },
					Size = 16 * p
				}
			},
			Error = {
				Field = {
					BorderColor = {
						Color3 = Color3.new(0.96863, 0.29412, 0.32157),
						Transparency = 0
					}
				}
			},
			Disabled = {
				Field = { Opacity = 0.32 }
			}
		},
		InputLabel = {
			Base = {
				Typography = {
					Font = Enum.Font.Gotham,
					FontSize = 12 * p,
					LineHeight = 1.15,
					LetterSpacing = 0
				},
				ContentColor = {
					Color3 = Color3.new(0.74118, 0.7451, 0.7451),
					Transparency = 0
				},
				Spacing = {
					Bottom = 4 * p
				},
				Opacity = 1
			},
			Disabled = { Opacity = 0.32 }
		},
		HelperText = {
			Base = {
				Typography = {
					Font = Enum.Font.GothamMedium,
					FontSize = 10 * p,
					LineHeight = 1.2,
					LetterSpacing = 0
				},
				ContentColor = {
					Color3 = Color3.new(0.74118, 0.7451, 0.7451),
					Transparency = 0
				},
				Padding = {
					Top = 4 * p
				},
				Opacity = 1
			},
			Error = {
				ContentColor = {
					Color3 = Color3.new(0.96863, 0.29412, 0.32157),
					Transparency = 0
				}
			}
		}
	}
end
