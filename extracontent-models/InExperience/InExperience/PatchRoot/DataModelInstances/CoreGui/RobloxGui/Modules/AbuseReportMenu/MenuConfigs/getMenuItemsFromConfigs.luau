local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local DropdownReportMenuItem = require(AbuseReportMenu.Components.MenuItems.DropdownReportMenuItem)
local ButtonReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ButtonReportMenuItem)
local FreeCommentsMenuItem = require(AbuseReportMenu.Components.MenuItems.FreeCommentsMenuItem)
local ModalBasedSelectorMenuItem = require(AbuseReportMenu.Components.MenuItems.ModalBasedSelectorMenuItem)
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)

local ButtonVariant = Foundation.Enums.ButtonVariant

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local FFlagReportFocusNavIEMButtons = require(AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)

local function getMenuItemsFromConfigs(p, p2, props, items, isSmallPortraitViewport: boolean)
	local children = {}
	local v = useLocalization(Constants.localizationKeys)
	local onMenuOpenChange

	if FFlagHideShortcutsOnReportDropdown then
		onMenuOpenChange = React.useCallback(function(p3)
			if props.onDropdownMenuOpenChange then
				props.onDropdownMenuOpenChange(p3)
			end
		end, { props.onDropdownMenuOpenChange })
	end

	local ref

	if FFlagReportFocusNavIEMButtons then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	if FFlagReportFocusNavIEMButtons then
		React.useEffect(function()
			if props.setLastSelectableObjects and ref.current then
				props.setLastSelectableObjects({ ref.current })
			end
		end, { ref, props.setLastSelectableObjects })
	end

	local v2

	if FFlagReportFocusNavIEMButtons then
		v2 = {}

		for _, item in items do
			if item.getIsVisible(p) then
				table.insert(v2, item)
			end
		end
	else
		v2 = items
	end

	for k, v3 in v2 do
		if not (FFlagReportFocusNavIEMButtons or v3.getIsVisible(p)) then
			continue
		end

		local componentType = v3.componentType
		local componentName = v3.componentName

		if componentType == "generic" then
			continue
		end

		if componentType == "freeComments" then
			local createElement = React.createElement
			local v4 = {
				layoutOrder = k,
				comment = p.comment,
				placeholderText = v.ReportCommentPlaceholder,
				menuContainerWidth = props.menuWidth,
				isSmallPortraitViewport = isSmallPortraitViewport,
				onUpdate = function(p3)
					v3.onUpdate(p3, p, p2, props)
				end,
				ref = 0
			}
			local ref2

			if FFlagReportFocusNavIEMButtons and k == #v2 then
				ref2 = ref
			end

			v4.ref = ref2
			children[componentName] = createElement(FreeCommentsMenuItem, v4)
		elseif componentType == "button" then
			local iconSrc = v3.getIconSrc(props)
			local createElement = React.createElement
			local label

			if v3.fieldLabel == "" then
				label = v3.fieldLabel
			else
				label = v[v3.fieldLabel]
			end

			local createElement2 = React.createElement
			local button = Foundation.Button
			local variant

			if v3.variant == "primary" then
				variant = ButtonVariant.SubEmphasis
			else
				variant = ButtonVariant.Subtle
			end

			local v4 = {
				variant = variant,
				text = v[v3.getButtonLabel(props)],
				icon = 0,
				width = 0,
				isDisabled = 0,
				onActivated = 0,
				ref = 0
			}

			if iconSrc == "" then
				iconSrc = nil
			end

			v4.icon = iconSrc
			v4.width = UDim.new(1, 0)
			v4.isDisabled = v3.getIsDisabled ~= nil and v3.getIsDisabled(p, props)

			function v4.onActivated()
				v3.onClick(p, p2, props)
			end

			local ref2

			if FFlagReportFocusNavIEMButtons and k == #v2 then
				ref2 = ref
			end

			v4.ref = ref2
			children[componentName] = createElement(ButtonReportMenuItem, {
				label = label,
				button = createElement2(button, v4),
				menuContainerWidth = props.menuWidth,
				layoutOrder = k,
				isSmallPortraitViewport = isSmallPortraitViewport
			})
		elseif componentType == "dropdown" then
			local createElement = React.createElement
			local v4 = {
				label = v[v3.fieldLabel],
				placeholderText = v.ChooseOne,
				layoutOrder = k,
				onSelect = function(p3)
					v3.onUpdateSelectedOption(p3, p, p2, props)
				end,
				onMenuOpenChange = onMenuOpenChange,
				menuContainerWidth = props.menuWidth,
				readonlyValue = v[v3.readonlyValue],
				selections = v3.getMenuItems(p),
				isSmallPortraitViewport = isSmallPortraitViewport,
				minHeight = isSmallPortraitViewport and 0 or Constants.MenuItemHeight,
				ref = 0
			}
			local ref2

			if FFlagReportFocusNavIEMButtons and k == #v2 then
				ref2 = ref
			end

			v4.ref = ref2
			children[componentName] = createElement(DropdownReportMenuItem, v4)
		elseif componentType == "modalSelector" then
			local createElement = React.createElement
			local v4 = {
				label = v[v3.fieldLabel],
				layoutOrder = k,
				onSelect = function(label, subLabel, identifier)
					v3.onUpdateSelectedOption(
						{ label = label, subLabel = subLabel, identifier = identifier },
						p,
						p2,
						props
					)
				end,
				onMenuOpenChange = onMenuOpenChange,
				menuContainerWidth = props.menuWidth,
				selectorHeight = Constants.MenuItemHeight,
				selectedValue = 0,
				selections = 0,
				viewportHeight = 0,
				viewportWidth = 0,
				isSmallPortraitViewport = 0,
				placeholderText = 0,
				ref = 0
			}
			local selectedValue

			if v3.getSelectedValue then
				selectedValue = v[v3.getSelectedValue(p)] or v3.getSelectedValue(p) or nil
			end

			v4.selectedValue = selectedValue

			v4.selections = v3.getMenuItems(p, v)
			v4.viewportHeight = props.viewportDimension.height
			v4.viewportWidth = props.viewportDimension.width
			v4.isSmallPortraitViewport = isSmallPortraitViewport
			v4.placeholderText = v.ChooseOne
			local ref2

			if FFlagReportFocusNavIEMButtons and k == #v2 then
				ref2 = ref
			end

			v4.ref = ref2
			children[componentName] = createElement(ModalBasedSelectorMenuItem, v4)
		end
	end

	return children
end

return getMenuItemsFromConfigs
