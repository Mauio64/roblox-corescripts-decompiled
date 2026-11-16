return {
	["text-body-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyMedium", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingBodyMedium",
					PaddingTop = "$TextPaddingBodyMedium"
				},
				tag = "text-body-medium"
			}
		},
		properties = {
			LineHeight = 1.177,
			TextSize = "$TextSizeBodyMedium",
			FontFace = "$FontBodyMedium"
		},
		attributes = {
			{
				name = "FontBodyMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeBodyMedium", value = 25.5 }
		}
	},
	["text-display-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplayMedium", value = UDim.new(0, 0) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingDisplayMedium",
					PaddingTop = "$TextPaddingDisplayMedium"
				},
				tag = "text-display-medium"
			}
		},
		properties = {
			LineHeight = 1,
			TextSize = "$TextSizeDisplayMedium",
			FontFace = "$FontDisplayMedium"
		},
		attributes = {
			{
				name = "FontDisplayMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeDisplayMedium", value = 102 }
		}
	},
	["text-title-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleSmall", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingTitleSmall",
					PaddingTop = "$TextPaddingTitleSmall"
				},
				tag = "text-title-small"
			}
		},
		properties = {
			LineHeight = 1.2,
			TextSize = "$TextSizeTitleSmall",
			FontFace = "$FontTitleSmall"
		},
		attributes = {
			{
				name = "FontTitleSmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeTitleSmall", value = 22.5 }
		}
	},
	["text-heading-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingHeadingSmall", value = UDim.new(0, 0) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingHeadingSmall",
					PaddingTop = "$TextPaddingHeadingSmall"
				},
				tag = "text-heading-small"
			}
		},
		properties = {
			LineHeight = 1,
			TextSize = "$TextSizeHeadingSmall",
			FontFace = "$FontHeadingSmall"
		},
		attributes = {
			{
				name = "FontHeadingSmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeHeadingSmall", value = 36 }
		}
	},
	["text-caption-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingCaptionLarge", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingCaptionLarge",
					PaddingTop = "$TextPaddingCaptionLarge"
				},
				tag = "text-caption-large"
			}
		},
		properties = {
			LineHeight = 1.177,
			TextSize = "$TextSizeCaptionLarge",
			FontFace = "$FontCaptionLarge"
		},
		attributes = {
			{
				name = "FontCaptionLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeCaptionLarge", value = 25.5 }
		}
	},
	["text-defaults"] = {
		properties = { FontFace = "$FontBodyLarge" },
		priority = -1,
		attributes = {
			{
				name = "FontBodyLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			}
		}
	},
	["text-caption-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingCaptionMedium", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingCaptionMedium",
					PaddingTop = "$TextPaddingCaptionMedium"
				},
				tag = "text-caption-medium"
			}
		},
		properties = {
			LineHeight = 1.2,
			TextSize = "$TextSizeCaptionMedium",
			FontFace = "$FontCaptionMedium"
		},
		attributes = {
			{
				name = "FontCaptionMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeCaptionMedium", value = 22.5 }
		}
	},
	["text-heading-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingHeadingMedium", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingHeadingMedium",
					PaddingTop = "$TextPaddingHeadingMedium"
				},
				tag = "text-heading-medium"
			}
		},
		properties = {
			LineHeight = 1.103,
			TextSize = "$TextSizeHeadingMedium",
			FontFace = "$FontHeadingMedium"
		},
		attributes = {
			{
				name = "FontHeadingMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeHeadingMedium", value = 43.5 }
		}
	},
	["text-size-defaults"] = {
		attributes = {
			{ name = "TextSizeBodyLarge", value = 28.5 }
		},
		properties = { TextSize = "$TextSizeBodyLarge", LineHeight = 1.158 },
		priority = -1,
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyLarge", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = -1,
				properties = {
					PaddingBottom = "$TextPaddingBodyLarge",
					PaddingTop = "$TextPaddingBodyLarge"
				},
				tag = "text-size-defaults"
			}
		}
	},
	["text-caption-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingCaptionSmall", value = UDim.new(0, 1) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingCaptionSmall",
					PaddingTop = "$TextPaddingCaptionSmall"
				},
				tag = "text-caption-small"
			}
		},
		properties = {
			LineHeight = 1.167,
			TextSize = "$TextSizeCaptionSmall",
			FontFace = "$FontCaptionSmall"
		},
		attributes = {
			{
				name = "FontCaptionSmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeCaptionSmall", value = 18 }
		}
	},
	["text-body-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodySmall", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingBodySmall",
					PaddingTop = "$TextPaddingBodySmall"
				},
				tag = "text-body-small"
			}
		},
		properties = {
			LineHeight = 1.2,
			TextSize = "$TextSizeBodySmall",
			FontFace = "$FontBodySmall"
		},
		attributes = {
			{
				name = "FontBodySmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeBodySmall", value = 22.5 }
		}
	},
	["text-display-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplaySmall", value = UDim.new(0, 0) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingDisplaySmall",
					PaddingTop = "$TextPaddingDisplaySmall"
				},
				tag = "text-display-small"
			}
		},
		properties = {
			LineHeight = 1,
			TextSize = "$TextSizeDisplaySmall",
			FontFace = "$FontDisplaySmall"
		},
		attributes = {
			{
				name = "FontDisplaySmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeDisplaySmall", value = 72 }
		}
	},
	["text-display-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplayLarge", value = UDim.new(0, 0) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingDisplayLarge",
					PaddingTop = "$TextPaddingDisplayLarge"
				},
				tag = "text-display-large"
			}
		},
		properties = {
			LineHeight = 0.99,
			TextSize = "$TextSizeDisplayLarge",
			FontFace = "$FontDisplayLarge"
		},
		attributes = {
			{
				name = "FontDisplayLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeDisplayLarge", value = 145.5 }
		}
	},
	["text-label-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingLabelLarge", value = UDim.new(0, -2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingLabelLarge",
					PaddingTop = "$TextPaddingLabelLarge"
				},
				tag = "text-label-large"
			}
		},
		properties = {
			LineHeight = 0.842,
			TextSize = "$TextSizeLabelLarge",
			FontFace = "$FontLabelLarge"
		},
		attributes = {
			{
				name = "FontLabelLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeLabelLarge", value = 28.5 }
		}
	},
	["text-label-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingLabelSmall", value = UDim.new(0, -2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingLabelSmall",
					PaddingTop = "$TextPaddingLabelSmall"
				},
				tag = "text-label-small"
			}
		},
		properties = {
			LineHeight = 0.8,
			TextSize = "$TextSizeLabelSmall",
			FontFace = "$FontLabelSmall"
		},
		attributes = {
			{
				name = "FontLabelSmall",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeLabelSmall", value = 22.5 }
		}
	},
	["text-body-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyLarge", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingBodyLarge",
					PaddingTop = "$TextPaddingBodyLarge"
				},
				tag = "text-body-large"
			}
		},
		properties = {
			LineHeight = 1.158,
			TextSize = "$TextSizeBodyLarge",
			FontFace = "$FontBodyLarge"
		},
		attributes = {
			{
				name = "FontBodyLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeBodyLarge", value = 28.5 }
		}
	},
	["text-title-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleLarge", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingTitleLarge",
					PaddingTop = "$TextPaddingTitleLarge"
				},
				tag = "text-title-large"
			}
		},
		properties = {
			LineHeight = 1.158,
			TextSize = "$TextSizeTitleLarge",
			FontFace = "$FontTitleLarge"
		},
		attributes = {
			{
				name = "FontTitleLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeTitleLarge", value = 28.5 }
		}
	},
	["text-title-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleMedium", value = UDim.new(0, 2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingTitleMedium",
					PaddingTop = "$TextPaddingTitleMedium"
				},
				tag = "text-title-medium"
			}
		},
		properties = {
			LineHeight = 1.177,
			TextSize = "$TextSizeTitleMedium",
			FontFace = "$FontTitleMedium"
		},
		attributes = {
			{
				name = "FontTitleMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeTitleMedium", value = 25.5 }
		}
	},
	["text-heading-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingHeadingLarge", value = UDim.new(0, 0) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingHeadingLarge",
					PaddingTop = "$TextPaddingHeadingLarge"
				},
				tag = "text-heading-large"
			}
		},
		properties = {
			LineHeight = 1,
			TextSize = "$TextSizeHeadingLarge",
			FontFace = "$FontHeadingLarge"
		},
		attributes = {
			{
				name = "FontHeadingLarge",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeHeadingLarge", value = 51 }
		}
	},
	["text-label-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingLabelMedium", value = UDim.new(0, -2) }
				},
				pseudo = "UIPadding",
				priority = 0,
				properties = {
					PaddingBottom = "$TextPaddingLabelMedium",
					PaddingTop = "$TextPaddingLabelMedium"
				},
				tag = "text-label-medium"
			}
		},
		properties = {
			LineHeight = 0.824,
			TextSize = "$TextSizeLabelMedium",
			FontFace = "$FontLabelMedium"
		},
		attributes = {
			{
				name = "FontLabelMedium",
				value = Font.new("rbxassetid://127896232205472", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			},
			{ name = "TextSizeLabelMedium", value = 25.5 }
		}
	}
}
