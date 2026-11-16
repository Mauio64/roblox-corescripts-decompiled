local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

local FFlagAppChatExtendConversationListRowDividers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatExtendConversationListRowDividers")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local FFlagAppChatAlignCustomConversationListRowChevron = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAlignCustomConversationListRowChevron")

local useCustomConversationListRowPresentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CustomConversationListRow/useCustomConversationListRowPresentation")

local function CustomConversationListRow(props)
	local v5 = useCustomConversationListRowPresentation({
		entryHeight = props.entryHeight,
		onActivated = props.onActivated
	})

	local v6 = Foundation.Hooks.useTokens()
	local showBackground = v5.showBackground
	local udim = UDim.new(0, v5.pagePaddingLeft)
	local udim2 = UDim.new(0, v5.pagePaddingRight)

	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		backgroundStyle = v6.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v5.entryHeight),
		testId = 0
	}
	local v8 = if FFlagDebugAppChatEnableDomLocators then props.testId else nil
	v7.testId = v8

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v10 = if not FFlagAppChatExtendConversationListRowDividers then UDim2.fromScale(1, 1) else nil

	local v11 = if not showBackground then v6.Color.None else nil
	local customCell = {
		Name = "customCell",
		Size = v10,
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = v11,
		selection = { Selectable = true },
		onActivated = v5.onActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v14 = if not FFlagAppChatExtendConversationListRowDividers then UDim2.fromScale(1, 1) else nil

	local v17 = {
		icon = React.createElement(
			Foundation.View,
			{
				tag = "row align-x-center align-y-center size-1000-1000",
				LayoutOrder = 0
			},
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
							style = v6.Color.Content.Emphasis
						})
					}
				)
			}
		),
		body = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local v19 = {
		mainContent = React.createElement(Foundation.View, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, {
			info = React.createElement(
				Foundation.View,
				{
					tag = "col align-y-center fill gap-xxsmall size-0-full clip",
					LayoutOrder = 1
				},
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
					style = v6.Color.Content.Emphasis
				})
			})
		}),
		divider = 0
	}

	local v20 = if not FFlagAppChatRemoveConversationListDivider then React.createElement(
		Foundation.View,
		{ tag = "size-full-0 auto-y", Name = "divider", LayoutOrder = 2 },
		{
			line = React.createElement(Foundation.Divider)
		}
	) else nil
	v19.divider = v20
	v17.body = createElement4(
		view4,
		{ tag = "col fill size-0-full clip", Name = "body", LayoutOrder = 1 },
		v19
	)
	return createElement(view, v7, {
		customCell = createElement2(view2, customCell, {
			content = createElement3(view3, {
				Size = v14,
				tag = "row align-y-center gap-small size-full",
				padding = {
					left = udim,
					right = if not FFlagAppChatExtendConversationListRowDividers then udim2 else nil
				}
			}, v17)
		})
	})
end

return React.memo(CustomConversationListRow)
