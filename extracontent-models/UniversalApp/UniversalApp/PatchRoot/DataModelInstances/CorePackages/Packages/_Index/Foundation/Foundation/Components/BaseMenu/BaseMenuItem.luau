local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Logger = require(Foundation.Utility.Logger)
local React = require(parent.React)

local Constants = require(Foundation.Constants)

local Icon = require(Foundation.Components.Icon)
local Popover = require(Foundation.Components.Popover)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useTokens = require(Foundation.Providers.Style.useTokens)

local useBindable = require(Foundation.Utility.useBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local ReactUtils = require(parent.ReactUtils)
local useComposedRef = ReactUtils.useComposedRef

require(Foundation.Enums.InputSize)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)

local Flags = require(Foundation.Utility.Flags)

local BaseMenuItemAccessory = require(script.Parent.BaseMenuItemAccessory)
local BaseMenuContext = require(script.Parent.BaseMenuContext)
local BaseMenuScrollContainer = require(script.Parent.BaseMenuScrollContainer)

local useBaseMenuItemVariants = require(script.Parent.useBaseMenuItemVariants)
local useMenuItemHover = require(script.Parent.useMenuItemHover)

local v = { isChecked = false }

local function resolveAccessory(iconName) -- 2 equivalent calls inferred from this helper
	if iconName == nil then
		return nil
	end

	if type(iconName) == "string" then
		return { iconName = iconName }
	end

	return iconName
end

local function getInputSinkAll()
	if not Flags.FoundationGuiObjectInputSinkProperty then
		return nil
	end

	local success, engineFeature = pcall(game.GetEngineFeature, game, "GuiObjectInputSink")

	if not (success and engineFeature) then
		return nil
	end

	local success2, result = pcall(function()
		return Enum.InputSink.All
	end)
	return if success2 then result else nil
end

local inputSinkAll = getInputSinkAll()

local function getContainerPadding(container, flag: boolean)
	local v2

	if flag then
		v2 = container.paddingLeftWithCheck
	else
		v2 = container.paddingLeftWithoutCheck
	end

	return {
		left = UDim.new(0, v2 or 0),
		right = UDim.new(0, container.paddingRight or 0)
	}
end

local function BaseMenuItem(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = React.useContext(BaseMenuContext)
	local v4

	if v2.menuHasLeading == nil then
		v4 = v3.hasLeading == true
	else
		v4 = v2.menuHasLeading
	end

	local v5

	if v2.menuHasCheck == nil then
		v5 = v2.isChecked == true
	else
		v5 = v2.menuHasCheck
	end

	local tokens = useTokens()
	local size = v2.size or v3.size
	local depth = v3.depth

	local isSubmenu = v2.children ~= nil
	local isOpen = isSubmenu and v3.hoverOpenPath[depth] == v2.id

	local accessory = resolveAccessory(v2.leading or v2.icon) -- inferred equivalent call
	local accessory2 = resolveAccessory(v2.trailing) -- inferred equivalent call
	local v6 = v3.maxHeight ~= nil
	local v7 = useBaseMenuItemVariants(tokens, size, v6)

	local ref = React.useRef(nil)
	local v8

	if v2.isChecked == true then
		v8 = not isSubmenu
	else
		v8 = false
	end

	local state, setState = React.useState(false)
	local setHasLeading = React.useCallback(function()
		setState(true)
	end, {})
	local v9 = accessory ~= nil
	React.useEffect(function()
		if v9 and v3.setHasLeading then
			v3.setHasLeading()
		end
	end, { v9, v3.setHasLeading })

	useMenuItemHover({
		itemRef = ref,
		id = v2.id,
		depth = depth,
		isSubmenu = isSubmenu,
		isDisabled = v2.isDisabled,
		hoverOpenAtDepth = v3.hoverOpenAtDepth,
		hoverCloseAtDepth = v3.hoverCloseAtDepth
	})

	local onActivated = React.useCallback(function()
		if isSubmenu then
			if v2.isDisabled then
				return
			end

			if v3.hoverOpenAtDepth and not isOpen then
				v3.hoverOpenAtDepth(depth, v2.id, true)
			end
		else
			if v3.hoverReset then
				v3.hoverReset()
			end

			local onActivated

			if v2.onActivated then
				onActivated = v2.onActivated
			else
				onActivated = v3.onActivated
			end

			if onActivated then
				onActivated(v2.id)
			else
				Logger:warning("Menu should have either onActivated on itself or on all of its children")
			end

			if depth > 1 and v3.onNestedLeafActivated then
				v3.onNestedLeafActivated()
			end
		end
	end, {
		isSubmenu,
		v2.isDisabled,
		isOpen,
		depth,
		v2.id,
		v2.onActivated,
		v3.onActivated,
		v3.onNestedLeafActivated,
		v3.hoverOpenAtDepth,
		v3.hoverReset
	})

	local onPressedOutside = React.useCallback(function()
		if v3.hoverReset then
			v3.hoverReset()
		end
	end, { v3.hoverReset })

	local maxHeight = useBindable(v3.maxHeight)

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, tokens.Radius.Small),
			offset = tokens.Size.Size_200,
			borderWidth = tokens.Stroke.Thicker
		}
	end, { tokens })

	local ref2 = useComposedRef(ref, p2)

	local containerPadding = getContainerPadding(v7.container, v5)
	local layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder
	}

	local gap = v7.wrapper and v7.wrapper.gap or 0
	local check

	if v5 then
		local createElement = React.createElement
		local v10 = {
			LayoutOrder = 1,
			tag = `{v7.slotAlign.tag} {v7.check.tag}`,
			testId = `{v2.testId}--check-column`
		}
		local check2

		if v8 then
			check2 = React.createElement(Icon, {
				name = BuilderIcons.Icon.Check,
				style = v7.check.style,
				size = v7.check.size,
				testId = `{v2.testId}--checkmark`
			})
		end

		check = createElement(View, v10, { Check = check2 })
	end

	local leading = nil

	if accessory == nil then
		if v4 then
			leading = React.createElement(View, {
				LayoutOrder = 1,
				tag = `{v7.slotAlign.tag} {v7.icon.tag}`
			})
		end
	else
		leading = React.createElement(BaseMenuItemAccessory, {
			LayoutOrder = 1,
			accessory = accessory,
			iconVariant = v7.icon,
			size = size,
			tokens = tokens,
			testId = `{v2.testId}--leading`
		})
	end

	local element = React.createElement(Text, { LayoutOrder = 2, Text = v2.text, tag = v7.text.tag })

	local trailing = nil

	if isSubmenu then
		trailing = React.createElement(Icon, {
			LayoutOrder = 3,
			name = BuilderIcons.Icon.ChevronSmallRight,
			style = v7.check.style,
			size = v7.chevron.size,
			testId = `{v2.testId}--chevron`
		})
	elseif accessory2 ~= nil then
		trailing = React.createElement(BaseMenuItemAccessory, {
			LayoutOrder = 3,
			accessory = accessory2,
			iconVariant = v7.icon,
			size = size,
			tokens = tokens,
			testId = `{v2.testId}--trailing`
		})
	end

	local createElement = React.createElement
	local groupTransparency

	if v2.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	local element2 = createElement(View, withCommonProps(v2, {
		GroupTransparency = groupTransparency,
		isDisabled = v2.isDisabled,
		onActivated = onActivated,
		selection = {
			Selectable = not v2.isDisabled
		},
		cursor = cursor,
		tag = v7.container.tag,
		padding = containerPadding,
		layout = layout,
		ref = ref2
	}), {
		Check = check,
		Wrapper = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-xy",
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, gap),
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}, { Leading = leading, Title = element, Trailing = trailing })
	})

	local v10 = React.useMemo(function()
		return {
			onActivated = v3.onActivated,
			onNestedLeafActivated = v3.onNestedLeafActivated,
			size = size,
			hasLeading = state,
			setHasLeading = setHasLeading,
			hoverOpenPath = v3.hoverOpenPath,
			hoverOpenAtDepth = v3.hoverOpenAtDepth,
			hoverCloseAtDepth = v3.hoverCloseAtDepth,
			hoverReset = v3.hoverReset,
			depth = depth + 1,
			maxHeight = v3.maxHeight
		}
	end, {
		v3.onActivated,
		v3.onNestedLeafActivated,
		size,
		state,
		v3.hoverOpenPath,
		v3.hoverOpenAtDepth,
		v3.hoverCloseAtDepth,
		v3.hoverReset,
		depth,
		v3.maxHeight
	})

	if not isSubmenu then
		return element2
	end

	local standard = tokens.Stroke.Standard
	local size2 = v7.groupPadding.size

	local element3 = React.createElement(BaseMenuContext.Provider, { value = v10 }, v2.children)
	local v11

	if v6 then
		v11 = React.createElement(BaseMenuScrollContainer, {
			maxHeight = maxHeight,
			scrollViewProps = { tag = v7.submenuContent.tag, InputSink = inputSinkAll }
		}, element3)
	else
		v11 = React.createElement(View, { tag = v7.submenuContent.tag, InputSink = inputSinkAll }, element3)
	end

	return React.createElement(React.Fragment, nil, {
		Item = element2,
		Submenu = React.createElement(Popover.Root, {
			isOpen = isOpen,
			testId = `{v2.testId}--submenu`
		}, {
			Anchor = React.createElement(Popover.Anchor, { anchorRef = ref }),
			Content = React.createElement(Popover.Content, {
				side = {
					position = PopoverSide.Right,
					offset = size2 / 2 + standard
				},
				align = {
					position = PopoverAlign.Start,
					offset = -size2
				},
				hasArrow = false,
				onPressedOutside = onPressedOutside,
				backgroundStyle = tokens.Color.Surface.Surface_200,
				radius = Radius.Medium
			}, v11)
		})
	})
end

return React.memo(React.forwardRef(BaseMenuItem))
