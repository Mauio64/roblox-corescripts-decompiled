local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local DropdownReportMenuItem = require(AbuseReportMenu.Components.MenuItems.DropdownReportMenuItem)
local ButtonReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ButtonReportMenuItem)
local FreeCommentsMenuItem = require(AbuseReportMenu.Components.MenuItems.FreeCommentsMenuItem)
local ModalBasedSelectorMenuItem = require(AbuseReportMenu.Components.MenuItems.ModalBasedSelectorMenuItem)
local ChatModalSelectorMenuItem = require(AbuseReportMenu.Components.MenuItems.ChatModalSelectorMenuItem)

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local FFlagInGameMenuAddChatLineReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagInGameMenuAddChatLineReporting
local FFlagReportFocusNavIEMButtons = require(AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)

local function getMenuItemsFromConfigs(p1, p2, p3, t1: {[any]: any}, b1: boolean) -- line: 22
	-- upvalues: useLocalization (copy), Constants (copy), FFlagHideShortcutsOnReportDropdown (copy), React (copy), FFlagReportFocusNavIEMButtons (copy), FreeCommentsMenuItem (copy), ButtonReportMenuItem (copy), Foundation (copy), ButtonVariant (copy), DropdownReportMenuItem (copy), ModalBasedSelectorMenuItem (copy), FFlagInGameMenuAddChatLineReporting (copy), ChatModalSelectorMenuItem (copy)
	local t2 = {}
	local v23 = useLocalization(Constants.localizationKeys)
	local v24 = nil

	if FFlagHideShortcutsOnReportDropdown then
		v24 = React.useCallback(function(p4) -- line: 34
			-- upvalues: p3 (copy)
			if p3.onDropdownMenuOpenChange then
				p3.onDropdownMenuOpenChange(p4)
			end
		end, { p3.onDropdownMenuOpenChange })
	end

	local v25 = if not FFlagReportFocusNavIEMButtons then nil else React.useRef(nil)

	if FFlagReportFocusNavIEMButtons then
		React.useEffect(function() -- line: 45
			-- upvalues: p3 (copy), v25 (copy)
			if p3.setLastSelectableObjects and v25.current then
				p3.setLastSelectableObjects({ v25.current })
			end
		end, {
			v25,
			p3.setLastSelectableObjects
		})
	end

	local v26 = t1

	if FFlagReportFocusNavIEMButtons then
		v26 = {}

		for _, v28 in t1 do
			if v28.getIsVisible(p1) then
				table.insert(v26, v28)
			end
		end
	end

	for v29, v30 in v26 do
		if FFlagReportFocusNavIEMButtons or v30.getIsVisible(p1) then
			local componentType = v30.componentType
			local componentName = v30.componentName

			if componentType ~= "generic" then
				if componentType == "freeComments" then
					t2[componentName] = React.createElement(FreeCommentsMenuItem, {
						layoutOrder = v29,
						comment = p1.comment,
						placeholderText = v23.ReportCommentPlaceholder,
						menuContainerWidth = p3.menuWidth,
						isSmallPortraitViewport = b1,
						onUpdate = function(p5) -- line: 75
							-- upvalues: v30 (copy), p1 (copy), p2 (copy), p3 (copy)
							v30.onUpdate(p5, p1, p2, p3)
						end,
						ref = if not FFlagReportFocusNavIEMButtons or v29 ~= #v26 then nil else v25
					})
				elseif componentType == "button" then
					local v33 = v30.getIconSrc(p3)

					t2[componentName] = React.createElement(ButtonReportMenuItem, {
						label = if v30.fieldLabel ~= "" then v23[v30.fieldLabel] else v30.fieldLabel,
						button = React.createElement(Foundation.Button, {
							variant = if v30.variant ~= "primary" then ButtonVariant.Subtle else ButtonVariant.SubEmphasis,
							text = v23[v30.getButtonLabel(p3)],
							icon = if v33 == "" then nil else v33,
							width = UDim.new(1, 0),
							isDisabled = v30.getIsDisabled ~= nil and v30.getIsDisabled(p1, p3),
							onActivated = function() -- line: 96
								-- upvalues: v30 (copy), p1 (copy), p2 (copy), p3 (copy)
								v30.onClick(p1, p2, p3)
							end,
							ref = if not FFlagReportFocusNavIEMButtons or v29 ~= #v26 then nil else v25
						}),
						menuContainerWidth = p3.menuWidth,
						layoutOrder = v29,
						isSmallPortraitViewport = b1
					})
				elseif componentType == "dropdown" then
					t2[componentName] = React.createElement(DropdownReportMenuItem, {
						label = v23[v30.fieldLabel],
						placeholderText = v23.ChooseOne,
						layoutOrder = v29,
						onSelect = function(p6) -- line: 112
							-- upvalues: v30 (copy), p1 (copy), p2 (copy), p3 (copy)
							v30.onUpdateSelectedOption(p6, p1, p2, p3)
						end,
						onMenuOpenChange = v24,
						menuContainerWidth = p3.menuWidth,
						readonlyValue = v23[v30.readonlyValue],
						selections = v30.getMenuItems(p1),
						isSmallPortraitViewport = b1,
						minHeight = if not b1 then Constants.MenuItemHeight else 0,
						ref = if not FFlagReportFocusNavIEMButtons or v29 ~= #v26 then nil else v25
					})
				elseif componentType == "modalSelector" then
					t2[componentName] = React.createElement(ModalBasedSelectorMenuItem, {
						label = v23[v30.fieldLabel],
						layoutOrder = v29,
						onSelect = function(p7, p8, p9) -- line: 129
							-- upvalues: v30 (copy), p1 (copy), p2 (copy), p3 (copy)
							local t3 = {
								label = p7,
								subLabel = p8,
								identifier = p9
							}

							v30.onUpdateSelectedOption(t3, p1, p2, p3)
						end,
						onMenuOpenChange = v24,
						menuContainerWidth = p3.menuWidth,
						selectorHeight = Constants.MenuItemHeight,
						selectedValue = if not v30.getSelectedValue then nil else v23[v30.getSelectedValue(p1)] or (v30.getSelectedValue(p1) or nil),
						selections = v30.getMenuItems(p1, v23),
						viewportHeight = p3.viewportDimension.height,
						viewportWidth = p3.viewportDimension.width,
						isSmallPortraitViewport = b1,
						placeholderText = v23.ChooseOne,
						ref = if not FFlagReportFocusNavIEMButtons or v29 ~= #v26 then nil else v25
					})
				elseif FFlagInGameMenuAddChatLineReporting and componentType == "chatModalSelector" then
					t2[componentName] = React.createElement(ChatModalSelectorMenuItem, {
						label = v23[v30.fieldLabel],
						layoutOrder = v29,
						onSelect = function(p10, t4: {[any]: any}) -- line: 158
							-- upvalues: v30 (copy), p1 (copy), p2 (copy), p3 (copy)
							v30.onUpdateSelectedOption(p10, t4, p1, p2, p3)
						end,
						onMenuOpenChange = v24,
						menuContainerWidth = p3.menuWidth,
						selectorHeight = Constants.MenuItemHeight,
						selectedValue = if not v30.getSelectedValue then nil else v30.getSelectedValue(p1) or nil,
						isSmallPortraitViewport = b1,
						placeholderText = v23.ChooseOne,
						ref = if not FFlagReportFocusNavIEMButtons or v29 ~= #v26 then nil else v25
					})
				end
			end
		end
	end

	return t2
end

return getMenuItemsFromConfigs
