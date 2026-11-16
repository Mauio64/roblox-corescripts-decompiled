local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Components = Foundation.Components
local Checkbox = require(Components.Checkbox)
local Divider = require(Components.Divider)
local Flags = require(Foundation.Utility.Flags)
local Icon = require(Components.Icon)
local InputSize = require(Foundation.Enums.InputSize)
local ListItemInputType = require(Foundation.Enums.ListItemInputType)
local RadioGroup = require(Components.RadioGroup)
local Text = require(Components.Text)
local Toggle = require(Components.Toggle)
require(Foundation.Components.Types)
local View = require(Components.View)
local devAssert = require(Foundation.Utility.devAssert)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local useListItemVariants = require(script.Parent.useListItemVariants)

local ListAccessory = require(script.Parent.ListAccessory)
local useListAccessoryVariants = require(script.Parent.useListAccessoryVariants)

local useList = require(script.Parent.Parent.useList)

local v = {
	[InputSize.XSmall] = "gap-xxsmall",
	[InputSize.Small] = "gap-xxsmall",
	[InputSize.Medium] = "gap-xsmall",
	[InputSize.Large] = "gap-xsmall"
}

local v2 = {}

local function ListItem(p, ref)
	local v3 = withDefaults(p, v2)

	if Flags.FoundationListItemDecoupledInput then
		local v4 = v3.onActivated ~= nil
		local v5 = typeof(v3.input) == "table" and v3.input.onActivated ~= nil
		devAssert(not (v4 and v5), "ListItem: set `onActivated` on the item or on `input`, not both.")
	end

	local v4 = useList()
	local size = v4.size or InputSize.Medium

	local v5 = useTokens()

	local v6 = useListItemVariants(v5, size)
	local v7 = useListAccessoryVariants(v5, size, "Icon")

	local v8 = v[size]
	local v9

	if typeof(v3.onActivated) == "table" then
		v9 = v3.onActivated.onActivated ~= nil
	else
		v9 = false
	end

	local onActivated2 = React.useMemo(function()
		if v9 then
			return v3.onActivated.onActivated
		end

		return if v3.onActivated ~= nil then v3.onActivated else nil
	end, { v3.onActivated, v9 })

	local v10 = React.useMemo(function()
		if not Flags.FoundationListItemDecoupledInput then
			return nil
		end

		if v3.input == nil then
			if v9 then
				local onActivated = v3.onActivated
				return {
					type = onActivated.inputType or ListItemInputType.Chevron,
					isChecked = onActivated.isChecked
				}
			end

			if v3.onActivated == nil then
				return nil
			end

			return { type = ListItemInputType.Chevron }
		else
			if typeof(v3.input) ~= "table" then
				return { type = v3.input }
			end

			local input = v3.input
			return {
				type = input.type,
				isChecked = input.isChecked,
				onActivated = input.onActivated
			}
		end
	end, { v3.onActivated, v3.input, v9 })

	local v11 = React.useMemo(function()
		return if v9 then v3.onActivated.inputType else nil
	end, { v3.onActivated, v9 })

	local isChecked = React.useMemo(function()
		return if v9 then v3.onActivated.isChecked else nil
	end, { v3.onActivated, v9 })

	local v12 = React.useMemo(function()
		if typeof(v3.title) == "string" then
			return v3.title
		end

		if typeof(v3.title) == "table" then
			return v3.title.title
		end

		return nil
	end, { v3.title })

	local text = React.useMemo(function()
		if not (typeof(v3.title) == "table" and v3.title.title ~= nil) then
			return nil
		end

		return v3.title.metadata
	end, { v3.title })

	local v13 = React.useMemo(function()
		return v12 and string.gsub(v12, "%s+", "-") or ""
	end, { v12 })
	local testId

	if v3.testId then
		testId = v3.testId
	else
		testId = `{v4.testId}--item-{v13}`
	end

	v3.testId = testId
	local v14

	if Flags.FoundationListItemDecoupledInput then
		if v10 == nil then
			v14 = false
		else
			v14 = v10.type ~= ListItemInputType.None
		end
	else
		v14 = v3.onActivated ~= nil
	end

	if Flags.FoundationListItemDecoupledInput then
		v11 = if v10 then v10.type else nil
	end

	if Flags.FoundationListItemDecoupledInput then
		isChecked = if v10 then v10.isChecked else nil
	end

	local onActivated = React.useCallback(function(flag: boolean)
		if Flags.FoundationListItemDecoupledInput and v10 and v10.onActivated then
			v10.onActivated(flag)
		elseif onActivated2 then
			onActivated2()
		end
	end, { v10, onActivated2 })

	local onValueChanged = React.useCallback(function(p2: string)
		onActivated(p2 == "radio")
	end, { onActivated })

	local createElement = React.createElement
	local v15 = { tag = "col size-full-0 auto-y", LayoutOrder = v3.LayoutOrder, ref = ref }

	local createElement2 = React.createElement
	local padding

	if v4.isContained then
		padding = v5.Padding.Small
	else
		padding = { left = 0, right = 0 }
		local v16

		if v4.hasMargin then
			v16 = v5.Padding.Small
		else
			v16 = -v5.Padding.Small
		end

		padding.left = UDim.new(0, v16)
		local v17

		if v4.hasMargin then
			v17 = v5.Padding.Small
		else
			v17 = -v5.Padding.Small
		end

		padding.right = UDim.new(0, v17)
	end

	local createElement3 = React.createElement
	local v16 = {
		onActivated = onActivated2,
		onSecondaryActivated = v3.onSecondaryActivated,
		tag = {
			["size-full-0 auto-y radius-medium"] = true,
			["margin-x-small"] = v4.hasMargin,
			["padding-x-small"] = not v4.hasMargin
		}
	}

	local createElement4 = React.createElement
	local v17 = {
		testId = v3.testId,
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small radius-medium"
	}
	local leadingContainer

	if v3.leading then
		leadingContainer = React.createElement(ListAccessory, {
			config = v3.leading,
			size = size,
			testId = `{v3.testId}--leading-accessory`,
			LayoutOrder = 0
		})
	end

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local v18 = {
		tag = { ["col fill auto-y padding-y-xsmall"] = true, [v8] = true },
		LayoutOrder = 1
	}
	local titleContainer

	if v12 then
		local createElement7 = React.createElement
		local title

		if v12 then
			title = React.createElement(Text, {
				Text = escapeRichText(v12),
				RichText = true,
				tag = v6.title.tag,
				LayoutOrder = 0
			})
		end

		local metadata

		if text then
			metadata = React.createElement(Text, {
				Text = text,
				RichText = true,
				tag = v6.metadata.tag,
				LayoutOrder = 1
			})
		end

		titleContainer = createElement7(View, {
			tag = { ["col auto-xy"] = true, ["gap-xsmall"] = false },
			LayoutOrder = 0
		}, { Title = title, Metadata = metadata })
	end

	local v19 = {
		TextContainer = createElement6(View, v18, {
			TitleContainer = titleContainer,
			Description = v3.description and React.createElement(Text, {
				Text = v3.description,
				RichText = true,
				tag = v6.description.tag,
				LayoutOrder = 1
			})
		}),
		TrailingContainer = 0,
		ActivatedIconContainer = 0
	}
	local trailingContainer

	if v3.trailing then
		trailingContainer = React.createElement(
			View,
			{ tag = "align-x-center align-y-center auto-xy", LayoutOrder = 2 },
			v3.trailing
		)
	end

	v19.TrailingContainer = trailingContainer
	local activatedIconContainer

	if v14 then
		local createElement7 = React.createElement
		local activatedIcon

		if v11 == nil or Flags.FoundationListItemDecoupledInput and v11 == ListItemInputType.Chevron then
			activatedIcon = React.createElement(Icon, {
				name = BuilderIcons.Icon.ChevronLargeRight,
				size = v6.icon.size,
				testId = `{v3.testId}--activated-icon`
			})
		elseif v11 == ListItemInputType.Radio then
			activatedIcon = React.createElement(RadioGroup.Root, {
				value = isChecked and "radio" or "",
				onValueChanged = onValueChanged,
				Selectable = false
			}, React.createElement(RadioGroup.Item, { value = "radio", label = "", size = size }))
		else
			local createElement8 = React.createElement
			local v20

			if v11 == ListItemInputType.Checkbox then
				v20 = Checkbox
			else
				v20 = Toggle
			end

			activatedIcon = createElement8(v20, {
				label = "",
				onActivated = onActivated,
				isChecked = isChecked,
				size = size,
				Selectable = false
			})
		end

		activatedIconContainer = createElement7(
			View,
			{ tag = "align-x-center align-y-center auto-xy", LayoutOrder = 3 },
			{ ActivatedIcon = activatedIcon }
		)
	end

	v19.ActivatedIconContainer = activatedIconContainer
	local v20 = {
		HoverWrapper = createElement2(
			View,
			{ padding = padding, tag = "size-full-0 auto-y padding-y-xsmall", LayoutOrder = 1 },
			{
				ListItemContainer = createElement3(View, v16, {
					ListItem = createElement4(View, v17, {
						LeadingContainer = leadingContainer,
						Content = createElement5(
							View,
							{
								tag = "row flex-between align-x-center align-y-center fill gap-medium auto-y",
								LayoutOrder = 1
							},
							v19
						)
					})
				})
			}
		),
		Divider = 0
	}
	local divider

	if v4.hasDivider and v3.LayoutOrder ~= v4.lastLayoutOrder then
		if v4.isInset then
			divider = React.createElement(View, { tag = "row size-full-0 auto-y", LayoutOrder = 2 }, {
				LeadingSpacer = React.createElement(View, {
					Size = UDim2.fromOffset(
						(not v4.hasMargin and 0 or v5.Padding.Small + v5.Margin.Small) + (not v3.leading and 0 or v7.container.Size.X.Offset + v5.Gap.Medium),
						0
					),
					LayoutOrder = 0
				}),
				DividerLine = React.createElement(
					View,
					{ tag = "fill auto-y", LayoutOrder = 1 },
					React.createElement(Divider)
				)
			})
		else
			divider = React.createElement(Divider, { LayoutOrder = 2 })
		end
	end

	v20.Divider = divider
	return createElement(View, v15, v20)
end

return React.memo(React.forwardRef(ListItem))
