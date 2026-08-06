local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local isBuilderOrMigratedIcon = require(Foundation.Utility.iconMigrationUtils).isBuilderOrMigratedIcon
local Logger = require(Foundation.Utility.Logger)
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local Popover = require(Foundation.Components.Popover)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local useBindable = require(Foundation.Utility.useBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useComposedRef = require(FoundationParent.ReactUtils).useComposedRef

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
local t1 = {
	isChecked = false
}

local function resolveAccessory(p1) -- line: 71
	if p1 == nil then
		return nil
	end

	if type(p1) == "string" then
		return {
			iconName = p1
		}
	end

	return p1
end
local function getInputSinkAll() -- line: 84
	-- upvalues: Flags (copy)
	if not Flags.FoundationGuiObjectInputSinkProperty then
		return nil
	end

	local ok, result = pcall(game.GetEngineFeature, game, "GuiObjectInputSink")

	if not ok or not result then
		return nil
	end

	local ok2, result2 = pcall(function() -- line: 94
		return Enum.InputSink.All
	end)

	if ok2 then
		return result2
	end

	return nil
end

local v30 = getInputSinkAll()

local function getContainerPadding(p2, b1: boolean) -- line: 103
	local v40 = if not b1 then p2.paddingLeftWithoutCheck else p2.paddingLeftWithCheck

	return {
		left = UDim.new(0, v40 or 0),
		right = UDim.new(0, p2.paddingRight or 0)
	}
end
local function BaseMenuItem(p3, p4) -- line: 112
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), BaseMenuContext (copy), Flags (copy), useTokens (copy), useBaseMenuItemVariants (copy), useMenuItemHover (copy), Logger (copy), useBindable (copy), BuilderIcons (copy), useComposedRef (copy), getContainerPadding (copy), View (copy), Icon (copy), BaseMenuItemAccessory (copy), Text (copy), withCommonProps (copy), Constants (copy), isBuilderOrMigratedIcon (copy), Image (copy), BaseMenuScrollContainer (copy), v30 (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), Radius (copy)
	local v43 = withDefaults(p3, t1)
	local v44 = React.useContext(BaseMenuContext)
	local v45, v46

	if Flags.FoundationBaseMenuBeta then
		v45 = if v43.menuHasLeading == nil then v44.hasLeading == true else v43.menuHasLeading
		v46 = if v43.menuHasCheck == nil then v43.isChecked == true else v43.menuHasCheck
	else
		v45 = v44.hasLeading == true
		v46 = false
	end

	local v47 = useTokens()
	local v48 = v43.size or v44.size
	local depth = v44.depth
	local v50 = v43.children ~= nil
	local v51 = v50 and v44.hoverOpenPath[depth] == v43.id
	local v53

	if Flags.FoundationBaseMenuBeta then
		local v52 = v43.leading or v43.icon

		v53 = if v52 ~= nil then if type(v52) ~= "string" then v52 else {
			iconName = v52
		} else nil
	else
		v53 = nil
	end

	local v55

	if Flags.FoundationBaseMenuBeta then
		local trailing = v43.trailing

		v55 = if trailing ~= nil then if type(trailing) ~= "string" then trailing else {
			iconName = trailing
		} else nil
	else
		v55 = nil
	end

	local v56 = Flags.FoundationBaseMenuSubmenuMaxHeight and v44.maxHeight ~= nil
	local v57 = useBaseMenuItemVariants(v47, v48, not v50 and v43.isChecked, v56)
	local v58 = React.useRef(nil)
	local v59 = v43.isChecked == true and not v50
	local v60, v61 = React.useState(false)
	local v62 = React.useCallback(function() -- line: 143
		-- upvalues: v61 (copy)
		v61(true)
	end, {})
	local v63 = if not Flags.FoundationBaseMenuBeta then v43.icon ~= nil else v53 ~= nil

	React.useEffect(function() -- line: 148
		-- upvalues: v63 (copy), v44 (copy)
		if v63 and v44.setHasLeading then
			v44.setHasLeading()
		end
	end, {
		v63,
		v44.setHasLeading
	})
	useMenuItemHover({
		itemRef = v58,
		id = v43.id,
		depth = depth,
		isSubmenu = v50,
		isDisabled = v43.isDisabled,
		hoverOpenAtDepth = v44.hoverOpenAtDepth,
		hoverCloseAtDepth = v44.hoverCloseAtDepth
	})

	local v64 = React.useCallback(function() -- line: 165
		-- upvalues: v50 (copy), v43 (copy), v44 (copy), v51 (copy), depth (copy), Logger (copy)
		if v50 then
			if v43.isDisabled then
				return
			end

			if v44.hoverOpenAtDepth and not v51 then
				v44.hoverOpenAtDepth(depth, v43.id, true)

				return
			end
		else
			if v44.hoverReset then
				v44.hoverReset()
			end

			local v82 = if not v43.onActivated then v44.onActivated else v43.onActivated

			if not v82 then
				Logger:warning("Menu should have either onActivated on itself or on all of its children")
			else
				v82(v43.id)
			end

			if depth > 1 and v44.onNestedLeafActivated then
				v44.onNestedLeafActivated()
			end
		end
	end, {
		v50,
		v43.isDisabled,
		v51,
		depth,
		v43.id,
		v43.onActivated,
		v44.onActivated,
		v44.onNestedLeafActivated,
		v44.hoverOpenAtDepth,
		v44.hoverReset
	})
	local v65 = React.useCallback(function() -- line: 206
		-- upvalues: v44 (copy)
		if v44.hoverReset then
			v44.hoverReset()
		end
	end, { v44.hoverReset })
	local v66 = useBindable(v44.maxHeight)
	local v67 = React.useMemo(function() -- line: 214
		-- upvalues: v47 (copy)
		return {
			radius = UDim.new(0, v47.Radius.Small),
			offset = v47.Size.Size_200,
			borderWidth = v47.Stroke.Thicker
		}
	end, { v47 })
	local v68 = React.useMemo(function() -- line: 222
		-- upvalues: BuilderIcons (copy), v43 (copy)
		return BuilderIcons.Migration.uiblox[v43.icon]
	end, { v43.icon })
	local v69 = useComposedRef(v58, p4)
	local v77

	if Flags.FoundationBaseMenuBeta then
		local v70 = getContainerPadding(v57.container, v46)
		local t2 = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		local v72 = v57.wrapper and v57.wrapper.gap or 0
		local v73 = nil

		if v46 then
			v73 = React.createElement(View, {
				LayoutOrder = 1,
				tag = `{ v57.slotAlign.tag } { v57.check.tag }`,
				testId = `{ v43.testId }--check-column`
			}, {
				Check = if not v59 then nil else React.createElement(Icon, {
					name = BuilderIcons.Icon.Check,
					style = v57.check.style,
					size = v57.check.size,
					testId = `{ v43.testId }--checkmark`
				})
			})
		end

		local v74 = nil

		if v53 ~= nil then
			v74 = React.createElement(BaseMenuItemAccessory, {
				LayoutOrder = 1,
				accessory = v53,
				iconVariant = v57.icon,
				size = v48,
				tokens = v47,
				testId = `{ v43.testId }--leading`
			})
		elseif v45 then
			v74 = React.createElement(View, {
				LayoutOrder = 1,
				tag = `{ v57.slotAlign.tag } { v57.icon.tag }`
			})
		end

		local v75 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v43.text,
			tag = v57.text.tag
		})
		local v76 = nil

		if v50 then
			v76 = React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.ChevronSmallRight,
				style = v57.check.style,
				size = v57.chevron.size,
				testId = `{ v43.testId }--chevron`
			})
		elseif v55 ~= nil then
			v76 = React.createElement(BaseMenuItemAccessory, {
				LayoutOrder = 3,
				accessory = v55,
				iconVariant = v57.icon,
				size = v48,
				tokens = v47,
				testId = `{ v43.testId }--trailing`
			})
		end

		v77 = React.createElement(View, withCommonProps(v43, {
			GroupTransparency = if not v43.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			isDisabled = v43.isDisabled,
			onActivated = v64,
			selection = {
				Selectable = not v43.isDisabled
			},
			cursor = v67,
			tag = v57.container.tag,
			padding = v70,
			layout = t2,
			ref = v69
		}), {
			Check = v73,
			Wrapper = React.createElement(View, {
				LayoutOrder = 2,
				tag = "auto-xy",
				flexItem = {
					FlexMode = Enum.UIFlexMode.Fill
				},
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v72),
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Leading = v74,
				Title = v75,
				Trailing = v76
			})
		})
	else
		v77 = React.createElement(View, withCommonProps(v43, {
			GroupTransparency = if not v43.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			isDisabled = v43.isDisabled,
			onActivated = v64,
			selection = {
				Selectable = not v43.isDisabled
			},
			cursor = v67,
			tag = v57.container.tag,
			ref = v69
		}), {
			Icon = if not v43.icon and not v45 then nil else if not v43.icon or not isBuilderOrMigratedIcon(v43.icon) then React.createElement(Image, {
				LayoutOrder = 1,
				Image = v43.icon,
				tag = v57.icon.tag
			}) else React.createElement(View, {
				LayoutOrder = 1,
				tag = `align-x-center align-y-center { v57.icon.tag }`
			}, {
				Icon = React.createElement(Icon, {
					name = if not v68 then v43.icon else v68.name,
					style = v57.icon.style,
					size = v57.icon.size
				})
			}),
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v43.text,
				tag = v57.text.tag
			}),
			Chevron = if not v50 then nil else React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.ChevronSmallRight,
				style = v57.check.style,
				size = v57.chevron.size,
				testId = `{ v43.testId }--chevron`
			}),
			Check = if v50 or not v43.isChecked then nil else React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.Check,
				style = v57.check.style,
				size = v57.check.size,
				testId = `{ v43.testId }--checkmark`
			})
		})
	end

	if not v50 then
		return v77
	end

	local Standard = v47.Stroke.Standard
	local size = v57.groupPadding.size
	local v80 = React.createElement(BaseMenuContext.Provider, {
		value = {
			onActivated = v44.onActivated,
			onNestedLeafActivated = v44.onNestedLeafActivated,
			size = v48,
			hasLeading = v60,
			setHasLeading = v62,
			hoverOpenPath = v44.hoverOpenPath,
			hoverOpenAtDepth = v44.hoverOpenAtDepth,
			hoverCloseAtDepth = v44.hoverCloseAtDepth,
			hoverReset = v44.hoverReset,
			depth = depth + 1,
			maxHeight = v44.maxHeight
		}
	}, v43.children)
	local v81 = if not v56 then React.createElement(View, {
		tag = v57.submenuContent.tag,
		InputSink = v30
	}, v80) else React.createElement(BaseMenuScrollContainer, {
		maxHeight = v66,
		scrollViewProps = {
			tag = v57.submenuContent.tag,
			InputSink = v30
		}
	}, v80)

	return React.createElement(React.Fragment, nil, {
		Item = v77,
		Submenu = React.createElement(Popover.Root, {
			isOpen = v51,
			testId = `{ v43.testId }--submenu`
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				anchorRef = v58
			}),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				side = {
					position = PopoverSide.Right,
					offset = size / 2 + Standard
				},
				align = {
					position = PopoverAlign.Start,
					offset = -size
				},
				onPressedOutside = v65,
				backgroundStyle = if not Flags.FoundationBaseMenuBeta then v47.Color.Surface.Surface_100 else v47.Color.Surface.Surface_200,
				radius = Radius.Medium
			}, v81)
		})
	})
end

return React.memo(React.forwardRef(BaseMenuItem))
