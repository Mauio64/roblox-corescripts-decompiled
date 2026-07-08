local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local Components = Foundation.Components
local Checkbox = require(Components.Checkbox)
local Divider = require(Components.Divider)
local Icon = require(Components.Icon)
local InputSize = require(Foundation.Enums.InputSize)
local ListItemInputType = require(Foundation.Enums.ListItemInputType)
local RadioGroup = require(Components.RadioGroup)
local Text = require(Components.Text)
local Toggle = require(Components.Toggle)

require(Foundation.Components.Types)

local View = require(Components.View)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local useListItemVariants = require(script.Parent.useListItemVariants)
local ListAccessory = require(script.Parent.ListAccessory)
local useListAccessoryVariants = require(script.Parent.useListAccessoryVariants)
local useList = require(script.Parent.Parent.useList)
local t1 = {}

local function ListItem(p1, p2) -- line: 56
	-- upvalues: withDefaults (copy), t1 (copy), useList (copy), InputSize (copy), useTokens (copy), useListItemVariants (copy), useListAccessoryVariants (copy), React (copy), View (copy), ListAccessory (copy), Text (copy), escapeRichText (copy), Icon (copy), BuilderIcons (copy), ListItemInputType (copy), RadioGroup (copy), Checkbox (copy), Toggle (copy), Divider (copy)
	local v26 = withDefaults(p1, t1)
	local v27 = useList()
	local v28 = v27.size or InputSize.Medium
	local v29 = useTokens()
	local v30 = useListItemVariants(v29, v28)
	local v31 = useListAccessoryVariants(v29, v28, "Icon")
	local v32 = typeof(v26.onActivated) == "table" and v26.onActivated.onActivated ~= nil
	local v33 = React.useMemo(function() -- line: 68
		-- upvalues: v32 (copy), v26 (copy)
		if v32 then
			return v26.onActivated.onActivated
		end

		if v26.onActivated ~= nil then
			return v26.onActivated
		end

		return nil
	end, {
		v26.onActivated,
		v32
	})
	local v34 = React.useMemo(function() -- line: 77
		-- upvalues: v32 (copy), v26 (copy)
		if v32 then
			return v26.onActivated.inputType
		end

		return nil
	end, {
		v26.onActivated,
		v32
	})
	local v35 = React.useMemo(function() -- line: 84
		-- upvalues: v32 (copy), v26 (copy)
		if v32 then
			return v26.onActivated.isChecked
		end

		return nil
	end, {
		v26.onActivated,
		v32
	})
	local v36 = React.useMemo(function() -- line: 91
		-- upvalues: v26 (copy)
		if typeof(v26.title) == "string" then
			return v26.title
		end

		if typeof(v26.title) == "table" then
			return v26.title.title
		end

		return nil
	end, { v26.title })
	local v37 = React.useMemo(function() -- line: 100
		-- upvalues: v26 (copy)
		if typeof(v26.title) == "table" then
			if v26.title.title ~= nil then
				return v26.title.metadata
			end

			return nil
		end

		return nil
	end, { v26.title })
	local v38 = React.useMemo(function() -- line: 108
		-- upvalues: v36 (copy)
		return v36 and string.gsub(v36, "%s+", "-") or ""
	end, { v36 })

	v26.testId = if not v26.testId then `{ v27.testId }--item-{ v38 }` else v26.testId

	local v39 = React.useCallback(function() -- line: 113
		-- upvalues: v33 (copy)
		if v33 then
			v33()
		end
	end, { v33 })

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = v26.LayoutOrder,
		ref = p2
	}, {
		HoverWrapper = React.createElement(View, {
			tag = "size-full-0 auto-y padding-y-xsmall",
			LayoutOrder = 1,
			padding = if not v27.isContained then {
				left = UDim.new(0, if not v27.hasMargin then -v29.Padding.Small else v29.Padding.Small),
				right = UDim.new(0, if not v27.hasMargin then -v29.Padding.Small else v29.Padding.Small)
			} else v29.Padding.Small
		}, {
			ListItemContainer = React.createElement(View, {
				onActivated = v33,
				tag = {
					["size-full-0 auto-y radius-medium"] = true,
					["margin-x-small"] = v27.hasMargin,
					["padding-x-small"] = not v27.hasMargin
				}
			}, {
				ListItem = React.createElement(View, {
					tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small radius-medium",
					testId = v26.testId
				}, {
					LeadingContainer = if not v26.leading then nil else React.createElement(ListAccessory, {
						LayoutOrder = 0,
						config = v26.leading,
						size = v28,
						testId = `{ v26.testId }--leading-accessory`
					}),
					Content = React.createElement(View, {
						tag = "row flex-between align-x-center align-y-center fill gap-medium auto-y",
						LayoutOrder = 1
					}, {
						TextContainer = React.createElement(View, {
							tag = "col fill gap-small auto-y padding-y-xsmall",
							LayoutOrder = 1
						}, {
							TitleContainer = if not v36 then nil else React.createElement(View, {
								tag = "col gap-xsmall auto-xy",
								LayoutOrder = 0
							}, {
								Title = if not v36 then nil else React.createElement(Text, {
									RichText = true,
									LayoutOrder = 0,
									Text = escapeRichText(v36),
									tag = v30.title.tag
								}),
								Metadata = if not v37 then nil else React.createElement(Text, {
									RichText = true,
									LayoutOrder = 1,
									Text = v37,
									tag = v30.metadata.tag
								})
							}),
							Description = v26.description and React.createElement(Text, {
								RichText = true,
								LayoutOrder = 1,
								Text = v26.description,
								tag = v30.description.tag
							})
						}),
						TrailingContainer = if not v26.trailing then nil else React.createElement(View, {
							tag = "align-x-center align-y-center auto-xy",
							LayoutOrder = 2
						}, v26.trailing),
						ActivatedIconContainer = if not v26.onActivated then nil else React.createElement(View, {
							tag = "align-x-center align-y-center auto-xy",
							LayoutOrder = 3
						}, {
							ActivatedIcon = if v34 ~= nil then if v34 ~= ListItemInputType.Radio then React.createElement(if v34 ~= ListItemInputType.Checkbox then Toggle else Checkbox, {
								label = "",
								Selectable = false,
								onActivated = v39,
								isChecked = v35,
								size = v28
							}) else React.createElement(RadioGroup.Root, {
								Selectable = false,
								value = not v35 and "" or "radio",
								onValueChanged = v39
							}, React.createElement(RadioGroup.Item, {
								value = "radio",
								label = "",
								size = v28
							})) else React.createElement(Icon, {
								name = BuilderIcons.Icon.ChevronLargeRight,
								size = v30.icon.size,
								testId = `{ v26.testId }--activated-icon`
							})
						})
					})
				})
			})
		}),
		Divider = if not v27.hasDivider or v26.LayoutOrder == v27.lastLayoutOrder then nil else if not v27.isInset then React.createElement(Divider, {
			LayoutOrder = 2
		}) else React.createElement(View, {
			tag = "row size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			LeadingSpacer = React.createElement(View, {
				LayoutOrder = 0,
				Size = UDim2.fromOffset((not v27.hasMargin and 0 or v29.Padding.Small + v29.Margin.Small) + (not v26.leading and 0 or v31.container.Size.X.Offset + v29.Gap.Medium), 0)
			}),
			DividerLine = React.createElement(View, {
				tag = "fill auto-y",
				LayoutOrder = 1
			}, React.createElement(Divider))
		})
	})
end

return React.memo(React.forwardRef(ListItem))
