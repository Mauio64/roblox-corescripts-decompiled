local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = BuilderIcons.Icon

local ButtonVariant = require(Foundation.Enums.ButtonVariant)

local InputSize = require(Foundation.Enums.InputSize)

local LinkVariant = require(Foundation.Enums.LinkVariant)

local Icon2 = require(Foundation.Components.Icon)
local IconButton = require(Foundation.Components.IconButton)
local Link = require(Foundation.Components.Link)
local Menu = require(Foundation.Components.Menu)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local BreadcrumbAccessory = require(script.Parent.BreadcrumbAccessory)

local useBreadcrumbVariants = require(script.Parent.useBreadcrumbVariants)

local useTokens = require(Foundation.Providers.Style.useTokens)

local v = { size = InputSize.Medium, testId = "--foundation-breadcrumb" }

local function BreadcrumbItem(props)
	local item = props.item
	local variantProps = props.variantProps
	local testId = props.testId
	local text

	if props.isCurrent or item.onActivated == nil then
		local createElement = React.createElement
		local v2 = { Text = item.text, tag = 0, LayoutOrder = 1, testId = 0 }
		local tag

		if props.isCurrent then
			tag = variantProps.current.tag
		else
			tag = variantProps.label.tag
		end

		v2.tag = tag

		v2.testId = `{testId}--text`
		text = createElement(Text, v2)
	else
		text = React.createElement(Link, {
			text = item.text,
			onActivated = item.onActivated,
			variant = LinkVariant.Standard,
			size = props.size,
			hasUnderline = false,
			LayoutOrder = 1,
			testId = `{testId}--link`
		})
	end

	local createElement = React.createElement
	local v2 = {
		tag = variantProps.item.tag,
		ref = item.ref,
		onActivated = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local onActivated

	if props.hasDropdown then
		onActivated = props.onDropdownActivated
	end

	v2.onActivated = onActivated
	v2.LayoutOrder = props.LayoutOrder
	v2.testId = testId
	local leading

	if item.leading ~= nil then
		leading = React.createElement(BreadcrumbAccessory, {
			config = item.leading,
			variant = variantProps.accessory,
			LayoutOrder = 1,
			testId = `{testId}--leading`
		})
	end

	local createElement2 = React.createElement
	local v3 = { tag = variantProps.itemText.tag, LayoutOrder = 2 }
	local chevron

	if props.hasDropdown then
		chevron = React.createElement(Icon2, {
			name = Icon.ChevronLargeDown,
			size = variantProps.accessory.iconSize,
			style = variantProps.accessory.style,
			LayoutOrder = 2,
			testId = `{testId}--chevron`
		})
	end

	return createElement(View, v2, {
		Leading = leading,
		ItemText = createElement2(View, v3, { Text = text, Chevron = chevron })
	})
end

local function Breadcrumb(p, ref2)
	local v2 = withDefaults(p, v)
	local variantProps = useBreadcrumbVariants(useTokens(), v2.size)

	local count = #v2.items
	local v3 = count > 4
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not v3 then
			setState(false)
		end
	end, { v3 })

	local onActivated = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})
	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated2 = React.useCallback(function(p2)
		setState(false)
		local item = v2.items[p2]

		if item and item.onActivated then
			item.onActivated()
		end
	end, { v2.items })

	local v4 = React.useMemo(function()
		if v3 then
			return {
				{ item = v2.items[1], index = 1 },
				{ overflow = true },
				{ item = v2.items[count], index = count }
			}
		end

		local result = {}

		for k, item in v2.items do
			table.insert(result, { item = item, index = k })
		end

		return result
	end, { v2.items, count, v3 })

	local items = React.useMemo(function()
		local result = {}

		if v3 then
			for i = 2, count - 1 do
				local item = v2.items[i]
				table.insert(result, {
					id = i,
					text = item.text,
					isDisabled = item.onActivated == nil
				})
			end
		end

		return result
	end, { v2.items, count, v3 })

	local children = {}

	for k, v5 in v4 do
		if v5.overflow then
			children.Overflow = React.createElement(IconButton, {
				icon = Icon.ThreeDotsHorizontal,
				onActivated = onActivated,
				ref = ref,
				size = variantProps.overflow.size,
				variant = ButtonVariant.Standard,
				LayoutOrder = 2 * k - 1,
				testId = `{v2.testId}--overflow`
			})
		else
			local item = v5.item
			local index = v5.index
			local isCurrent = index == count
			local formatted = `Item{index}`
			local createElement = React.createElement
			local v6 = {
				item = item,
				isCurrent = isCurrent,
				hasDropdown = isCurrent and v2.onDropdownActivated ~= nil,
				onDropdownActivated = 0,
				size = 0,
				variantProps = 0,
				LayoutOrder = 0,
				testId = 0
			}
			local onDropdownActivated

			if isCurrent then
				onDropdownActivated = v2.onDropdownActivated
			end

			v6.onDropdownActivated = onDropdownActivated
			v6.size = v2.size
			v6.variantProps = variantProps
			v6.LayoutOrder = 2 * k - 1
			v6.testId = item.testId or `{v2.testId}--item-{index}`
			children[formatted] = createElement(BreadcrumbItem, v6)
		end

		if k == #v4 then
			continue
		end

		local v6 = v5.overflow and "overflow" or v5.index
		children[`Separator{v6}`] = React.createElement(View, {
			tag = variantProps.separator.tag,
			LayoutOrder = 2 * k,
			testId = `{v2.testId}--separator-{v6}`
		}, {
			Slash = React.createElement(Text, {
				Text = "/",
				tag = variantProps.separator.textTag,
				LayoutOrder = 1,
				testId = `{v2.testId}--separator-{v6}--text`
			})
		})
	end

	if v3 then
		children.OverflowMenu = React.createElement(Menu, {
			isOpen = state,
			items = items,
			size = v2.size,
			anchorRef = ref,
			onActivated = onActivated2,
			onPressedOutside = onPressedOutside,
			LayoutOrder = #v4 * 2,
			testId = `{v2.testId}--overflow-menu`
		})
	end

	return React.createElement(View, withCommonProps(v2, {
		tag = variantProps.container.tag,
		ref = ref2
	}), children)
end

return React.memo(React.forwardRef(Breadcrumb))
