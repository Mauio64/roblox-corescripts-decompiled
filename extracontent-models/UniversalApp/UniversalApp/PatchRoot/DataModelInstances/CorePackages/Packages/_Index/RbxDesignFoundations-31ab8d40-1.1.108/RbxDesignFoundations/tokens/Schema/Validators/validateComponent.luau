return function(data)
	return {
		VerticalTile = data.strictInterface({
			Base = data.strictInterface({
				Container = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderWidth = data.number,
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					DropShadow = data.strictInterface({
						X = data.number,
						Y = data.number,
						Blur = data.number,
						Color = data.strictInterface({
							Color3 = data.Color3,
							Transparency = data.number
						})
					}),
					BorderRadius = data.strictInterface({
						LeadingTop = data.number,
						TrailingTop = data.number,
						TrailingBottom = data.number,
						LeadingBottom = data.number
					})
				}),
				ContentTop = data.strictInterface({
					Spacing = data.strictInterface({
						Top = data.number,
						Trailing = data.number,
						Bottom = data.number,
						Leading = data.number
					})
				}),
				ContentBottom = data.strictInterface({
					Spacing = data.strictInterface({
						Top = data.number,
						Trailing = data.number,
						Bottom = data.number,
						Leading = data.number
					})
				})
			})
		}),
		PlayerTileSmall = data.strictInterface({
			Base = data.strictInterface({
				Container = data.strictInterface({
					Gap = data.number,
					Spacing = data.strictInterface({
						Top = data.number,
						Trailing = data.number,
						Bottom = data.number,
						Leading = data.number
					})
				}),
				Image = data.strictInterface({
					Size = data.number,
					BackgroundColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderRadius = data.number,
					BorderWidth = data.number
				}),
				Status = data.strictInterface({
					Size = data.number,
					BackgroundColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderWidth = data.number
				}),
				Content = data.strictInterface({
					Gap = data.number,
					Typography = data.strictInterface({
						Font = data.enum(Enum.Font),
						FontSize = data.number,
						LineHeight = data.number,
						LetterSpacing = data.number
					}),
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Icon = data.strictInterface({ Size = data.number }),
				Presence = data.strictInterface({
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			})
		}),
		Facepile = data.strictInterface({
			Container = data.strictInterface({ Gap = data.number }),
			FaceGroup = data.strictInterface({ Gap = data.number }),
			Face = data.strictInterface({
				BackgroundColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				BorderWidth = data.number,
				BorderColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				BorderRadius = data.number,
				Width = data.number,
				Height = data.number
			}),
			Badge = data.strictInterface({
				BackgroundColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				BorderWidth = data.number,
				BorderColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				BorderRadius = data.number,
				Spacing = data.number,
				Height = data.number,
				MinWidth = data.number,
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			}),
			Label = data.strictInterface({
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			})
		}),
		ControllerBar = data.strictInterface({
			BackgroundColor = data.strictInterface({
				Color3 = data.Color3,
				Transparency = data.number
			}),
			BorderRadius = data.strictInterface({
				LeadingTop = data.number,
				TrailingTop = data.number,
				TrailingBottom = data.number,
				LeadingBottom = data.number
			}),
			Spacing = data.strictInterface({
				Top = data.number,
				Trailing = data.number,
				Bottom = data.number,
				Leading = data.number
			}),
			Gap = data.number
		}),
		ControllerBarShortcut = data.strictInterface({
			Container = data.strictInterface({
				Gap = data.number,
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			}),
			Icon = data.strictInterface({ Size = data.number }),
			Label = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			})
		}),
		SelectionCursor = data.strictInterface({
			BorderWidth = data.number,
			Offset = data.number,
			Inset = data.number,
			Gradient = data.strictInterface({
				Start = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				End = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			})
		}),
		StateLayer = data.strictInterface({
			Base = data.strictInterface({ BorderWidth = data.number }),
			Standard = data.strictInterface({
				Initialize = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Default = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Hover = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Pressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Selected = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				SelectedPressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Disabled = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			Lighten = data.strictInterface({
				Initialize = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Default = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Hover = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Pressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Selected = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				SelectedPressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Disabled = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			Inverse = data.strictInterface({
				Initialize = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Default = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Hover = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Pressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Selected = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				SelectedPressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Disabled = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			Darken = data.strictInterface({
				Initialize = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Default = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Hover = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Pressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Selected = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				SelectedPressed = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Disabled = data.strictInterface({
					Color = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			})
		}),
		MenuCell = data.strictInterface({
			Base = data.strictInterface({
				Container = data.strictInterface({
					Height = data.number,
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BackgroundColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderRadius = data.strictInterface({
						TopLeading = data.number,
						TopTrailing = data.number,
						BottomTrailing = data.number,
						BottomLeading = data.number
					}),
					BorderWidth = data.number,
					Spacing = data.strictInterface({
						Top = data.number,
						Trailing = data.number,
						Bottom = data.number,
						Leading = data.number
					})
				}),
				IconFrame = data.strictInterface({ Size = data.number }),
				TextFrame = data.strictInterface({
					Spacing = data.strictInterface({
						Top = data.number,
						Trailing = data.number,
						Bottom = data.number,
						Leading = data.number
					})
				}),
				Text = data.strictInterface({
					Typography = data.strictInterface({
						Font = data.enum(Enum.Font),
						FontSize = data.number,
						LineHeight = data.number,
						LetterSpacing = data.number
					})
				}),
				CheckFrame = data.strictInterface({ Size = data.number })
			}),
			Divider = data.strictInterface({
				Container = data.strictInterface({ BorderWidth = data.number })
			}),
			Disabled = data.strictInterface({
				Container = data.strictInterface({
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			HasRoundBottom = data.strictInterface({
				Container = data.strictInterface({
					BorderRadius = data.strictInterface({
						BottomTrailing = data.number,
						BottomLeading = data.number
					})
				})
			}),
			HasRoundTop = data.strictInterface({
				Container = data.strictInterface({
					BorderRadius = data.strictInterface({
						TopLeading = data.number,
						TopTrailing = data.number
					})
				})
			})
		}),
		BaseMenu = data.strictInterface({
			BorderRadius = data.number,
			BackgroundColor = data.strictInterface({
				Color3 = data.Color3,
				Transparency = data.number
			})
		}),
		StatGroup = data.strictInterface({ Gap = data.number }),
		StatItem = data.strictInterface({
			Container = data.strictInterface({
				Gap = data.number,
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			}),
			Icon = data.strictInterface({ Size = data.number }),
			Label = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			})
		}),
		MediaTile = data.strictInterface({
			Container = data.strictInterface({ BorderRadius = data.number }),
			Icon = data.strictInterface({ Size = data.number })
		}),
		StatWidget = data.strictInterface({
			Container = data.strictInterface({
				Gap = data.number,
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			}),
			Icon = data.strictInterface({ Size = data.number }),
			DataGroup = data.strictInterface({ Gap = data.number }),
			Data = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			}),
			Label = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				})
			})
		}),
		RateCount = data.strictInterface({
			Container = data.strictInterface({
				Spacing = data.number,
				Gap = data.number,
				BorderRadius = data.number,
				BackgroundColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			}),
			ButtonGroup = data.strictInterface({ Gap = data.number })
		}),
		PlayerCount = data.strictInterface({
			Container = data.strictInterface({
				Spacing = data.number,
				BorderRadius = data.number,
				BackgroundColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			})
		}),
		VerticalScrollView = data.strictInterface({
			Base = data.strictInterface({
				Handle = data.strictInterface({
					BackgroundColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderRadius = data.number
				}),
				Icon = data.strictInterface({ Size = data.number }),
				Track = data.strictInterface({
					Opacity = data.number,
					Spacing = data.strictInterface({ Top = data.number, Bottom = data.number })
				})
			}),
			Compact = data.strictInterface({
				Handle = data.strictInterface({ Width = data.number }),
				Track = data.strictInterface({ Width = data.number })
			}),
			Wide = data.strictInterface({
				Handle = data.strictInterface({ Width = data.number }),
				Track = data.strictInterface({ Width = data.number })
			}),
			Gamepad = data.strictInterface({
				Handle = data.strictInterface({ Width = data.number }),
				Track = data.strictInterface({ Width = data.number })
			})
		}),
		TextField = data.strictInterface({
			Base = data.strictInterface({
				Field = data.strictInterface({
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					BorderRadius = data.number,
					Typography = data.strictInterface({
						Font = data.enum(Enum.Font),
						FontSize = data.number,
						LineHeight = data.number,
						LetterSpacing = data.number
					}),
					Spacing = data.strictInterface({ Leading = data.number, Trailing = data.number }),
					Gap = data.number,
					Opacity = data.number
				}),
				PlaceholderText = data.strictInterface({
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				FieldValue = data.strictInterface({
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				IconLeading = data.strictInterface({
					ContentColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Size = data.number
				})
			}),
			Error = data.strictInterface({
				Field = data.strictInterface({
					BorderColor = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			Disabled = data.strictInterface({
				Field = data.strictInterface({ Opacity = data.number })
			})
		}),
		InputLabel = data.strictInterface({
			Base = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				}),
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Spacing = data.strictInterface({ Bottom = data.number }),
				Opacity = data.number
			}),
			Disabled = data.strictInterface({ Opacity = data.number })
		}),
		HelperText = data.strictInterface({
			Base = data.strictInterface({
				Typography = data.strictInterface({
					Font = data.enum(Enum.Font),
					FontSize = data.number,
					LineHeight = data.number,
					LetterSpacing = data.number
				}),
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Padding = data.strictInterface({ Top = data.number }),
				Opacity = data.number
			}),
			Error = data.strictInterface({
				ContentColor = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				})
			})
		})
	}
end
