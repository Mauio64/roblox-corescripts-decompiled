return {
	["text-body-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyMedium", value = UDim.new(0, 0) }
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
			LineHeight = 1.111,
			Font = "$FontBodyMedium",
			TextSize = "$TextSizeBodyMedium"
		},
		attributes = {
			{ name = "FontBodyMedium", value = Enum.Font.BuilderSans },
			{ name = "TextSizeBodyMedium", value = 18 }
		}
	},
	["text-display-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplayMedium", value = UDim.new(0, -1) }
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
			LineHeight = 0.958,
			Font = "$FontDisplayMedium",
			TextSize = "$TextSizeDisplayMedium"
		},
		attributes = {
			{ name = "FontDisplayMedium", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeDisplayMedium", value = 71 }
		}
	},
	["text-title-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleSmall", value = UDim.new(0, 1) }
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
			Font = "$FontTitleSmall",
			TextSize = "$TextSizeTitleSmall"
		},
		attributes = {
			{ name = "FontTitleSmall", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeTitleSmall", value = 15 }
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
			LineHeight = 0.96,
			Font = "$FontHeadingSmall",
			TextSize = "$TextSizeHeadingSmall"
		},
		attributes = {
			{ name = "FontHeadingSmall", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeHeadingSmall", value = 25 }
		}
	},
	["text-caption-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingCaptionLarge", value = UDim.new(0, 0) }
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
			LineHeight = 1.111,
			Font = "$FontCaptionLarge",
			TextSize = "$TextSizeCaptionLarge"
		},
		attributes = {
			{ name = "FontCaptionLarge", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeCaptionLarge", value = 18 }
		}
	},
	["text-defaults"] = {
		properties = { Font = "$FontBodyLarge" },
		priority = -1,
		attributes = {
			{ name = "FontBodyLarge", value = Enum.Font.BuilderSans }
		}
	},
	["text-caption-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingCaptionMedium", value = UDim.new(0, 1) }
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
			Font = "$FontCaptionMedium",
			TextSize = "$TextSizeCaptionMedium"
		},
		attributes = {
			{ name = "FontCaptionMedium", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeCaptionMedium", value = 15 }
		}
	},
	["text-heading-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingHeadingMedium", value = UDim.new(0, 1) }
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
			LineHeight = 1.067,
			Font = "$FontHeadingMedium",
			TextSize = "$TextSizeHeadingMedium"
		},
		attributes = {
			{ name = "FontHeadingMedium", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeHeadingMedium", value = 30 }
		}
	},
	["text-size-defaults"] = {
		attributes = {
			{ name = "TextSizeBodyLarge", value = 20 }
		},
		properties = { TextSize = "$TextSizeBodyLarge", LineHeight = 1.1 },
		priority = -1,
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyLarge", value = UDim.new(0, 1) }
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
					{ name = "TextPaddingCaptionSmall", value = UDim.new(0, 0) }
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
			LineHeight = 1.077,
			Font = "$FontCaptionSmall",
			TextSize = "$TextSizeCaptionSmall"
		},
		attributes = {
			{ name = "FontCaptionSmall", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeCaptionSmall", value = 13 }
		}
	},
	["text-body-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodySmall", value = UDim.new(0, 1) }
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
		properties = { LineHeight = 1.2, Font = "$FontBodySmall", TextSize = "$TextSizeBodySmall" },
		attributes = {
			{ name = "FontBodySmall", value = Enum.Font.BuilderSans },
			{ name = "TextSizeBodySmall", value = 15 }
		}
	},
	["text-display-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplaySmall", value = UDim.new(0, -1) }
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
			LineHeight = 0.96,
			Font = "$FontDisplaySmall",
			TextSize = "$TextSizeDisplaySmall"
		},
		attributes = {
			{ name = "FontDisplaySmall", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeDisplaySmall", value = 50 }
		}
	},
	["text-display-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingDisplayLarge", value = UDim.new(0, -2) }
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
			LineHeight = 0.951,
			Font = "$FontDisplayLarge",
			TextSize = "$TextSizeDisplayLarge"
		},
		attributes = {
			{ name = "FontDisplayLarge", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeDisplayLarge", value = 101 }
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
			LineHeight = 0.8,
			Font = "$FontLabelLarge",
			TextSize = "$TextSizeLabelLarge"
		},
		attributes = {
			{ name = "FontLabelLarge", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeLabelLarge", value = 20 }
		}
	},
	["text-label-small"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingLabelSmall", value = UDim.new(0, -1) }
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
			Font = "$FontLabelSmall",
			TextSize = "$TextSizeLabelSmall"
		},
		attributes = {
			{ name = "FontLabelSmall", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeLabelSmall", value = 15 }
		}
	},
	["text-body-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingBodyLarge", value = UDim.new(0, 1) }
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
		properties = { LineHeight = 1.1, Font = "$FontBodyLarge", TextSize = "$TextSizeBodyLarge" },
		attributes = {
			{ name = "FontBodyLarge", value = Enum.Font.BuilderSans },
			{ name = "TextSizeBodyLarge", value = 20 }
		}
	},
	["text-title-large"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleLarge", value = UDim.new(0, 1) }
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
			LineHeight = 1.1,
			Font = "$FontTitleLarge",
			TextSize = "$TextSizeTitleLarge"
		},
		attributes = {
			{ name = "FontTitleLarge", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeTitleLarge", value = 20 }
		}
	},
	["text-title-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingTitleMedium", value = UDim.new(0, 0) }
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
			LineHeight = 1.111,
			Font = "$FontTitleMedium",
			TextSize = "$TextSizeTitleMedium"
		},
		attributes = {
			{ name = "FontTitleMedium", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeTitleMedium", value = 18 }
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
			LineHeight = 0.971,
			Font = "$FontHeadingLarge",
			TextSize = "$TextSizeHeadingLarge"
		},
		attributes = {
			{ name = "FontHeadingLarge", value = Enum.Font.BuilderSansBold },
			{ name = "TextSizeHeadingLarge", value = 35 }
		}
	},
	["text-label-medium"] = {
		children = {
			{
				attributes = {
					{ name = "TextPaddingLabelMedium", value = UDim.new(0, -1) }
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
			LineHeight = 0.778,
			Font = "$FontLabelMedium",
			TextSize = "$TextSizeLabelMedium"
		},
		attributes = {
			{ name = "FontLabelMedium", value = Enum.Font.BuilderSansMedium },
			{ name = "TextSizeLabelMedium", value = 18 }
		}
	}
}
