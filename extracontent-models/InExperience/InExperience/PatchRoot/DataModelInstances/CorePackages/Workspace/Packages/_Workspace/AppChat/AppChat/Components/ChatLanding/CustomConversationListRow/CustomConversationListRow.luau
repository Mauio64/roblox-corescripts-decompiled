local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local FFlagAppChatExtendConversationListRowDividers = require(AppChat.Flags.FFlagAppChatExtendConversationListRowDividers)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)

local FFlagAppChatAlignCustomConversationListRowChevron = require(AppChat.Flags.FFlagAppChatAlignCustomConversationListRowChevron)

local useCustomConversationListRowPresentation = require(script.Parent.useCustomConversationListRowPresentation)

local function CustomConversationListRow(props)
	local v = useCustomConversationListRowPresentation({
		entryHeight = props.entryHeight,
		onActivated = props.onActivated
	})

	local v2 = Foundation.Hooks.useTokens()
	local showBackground = v.showBackground
	local udim = UDim.new(0, v.pagePaddingLeft)
	local udim2 = UDim.new(0, v.pagePaddingRight)

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		backgroundStyle = v2.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v.entryHeight),
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = props.testId
	end

	v3.testId = testId

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local size

	if not FFlagAppChatExtendConversationListRowDividers then
		size = UDim2.fromScale(1, 1)
	end

	local backgroundStyle

	if not showBackground then
		backgroundStyle = v2.Color.None
	end

	local customCell = {
		Name = "customCell",
		Size = size,
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = backgroundStyle,
		selection = { Selectable = true },
		onActivated = v.onActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local size2

	if not FFlagAppChatExtendConversationListRowDividers then
		size2 = UDim2.fromScale(1, 1)
	end

	local right

	if not FFlagAppChatExtendConversationListRowDividers then
		right = udim2
	end

	local v4 = {
		icon = React.createElement(
			Foundation.View,
			{ tag = "row align-x-center align-y-center size-1000-1000", LayoutOrder = 0 },
			{
				iconTile = React.createElement(
					Foundation.View,
					{
						tag = "row align-x-center align-y-center size-900-900 radius-medium bg-surface-100"
					},
					{
						icon = React.createElement(Foundation.Icon, {
							name = props.entryIcon,
							size = Foundation.Enums.IconSize.Medium,
							style = v2.Color.Content.Emphasis
						})
					}
				)
			}
		),
		body = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local v5 = {
		mainContent = React.createElement(Foundation.View, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, {
			info = React.createElement(
				Foundation.View,
				{ tag = "col align-y-center fill gap-xxsmall size-0-full clip", LayoutOrder = 1 },
				{
					title = React.createElement(Foundation.Text, {
						tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end content-default",
						Name = "title",
						Text = props.titleText or "",
						LayoutOrder = 1
					}),
					subtitle = React.createElement(Foundation.Text, {
						tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
						Name = "subTitle",
						Text = props.subTitleText or "",
						LayoutOrder = 2
					})
				}
			),
			chevron = React.createElement(Foundation.View, {
				tag = {
					["row align-y-center size-0-full auto-x"] = FFlagAppChatAlignCustomConversationListRowChevron,
					["row align-x-center align-y-center size-1200-full"] = not FFlagAppChatAlignCustomConversationListRowChevron
				},
				LayoutOrder = 2
			}, {
				icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.ChevronLargeRight,
					size = Foundation.Enums.IconSize.Medium,
					style = v2.Color.Content.Emphasis
				})
			})
		}),
		divider = 0
	}
	local divider

	if not FFlagAppChatRemoveConversationListDivider then
		divider = React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y", Name = "divider", LayoutOrder = 2 },
			{
				line = React.createElement(Foundation.Divider)
			}
		)
	end

	v5.divider = divider
	v4.body = createElement4(view4, {
		tag = "col fill size-0-full clip",
		Name = "body",
		LayoutOrder = 1
	}, v5)
	return createElement(view, v3, {
		customCell = createElement2(view2, customCell, {
			content = createElement3(view3, {
				Size = size2,
				tag = "row align-y-center gap-small size-full",
				padding = { left = udim, right = right }
			}, v4)
		})
	})
end

return React.memo(CustomConversationListRow)
