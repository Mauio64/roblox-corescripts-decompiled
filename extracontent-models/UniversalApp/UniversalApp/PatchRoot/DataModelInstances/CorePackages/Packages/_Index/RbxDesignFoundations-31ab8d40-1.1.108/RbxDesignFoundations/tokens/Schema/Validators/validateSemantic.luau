return function(data)
	return {
		Typography = data.strictInterface({
			Title = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			Header = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			Subheader = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			Body = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			CaptionHeader = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			CaptionBody = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			}),
			Footer = data.strictInterface({
				Font = data.enum(Enum.Font),
				FontSize = data.number,
				LineHeight = data.number,
				LetterSpacing = data.number
			})
		}),
		Color = data.strictInterface({
			Background = data.strictInterface({
				Default = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Contrast = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Muted = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				OnHover = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				OnPress = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			BackgroundUi = data.strictInterface({
				Default = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Contrast = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			Ui = data.strictInterface({
				Default = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Muted = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Emphasis = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			Text = data.strictInterface({
				Default = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Muted = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Emphasis = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Link = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Inverse = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			Icon = data.strictInterface({
				Default = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Emphasis = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				OnHover = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			Action = data.strictInterface({
				Primary = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Border = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Content = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				PrimaryBrand = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Border = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Content = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Secondary = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Border = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Content = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Alert = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Border = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Content = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Subtle = data.strictInterface({
					Background = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Border = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Content = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			State = data.strictInterface({
				Standard = data.strictInterface({
					Default = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Hover = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Pressed = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Lighten = data.strictInterface({
					Default = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Hover = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Pressed = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Inverse = data.strictInterface({
					Default = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Hover = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Pressed = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				}),
				Darken = data.strictInterface({
					Default = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Hover = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					}),
					Pressed = data.strictInterface({
						Color3 = data.Color3,
						Transparency = data.number
					})
				})
			}),
			Focus = data.strictInterface({
				Start = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				End = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Gradient = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			}),
			Common = data.strictInterface({
				Divider = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Overlay = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				DropShadow = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				NavigationBar = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Badge = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				BadgeContent = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Placeholder = data.strictInterface({
					Color3 = data.Color3,
					Transparency = data.number
				}),
				Online = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Offline = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Alert = data.strictInterface({ Color3 = data.Color3, Transparency = data.number }),
				Success = data.strictInterface({ Color3 = data.Color3, Transparency = data.number })
			})
		}),
		Radius = data.strictInterface({
			None = data.number,
			Small = data.number,
			Medium = data.number,
			Large = data.number,
			XLarge = data.number,
			Circle = data.number
		}),
		Icon = data.strictInterface({
			Size = data.strictInterface({
				Small = data.number,
				Medium = data.number,
				Large = data.number,
				XLarge = data.number,
				XxLarge = data.number
			})
		}),
		Stroke = data.strictInterface({ Input = data.number, Focus = data.number }),
		Offset = data.strictInterface({
			Focus = data.strictInterface({ Standard = data.number, Inset = data.number })
		}),
		Opacity = data.strictInterface({
			State = data.strictInterface({
				Lighten = data.strictInterface({ Hover = data.number, Pressed = data.number }),
				Darken = data.strictInterface({ Hover = data.number, Pressed = data.number })
			})
		})
	}
end
