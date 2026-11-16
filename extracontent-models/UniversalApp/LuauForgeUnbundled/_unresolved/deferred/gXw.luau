local CorePackages = game:GetService("CorePackages")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/deferred/gXg")

local module2 = require("@luauforge/deferred/gXh")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module3 = require("@luauforge/bundled/gfm")

local module4 = require("@luauforge/deferred/gmV")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled

local useTokens = Foundation.Hooks.useTokens
local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local menu = Foundation.Menu
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local view = Foundation.View

local function ManageOutfitsPage(props)
	local v5 = React.useCallback(function()
		return React.createElement(iconButton, {
			icon = iconName.ChevronLargeLeft,
			variant = buttonVariant.Utility,
			size = buttonSize.Medium,
			onActivated = props.onBackActivated
		})
	end, { props.onBackActivated })

	local v6 = React.useCallback(function()
		return React.createElement(button, {
			text = props.localized.selectActionText,
			variant = buttonVariant.Link,
			size = buttonSize.Medium,
			onActivated = props.onSelectActivated
		})
	end, { props.localized.selectActionText, props.onSelectActivated })

	local v7 = useSelector(module3)
	local v8 = useTokens()

	local size_1400 = v8.Size.Size_1400

	if v7 then
		size_1400 += v8.Size.Size_600
	end

	local size_600 = if v7 then v8.Size.Size_600 else nil

	local v9 = {
		SelectedCountTextLabel = React.createElement(Foundation.Text, {
			tag = "size-0-full auto-x text-heading-small",
			Text = props.localized.selectedLabelText
		}),
		DeleteButton = React.createElement(Foundation.Button, {
			tag = "size-0-full auto-x",
			text = props.localized.deleteButtonText,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = props.onDeleteActivated,
			isDisabled = #props.selectedOutfits == 0
		})
	}

	if fFlagAXAvatarFoldersEnabled and props.onAddToFolderActivated then
		local v10 = #props.selectedOutfits == 0

		local v11 = React.createElement(iconButton, {
			icon = iconName.TrashCan,
			isCircular = true,
			variant = buttonVariant.Standard,
			size = buttonSize.Medium,
			onActivated = props.onDeleteActivated,
			isDisabled = v10,
			LayoutOrder = 2,
			testId = "manage-outfits-delete"
		})

		local trashMenu = props.trashMenu

		if trashMenu then
			local createElement = React.createElement
			local v13 = {
				isOpen = trashMenu.isOpen,
				items = trashMenu.items,
				onActivated = trashMenu.onItemActivated,
				onPressedOutside = trashMenu.onPressedOutside,
				size = 0,
				side = 0,
				align = 0,
				LayoutOrder = 2,
				testId = "manage-outfits-trash-menu"
			}
			local v14 = if v7 then inputSize.Medium else inputSize.Large
			v13.size = v14

			v13.side = popoverSide.Top
			v13.align = popoverAlign.End
			v11 = createElement(menu, v13, { DeleteButton = v11 })
		end

		local element = React.createElement(
			Foundation.View,
			{ tag = "row align-y-center gap-small auto-xy" },
			{
				AddToFolderButton = React.createElement(iconButton, {
					icon = iconName.PlusLarge,
					isCircular = true,
					variant = buttonVariant.Standard,
					size = buttonSize.Medium,
					onActivated = props.onAddToFolderActivated,
					isDisabled = v10,
					LayoutOrder = 1,
					testId = "manage-outfits-add-to-folder"
				}),
				DeleteButton = v11
			}
		)

		v9 = { SelectedCountTextLabel = v9.SelectedCountTextLabel, Actions = element }
	end

	local createElement = React.createElement
	local v11 = {
		headerBarProps = {
			title = props.localized.title,
			renderLeft = v5,
			renderRight = v6
		},
		ZIndex = 1,
		forwardRef = props.focusNavigationRef
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v17 = {
		outfitType = props.outfitType,
		isEditable = true,
		onToggleOutfitCard = props.onToggleOutfitCard,
		selectedOutfits = props.selectedOutfits,
		setSelectedOutfits = props.setSelectedOutfits,
		multiSelect = props.multiSelect,
		goBack = props.onBackActivated,
		pageOwner = avatarScreen.ManageOutfitsPage,
		bottomContentPadding = 0,
		ref = 0,
		itemIdsFilter = 0
	}
	local v18 = if props.multiSelect then size_1400 else nil
	v17.bottomContentPadding = v18
	v17.ref = props.gridRef
	local v19 = if fFlagAXAvatarFoldersEnabled then props.itemIdsFilter else nil
	v17.itemIdsFilter = v19
	local v15 = {
		OutfitSelectionGrid = createElement3(module2, v17),
		ManageActionBar = 0
	}
	local v20

	if props.multiSelect then
		local createElement4 = React.createElement
		local view2 = Foundation.View
		local v21 = {
			tag = "col bg-surface-0",
			Size = UDim2.new(1, 0, 0, size_1400),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		}
		local v22 = {
			Divider = React.createElement(Foundation.Divider, { LayoutOrder = 1 }),
			BarContent = React.createElement(
				Foundation.View,
				{
					LayoutOrder = 2,
					tag = "row flex-x-between align-y-center size-full padding-x-medium"
				},
				v9
			),
			GapFiller = 0
		}

		local v23 = if size_600 then React.createElement(Foundation.View, {
			tag = "bg-surface-0",
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, size_600),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			LayoutOrder = 3
		}) else nil
		v22.GapFiller = v23
		v20 = createElement4(view2, v21, v22)
	end

	v15.ManageActionBar = v20
	return createElement(module, v11, {
		Body = createElement2(view, {
			tag = "fill size-full clip bg-surface-0",
			LayoutOrder = 1
		}, v15)
	})
end

return (module4(ManageOutfitsPage))
