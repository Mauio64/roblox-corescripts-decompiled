return {
	["bg-surface-200"] = {
		properties = {
			BackgroundTransparency = "$ColorSurfaceSurface200Transparency",
			BackgroundColor3 = "$ColorSurfaceSurface200Color3"
		},
		attributes = {
			{
				name = "ColorSurfaceSurface200Color3",
				value = Color3.new(0.929412, 0.901961, 1)
			},
			{ name = "ColorSurfaceSurface200Transparency", value = 0 }
		}
	},
	["stroke-system-emphasis"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemEmphasisColor3",
			Transparency = "$ColorSystemEmphasisTransparency"
		},
		attributes = {
			{ name = "ColorSystemEmphasisColor3", value = Color3.new(0.2, 0.372549, 1) },
			{ name = "ColorSystemEmphasisTransparency", value = 0 }
		}
	},
	["bg-over-media-100"] = {
		properties = {
			BackgroundTransparency = "$ColorOverMediaOverMedia100Transparency",
			BackgroundColor3 = "$ColorOverMediaOverMedia100Color3"
		},
		attributes = {
			{
				name = "ColorOverMediaOverMedia100Color3",
				value = Color3.new(0.901961, 0.858824, 1)
			},
			{ name = "ColorOverMediaOverMedia100Transparency", value = 0.08 }
		}
	},
	["bg-system-warning"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemWarningTransparency",
			BackgroundColor3 = "$ColorSystemWarningColor3"
		},
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		}
	},
	["content-action-sub-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorActionSubEmphasisForegroundColor3",
			TextTransparency = "$ColorActionSubEmphasisForegroundTransparency",
			TextColor3 = "$ColorActionSubEmphasisForegroundColor3",
			ImageTransparency = "$ColorActionSubEmphasisForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionSubEmphasisForegroundColor3",
				value = Color3.new(0.964706, 0.964706, 0.972549)
			},
			{ name = "ColorActionSubEmphasisForegroundTransparency", value = 0 }
		}
	},
	["bg-success"] = {
		deprecatedFor = "bg-system-success",
		properties = {
			BackgroundTransparency = "$ColorSystemSuccessTransparency",
			BackgroundColor3 = "$ColorSystemSuccessColor3"
		},
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		}
	},
	["bg-over-media-0"] = {
		properties = {
			BackgroundTransparency = "$ColorOverMediaOverMedia0Transparency",
			BackgroundColor3 = "$ColorOverMediaOverMedia0Color3"
		},
		attributes = {
			{
				name = "ColorOverMediaOverMedia0Color3",
				value = Color3.new(0.929412, 0.901961, 1)
			},
			{ name = "ColorOverMediaOverMedia0Transparency", value = 0.08 }
		}
	},
	["stroke-action-sub-emphasis"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionSubEmphasisBorderColor3",
			Transparency = "$ColorActionSubEmphasisBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionSubEmphasisBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionSubEmphasisBorderTransparency", value = 1 }
		}
	},
	["content-default"] = {
		properties = {
			ImageColor3 = "$ColorContentDefaultColor3",
			TextTransparency = "$ColorContentDefaultTransparency",
			TextColor3 = "$ColorContentDefaultColor3",
			ImageTransparency = "$ColorContentDefaultTransparency"
		},
		attributes = {
			{
				name = "ColorContentDefaultColor3",
				value = Color3.new(0.32549, 0.317647, 0.364706)
			},
			{ name = "ColorContentDefaultTransparency", value = 0 }
		}
	},
	["stroke-system-neutral"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemNeutralColor3",
			Transparency = "$ColorSystemNeutralTransparency"
		},
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		}
	},
	["content-action-soft-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorActionSoftEmphasisForegroundColor3",
			TextTransparency = "$ColorActionSoftEmphasisForegroundTransparency",
			TextColor3 = "$ColorActionSoftEmphasisForegroundColor3",
			ImageTransparency = "$ColorActionSoftEmphasisForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionSoftEmphasisForegroundColor3",
				value = Color3.new(0, 0.0784314, 0.360784)
			},
			{ name = "ColorActionSoftEmphasisForegroundTransparency", value = 0 }
		}
	},
	["content-action-over-media"] = {
		properties = {
			ImageColor3 = "$ColorActionOverMediaForegroundColor3",
			TextTransparency = "$ColorActionOverMediaForegroundTransparency",
			TextColor3 = "$ColorActionOverMediaForegroundColor3",
			ImageTransparency = "$ColorActionOverMediaForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionOverMediaForegroundColor3",
				value = Color3.new(0.964706, 0.964706, 0.972549)
			},
			{ name = "ColorActionOverMediaForegroundTransparency", value = 0 }
		}
	},
	["stroke-position-center"] = {
		pseudo = "UIStroke",
		properties = { BorderStrokePosition = Enum.BorderStrokePosition.Center }
	},
	["stroke-position-inner"] = {
		pseudo = "UIStroke",
		properties = { BorderStrokePosition = Enum.BorderStrokePosition.Inner }
	},
	["content-inverse-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorContentInverseEmphasisColor3",
			TextTransparency = "$ColorContentInverseEmphasisTransparency",
			TextColor3 = "$ColorContentInverseEmphasisColor3",
			ImageTransparency = "$ColorContentInverseEmphasisTransparency"
		},
		attributes = {
			{
				name = "ColorContentInverseEmphasisColor3",
				value = Color3.new(0.964706, 0.964706, 0.972549)
			},
			{ name = "ColorContentInverseEmphasisTransparency", value = 0 }
		}
	},
	["bg-action-soft-emphasis"] = {
		properties = {
			BackgroundTransparency = "$ColorActionSoftEmphasisBackgroundTransparency",
			BackgroundColor3 = "$ColorActionSoftEmphasisBackgroundColor3"
		},
		attributes = {
			{
				name = "ColorActionSoftEmphasisBackgroundColor3",
				value = Color3.new(0.2, 0.372549, 1)
			},
			{ name = "ColorActionSoftEmphasisBackgroundTransparency", value = 0.7 }
		}
	},
	["bg-neutral"] = {
		deprecatedFor = "bg-system-neutral",
		properties = {
			BackgroundTransparency = "$ColorSystemNeutralTransparency",
			BackgroundColor3 = "$ColorSystemNeutralColor3"
		},
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		}
	},
	["bg-action-over-media"] = {
		properties = {
			BackgroundTransparency = "$ColorActionOverMediaBackgroundTransparency",
			BackgroundColor3 = "$ColorActionOverMediaBackgroundColor3"
		},
		attributes = {
			{
				name = "ColorActionOverMediaBackgroundColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorActionOverMediaBackgroundTransparency", value = 0 }
		}
	},
	["bg-action-alert"] = {
		properties = {
			BackgroundTransparency = "$ColorActionAlertBackgroundTransparency",
			BackgroundColor3 = "$ColorActionAlertBackgroundColor3"
		},
		attributes = {
			{
				name = "ColorActionAlertBackgroundColor3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorActionAlertBackgroundTransparency", value = 0.88 }
		}
	},
	["content-action-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorActionEmphasisForegroundColor3",
			TextTransparency = "$ColorActionEmphasisForegroundTransparency",
			TextColor3 = "$ColorActionEmphasisForegroundColor3",
			ImageTransparency = "$ColorActionEmphasisForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionEmphasisForegroundColor3",
				value = Color3.new(0.968627, 0.968627, 0.972549)
			},
			{ name = "ColorActionEmphasisForegroundTransparency", value = 0 }
		}
	},
	["stroke-emphasis"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorStrokeEmphasisColor3",
			Transparency = "$ColorStrokeEmphasisTransparency"
		},
		attributes = {
			{
				name = "ColorStrokeEmphasisColor3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorStrokeEmphasisTransparency", value = 0.84 }
		}
	},
	["content-inverse-default"] = {
		properties = {
			ImageColor3 = "$ColorContentInverseDefaultColor3",
			TextTransparency = "$ColorContentInverseDefaultTransparency",
			TextColor3 = "$ColorContentInverseDefaultColor3",
			ImageTransparency = "$ColorContentInverseDefaultTransparency"
		},
		attributes = {
			{
				name = "ColorContentInverseDefaultColor3",
				value = Color3.new(0.894118, 0.890196, 0.913725)
			},
			{ name = "ColorContentInverseDefaultTransparency", value = 0 }
		}
	},
	["content-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorContentEmphasisColor3",
			TextTransparency = "$ColorContentEmphasisTransparency",
			TextColor3 = "$ColorContentEmphasisColor3",
			ImageTransparency = "$ColorContentEmphasisTransparency"
		},
		attributes = {
			{
				name = "ColorContentEmphasisColor3",
				value = Color3.new(0.0941176, 0.0901961, 0.113725)
			},
			{ name = "ColorContentEmphasisTransparency", value = 0 }
		}
	},
	["bg-action-sub-emphasis"] = {
		properties = {
			BackgroundTransparency = "$ColorActionSubEmphasisBackgroundTransparency",
			BackgroundColor3 = "$ColorActionSubEmphasisBackgroundColor3"
		},
		attributes = {
			{
				name = "ColorActionSubEmphasisBackgroundColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorActionSubEmphasisBackgroundTransparency", value = 0 }
		}
	},
	["bg-system-alert"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemAlertTransparency",
			BackgroundColor3 = "$ColorSystemAlertColor3"
		},
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		}
	},
	["bg-surface-300"] = {
		properties = {
			BackgroundTransparency = "$ColorSurfaceSurface300Transparency",
			BackgroundColor3 = "$ColorSurfaceSurface300Color3"
		},
		attributes = {
			{
				name = "ColorSurfaceSurface300Color3",
				value = Color3.new(0.901961, 0.858824, 1)
			},
			{ name = "ColorSurfaceSurface300Transparency", value = 0 }
		}
	},
	["stroke-action-emphasis"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionEmphasisBorderColor3",
			Transparency = "$ColorActionEmphasisBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionEmphasisBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionEmphasisBorderTransparency", value = 1 }
		}
	},
	["text-color-defaults"] = {
		properties = {
			TextTransparency = "$ColorContentDefaultTransparency",
			TextColor3 = "$ColorContentDefaultColor3"
		},
		priority = -1,
		attributes = {
			{
				name = "ColorContentDefaultColor3",
				value = Color3.new(0.32549, 0.317647, 0.364706)
			},
			{ name = "ColorContentDefaultTransparency", value = 0 }
		}
	},
	["content-success"] = {
		deprecatedFor = "content-system-success",
		properties = {
			ImageColor3 = "$ColorSystemSuccessColor3",
			TextTransparency = "$ColorSystemSuccessTransparency",
			TextColor3 = "$ColorSystemSuccessColor3",
			ImageTransparency = "$ColorSystemSuccessTransparency"
		},
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		}
	},
	["bg-alert"] = {
		deprecatedFor = "bg-system-alert",
		properties = {
			BackgroundTransparency = "$ColorSystemAlertTransparency",
			BackgroundColor3 = "$ColorSystemAlertColor3"
		},
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		}
	},
	["bg-contrast"] = {
		deprecatedFor = "bg-system-contrast",
		properties = {
			BackgroundTransparency = "$ColorSystemContrastTransparency",
			BackgroundColor3 = "$ColorSystemContrastColor3"
		},
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		}
	},
	["content-action-utility"] = {
		properties = {
			ImageColor3 = "$ColorActionUtilityForegroundColor3",
			TextTransparency = "$ColorActionUtilityForegroundTransparency",
			TextColor3 = "$ColorActionUtilityForegroundColor3",
			ImageTransparency = "$ColorActionUtilityForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionUtilityForegroundColor3",
				value = Color3.new(0.0941176, 0.0901961, 0.113725)
			},
			{ name = "ColorActionUtilityForegroundTransparency", value = 0 }
		}
	},
	["bg-shift-100"] = {
		properties = {
			BackgroundTransparency = "$ColorShiftShift100Transparency",
			BackgroundColor3 = "$ColorShiftShift100Color3"
		},
		attributes = {
			{
				name = "ColorShiftShift100Color3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorShiftShift100Transparency", value = 0.96 }
		}
	},
	["content-system-success"] = {
		properties = {
			ImageColor3 = "$ColorSystemSuccessColor3",
			TextTransparency = "$ColorSystemSuccessTransparency",
			TextColor3 = "$ColorSystemSuccessColor3",
			ImageTransparency = "$ColorSystemSuccessTransparency"
		},
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		}
	},
	["bg-action-standard"] = {
		properties = {
			BackgroundTransparency = "$ColorActionStandardBackgroundTransparency",
			BackgroundColor3 = "$ColorActionStandardBackgroundColor3"
		},
		attributes = {
			{
				name = "ColorActionStandardBackgroundColor3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorActionStandardBackgroundTransparency", value = 0.88 }
		}
	},
	["stroke-action-alert"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionAlertBorderColor3",
			Transparency = "$ColorActionAlertBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionAlertBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionAlertBorderTransparency", value = 1 }
		}
	},
	["stroke-contrast"] = {
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		},
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemContrastColor3",
			Transparency = "$ColorSystemContrastTransparency"
		},
		deprecatedFor = "stroke-system-contrast"
	},
	["content-system-neutral"] = {
		properties = {
			ImageColor3 = "$ColorSystemNeutralColor3",
			TextTransparency = "$ColorSystemNeutralTransparency",
			TextColor3 = "$ColorSystemNeutralColor3",
			ImageTransparency = "$ColorSystemNeutralTransparency"
		},
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		}
	},
	["content-action-alert"] = {
		properties = {
			ImageColor3 = "$ColorActionAlertForegroundColor3",
			TextTransparency = "$ColorActionAlertForegroundTransparency",
			TextColor3 = "$ColorActionAlertForegroundColor3",
			ImageTransparency = "$ColorActionAlertForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionAlertForegroundColor3",
				value = Color3.new(0.752941, 0.0941176, 0.0470588)
			},
			{ name = "ColorActionAlertForegroundTransparency", value = 0 }
		}
	},
	["stroke-system-warning"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemWarningColor3",
			Transparency = "$ColorSystemWarningTransparency"
		},
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		}
	},
	["bg-action-utility"] = {
		properties = {
			BackgroundTransparency = "$ColorActionUtilityBackgroundTransparency",
			BackgroundColor3 = "$ColorActionUtilityBackgroundColor3"
		},
		attributes = {
			{ name = "ColorActionUtilityBackgroundColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionUtilityBackgroundTransparency", value = 1 }
		}
	},
	["content-action-link"] = {
		properties = {
			ImageColor3 = "$ColorActionLinkForegroundColor3",
			TextTransparency = "$ColorActionLinkForegroundTransparency",
			TextColor3 = "$ColorActionLinkForegroundColor3",
			ImageTransparency = "$ColorActionLinkForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionLinkForegroundColor3",
				value = Color3.new(0.0941176, 0.0901961, 0.113725)
			},
			{ name = "ColorActionLinkForegroundTransparency", value = 0 }
		}
	},
	["bg-surface-0"] = {
		properties = {
			BackgroundTransparency = "$ColorSurfaceSurface0Transparency",
			BackgroundColor3 = "$ColorSurfaceSurface0Color3"
		},
		attributes = {
			{
				name = "ColorSurfaceSurface0Color3",
				value = Color3.new(0.929412, 0.901961, 1)
			},
			{ name = "ColorSurfaceSurface0Transparency", value = 0 }
		}
	},
	["bg-over-media-300"] = {
		properties = {
			BackgroundTransparency = "$ColorOverMediaOverMedia300Transparency",
			BackgroundColor3 = "$ColorOverMediaOverMedia300Color3"
		},
		attributes = {
			{
				name = "ColorOverMediaOverMedia300Color3",
				value = Color3.new(0.901961, 0.858824, 1)
			},
			{ name = "ColorOverMediaOverMedia300Transparency", value = 0.08 }
		}
	},
	["content-action-standard"] = {
		properties = {
			ImageColor3 = "$ColorActionStandardForegroundColor3",
			TextTransparency = "$ColorActionStandardForegroundTransparency",
			TextColor3 = "$ColorActionStandardForegroundColor3",
			ImageTransparency = "$ColorActionStandardForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionStandardForegroundColor3",
				value = Color3.new(0.0941176, 0.0901961, 0.113725)
			},
			{ name = "ColorActionStandardForegroundTransparency", value = 0 }
		}
	},
	["content-inverse-link"] = {
		properties = {
			ImageColor3 = "$ColorContentInverseLinkColor3",
			TextTransparency = "$ColorContentInverseLinkTransparency",
			TextColor3 = "$ColorContentInverseLinkColor3",
			ImageTransparency = "$ColorContentInverseLinkTransparency"
		},
		attributes = {
			{
				name = "ColorContentInverseLinkColor3",
				value = Color3.new(0.784314, 0.870588, 0.996078)
			},
			{ name = "ColorContentInverseLinkTransparency", value = 0 }
		}
	},
	["bg-system-neutral"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemNeutralTransparency",
			BackgroundColor3 = "$ColorSystemNeutralColor3"
		},
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		}
	},
	["content-link"] = {
		properties = {
			ImageColor3 = "$ColorContentLinkColor3",
			TextTransparency = "$ColorContentLinkTransparency",
			TextColor3 = "$ColorContentLinkColor3",
			ImageTransparency = "$ColorContentLinkTransparency"
		},
		attributes = {
			{
				name = "ColorContentLinkColor3",
				value = Color3.new(0.0588235, 0.0980392, 0.541176)
			},
			{ name = "ColorContentLinkTransparency", value = 0 }
		}
	},
	["content-muted"] = {
		properties = {
			ImageColor3 = "$ColorContentMutedColor3",
			TextTransparency = "$ColorContentMutedTransparency",
			TextColor3 = "$ColorContentMutedColor3",
			ImageTransparency = "$ColorContentMutedTransparency"
		},
		attributes = {
			{
				name = "ColorContentMutedColor3",
				value = Color3.new(0.388235, 0.380392, 0.427451)
			},
			{ name = "ColorContentMutedTransparency", value = 0 }
		}
	},
	["bg-system-emphasis"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemEmphasisTransparency",
			BackgroundColor3 = "$ColorSystemEmphasisColor3"
		},
		attributes = {
			{ name = "ColorSystemEmphasisColor3", value = Color3.new(0.2, 0.372549, 1) },
			{ name = "ColorSystemEmphasisTransparency", value = 0 }
		}
	},
	["content-system-emphasis"] = {
		properties = {
			ImageColor3 = "$ColorSystemEmphasisColor3",
			TextTransparency = "$ColorSystemEmphasisTransparency",
			TextColor3 = "$ColorSystemEmphasisColor3",
			ImageTransparency = "$ColorSystemEmphasisTransparency"
		},
		attributes = {
			{ name = "ColorSystemEmphasisColor3", value = Color3.new(0.2, 0.372549, 1) },
			{ name = "ColorSystemEmphasisTransparency", value = 0 }
		}
	},
	["bg-action-emphasis"] = {
		properties = {
			BackgroundTransparency = "$ColorActionEmphasisBackgroundTransparency",
			BackgroundColor3 = "$ColorActionEmphasisBackgroundColor3"
		},
		attributes = {
			{ name = "ColorActionEmphasisBackgroundColor3", value = Color3.new(0.2, 0.372549, 1) },
			{ name = "ColorActionEmphasisBackgroundTransparency", value = 0 }
		}
	},
	["content-system-contrast"] = {
		properties = {
			ImageColor3 = "$ColorSystemContrastColor3",
			TextTransparency = "$ColorSystemContrastTransparency",
			TextColor3 = "$ColorSystemContrastColor3",
			ImageTransparency = "$ColorSystemContrastTransparency"
		},
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		}
	},
	["bg-action-subtle"] = {
		properties = {
			BackgroundTransparency = "$ColorActionSubtleBackgroundTransparency",
			BackgroundColor3 = "$ColorActionSubtleBackgroundColor3"
		},
		attributes = {
			{ name = "ColorActionSubtleBackgroundColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionSubtleBackgroundTransparency", value = 1 }
		}
	},
	["content-system-alert"] = {
		properties = {
			ImageColor3 = "$ColorSystemAlertColor3",
			TextTransparency = "$ColorSystemAlertTransparency",
			TextColor3 = "$ColorSystemAlertColor3",
			ImageTransparency = "$ColorSystemAlertTransparency"
		},
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		}
	},
	["stroke-default"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorStrokeDefaultColor3",
			Transparency = "$ColorStrokeDefaultTransparency"
		},
		attributes = {
			{
				name = "ColorStrokeDefaultColor3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorStrokeDefaultTransparency", value = 0.88 }
		}
	},
	["content-system-warning"] = {
		properties = {
			ImageColor3 = "$ColorSystemWarningColor3",
			TextTransparency = "$ColorSystemWarningTransparency",
			TextColor3 = "$ColorSystemWarningColor3",
			ImageTransparency = "$ColorSystemWarningTransparency"
		},
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		}
	},
	["stroke-action-over-media"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionOverMediaBorderColor3",
			Transparency = "$ColorActionOverMediaBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionOverMediaBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionOverMediaBorderTransparency", value = 1 }
		}
	},
	["stroke-position-outer"] = {
		pseudo = "UIStroke",
		properties = { BorderStrokePosition = Enum.BorderStrokePosition.Outer }
	},
	["stroke-alert"] = {
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		},
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemAlertColor3",
			Transparency = "$ColorSystemAlertTransparency"
		},
		deprecatedFor = "stroke-system-alert"
	},
	["bg-system-contrast"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemContrastTransparency",
			BackgroundColor3 = "$ColorSystemContrastColor3"
		},
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		}
	},
	["bg-surface-100"] = {
		properties = {
			BackgroundTransparency = "$ColorSurfaceSurface100Transparency",
			BackgroundColor3 = "$ColorSurfaceSurface100Color3"
		},
		attributes = {
			{
				name = "ColorSurfaceSurface100Color3",
				value = Color3.new(0.901961, 0.858824, 1)
			},
			{ name = "ColorSurfaceSurface100Transparency", value = 0 }
		}
	},
	["stroke-muted"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorStrokeMutedColor3",
			Transparency = "$ColorStrokeMutedTransparency"
		},
		attributes = {
			{
				name = "ColorStrokeMutedColor3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorStrokeMutedTransparency", value = 0.92 }
		}
	},
	["stroke-action-subtle"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionSubtleBorderColor3",
			Transparency = "$ColorActionSubtleBorderTransparency"
		},
		attributes = {
			{
				name = "ColorActionSubtleBorderColor3",
				value = Color3.new(0.286275, 0.32549, 0.352941)
			},
			{ name = "ColorActionSubtleBorderTransparency", value = 0 }
		}
	},
	["content-action-subtle"] = {
		properties = {
			ImageColor3 = "$ColorActionSubtleForegroundColor3",
			TextTransparency = "$ColorActionSubtleForegroundTransparency",
			TextColor3 = "$ColorActionSubtleForegroundColor3",
			ImageTransparency = "$ColorActionSubtleForegroundTransparency"
		},
		attributes = {
			{
				name = "ColorActionSubtleForegroundColor3",
				value = Color3.new(0.0941176, 0.0901961, 0.113725)
			},
			{ name = "ColorActionSubtleForegroundTransparency", value = 0 }
		}
	},
	["stroke-warning"] = {
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		},
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemWarningColor3",
			Transparency = "$ColorSystemWarningTransparency"
		},
		deprecatedFor = "stroke-system-warning"
	},
	["bg-action-link"] = {
		properties = {
			BackgroundTransparency = "$ColorActionLinkBackgroundTransparency",
			BackgroundColor3 = "$ColorActionLinkBackgroundColor3"
		},
		attributes = {
			{ name = "ColorActionLinkBackgroundColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionLinkBackgroundTransparency", value = 1 }
		}
	},
	["content-contrast"] = {
		deprecatedFor = "content-system-contrast",
		properties = {
			ImageColor3 = "$ColorSystemContrastColor3",
			TextTransparency = "$ColorSystemContrastTransparency",
			TextColor3 = "$ColorSystemContrastColor3",
			ImageTransparency = "$ColorSystemContrastTransparency"
		},
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		}
	},
	["stroke-action-link"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionLinkBorderColor3",
			Transparency = "$ColorActionLinkBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionLinkBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionLinkBorderTransparency", value = 1 }
		}
	},
	["stroke-action-utility"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionUtilityBorderColor3",
			Transparency = "$ColorActionUtilityBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionUtilityBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionUtilityBorderTransparency", value = 1 }
		}
	},
	["stroke-action-standard"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionStandardBorderColor3",
			Transparency = "$ColorActionStandardBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionStandardBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionStandardBorderTransparency", value = 1 }
		}
	},
	["bg-shift-400"] = {
		properties = {
			BackgroundTransparency = "$ColorShiftShift400Transparency",
			BackgroundColor3 = "$ColorShiftShift400Color3"
		},
		attributes = {
			{
				name = "ColorShiftShift400Color3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorShiftShift400Transparency", value = 0.84 }
		}
	},
	["stroke-action-soft-emphasis"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorActionSoftEmphasisBorderColor3",
			Transparency = "$ColorActionSoftEmphasisBorderTransparency"
		},
		attributes = {
			{ name = "ColorActionSoftEmphasisBorderColor3", value = Color3.new(0, 0, 0) },
			{ name = "ColorActionSoftEmphasisBorderTransparency", value = 1 }
		}
	},
	["bg-over-media-200"] = {
		properties = {
			BackgroundTransparency = "$ColorOverMediaOverMedia200Transparency",
			BackgroundColor3 = "$ColorOverMediaOverMedia200Color3"
		},
		attributes = {
			{
				name = "ColorOverMediaOverMedia200Color3",
				value = Color3.new(0.929412, 0.901961, 1)
			},
			{ name = "ColorOverMediaOverMedia200Transparency", value = 0.08 }
		}
	},
	["stroke-system-success"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemSuccessColor3",
			Transparency = "$ColorSystemSuccessTransparency"
		},
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		}
	},
	["stroke-success"] = {
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		},
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemSuccessColor3",
			Transparency = "$ColorSystemSuccessTransparency"
		},
		deprecatedFor = "stroke-system-success"
	},
	["content-inverse-muted"] = {
		properties = {
			ImageColor3 = "$ColorContentInverseMutedColor3",
			TextTransparency = "$ColorContentInverseMutedTransparency",
			TextColor3 = "$ColorContentInverseMutedColor3",
			ImageTransparency = "$ColorContentInverseMutedTransparency"
		},
		attributes = {
			{
				name = "ColorContentInverseMutedColor3",
				value = Color3.new(0.745098, 0.733333, 0.768627)
			},
			{ name = "ColorContentInverseMutedTransparency", value = 0 }
		}
	},
	["stroke-system-contrast"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemContrastColor3",
			Transparency = "$ColorSystemContrastTransparency"
		},
		attributes = {
			{
				name = "ColorSystemContrastColor3",
				value = Color3.new(0.0705882, 0.0705882, 0.0823529)
			},
			{ name = "ColorSystemContrastTransparency", value = 0 }
		}
	},
	["content-alert"] = {
		deprecatedFor = "content-system-alert",
		properties = {
			ImageColor3 = "$ColorSystemAlertColor3",
			TextTransparency = "$ColorSystemAlertTransparency",
			TextColor3 = "$ColorSystemAlertColor3",
			ImageTransparency = "$ColorSystemAlertTransparency"
		},
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		}
	},
	["content-neutral"] = {
		deprecatedFor = "content-system-neutral",
		properties = {
			ImageColor3 = "$ColorSystemNeutralColor3",
			TextTransparency = "$ColorSystemNeutralTransparency",
			TextColor3 = "$ColorSystemNeutralColor3",
			ImageTransparency = "$ColorSystemNeutralTransparency"
		},
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		}
	},
	["bg-warning"] = {
		deprecatedFor = "bg-system-warning",
		properties = {
			BackgroundTransparency = "$ColorSystemWarningTransparency",
			BackgroundColor3 = "$ColorSystemWarningColor3"
		},
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		}
	},
	["stroke-neutral"] = {
		attributes = {
			{
				name = "ColorSystemNeutralColor3",
				value = Color3.new(0.286275, 0.301961, 0.352941)
			},
			{ name = "ColorSystemNeutralTransparency", value = 0 }
		},
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemNeutralColor3",
			Transparency = "$ColorSystemNeutralTransparency"
		},
		deprecatedFor = "stroke-system-neutral"
	},
	["bg-shift-200"] = {
		properties = {
			BackgroundTransparency = "$ColorShiftShift200Transparency",
			BackgroundColor3 = "$ColorShiftShift200Color3"
		},
		attributes = {
			{
				name = "ColorShiftShift200Color3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorShiftShift200Transparency", value = 0.92 }
		}
	},
	["stroke-system-alert"] = {
		pseudo = "UIStroke",
		properties = {
			Color = "$ColorSystemAlertColor3",
			Transparency = "$ColorSystemAlertTransparency"
		},
		attributes = {
			{
				name = "ColorSystemAlertColor3",
				value = Color3.new(0.87451, 0.156863, 0.121569)
			},
			{ name = "ColorSystemAlertTransparency", value = 0 }
		}
	},
	["bg-system-success"] = {
		properties = {
			BackgroundTransparency = "$ColorSystemSuccessTransparency",
			BackgroundColor3 = "$ColorSystemSuccessColor3"
		},
		attributes = {
			{
				name = "ColorSystemSuccessColor3",
				value = Color3.new(0.223529, 0.772549, 0.509804)
			},
			{ name = "ColorSystemSuccessTransparency", value = 0 }
		}
	},
	["bg-shift-300"] = {
		properties = {
			BackgroundTransparency = "$ColorShiftShift300Transparency",
			BackgroundColor3 = "$ColorShiftShift300Color3"
		},
		attributes = {
			{
				name = "ColorShiftShift300Color3",
				value = Color3.new(0.223529, 0.2, 0.301961)
			},
			{ name = "ColorShiftShift300Transparency", value = 0.88 }
		}
	},
	["bg-emphasis"] = {
		deprecatedFor = "bg-system-emphasis",
		properties = {
			BackgroundTransparency = "$ColorSystemEmphasisTransparency",
			BackgroundColor3 = "$ColorSystemEmphasisColor3"
		},
		attributes = {
			{ name = "ColorSystemEmphasisColor3", value = Color3.new(0.2, 0.372549, 1) },
			{ name = "ColorSystemEmphasisTransparency", value = 0 }
		}
	},
	["content-warning"] = {
		deprecatedFor = "content-system-warning",
		properties = {
			ImageColor3 = "$ColorSystemWarningColor3",
			TextTransparency = "$ColorSystemWarningTransparency",
			TextColor3 = "$ColorSystemWarningColor3",
			ImageTransparency = "$ColorSystemWarningTransparency"
		},
		attributes = {
			{
				name = "ColorSystemWarningColor3",
				value = Color3.new(0.54902, 0.32549, 0.0117647)
			},
			{ name = "ColorSystemWarningTransparency", value = 0 }
		}
	}
}
