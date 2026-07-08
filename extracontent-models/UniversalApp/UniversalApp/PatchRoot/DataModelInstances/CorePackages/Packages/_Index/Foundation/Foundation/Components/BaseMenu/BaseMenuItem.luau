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
local useBaseMenuItemVariants = require(script.Parent.useBaseMenuItemVariants)
local useMenuItemHover = require(script.Parent.useMenuItemHover)
local t1 = {
	isChecked = false
}

local function resolveAccessory(p1) -- line: 68
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
local function getInputSinkAll() -- line: 81
	-- upvalues: Flags (copy)
	if not Flags.FoundationGuiObjectInputSinkProperty then
		return nil
	end

	local ok, result = pcall(game.GetEngineFeature, game, "GuiObjectInputSink")

	if not ok or not result then
		return nil
	end

	local ok2, result2 = pcall(function() -- line: 91
		return Enum.InputSink.All
	end)

	if ok2 then
		return result2
	end

	return nil
end

local v28 = getInputSinkAll()

local function getContainerPadding(p2, b1: boolean) -- line: 100
	local v38 = if not b1 then p2.paddingLeftWithoutCheck else p2.paddingLeftWithCheck

	return {
		left = UDim.new(0, v38 or 0),
		right = UDim.new(0, p2.paddingRight or 0)
	}
end
local function BaseMenuItem(p3, p4) -- line: 109
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), BaseMenuContext (copy), Flags (copy), useTokens (copy), useBaseMenuItemVariants (copy), useMenuItemHover (copy), Logger (copy), BuilderIcons (copy), useComposedRef (copy), getContainerPadding (copy), View (copy), Icon (copy), BaseMenuItemAccessory (copy), Text (copy), withCommonProps (copy), Constants (copy), isBuilderOrMigratedIcon (copy), Image (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), Radius (copy), v28 (copy)
	local v41 = withDefaults(p3, t1)
	local v42 = React.useContext(BaseMenuContext)
	local v43, v44

	if Flags.FoundationBaseMenuBeta then
		v43 = if v41.menuHasLeading == nil then v42.hasLeading == true else v41.menuHasLeading
		v44 = if v41.menuHasCheck == nil then v41.isChecked == true else v41.menuHasCheck
	else
		v43 = v42.hasLeading == true
		v44 = false
	end

	local v45 = useTokens()
	local v46 = v41.size or v42.size
	local depth = v42.depth
	local v48 = v41.children ~= nil
	local v49 = v48 and v42.hoverOpenPath[depth] == v41.id
	local v51

	if Flags.FoundationBaseMenuBeta then
		local v50 = v41.leading or v41.icon

		v51 = if v50 ~= nil then if type(v50) ~= "string" then v50 else {
			iconName = v50
		} else nil
	else
		v51 = nil
	end

	local v53

	if Flags.FoundationBaseMenuBeta then
		local trailing = v41.trailing

		v53 = if trailing ~= nil then if type(trailing) ~= "string" then trailing else {
			iconName = trailing
		} else nil
	else
		v53 = nil
	end

	local v54 = useBaseMenuItemVariants(v45, v46, not v48 and v41.isChecked)
	local v55 = React.useRef(nil)
	local v56 = v41.isChecked == true and not v48
	local v57, v58 = React.useState(false)
	local v59 = React.useCallback(function() -- line: 138
		-- upvalues: v58 (copy)
		v58(true)
	end, {})
	local v60 = if not Flags.FoundationBaseMenuBeta then v41.icon ~= nil else v51 ~= nil

	React.useEffect(function() -- line: 143
		-- upvalues: v60 (copy), v42 (copy)
		if v60 and v42.setHasLeading then
			v42.setHasLeading()
		end
	end, {
		v60,
		v42.setHasLeading
	})
	useMenuItemHover({
		itemRef = v55,
		id = v41.id,
		depth = depth,
		isSubmenu = v48,
		isDisabled = v41.isDisabled,
		hoverOpenAtDepth = v42.hoverOpenAtDepth,
		hoverCloseAtDepth = v42.hoverCloseAtDepth
	})

	local v61 = React.useCallback(function() -- line: 160
		-- upvalues: v48 (copy), v41 (copy), v42 (copy), v49 (copy), depth (copy), Logger (copy)
		if v48 then
			if v41.isDisabled then
				return
			end

			if v42.hoverOpenAtDepth and not v49 then
				v42.hoverOpenAtDepth(depth, v41.id, true)

				return
			end
		else
			if v42.hoverReset then
				v42.hoverReset()
			end

			local v76 = if not v41.onActivated then v42.onActivated else v41.onActivated

			if not v76 then
				Logger:warning("Menu should have either onActivated on itself or on all of its children")
			else
				v76(v41.id)
			end

			if depth > 1 and v42.onNestedLeafActivated then
				v42.onNestedLeafActivated()
			end
		end
	end, {
		v48,
		v41.isDisabled,
		v49,
		depth,
		v41.id,
		v41.onActivated,
		v42.onActivated,
		v42.onNestedLeafActivated,
		v42.hoverOpenAtDepth,
		v42.hoverReset
	})
	local v62 = React.useCallback(function() -- line: 201
		-- upvalues: v42 (copy)
		if v42.hoverReset then
			v42.hoverReset()
		end
	end, { v42.hoverReset })
	local v63 = React.useMemo(function() -- line: 207
		-- upvalues: v45 (copy)
		return {
			radius = UDim.new(0, v45.Radius.Small),
			offset = v45.Size.Size_200,
			borderWidth = v45.Stroke.Thicker
		}
	end, { v45 })
	local v64 = React.useMemo(function() -- line: 215
		-- upvalues: BuilderIcons (copy), v41 (copy)
		return BuilderIcons.Migration.uiblox[v41.icon]
	end, { v41.icon })
	local v65 = useComposedRef(v55, p4)
	local v73

	if Flags.FoundationBaseMenuBeta then
		local v66 = getContainerPadding(v54.container, v44)
		local t2 = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		local v68 = v54.wrapper and v54.wrapper.gap or 0
		local v69 = nil

		if v44 then
			v69 = React.createElement(View, {
				LayoutOrder = 1,
				tag = `{ v54.slotAlign.tag } { v54.check.tag }`,
				testId = `{ v41.testId }--check-column`
			}, {
				Check = if not v56 then nil else React.createElement(Icon, {
					name = BuilderIcons.Icon.Check,
					style = v54.check.style,
					size = v54.check.size,
					testId = `{ v41.testId }--checkmark`
				})
			})
		end

		local v70 = nil

		if v51 ~= nil then
			v70 = React.createElement(BaseMenuItemAccessory, {
				LayoutOrder = 1,
				accessory = v51,
				iconVariant = v54.icon,
				size = v46,
				tokens = v45,
				testId = `{ v41.testId }--leading`
			})
		elseif v43 then
			v70 = React.createElement(View, {
				LayoutOrder = 1,
				tag = `{ v54.slotAlign.tag } { v54.icon.tag }`
			})
		end

		local v71 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v41.text,
			tag = v54.text.tag
		})
		local v72 = nil

		if v48 then
			v72 = React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.ChevronSmallRight,
				style = v54.check.style,
				size = v54.chevron.size,
				testId = `{ v41.testId }--chevron`
			})
		elseif v53 ~= nil then
			v72 = React.createElement(BaseMenuItemAccessory, {
				LayoutOrder = 3,
				accessory = v53,
				iconVariant = v54.icon,
				size = v46,
				tokens = v45,
				testId = `{ v41.testId }--trailing`
			})
		end

		v73 = React.createElement(View, withCommonProps(v41, {
			GroupTransparency = if not v41.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			isDisabled = v41.isDisabled,
			onActivated = v61,
			selection = {
				Selectable = not v41.isDisabled
			},
			cursor = v63,
			tag = v54.container.tag,
			padding = v66,
			layout = t2,
			ref = v65
		}), {
			Check = v69,
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
					Padding = UDim.new(0, v68),
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Leading = v70,
				Title = v71,
				Trailing = v72
			})
		})
	else
		v73 = React.createElement(View, withCommonProps(v41, {
			GroupTransparency = if not v41.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			isDisabled = v41.isDisabled,
			onActivated = v61,
			selection = {
				Selectable = not v41.isDisabled
			},
			cursor = v63,
			tag = v54.container.tag,
			ref = v65
		}), {
			Icon = if not v41.icon and not v43 then nil else if not v41.icon or not isBuilderOrMigratedIcon(v41.icon) then React.createElement(Image, {
				LayoutOrder = 1,
				Image = v41.icon,
				tag = v54.icon.tag
			}) else React.createElement(View, {
				LayoutOrder = 1,
				tag = `align-x-center align-y-center { v54.icon.tag }`
			}, {
				Icon = React.createElement(Icon, {
					name = if not v64 then v41.icon else v64.name,
					style = v54.icon.style,
					size = v54.icon.size
				})
			}),
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v41.text,
				tag = v54.text.tag
			}),
			Chevron = if not v48 then nil else React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.ChevronSmallRight,
				style = v54.check.style,
				size = v54.chevron.size,
				testId = `{ v41.testId }--chevron`
			}),
			Check = if v48 or not v41.isChecked then nil else React.createElement(Icon, {
				LayoutOrder = 3,
				name = BuilderIcons.Icon.Check,
				style = v54.check.style,
				size = v54.check.size,
				testId = `{ v41.testId }--checkmark`
			})
		})
	end

	if not v48 then
		return v73
	end

	local Standard = v45.Stroke.Standard
	local size = v54.groupPadding.size

	return React.createElement(React.Fragment, nil, {
		Item = v73,
		Submenu = React.createElement(Popover.Root, {
			isOpen = v49,
			testId = `{ v41.testId }--submenu`
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				anchorRef = v55
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
				onPressedOutside = v62,
				backgroundStyle = if not Flags.FoundationBaseMenuBeta then v45.Color.Surface.Surface_100 else v45.Color.Surface.Surface_200,
				radius = Radius.Medium
			}, React.createElement(View, {
				tag = v54.submenuContent.tag,
				InputSink = v28
			}, React.createElement(BaseMenuContext.Provider, {
				value = {
					onActivated = v42.onActivated,
					onNestedLeafActivated = v42.onNestedLeafActivated,
					size = v46,
					hasLeading = v57,
					setHasLeading = v59,
					hoverOpenPath = v42.hoverOpenPath,
					hoverOpenAtDepth = v42.hoverOpenAtDepth,
					hoverCloseAtDepth = v42.hoverCloseAtDepth,
					hoverReset = v42.hoverReset,
					depth = depth + 1
				}
			}, v41.children)))
		})
	})
end

return React.memo(React.forwardRef(BaseMenuItem))
