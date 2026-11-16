local module = require("@luauforge/bundled/hwA")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local module4 = require("@luauforge/bundled/hxZ")

local iconButton = Foundation.IconButton
local searchInput = Foundation.SearchInput
local sheet = Foundation.Sheet
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius
local searchInputShape = Foundation.Enums.SearchInputShape
local getIconRichText = Foundation.Utility.getIconRichText

local v5 = { 0.92 }

local function SkeletonRow(p2)
	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-small",
			testId = "send-robux-friends-skeleton"
		},
		{
			Avatar = React.createElement(skeleton, {
				LayoutOrder = 1,
				radius = radius.Circle,
				Size = UDim2.fromOffset(48, 48)
			}),
			Name = React.createElement(skeleton, {
				LayoutOrder = 2,
				radius = radius.Small,
				Size = UDim2.new(0.5, 0, 0, 16)
			})
		}
	)
end

local function SectionView(props)
	local children = {
		Heading = React.createElement(text, {
			LayoutOrder = 0,
			Text = props.section.heading,
			tag = "size-full-0 auto-y padding-y-small text-title-medium text-align-x-left content-emphasis"
		}),
		Skeleton = 0
	}

	local v6 = if props.section.showSkeleton then React.createElement(SkeletonRow, {
		LayoutOrder = 1
	}) else nil
	children.Skeleton = v6

	for k, row in props.section.rows do
		children[`User_{row.userId}`] = React.createElement(module4, {
			LayoutOrder = k,
			userId = row.userId,
			displayName = row.displayName,
			username = row.username,
			hasVerifiedBadge = row.hasVerifiedBadge,
			isRobloxPlus = row.isRobloxPlus,
			onActivated = props.onRecipientSelected
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col size-full-0 auto-y",
			testId = props.testId
		},
		children
	)
end

local function SendRobuxSheetView(props)
	local createElement = React.createElement
	local root = sheet.Root
	local v6 = {
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		snapPoints = v5,
		centerSheetHeight = 0.7,
		onClose = props.onSheetClosed,
		ref = props.focusRef,
		testId = "send-robux-sheet"
	}

	local createElement2 = React.createElement
	local header = sheet.Header
	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v13 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = `{getIconRichText(iconName.RobloxPlus)} {props.title}`,
			RichText = true,
			tag = "auto-xy text-heading-small text-align-x-left content-default",
			testId = "send-robux-sheet-title"
		}),
		Trailing = 0
	}

	local createElement5 = React.createElement

	local v17 = if props.balanceText then React.createElement(text, {
		LayoutOrder = 1,
		Text = `{getIconRichText(iconName.Robux)} {props.balanceText}`,
		RichText = true,
		tag = "auto-xy text-label-large text-align-x-right content-emphasis",
		testId = "send-robux-sheet-balance"
	}) else React.createElement(skeleton, {
		LayoutOrder = 1,
		radius = radius.Small,
		Size = UDim2.fromOffset(64, 20),
		testId = "send-robux-sheet-balance-skeleton"
	})
	v13.Trailing = createElement5(view, {
		LayoutOrder = 2,
		tag = "row align-y-center gap-small auto-xy"
	}, {
		Balance = v17,
		Close = React.createElement(iconButton, {
			LayoutOrder = 2,
			icon = { name = module.Icon.X, variant = Foundation.Enums.IconVariant.Regular },
			isCircular = true,
			size = inputSize.Medium,
			variant = buttonVariant.Utility,
			onActivated = props.onClose,
			testId = "send-robux-sheet-close"
		})
	})
	local children = {
		Header = createElement2(header, { hasCloseAffordance = false }, {
			Column = createElement3(view, { tag = "col gap-medium size-full-0 auto-y" }, {
				TitleRow = createElement4(
					view,
					{
						LayoutOrder = 1,
						tag = "row flex-x-between align-y-center size-full-0 auto-y"
					},
					v13
				),
				Search = React.createElement(searchInput, {
					LayoutOrder = 2,
					text = props.searchText,
					placeholder = props.searchPlaceholder,
					onChanged = props.onSearchChanged,
					size = inputSize.Medium,
					shape = searchInputShape.Pill,
					width = UDim.new(1, 0),
					testId = "send-robux-sheet-search"
				})
			})
		}),
		Content = 0
	}

	local createElement6 = React.createElement
	local content = sheet.Content
	local createElement7 = React.createElement

	local v23 = if props.friends then React.createElement(SectionView, {
		LayoutOrder = 1,
		section = props.friends,
		onRecipientSelected = props.onRecipientSelected,
		testId = "send-robux-sheet-friends"
	}) else nil

	local v24 = if props.people then React.createElement(SectionView, {
		LayoutOrder = 2,
		section = props.people,
		onRecipientSelected = props.onRecipientSelected,
		testId = "send-robux-sheet-people"
	}) else nil

	local v25 = if props.noResultsText then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.noResultsText,
		tag = "size-full-0 auto-y padding-y-large text-body-large text-align-x-center content-default",
		testId = "send-robux-sheet-no-results"
	}) else nil
	children.Content = createElement6(content, {}, {
		Body = createElement7(view, {
			tag = "col gap-medium size-full-0 auto-y padding-bottom-medium"
		}, {
			Friends = v23,
			People = v24,
			NoResults = v25
		})
	})
	return createElement(root, v6, children)
end

return SendRobuxSheetView
