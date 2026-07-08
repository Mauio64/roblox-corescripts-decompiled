local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)

require(Foundation.Providers.Style.Tokens)
require(script.Parent.Types)

local cornerRules = require(script.Parent.cornerRules)
local tokenAttributePascalName = require(script.Parent.Parent.tokenAttributePascalName)

local function kebabToPascal(s1: string) -- line: 26
	return (s1:gsub("^%-?(.)", function(p1) -- line: 28
		return p1:upper()
	end):gsub("%-(.)", function(p2) -- line: 33
		return p2:upper()
	end))
end
local function getTextPadding(p3, n1: number) -- line: 40
	local v35 = p3.TextSize / n1 * (p3.LineHeight * n1) - p3.TextSize

	return (UDim.new(0, v35 / 2))
end
local function DefaultSizeRules(p4, n2: number) -- line: 49
	local v38 = p4.TextSize / n2 * (p4.LineHeight * n2) - p4.TextSize
	local uDim = UDim.new(0, v38 / 2)

	return {{
		tag = "text-size-defaults",
		priority = -1,
		properties = {
			TextSize = "$TextSizeBodyLarge",
			LineHeight = p4.LineHeight
		},
		children = {{
			tag = "text-size-defaults",
			pseudo = "UIPadding",
			priority = -1,
			properties = {
				PaddingTop = "$TextPaddingBodyLarge",
				PaddingBottom = "$TextPaddingBodyLarge"
			},
			attributes = {{
				name = "TextPaddingBodyLarge",
				value = uDim
			}}
		}},
		attributes = {{
			name = "TextSizeBodyLarge",
			value = p4.TextSize
		}}
	}}
end
local function ListLayoutSpacingRules(p5, p6) -- line: 87
	-- upvalues: kebabToPascal (copy), Dash (copy)
	local t1 = {}

	for _, v44 in p5 do
		local v45 = kebabToPascal(v44.name)

		table.insert(t1, {
			pseudo = "UIListLayout",
			tag = `gap-{ v44.name }`,
			properties = {
				Padding = `$Gap{ v45 }`
			},
			attributes = {{
				name = `Gap{ v45 }`,
				value = v44.size
			}}
		})
	end

	local t2 = {}

	for _, v48 in p6 do
		local v49 = kebabToPascal(v48.name)

		table.insert(t2, {
			pseudo = "UIListLayout",
			tag = `gutter-{ v48.name }`,
			properties = {
				Padding = `$Gutter{ v49 }`
			},
			attributes = {{
				name = `Gutter{ v49 }`,
				value = v48.size
			}}
		})
	end

	return Dash.joinArrays(t1, t2)
end
local function CornerRules(p7) -- line: 129
	-- upvalues: cornerRules (copy), kebabToPascal (copy)
	return cornerRules(p7, function(p8) -- line: 130
		-- upvalues: kebabToPascal (copy)
		local v203 = kebabToPascal(p8.name)

		return {
			cornerValue = `$Radius{ v203 }`,
			attributes = {{
				name = `Radius{ v203 }`,
				value = p8.size
			}}
		}
	end)
end
local function SizeRules(p9) -- line: 144
	-- upvalues: kebabToPascal (copy)
	local t3 = {}

	for _, v54 in p9 do
		local v55 = kebabToPascal(v54.name)

		table.insert(t3, {
			tag = `size-{ v54.name }`,
			properties = {
				Size = `$Size{ v55 }`
			},
			attributes = {{
				name = `Size{ v55 }`,
				value = UDim2.new(v54.size, v54.size)
			}}
		})

		for _, v57 in p9 do
			local v58 = kebabToPascal(v57.name)

			table.insert(t3, {
				tag = `size-{ v54.name }-{ v57.name }`,
				properties = {
					Size = `$Size{ v55 }_{ v58 }`
				},
				attributes = {{
					name = `Size{ v55 }_{ v58 }`,
					value = UDim2.new(v54.size, v57.size)
				}}
			})
		end
	end

	return t3
end
local function TypographyRules(p10, n3: number) -- line: 182
	-- upvalues: kebabToPascal (copy)
	local t4 = {}

	for v62, v63 in p10 do
		local v64 = kebabToPascal(v62)
		local v65 = v63.TextSize / n3 * (v63.LineHeight * n3) - v63.TextSize
		local uDim = UDim.new(0, v65 / 2)

		table.insert(t4, {
			tag = `text-{ v62 }`,
			properties = {
				Font = `$Font{ v64 }`,
				TextSize = `$TextSize{ v64 }`,
				LineHeight = v63.LineHeight
			},
			attributes = {
				{
					name = `Font{ v64 }`,
					value = v63.Font
				},
				{
					name = `TextSize{ v64 }`,
					value = v63.TextSize
				}
			},
			children = {{
				pseudo = "UIPadding",
				priority = 0,
				tag = `text-{ v62 }`,
				properties = {
					PaddingTop = `$TextPadding{ v64 }`,
					PaddingBottom = `$TextPadding{ v64 }`
				},
				attributes = {{
					name = `TextPadding{ v64 }`,
					value = uDim
				}}
			}}
		})
	end

	return t4
end
local function PaddingRules(p11, p12) -- line: 229
	-- upvalues: kebabToPascal (copy)
	local t5 = {}
	local t6 = {
		x = {
			"PaddingLeft",
			"PaddingRight"
		},
		y = {
			"PaddingTop",
			"PaddingBottom"
		},
		top = { "PaddingTop" },
		bottom = { "PaddingBottom" },
		left = { "PaddingLeft" },
		right = { "PaddingRight" }
	}

	for _, v72 in p11 do
		local v73 = kebabToPascal(v72.name)

		table.insert(t5, {
			pseudo = "UIPadding",
			tag = `padding-{ v72.name }`,
			properties = {
				PaddingTop = `$Padding{ v73 }`,
				PaddingBottom = `$Padding{ v73 }`,
				PaddingLeft = `$Padding{ v73 }`,
				PaddingRight = `$Padding{ v73 }`
			},
			attributes = {{
				name = `Padding{ v73 }`,
				value = v72.size
			}}
		})
	end

	for _, v75 in p12 do
		local v76 = kebabToPascal(v75.name)

		table.insert(t5, {
			pseudo = "UIPadding",
			tag = `margin-{ v75.name }`,
			properties = {
				PaddingTop = `$Margin{ v76 }`,
				PaddingBottom = `$Margin{ v76 }`,
				PaddingLeft = `$Margin{ v76 }`,
				PaddingRight = `$Margin{ v76 }`
			},
			attributes = {{
				name = `Margin{ v76 }`,
				value = v75.size
			}}
		})
	end

	for v77, v78 in t6 do
		for _, v80 in p11 do
			local v81 = kebabToPascal(v80.name)
			local t7 = {}

			for _, v84 in v78 do
				t7[v84] = `$Padding{ v81 }`
			end

			table.insert(t5, {
				pseudo = "UIPadding",
				tag = `padding-{ v77 }-{ v80.name }`,
				properties = t7,
				attributes = {{
					name = `Padding{ v81 }`,
					value = v80.size
				}}
			})
		end

		for _, v86 in p12 do
			local v87 = kebabToPascal(v86.name)
			local t8 = {}

			for _, v90 in v78 do
				t8[v90] = `$Margin{ v87 }`
			end

			table.insert(t5, {
				pseudo = "UIPadding",
				tag = `margin-{ v77 }-{ v86.name }`,
				properties = t8,
				attributes = {{
					name = `Margin{ v87 }`,
					value = v86.size
				}}
			})
		end
	end

	return t5
end

local t9 = {
	Content = { "content" },
	Stroke = { "stroke" },
	Shift = { "bg" },
	Surface = { "bg" },
	OverMedia = { "bg" },
	System = {
		"bg",
		"content",
		"stroke"
	},
	Extended = {},
	Common = {},
	Selection = {},
	State = {},
	None = {}
}

local function DefaultRules(p13) -- line: 342
	local BodyLargeFont = p13.Typography.BodyLarge.Font

	return {
		{
			tag = "gui-object-defaults",
			priority = -1,
			properties = {
				BackgroundTransparency = 1
			}
		},
		{
			tag = "text-defaults",
			priority = -1,
			properties = {
				Font = "$FontBodyLarge"
			},
			attributes = {{
				name = "FontBodyLarge",
				value = BodyLargeFont
			}}
		}
	}
end
local function DefaultColorRules(p14) -- line: 368
	local DefaultColor3 = p14.Color.Content.Default.Color3
	local DefaultTransparency = p14.Color.Content.Default.Transparency

	return {{
		tag = "text-color-defaults",
		priority = -1,
		properties = {
			TextColor3 = "$ColorContentDefaultColor3",
			TextTransparency = "$ColorContentDefaultTransparency"
		},
		attributes = {
			{
				name = "ColorContentDefaultColor3",
				value = DefaultColor3
			},
			{
				name = "ColorContentDefaultTransparency",
				value = DefaultTransparency
			}
		}
	}}
end
local function BackgroundRules(p15, p16) -- line: 393
	-- upvalues: t9 (copy), tokenAttributePascalName (copy), kebabToPascal (copy)
	local t10 = {}

	for v99, v100 in p15 do
		if table.find(t9[v99], "bg") then
			for v101, v102 in v100 do
				local v103 = tokenAttributePascalName(v99, v101)

				table.insert(t10, {
					tag = `bg-{ v101 }`,
					properties = {
						BackgroundColor3 = `$Color{ v99 }{ v103 }Color3`,
						BackgroundTransparency = `$Color{ v99 }{ v103 }Transparency`
					},
					attributes = {
						{
							name = `Color{ v99 }{ v103 }Color3`,
							value = v102.Color3
						},
						{
							name = `Color{ v99 }{ v103 }Transparency`,
							value = v102.Transparency
						}
					}
				})
			end
		end
	end

	for v104, v105 in p16 do
		local v106 = kebabToPascal(v104)

		table.insert(t10, {
			tag = `bg-{ v104 }`,
			properties = {
				BackgroundColor3 = `$Color{ v106 }BackgroundColor3`,
				BackgroundTransparency = `$Color{ v106 }BackgroundTransparency`
			},
			attributes = {
				{
					name = `Color{ v106 }BackgroundColor3`,
					value = v105.Background.Color3
				},
				{
					name = `Color{ v106 }BackgroundTransparency`,
					value = v105.Background.Transparency
				}
			}
		})
	end

	return t10
end
local function StrokeSizeRules(p17) -- line: 445
	-- upvalues: kebabToPascal (copy)
	local t11 = {}

	for _, v110 in p17 do
		if v110.name ~= "none" then
			local v111 = kebabToPascal(v110.name)

			table.insert(t11, {
				pseudo = "UIStroke",
				tag = `stroke-{ v110.name }`,
				properties = {
					Thickness = `$StrokeThickness{ v111 }`
				},
				attributes = {{
					name = `StrokeThickness{ v111 }`,
					value = v110.size
				}}
			})
		end
	end

	return t11
end
local function StrokeRules(p18, p19) -- line: 472
	-- upvalues: t9 (copy), tokenAttributePascalName (copy), kebabToPascal (copy)
	local t12 = {}

	for v115, v116 in p18 do
		if table.find(t9[v115], "stroke") then
			for v117, v118 in v116 do
				local v119 = tokenAttributePascalName(v115, v117)

				table.insert(t12, {
					pseudo = "UIStroke",
					tag = `stroke-{ v117 }`,
					properties = {
						Color = `$Color{ v115 }{ v119 }Color3`,
						Transparency = `$Color{ v115 }{ v119 }Transparency`
					},
					attributes = {
						{
							name = `Color{ v115 }{ v119 }Color3`,
							value = v118.Color3
						},
						{
							name = `Color{ v115 }{ v119 }Transparency`,
							value = v118.Transparency
						}
					}
				})
			end
		end
	end

	for v120, v121 in p19 do
		local v122 = kebabToPascal(v120)

		table.insert(t12, {
			pseudo = "UIStroke",
			tag = `stroke-{ v120 }`,
			properties = {
				Color = `$Color{ v122 }BorderColor3`,
				Transparency = `$Color{ v122 }BorderTransparency`
			},
			attributes = {
				{
					name = `Color{ v122 }BorderColor3`,
					value = v121.Border.Color3
				},
				{
					name = `Color{ v122 }BorderTransparency`,
					value = v121.Border.Transparency
				}
			}
		})
	end

	for v123, v124 in {
		center = Enum.BorderStrokePosition.Center,
		inner = Enum.BorderStrokePosition.Inner,
		outer = Enum.BorderStrokePosition.Outer
	} do
		table.insert(t12, {
			pseudo = "UIStroke",
			tag = `stroke-position-{ v123 }`,
			properties = {
				BorderStrokePosition = v124
			}
		})
	end

	return t12
end
local function ContentRules(p20, p21) -- line: 542
	-- upvalues: t9 (copy), tokenAttributePascalName (copy), kebabToPascal (copy)
	local t13 = {}

	for v128, v129 in p20 do
		if table.find(t9[v128], "content") then
			for v130, v131 in v129 do
				local v132 = tokenAttributePascalName(v128, v130)

				table.insert(t13, {
					tag = `content-{ v130 }`,
					properties = {
						ImageColor3 = `$Color{ v128 }{ v132 }Color3`,
						ImageTransparency = `$Color{ v128 }{ v132 }Transparency`,
						TextColor3 = `$Color{ v128 }{ v132 }Color3`,
						TextTransparency = `$Color{ v128 }{ v132 }Transparency`
					},
					attributes = {
						{
							name = `Color{ v128 }{ v132 }Color3`,
							value = v131.Color3
						},
						{
							name = `Color{ v128 }{ v132 }Transparency`,
							value = v131.Transparency
						}
					}
				})
			end
		end
	end

	for v133, v134 in p21 do
		local v135 = kebabToPascal(v133)

		table.insert(t13, {
			tag = `content-{ v133 }`,
			properties = {
				ImageColor3 = `$Color{ v135 }ForegroundColor3`,
				ImageTransparency = `$Color{ v135 }ForegroundTransparency`,
				TextColor3 = `$Color{ v135 }ForegroundColor3`,
				TextTransparency = `$Color{ v135 }ForegroundTransparency`
			},
			attributes = {
				{
					name = `Color{ v135 }ForegroundColor3`,
					value = v134.Foreground.Color3
				},
				{
					name = `Color{ v135 }ForegroundTransparency`,
					value = v134.Foreground.Transparency
				}
			}
		})
	end

	return t13
end
local function DeprecatedColorRules(p22) -- line: 598
	-- upvalues: tokenAttributePascalName (copy)
	local t14 = {}

	for v138, v139 in p22.System do
		local v140 = v138:sub(8)
		local v141 = tokenAttributePascalName("System", v138)

		table.insert(t14, {
			tag = `bg-{ v140 }`,
			properties = {
				BackgroundColor3 = `$ColorSystem{ v141 }Color3`,
				BackgroundTransparency = `$ColorSystem{ v141 }Transparency`
			},
			attributes = {
				{
					name = `ColorSystem{ v141 }Color3`,
					value = v139.Color3
				},
				{
					name = `ColorSystem{ v141 }Transparency`,
					value = v139.Transparency
				}
			},
			deprecatedFor = `bg-{ v138 }`
		})

		if v140 ~= "emphasis" then
			table.insert(t14, {
				tag = `content-{ v140 }`,
				properties = {
					ImageColor3 = `$ColorSystem{ v141 }Color3`,
					ImageTransparency = `$ColorSystem{ v141 }Transparency`,
					TextColor3 = `$ColorSystem{ v141 }Color3`,
					TextTransparency = `$ColorSystem{ v141 }Transparency`
				},
				attributes = {
					{
						name = `ColorSystem{ v141 }Color3`,
						value = v139.Color3
					},
					{
						name = `ColorSystem{ v141 }Transparency`,
						value = v139.Transparency
					}
				},
				deprecatedFor = `content-{ v138 }`
			})
			table.insert(t14, {
				pseudo = "UIStroke",
				tag = `stroke-{ v140 }`,
				properties = {
					Color = `$ColorSystem{ v141 }Color3`,
					Transparency = `$ColorSystem{ v141 }Transparency`
				},
				attributes = {
					{
						name = `ColorSystem{ v141 }Color3`,
						value = v139.Color3
					},
					{
						name = `ColorSystem{ v141 }Transparency`,
						value = v139.Transparency
					}
				},
				deprecatedFor = `stroke-{ v138 }`
			})
		end
	end

	return t14
end
local function EngineDefaultBypassRules() -- line: 677
	return {
		{
			tag = "x-default-transparency",
			properties = {
				BackgroundTransparency = 0
			}
		},
		{
			tag = "x-default-text-size",
			properties = {
				TextSize = 8
			}
		}
	}
end
local function ListLayoutRules() -- line: 694
	-- upvalues: Dash (copy)
	local t15 = {
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
	local t16 = {
		{
			tag = "align-x-left",
			pseudo = "UIListLayout",
			properties = {
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}
		},
		{
			tag = "align-x-center",
			pseudo = "UIListLayout",
			properties = {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}
		},
		{
			tag = "align-x-right",
			pseudo = "UIListLayout",
			properties = {
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}
		},
		{
			tag = "align-y-top",
			pseudo = "UIListLayout",
			properties = {
				VerticalAlignment = Enum.VerticalAlignment.Top
			}
		},
		{
			tag = "align-y-center",
			pseudo = "UIListLayout",
			properties = {
				VerticalAlignment = Enum.VerticalAlignment.Center
			}
		},
		{
			tag = "align-y-bottom",
			pseudo = "UIListLayout",
			properties = {
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}
		}
	}
	local t17 = {
		{
			tag = "wrap",
			pseudo = "UIListLayout",
			properties = {
				Wraps = true
			}
		},
		{
			tag = "no-wrap",
			pseudo = "UIListLayout",
			properties = {
				Wraps = false
			}
		}
	}
	local t18 = {}

	for v146, v147 in {
		none = Enum.UIFlexAlignment.None,
		fill = Enum.UIFlexAlignment.Fill,
		around = Enum.UIFlexAlignment.SpaceAround,
		between = Enum.UIFlexAlignment.SpaceBetween,
		evenly = Enum.UIFlexAlignment.SpaceEvenly
	} do
		table.insert(t18, {
			pseudo = "UIListLayout",
			tag = `flex-{ v146 }`,
			properties = {
				HorizontalFlex = v147,
				VerticalFlex = v147
			}
		})
		table.insert(t18, {
			pseudo = "UIListLayout",
			tag = `flex-x-{ v146 }`,
			properties = {
				HorizontalFlex = v147
			}
		})
		table.insert(t18, {
			pseudo = "UIListLayout",
			tag = `flex-y-{ v146 }`,
			properties = {
				VerticalFlex = v147
			}
		})
	end

	local t19 = {}

	for v149, v150 in {
		auto = Enum.ItemLineAlignment.Automatic,
		start = Enum.ItemLineAlignment.Start,
		center = Enum.ItemLineAlignment.Center,
		["end"] = Enum.ItemLineAlignment.End,
		stretch = Enum.ItemLineAlignment.Stretch
	} do
		table.insert(t19, {
			pseudo = "UIListLayout",
			tag = `items-{ v149 }`,
			properties = {
				ItemLineAlignment = v150
			}
		})
	end

	return Dash.joinArrays(t15, t16, t17, t18, t19)
end
local function FlexItemRules() -- line: 836
	-- upvalues: Dash (copy)
	local t20 = {
		{
			tag = "grow",
			pseudo = "UIFlexItem",
			properties = {
				FlexMode = Enum.UIFlexMode.Grow
			}
		},
		{
			tag = "shrink",
			pseudo = "UIFlexItem",
			properties = {
				FlexMode = Enum.UIFlexMode.Shrink
			}
		},
		{
			tag = "fill",
			pseudo = "UIFlexItem",
			properties = {
				FlexMode = Enum.UIFlexMode.Fill
			}
		},
		{
			tag = "no-flex",
			pseudo = "UIFlexItem",
			properties = {
				FlexMode = Enum.UIFlexMode.None
			}
		}
	}
	local t21 = {}
	local t22 = {}

	for v154 in {
		1,
		2,
		3,
		4,
		5
	} do
		table.insert(t21, {
			pseudo = "UIFlexItem",
			tag = `grow-{ v154 }`,
			properties = {
				FlexMode = Enum.UIFlexMode.Custom,
				GrowRatio = v154
			}
		})
		table.insert(t22, {
			pseudo = "UIFlexItem",
			tag = `shrink-{ v154 }`,
			properties = {
				FlexMode = Enum.UIFlexMode.Custom,
				ShrinkRatio = v154
			}
		})
	end

	local t23 = {}

	for v156, v157 in {
		auto = Enum.ItemLineAlignment.Automatic,
		start = Enum.ItemLineAlignment.Start,
		center = Enum.ItemLineAlignment.Center,
		["end"] = Enum.ItemLineAlignment.End,
		stretch = Enum.ItemLineAlignment.Stretch
	} do
		table.insert(t23, {
			pseudo = "UIFlexItem",
			tag = `self-{ v156 }`,
			properties = {
				ItemLineAlignment = v157
			}
		})
	end

	return Dash.joinArrays(t20, t21, t22, t23)
end
local function TextRules() -- line: 915
	local t24 = {}

	for v159, v160 in {
		left = Enum.TextXAlignment.Left,
		center = Enum.TextXAlignment.Center,
		right = Enum.TextXAlignment.Right
	} do
		table.insert(t24, {
			tag = `text-align-x-{ v159 }`,
			properties = {
				TextXAlignment = v160
			}
		})
	end

	for v161, v162 in {
		top = Enum.TextYAlignment.Top,
		center = Enum.TextYAlignment.Center,
		bottom = Enum.TextYAlignment.Bottom
	} do
		table.insert(t24, {
			tag = `text-align-y-{ v161 }`,
			properties = {
				TextYAlignment = v162
			}
		})
	end

	for v163, v164 in {
		none = Enum.TextTruncate.None,
		["end"] = Enum.TextTruncate.AtEnd,
		split = Enum.TextTruncate.SplitWord
	} do
		table.insert(t24, {
			tag = `text-truncate-{ v163 }`,
			properties = {
				TextTruncate = v164
			}
		})
	end

	table.insert(t24, {
		tag = "text-wrap",
		properties = {
			TextWrapped = true
		}
	})
	table.insert(t24, {
		tag = "text-no-wrap",
		properties = {
			TextWrapped = false
		}
	})

	return t24
end
local function AutomaticSizeRules() -- line: 980
	local t25 = {}

	for v166, v167 in {
		none = Enum.AutomaticSize.None,
		x = Enum.AutomaticSize.X,
		y = Enum.AutomaticSize.Y,
		xy = Enum.AutomaticSize.XY
	} do
		table.insert(t25, {
			tag = `auto-{ v166 }`,
			properties = {
				AutomaticSize = v167
			}
		})
	end

	return t25
end
local function PositionRules() -- line: 1002
	local t26 = {}
	local t27 = {
		left = 0,
		center = 0.5,
		right = 1
	}
	local t28 = {
		top = 0,
		center = 0.5,
		bottom = 1
	}

	for v171, v172 in t27 do
		for v173, v174 in t28 do
			table.insert(t26, {
				tag = `position-{ v173 }-{ v171 }`,
				properties = {
					Position = UDim2.fromScale(v172, v174)
				}
			})
		end
	end

	return t26
end
local function AnchorPointRules() -- line: 1020
	local t29 = {}
	local t30 = {
		left = 0,
		center = 0.5,
		right = 1
	}
	local t31 = {
		top = 0,
		center = 0.5,
		bottom = 1
	}

	for v178, v179 in t30 do
		for v180, v181 in t31 do
			table.insert(t29, {
				tag = `anchor-{ v180 }-{ v178 }`,
				properties = {
					AnchorPoint = Vector2.new(v179, v181)
				}
			})
		end
	end

	return t29
end
local function ClipsDescendantRules() -- line: 1038
	return {
		{
			tag = "clip",
			properties = {
				ClipsDescendants = true
			}
		},
		{
			tag = "no-clip",
			properties = {
				ClipsDescendants = false
			}
		}
	}
end
local function roundDecimals(n4: number, n5: number) -- line: 1055
	local v184 = 10 ^ n5

	return math.round(n4 * v184) / v184
end
local function AspectRatioRules() -- line: 1060
	local t32 = {}

	for _, v187 in {
		{
			1,
			1
		},
		{
			5,
			4
		},
		{
			4,
			3
		},
		{
			3,
			2
		},
		{
			16,
			9
		},
		{
			2,
			1
		}
	} do
		table.insert(t32, {
			pseudo = "UIAspectRatioConstraint",
			tag = `aspect-{ v187[1] }-{ v187[2] }`,
			properties = {
				AspectRatio = math.round(v187[1] / v187[2] * 1000) / 1000
			}
		})

		if v187[1] ~= v187[2] then
			table.insert(t32, {
				pseudo = "UIAspectRatioConstraint",
				tag = `aspect-{ v187[2] }-{ v187[1] }`,
				properties = {
					AspectRatio = math.round(v187[2] / v187[1] * 1000) / 1000
				}
			})
		end
	end

	return t32
end

return {
	rulesGenerator = function(p23, p24) -- line: 1088
		-- upvalues: Dash (copy), DefaultRules (copy), EngineDefaultBypassRules (copy), FlexItemRules (copy), TextRules (copy), AutomaticSizeRules (copy), PositionRules (copy), AnchorPointRules (copy), ClipsDescendantRules (copy), AspectRatioRules (copy), DefaultSizeRules (copy), ListLayoutRules (copy), ListLayoutSpacingRules (copy), cornerRules (copy), kebabToPascal (copy), SizeRules (copy), StrokeSizeRules (copy), TypographyRules (copy), PaddingRules (copy), DefaultColorRules (copy), DeprecatedColorRules (copy), BackgroundRules (copy), StrokeRules (copy), ContentRules (copy)
		local colors = p24.colors
		local variants = p24.variants
		local gaps = p24.gaps
		local gutters = p24.gutters
		local radii = p24.radii
		local sizes = p24.sizes
		local strokes = p24.strokes
		local typography = p24.typography
		local paddings = p24.paddings
		local margins = p24.margins

		return Dash.joinArrays(DefaultRules(p23), EngineDefaultBypassRules(), FlexItemRules(), TextRules(), AutomaticSizeRules(), PositionRules(), AnchorPointRules(), ClipsDescendantRules(), (AspectRatioRules())), Dash.joinArrays(DefaultSizeRules(typography["body-large"], p23.Config.Text.NominalScale), ListLayoutRules(), ListLayoutSpacingRules(gaps, gutters), cornerRules(radii, function(p25) -- line: 130
			-- upvalues: kebabToPascal (copy)
			local v205 = kebabToPascal(p25.name)

			return {
				cornerValue = `$Radius{ v205 }`,
				attributes = {{
					name = `Radius{ v205 }`,
					value = p25.size
				}}
			}
		end), SizeRules(sizes), StrokeSizeRules(strokes), TypographyRules(typography, p23.Config.Text.NominalScale), (PaddingRules(paddings, margins))), (Dash.joinArrays(DefaultColorRules(p23), DeprecatedColorRules(colors), BackgroundRules(colors, variants), StrokeRules(colors, variants), (ContentRules(colors, variants))))
	end
}
