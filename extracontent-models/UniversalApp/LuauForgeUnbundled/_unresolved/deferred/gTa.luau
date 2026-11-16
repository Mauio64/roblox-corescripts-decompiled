local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useTokens = Foundation.Hooks.useTokens
local module2 = require("@luauforge/deferred/gTb")

local module3 = require("@luauforge/deferred/gSU")
local module4 = require("@luauforge/deferred/gSY")
local module5 = require("@luauforge/deferred/gSw")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXSlotsDesktopRedesign = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsDesktopRedesign

local fFlagAXMoveCatalogFilterToL1Navigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveCatalogFilterToL1Navigation
local fFlagAXSlotsDisableScrollAwayOnLandscape = AvatarExperienceFlags.FFlagAXSlotsDisableScrollAwayOnLandscape
local fFlagAXSlotsScrollAwayOnlyWithSlots = AvatarExperienceFlags.FFlagAXSlotsScrollAwayOnlyWithSlots
local fFlagAXSlotEditorCategoryMenu = AvatarExperienceFlags.FFlagAXSlotEditorCategoryMenu

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local v6 = Responsive.useOrientation()
	local v7

	if not fFlagAXSlotsDesktopRedesign then
		v7 = v6 == Responsive.BreakpointConfig.Enum.Portrait
	end

	local v8

	if fFlagAXSlotsDisableScrollAwayOnLandscape then
		v8 = React.useMemo(function()
			if props.disableScrollAway then
				return 1
			end

			return props.slotSubNavigationFill
		end, { props.disableScrollAway, props.slotSubNavigationFill })
	else
		v8 = nil
	end

	local useEffect = React.useEffect
	local function fn()
		if props.absoluteSizeChanged then
			local v9

			if fFlagAXSlotsScrollAwayOnlyWithSlots then
				v9 = props.navigationFrameHeight - props.navHeight
			else
				v9 = props.slotCardTotalHeight
			end

			local absoluteSizeChanged = props.absoluteSizeChanged
			local newVector2 = Vector2.new

			local v11 = if fFlagAXSlotsDisableScrollAwayOnLandscape then props.navigationFrameHeight - (1 - v8) * v9 else props.navigationFrameHeight - (1 - props.slotSubNavigationFill) * v9
			absoluteSizeChanged(newVector2(0, v11))
		end
	end

	local absoluteSizeChanged = props.absoluteSizeChanged
	local navigationFrameHeight = props.navigationFrameHeight
	local slotSubNavigationFill = props.slotSubNavigationFill
	local slotCardTotalHeight = props.slotCardTotalHeight
	local v10 = if fFlagAXSlotsDisableScrollAwayOnLandscape then v8 else nil
	local v11 = if fFlagAXSlotsScrollAwayOnlyWithSlots then props.navHeight else nil
	useEffect(fn, {
		absoluteSizeChanged,
		navigationFrameHeight,
		slotSubNavigationFill,
		slotCardTotalHeight,
		v10,
		v11
	})

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		ref = p2
	}

	local v14 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		NavigationFrame = 0
	}

	local createElement2 = React.createElement
	local v16 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		ZIndex = 3,
		ref = p2
	}

	local v21 = if not (fFlagAXSlotsDesktopRedesign or v7) then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v5.Size.Size_200),
		PaddingBottom = UDim.new(0, v5.Size.Size_500),
		PaddingLeft = UDim.new(0, v5.Size.Size_100)
	}) else nil
	local v22

	if fFlagAXSlotsDesktopRedesign or v7 then
		v22 = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{ if fFlagAXSlotEditorCategoryMenu then React.createElement(module3, props.slotNavigationProps) else React.createElement(module5, {
					height = props.navHeight,
					layoutOrder = 0,
					showFilterButton = not props.hideFilter,
					showFilterRight = (fFlagAXSlotsDesktopRedesign or fFlagAXMoveCatalogFilterToL1Navigation) and true or nil
				}, { React.createElement(module2, props.slotNavigationProps) }) }
		)
	elseif fFlagAXSlotEditorCategoryMenu then
		v22 = React.createElement(module3, props.slotNavigationProps)
	else
		v22 = React.createElement(module2, props.slotNavigationProps)
	end

	local v23

	if fFlagAXSlotsDesktopRedesign or v7 then
		if #props.slotSubNavigationProps.slots > 0 then
			local createElement4 = React.createElement
			local newUDim2 = UDim2.new
			local v29

			if fFlagAXSlotsDisableScrollAwayOnLandscape then
				v29 = props.slotCardTotalHeight * v8
			else
				v29 = props.slotCardTotalHeight * props.slotSubNavigationFill
			end

			local v25 = {
				Size = newUDim2(1, 0, 0, v29),
				Position = UDim2.new(0, 0, 0, props.navigationFrameHeight - props.slotCardTotalHeight),
				BackgroundTransparency = 1,
				ZIndex = 0,
				ClipsDescendants = true
			}

			local createElement5 = React.createElement
			local newUDim = UDim.new
			local v33

			if fFlagAXSlotsDisableScrollAwayOnLandscape then
				v33 = props.slotCardTotalHeight * v8
			else
				v33 = props.slotCardTotalHeight * props.slotSubNavigationFill
			end

			v23 = createElement4("Frame", v25, {
				Padding = createElement5("UIPadding", { PaddingTop = newUDim(0, v33) }),
				BackgroundFrame = React.createElement("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, -props.slotCardTotalHeight)
				}, {
					SlotsFrame = React.createElement(
						"Frame",
						{
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 0,
							BackgroundColor3 = v5.Color.Surface.Surface_100.Color3
						},
						{
							Slots = React.createElement(module4, props.slotSubNavigationProps)
						}
					)
				})
			})
		end
	else
		v23 = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			Position = UDim2.new(0, 0, 0, props.navigationFrameHeight - props.slotCardTotalHeight)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v5.Size.Size_200)
			}),
			React.createElement(module4, props.slotSubNavigationProps)
		})
	end

	v14.NavigationFrame = createElement2("Frame", v16, {
		SlotNavigationFrame = createElement3("Frame", v19, {
			Padding = v21,
			SlotNavigation = v22,
			SlotSubNavigation = v23
		})
	})
	return createElement("Frame", v13, v14)
end))
