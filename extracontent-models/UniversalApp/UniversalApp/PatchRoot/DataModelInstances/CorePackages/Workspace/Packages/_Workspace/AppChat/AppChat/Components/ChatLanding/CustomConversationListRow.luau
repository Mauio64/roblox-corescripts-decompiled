local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)
local useCustomConversationListRowPresentation = require(script.useCustomConversationListRowPresentation)

local function CustomConversationListRow(t1: {[any]: any}) -- line: 28
	-- upvalues: useCustomConversationListRowPresentation (copy), Foundation (copy), React (copy), FFlagDebugAppChatEnableDomLocators (copy), FFlagAppChatRemoveConversationListDivider (copy)
	local v10 = useCustomConversationListRowPresentation({
		entryHeight = t1.entryHeight,
		onActivated = t1.onActivated
	})
	local v11 = Foundation.Hooks.useTokens()

	return React.createElement(Foundation.View, {
		BorderSizePixel = 0,
		backgroundStyle = v11.Color.None,
		Size = UDim2.new(1, 0, 0, v10.entryHeight),
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else t1.testId
	}, {
		customCell = React.createElement(Foundation.View, {
			Name = "customCell",
			tag = "size-full bg-surface-0",
			Size = UDim2.fromScale(1, 1),
			selection = {
				Selectable = true
			},
			onActivated = v10.onActivated,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.Background
			}
		}, {
			content = React.createElement(Foundation.View, {
				tag = "row align-y-center gap-small size-full",
				Size = UDim2.fromScale(1, 1),
				padding = {
					left = UDim.new(0, v10.pagePaddingLeft),
					right = UDim.new(0, v10.pagePaddingRight)
				}
			}, {
				icon = React.createElement(Foundation.View, {
					tag = "row align-x-center align-y-center size-1000-1000",
					LayoutOrder = 0
				}, {
					iconTile = React.createElement(Foundation.View, {
						tag = "row align-x-center align-y-center size-900-900 radius-medium bg-surface-100"
					}, {
						icon = React.createElement(Foundation.Icon, {
							name = t1.entryIcon,
							size = Foundation.Enums.IconSize.Medium,
							style = v11.Color.Content.Emphasis
						})
					})
				}),
				body = React.createElement(Foundation.View, {
					tag = "col fill size-0-full clip",
					Name = "body",
					LayoutOrder = 1
				}, {
					mainContent = React.createElement(Foundation.View, {
						tag = "row align-y-center fill gap-small size-full-0 clip",
						Name = "mainContent",
						LayoutOrder = 1
					}, {
						info = React.createElement(Foundation.View, {
							tag = "col align-y-center fill gap-xxsmall size-0-full clip",
							LayoutOrder = 1
						}, {
							title = React.createElement(Foundation.Text, {
								tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end content-default",
								Name = "title",
								LayoutOrder = 1,
								Text = t1.titleText or ""
							}),
							subtitle = React.createElement(Foundation.Text, {
								tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
								Name = "subTitle",
								LayoutOrder = 2,
								Text = t1.subTitleText or ""
							})
						}),
						chevron = React.createElement(Foundation.View, {
							tag = "row align-x-center align-y-center size-1200-full",
							LayoutOrder = 2
						}, {
							icon = React.createElement(Foundation.Icon, {
								name = Foundation.Enums.IconName.ChevronLargeRight,
								size = Foundation.Enums.IconSize.Medium,
								style = v11.Color.Content.Emphasis
							})
						})
					}),
					divider = if FFlagAppChatRemoveConversationListDivider then nil else React.createElement(Foundation.View, {
						tag = "size-full-0 auto-y",
						Name = "divider",
						LayoutOrder = 2
					}, {
						line = React.createElement(Foundation.Divider)
					})
				})
			})
		})
	})
end

return React.memo(CustomConversationListRow)
