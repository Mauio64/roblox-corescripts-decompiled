local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.Types)
local cornerRules = require(script.Parent.cornerRules)
local shadowRules = require(script.Parent.shadowRules)
local tokenAttributePascalName = require(script.Parent.Parent.tokenAttributePascalName)

local function kebabToPascal(value: string)
	return (value:gsub("^%-?(.)", function(value2)
		return value2:upper()
	end):gsub("%-(.)", function(value2)
		return value2:upper()
	end))
end

local function getTextPadding(p, p2: number) -- 2 equivalent calls inferred from this helper
	local v = p.TextSize / p2 * (p.LineHeight * p2) - p.TextSize
	return (UDim.new(0, v / 2))
end

local function DefaultSizeRules(bodylarge, nominalScale: number)
	local textPadding = getTextPadding(bodylarge, nominalScale) -- inferred equivalent call
	return {
		{
			tag = "text-size-defaults",
			priority = -1,
			properties = { TextSize = "$TextSizeBodyLarge", LineHeight = bodylarge.LineHeight },
			children = {
				{
					tag = "text-size-defaults",
					pseudo = "UIPadding",
					priority = -1,
					properties = {
						PaddingTop = "$TextPaddingBodyLarge",
						PaddingBottom = "$TextPaddingBodyLarge"
					},
					attributes = {
						{ name = "TextPaddingBodyLarge", value = textPadding }
					}
				}
			},
			attributes = {
				{ name = "TextSizeBodyLarge", value = bodylarge.TextSize }
			}
		}
	}
end

local function ListLayoutSpacingRules(gaps, gutters)
	local v = {}

	for _, item in gaps do
		local v2 = kebabToPascal(item.name)
		table.insert(v, {
			tag = `gap-{item.name}`,
			pseudo = "UIListLayout",
			properties = { Padding = `$Gap{v2}` },
			attributes = {
				{ name = `Gap{v2}`, value = item.size }
			}
		})
	end

	local v2 = {}

	for _, item in gutters do
		local v3 = kebabToPascal(item.name)
		table.insert(v2, {
			tag = `gutter-{item.name}`,
			pseudo = "UIListLayout",
			properties = { Padding = `$Gutter{v3}` },
			attributes = {
				{ name = `Gutter{v3}`, value = item.size }
			}
		})
	end

	return Dash.joinArrays(v, v2)
end

local function CornerRules(p)
	return cornerRules(p, function(p2)
		local v = kebabToPascal(p2.name)
		return {
			cornerValue = `$Radius{v}`,
			attributes = {
				{ name = `Radius{v}`, value = p2.size }
			}
		}
	end)
end

local function ShadowRules(p) -- 1 equivalent call inferred from this helper
	return shadowRules(p)
end

local function SizeRules(sizes)
	local result = {}

	for _, item in sizes do
		local v = kebabToPascal(item.name)
		table.insert(result, {
			tag = `size-{item.name}`,
			properties = { Size = `$Size{v}` },
			attributes = {
				{
					name = `Size{v}`,
					value = UDim2.new(item.size, item.size)
				}
			}
		})

		for _, item2 in sizes do
			local v2 = kebabToPascal(item2.name)
			table.insert(result, {
				tag = `size-{item.name}-{item2.name}`,
				properties = { Size = `$Size{v}_{v2}` },
				attributes = {
					{
						name = `Size{v}_{v2}`,
						value = UDim2.new(item.size, item2.size)
					}
				}
			})
		end
	end

	return result
end

local function TypographyRules(typography, nominalScale: number)
	local result = {}

	for k, item in typography do
		local v = kebabToPascal(k)
		local textPadding = getTextPadding(item, nominalScale) -- inferred equivalent call
		table.insert(result, {
			tag = `text-{k}`,
			properties = {
				FontFace = `$Font{v}`,
				TextSize = `$TextSize{v}`,
				LineHeight = item.LineHeight
			},
			attributes = {
				{ name = `Font{v}`, value = item.Font },
				{ name = `TextSize{v}`, value = item.TextSize }
			},
			children = {
				{
					tag = `text-{k}`,
					pseudo = "UIPadding",
					priority = 0,
					properties = {
						PaddingTop = `$TextPadding{v}`,
						PaddingBottom = `$TextPadding{v}`
					},
					attributes = {
						{ name = `TextPadding{v}`, value = textPadding }
					}
				}
			}
		})
	end

	return result
end

local function PaddingRules(paddings, margins)
	local result = {}

	for _, item in paddings do
		local v = kebabToPascal(item.name)
		table.insert(result, {
			tag = `padding-{item.name}`,
			pseudo = "UIPadding",
			properties = {
				PaddingTop = `$Padding{v}`,
				PaddingBottom = `$Padding{v}`,
				PaddingLeft = `$Padding{v}`,
				PaddingRight = `$Padding{v}`
			},
			attributes = {
				{ name = `Padding{v}`, value = item.size }
			}
		})
	end

	for _, item in margins do
		local v = kebabToPascal(item.name)
		table.insert(result, {
			tag = `margin-{item.name}`,
			pseudo = "UIPadding",
			properties = {
				PaddingTop = `$Margin{v}`,
				PaddingBottom = `$Margin{v}`,
				PaddingLeft = `$Margin{v}`,
				PaddingRight = `$Margin{v}`
			},
			attributes = {
				{ name = `Margin{v}`, value = item.size }
			}
		})
	end

	for k, v in {
		x = { "PaddingLeft", "PaddingRight" },
		y = { "PaddingTop", "PaddingBottom" },
		top = { "PaddingTop" },
		bottom = { "PaddingBottom" },
		left = { "PaddingLeft" },
		right = { "PaddingRight" }
	} do
		for _, item in paddings do
			local v2 = kebabToPascal(item.name)
			local properties = {}

			for _, v3 in v do
				properties[v3] = `$Padding{v2}`
			end

			table.insert(result, {
				tag = `padding-{k}-{item.name}`,
				pseudo = "UIPadding",
				properties = properties,
				attributes = {
					{ name = `Padding{v2}`, value = item.size }
				}
			})
		end

		for _, item in margins do
			local v2 = kebabToPascal(item.name)
			local properties = {}

			for _, v3 in v do
				properties[v3] = `$Margin{v2}`
			end

			table.insert(result, {
				tag = `margin-{k}-{item.name}`,
				pseudo = "UIPadding",
				properties = properties,
				attributes = {
					{ name = `Margin{v2}`, value = item.size }
				}
			})
		end
	end

	return result
end

local v = {
	Content = { "content" },
	Stroke = { "stroke" },
	Shift = { "bg" },
	Surface = { "bg" },
	OverMedia = { "bg" },
	System = { "bg", "content", "stroke" },
	Extended = {},
	Common = {},
	Selection = {},
	State = {},
	None = {}
}

local function GuiObjectDefaultRules()
	return {
		{
			tag = "gui-object-defaults",
			priority = -1,
			properties = { BackgroundTransparency = 1 }
		}
	}
end

local function DefaultFontRules(p)
	return {
		{
			tag = "text-defaults",
			priority = -1,
			properties = { FontFace = "$FontBodyLarge" },
			attributes = {
				{ name = "FontBodyLarge", value = p.Typography.BodyLarge.Font }
			}
		}
	}
end

local function DefaultColorRules(p)
	return {
		{
			tag = "text-color-defaults",
			priority = -1,
			properties = {
				TextColor3 = "$ColorContentDefaultColor3",
				TextTransparency = "$ColorContentDefaultTransparency"
			},
			attributes = {
				{ name = "ColorContentDefaultColor3", value = p.Color.Content.Default.Color3 },
				{
					name = "ColorContentDefaultTransparency",
					value = p.Color.Content.Default.Transparency
				}
			}
		}
	}
end

local function BackgroundRules(colors, variants)
	local result = {}

	for k, item in colors do
		if not table.find(v[k], "bg") then
			continue
		end

		for k2, v2 in item do
			local v3 = tokenAttributePascalName(k, k2)
			table.insert(result, {
				tag = `bg-{k2}`,
				properties = {
					BackgroundColor3 = `$Color{k}{v3}Color3`,
					BackgroundTransparency = `$Color{k}{v3}Transparency`
				},
				attributes = {
					{ name = `Color{k}{v3}Color3`, value = v2.Color3 },
					{ name = `Color{k}{v3}Transparency`, value = v2.Transparency }
				}
			})
		end
	end

	for k, item in variants do
		local v2 = kebabToPascal(k)
		table.insert(result, {
			tag = `bg-{k}`,
			properties = {
				BackgroundColor3 = `$Color{v2}BackgroundColor3`,
				BackgroundTransparency = `$Color{v2}BackgroundTransparency`
			},
			attributes = {
				{ name = `Color{v2}BackgroundColor3`, value = item.Background.Color3 },
				{
					name = `Color{v2}BackgroundTransparency`,
					value = item.Background.Transparency
				}
			}
		})
	end

	return result
end

local function StrokeSizeRules(strokes)
	local result = {}

	for _, item in strokes do
		if item.name == "none" then
			continue
		end

		local v2 = kebabToPascal(item.name)
		table.insert(result, {
			tag = `stroke-{item.name}`,
			pseudo = "UIStroke",
			properties = { Thickness = `$StrokeThickness{v2}` },
			attributes = {
				{ name = `StrokeThickness{v2}`, value = item.size }
			}
		})
	end

	return result
end

local function StrokeRules(colors, variants)
	local result = {}

	for k, item in colors do
		if not table.find(v[k], "stroke") then
			continue
		end

		for k2, v2 in item do
			local v3 = tokenAttributePascalName(k, k2)
			table.insert(result, {
				tag = `stroke-{k2}`,
				pseudo = "UIStroke",
				properties = {
					Color = `$Color{k}{v3}Color3`,
					Transparency = `$Color{k}{v3}Transparency`
				},
				attributes = {
					{ name = `Color{k}{v3}Color3`, value = v2.Color3 },
					{ name = `Color{k}{v3}Transparency`, value = v2.Transparency }
				}
			})
		end
	end

	for k, item in variants do
		local v2 = kebabToPascal(k)
		table.insert(result, {
			tag = `stroke-{k}`,
			pseudo = "UIStroke",
			properties = {
				Color = `$Color{v2}BorderColor3`,
				Transparency = `$Color{v2}BorderTransparency`
			},
			attributes = {
				{ name = `Color{v2}BorderColor3`, value = item.Border.Color3 },
				{ name = `Color{v2}BorderTransparency`, value = item.Border.Transparency }
			}
		})
	end

	for k, borderStrokePosition in {
		["center"] = Enum.BorderStrokePosition.Center,
		inner = Enum.BorderStrokePosition.Inner,
		outer = Enum.BorderStrokePosition.Outer
	} do
		table.insert(result, {
			tag = `stroke-position-{k}`,
			pseudo = "UIStroke",
			properties = { BorderStrokePosition = borderStrokePosition }
		})
	end

	return result
end

local function ContentRules(colors, variants)
	local result = {}

	for k, item in colors do
		if not table.find(v[k], "content") then
			continue
		end

		for k2, v2 in item do
			local v3 = tokenAttributePascalName(k, k2)
			table.insert(result, {
				tag = `content-{k2}`,
				properties = {
					ImageColor3 = `$Color{k}{v3}Color3`,
					ImageTransparency = `$Color{k}{v3}Transparency`,
					TextColor3 = `$Color{k}{v3}Color3`,
					TextTransparency = `$Color{k}{v3}Transparency`
				},
				attributes = {
					{ name = `Color{k}{v3}Color3`, value = v2.Color3 },
					{ name = `Color{k}{v3}Transparency`, value = v2.Transparency }
				}
			})
		end
	end

	for k, item in variants do
		local v2 = kebabToPascal(k)
		table.insert(result, {
			tag = `content-{k}`,
			properties = {
				ImageColor3 = `$Color{v2}ForegroundColor3`,
				ImageTransparency = `$Color{v2}ForegroundTransparency`,
				TextColor3 = `$Color{v2}ForegroundColor3`,
				TextTransparency = `$Color{v2}ForegroundTransparency`
			},
			attributes = {
				{ name = `Color{v2}ForegroundColor3`, value = item.Foreground.Color3 },
				{
					name = `Color{v2}ForegroundTransparency`,
					value = item.Foreground.Transparency
				}
			}
		})
	end

	return result
end

local function DeprecatedColorRules(colors)
	local result = {}

	for k, v2 in colors.System do
		local v3 = k:sub(8)
		local v4 = tokenAttributePascalName("System", k)

		table.insert(result, {
			tag = `bg-{v3}`,
			properties = {
				BackgroundColor3 = `$ColorSystem{v4}Color3`,
				BackgroundTransparency = `$ColorSystem{v4}Transparency`
			},
			attributes = {
				{ name = `ColorSystem{v4}Color3`, value = v2.Color3 },
				{ name = `ColorSystem{v4}Transparency`, value = v2.Transparency }
			},
			deprecatedFor = `bg-{k}`
		})

		if v3 == "emphasis" then
			continue
		end

		table.insert(result, {
			tag = `content-{v3}`,
			properties = {
				ImageColor3 = `$ColorSystem{v4}Color3`,
				ImageTransparency = `$ColorSystem{v4}Transparency`,
				TextColor3 = `$ColorSystem{v4}Color3`,
				TextTransparency = `$ColorSystem{v4}Transparency`
			},
			attributes = {
				{ name = `ColorSystem{v4}Color3`, value = v2.Color3 },
				{ name = `ColorSystem{v4}Transparency`, value = v2.Transparency }
			},
			deprecatedFor = `content-{k}`
		})

		table.insert(result, {
			tag = `stroke-{v3}`,
			pseudo = "UIStroke",
			properties = {
				Color = `$ColorSystem{v4}Color3`,
				Transparency = `$ColorSystem{v4}Transparency`
			},
			attributes = {
				{ name = `ColorSystem{v4}Color3`, value = v2.Color3 },
				{ name = `ColorSystem{v4}Transparency`, value = v2.Transparency }
			},
			deprecatedFor = `stroke-{k}`
		})
	end

	return result
end

local function EngineDefaultBypassRules()
	return {
		{
			tag = "x-default-transparency",
			properties = { BackgroundTransparency = 0 }
		},
		{
			tag = "x-default-text-size",
			properties = { TextSize = 8 }
		}
	}
end

local function ListLayoutRules()
	local v2 = {
		{
			tag = "row",
			pseudo = "UIListLayout",
			properties = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		},
		{
			tag = "col",
			pseudo = "UIListLayout",
			properties = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}
	}

	local v3 = {
		{
			tag = "align-x-left",
			pseudo = "UIListLayout",
			properties = { HorizontalAlignment = Enum.HorizontalAlignment.Left }
		},
		{
			tag = "align-x-center",
			pseudo = "UIListLayout",
			properties = { HorizontalAlignment = Enum.HorizontalAlignment.Center }
		},
		{
			tag = "align-x-right",
			pseudo = "UIListLayout",
			properties = { HorizontalAlignment = Enum.HorizontalAlignment.Right }
		},
		{
			tag = "align-y-top",
			pseudo = "UIListLayout",
			properties = { VerticalAlignment = Enum.VerticalAlignment.Top }
		},
		{
			tag = "align-y-center",
			pseudo = "UIListLayout",
			properties = { VerticalAlignment = Enum.VerticalAlignment.Center }
		},
		{
			tag = "align-y-bottom",
			pseudo = "UIListLayout",
			properties = { VerticalAlignment = Enum.VerticalAlignment.Bottom }
		}
	}

	local v4 = {}

	for k, v5 in {
		none = Enum.UIFlexAlignment.None,
		fill = Enum.UIFlexAlignment.Fill,
		around = Enum.UIFlexAlignment.SpaceAround,
		between = Enum.UIFlexAlignment.SpaceBetween,
		evenly = Enum.UIFlexAlignment.SpaceEvenly
	} do
		table.insert(v4, {
			tag = `flex-{k}`,
			pseudo = "UIListLayout",
			properties = { HorizontalFlex = v5, VerticalFlex = v5 }
		})

		table.insert(v4, {
			tag = `flex-x-{k}`,
			pseudo = "UIListLayout",
			properties = { HorizontalFlex = v5 }
		})

		table.insert(v4, {
			tag = `flex-y-{k}`,
			pseudo = "UIListLayout",
			properties = { VerticalFlex = v5 }
		})
	end

	local v5 = {}

	for k, itemLineAlignment in {
		auto = Enum.ItemLineAlignment.Automatic,
		start = Enum.ItemLineAlignment.Start,
		center = Enum.ItemLineAlignment.Center,
		["end"] = Enum.ItemLineAlignment.End,
		stretch = Enum.ItemLineAlignment.Stretch
	} do
		table.insert(v5, {
			tag = `items-{k}`,
			pseudo = "UIListLayout",
			properties = { ItemLineAlignment = itemLineAlignment }
		})
	end

	return Dash.joinArrays(v2, v3, {
		{
			tag = "wrap",
			pseudo = "UIListLayout",
			properties = { Wraps = true }
		},
		{
			tag = "no-wrap",
			pseudo = "UIListLayout",
			properties = { Wraps = false }
		}
	}, v4, v5)
end

local function FlexItemRules()
	local v2 = {
		{
			tag = "grow",
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.Grow }
		},
		{
			tag = "shrink",
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.Shrink }
		},
		{
			tag = "fill",
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.Fill }
		},
		{
			tag = "no-flex",
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.None }
		}
	}

	local v3 = {}
	local v4 = {}

	for k in { 1, 2, 3, 4, 5 } do
		table.insert(v3, {
			tag = `grow-{k}`,
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.Custom, GrowRatio = k }
		})

		table.insert(v4, {
			tag = `shrink-{k}`,
			pseudo = "UIFlexItem",
			properties = { FlexMode = Enum.UIFlexMode.Custom, ShrinkRatio = k }
		})
	end

	local v5 = {}

	for k, itemLineAlignment in {
		auto = Enum.ItemLineAlignment.Automatic,
		start = Enum.ItemLineAlignment.Start,
		center = Enum.ItemLineAlignment.Center,
		["end"] = Enum.ItemLineAlignment.End,
		stretch = Enum.ItemLineAlignment.Stretch
	} do
		table.insert(v5, {
			tag = `self-{k}`,
			pseudo = "UIFlexItem",
			properties = { ItemLineAlignment = itemLineAlignment }
		})
	end

	return Dash.joinArrays(v2, v3, v4, v5)
end

local function TextRules()
	local result = {}

	for k, textXAlignment in {
		["left"] = Enum.TextXAlignment.Left,
		center = Enum.TextXAlignment.Center,
		right = Enum.TextXAlignment.Right
	} do
		table.insert(result, {
			tag = `text-align-x-{k}`,
			properties = { TextXAlignment = textXAlignment }
		})
	end

	for k, textYAlignment in {
		["top"] = Enum.TextYAlignment.Top,
		center = Enum.TextYAlignment.Center,
		bottom = Enum.TextYAlignment.Bottom
	} do
		table.insert(result, {
			tag = `text-align-y-{k}`,
			properties = { TextYAlignment = textYAlignment }
		})
	end

	for k, textTruncate in {
		none = Enum.TextTruncate.None,
		["end"] = Enum.TextTruncate.AtEnd,
		split = Enum.TextTruncate.SplitWord
	} do
		table.insert(result, {
			tag = `text-truncate-{k}`,
			properties = { TextTruncate = textTruncate }
		})
	end

	table.insert(result, {
		tag = "text-wrap",
		properties = { TextWrapped = true }
	})

	table.insert(result, {
		tag = "text-no-wrap",
		properties = { TextWrapped = false }
	})

	return result
end

local function AutomaticSizeRules()
	local result = {}

	for k, automaticSize in {
		none = Enum.AutomaticSize.None,
		x = Enum.AutomaticSize.X,
		y = Enum.AutomaticSize.Y,
		xy = Enum.AutomaticSize.XY
	} do
		table.insert(result, {
			tag = `auto-{k}`,
			properties = { AutomaticSize = automaticSize }
		})
	end

	return result
end

local function PositionRules()
	local v2 = { top = 0, center = 0.5, bottom = 1 }
	local result = {}

	for k, v3 in { left = 0, center = 0.5, right = 1 } do
		for k2, v4 in v2 do
			table.insert(result, {
				tag = `position-{k2}-{k}`,
				properties = { Position = UDim2.fromScale(v3, v4) }
			})
		end
	end

	return result
end

local function AnchorPointRules()
	local v2 = { top = 0, center = 0.5, bottom = 1 }
	local result = {}

	for k, v3 in { left = 0, center = 0.5, right = 1 } do
		for k2, v4 in v2 do
			table.insert(result, {
				tag = `anchor-{k2}-{k}`,
				properties = { AnchorPoint = Vector2.new(v3, v4) }
			})
		end
	end

	return result
end

local function ClipsDescendantRules()
	return {
		{
			tag = "clip",
			properties = { ClipsDescendants = true }
		},
		{
			tag = "no-clip",
			properties = { ClipsDescendants = false }
		}
	}
end

local function roundDecimals(p: number, p2: number) -- 2 equivalent calls inferred from this helper
	local v2 = 10 ^ p2
	return math.round(p * v2) / v2
end

local function AspectRatioRules()
	local result = {}

	for _, v2 in {
		{ 1, 1 },
		{ 5, 4 },
		{ 4, 3 },
		{ 3, 2 },
		{ 16, 9 },
		{ 2, 1 }
	} do
		table.insert(result, {
			tag = `aspect-{v2[1]}-{v2[2]}`,
			pseudo = "UIAspectRatioConstraint",
			properties = {
				AspectRatio = roundDecimals(v2[1] / v2[2], 3) -- inferred equivalent call
			}
		})

		if v2[1] ~= v2[2] then
			table.insert(result, {
				tag = `aspect-{v2[2]}-{v2[1]}`,
				pseudo = "UIAspectRatioConstraint",
				properties = {
					AspectRatio = roundDecimals(v2[2] / v2[1], 3) -- inferred equivalent call
				}
			})
		end
	end

	return result
end

return {
	rulesGenerator = function(p, data)
		local colors = data.colors
		local variants = data.variants
		local gaps = data.gaps
		local gutters = data.gutters
		local radii = data.radii
		local sizes = data.sizes
		local strokes = data.strokes
		local typography = data.typography
		local paddings = data.paddings
		local margins = data.margins
		return
			Dash.joinArrays(
				GuiObjectDefaultRules(),
				EngineDefaultBypassRules(),
				FlexItemRules(),
				TextRules(),
				AutomaticSizeRules(),
				PositionRules(),
				AnchorPointRules(),
				ClipsDescendantRules(),
				AspectRatioRules()
			),
			Dash.joinArrays(ListLayoutRules(), ListLayoutSpacingRules(gaps, gutters), cornerRules(radii, function(p2)
				local v2 = kebabToPascal(p2.name)
				return {
					cornerValue = `$Radius{v2}`,
					attributes = {
						{ name = `Radius{v2}`, value = p2.size }
					}
				}
			end), ShadowRules(p), SizeRules(sizes), StrokeSizeRules(strokes), PaddingRules(paddings, margins)), -- inferred equivalent call
			Dash.joinArrays(
				DefaultColorRules(p),
				DeprecatedColorRules(colors),
				BackgroundRules(colors, variants),
				StrokeRules(colors, variants),
				ContentRules(colors, variants)
			),
			(Dash.joinArrays(
				DefaultFontRules(p),
				DefaultSizeRules(typography["body-large"], p.Config.Text.NominalScale),
				TypographyRules(typography, p.Config.Text.NominalScale)
			))
	end
}
