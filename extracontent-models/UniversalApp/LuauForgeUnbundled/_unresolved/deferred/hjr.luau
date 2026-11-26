local CorePackages = game:GetService("CorePackages")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/deferred/hjs")

local module2 = require("@luauforge/deferred/hjt")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module3 = require("@luauforge/bundled/gJS")

local module4 = require("@luauforge/deferred/gRz")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useTokens = Foundation.Hooks.useTokens
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local view = Foundation.View

local function UpdateOutfitPage(props)
	local v5 = React.useCallback(function()
		return React.createElement(iconButton, {
			icon = iconName.ChevronLargeLeft,
			variant = buttonVariant.Utility,
			size = buttonSize.Medium,
			onActivated = props.onBackActivated
		})
	end, { props.onBackActivated })

	local v6 = useSelector(module3)
	local v7 = useTokens()

	local v8 = if v6 then v7.Size.Size_1400 + v7.Size.Size_600 else v7.Size.Size_1400

	local createElement = React.createElement
	local v10 = {
		headerBarProps = { title = props.localized.title, renderLeft = v5 },
		ZIndex = 1,
		forwardRef = props.focusNavigationRef
	}

	local createElement2 = React.createElement

	local v14 = {
		Content = React.createElement(
			Foundation.View,
			{ tag = "col fill size-full clip bg-surface-0", LayoutOrder = 1 },
			{
				OutfitSelectionGrid = React.createElement(module2, {
					outfitType = props.outfitType,
					isEditable = true,
					onToggleOutfitCard = props.onToggleOutfitCard,
					selectedOutfits = props.selectedOutfits,
					setSelectedOutfits = props.setSelectedOutfits,
					multiSelect = false,
					goBack = props.onBackActivated,
					pageOwner = avatarScreen.UpdateOutfitPage,
					bottomContentPadding = v8,
					ref = props.gridRef
				})
			}
		),
		UpdateActionBar = 0
	}

	local createElement3 = React.createElement
	local view2 = Foundation.View
	local v15 = {
		testId = "UpdateActionBar",
		tag = "col bg-surface-0",
		Size = UDim2.new(1, 0, 0, v8),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1)
	}
	local v16 = {
		Divider = React.createElement(Foundation.Divider, { LayoutOrder = 1 }),
		ActionBarContent = React.createElement(
			Foundation.View,
			{
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-right align-y-center size-full padding-x-medium bg-surface-0"
			},
			{
				UpdateButton = React.createElement(Foundation.Button, {
					tag = "size-0-full auto-x",
					text = props.localized.updateButtonText,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = props.onUpdateActivated,
					isDisabled = #props.selectedOutfits == 0
				})
			}
		),
		GapFiller = 0
	}

	local v17 = if v6 then React.createElement(Foundation.View, {
		tag = "bg-surface-0 size-full-600 position-bottom-left anchor-bottom-left",
		LayoutOrder = 3
	}) else nil
	v16.GapFiller = v17
	v14.UpdateActionBar = createElement3(view2, v15, v16)
	return createElement(module, v10, {
		Body = createElement2(view, {
			tag = "fill size-full clip bg-surface-0",
			LayoutOrder = 1
		}, v14)
	})
end

return (module4(UpdateOutfitPage))
