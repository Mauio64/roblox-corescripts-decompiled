local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local DomLocators = require(AppChat.Utils.DomLocators)
local Squads = require(AppChatParent.Squads)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)
local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local useConversationRowPresentation = require(script.Parent.useConversationRowPresentation)
local SquadButtonSourceEnum = Squads.Enums.SquadButtonSourceEnum
local SquadComponentAccessWrapper = Squads.SquadComponentAccessWrapper
local SquadJoinButton = Squads.SquadJoinButton
local v14 = React.memo(ConversationFacePile)

local function ConversationRow(t1: {[any]: any}) -- line: 41
	-- upvalues: useConversationRowPresentation (copy), Foundation (copy), React (copy), FFlagDebugAppChatEnableDomLocators (copy), v14 (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), DomLocators (copy), FFlagAppChatRemoveConversationListDivider (copy)
	local v17 = useConversationRowPresentation({
		conversationId = t1.conversationId,
		entryHeight = t1.entryHeight,
		isSquadEnabled = t1.isSquadEnabled,
		isWideMode = t1.isWideMode,
		onActivated = t1.onActivated,
		onSquadJoinButtonActivated = t1.onSquadJoinButtonActivated,
		fireImpressionEvent = t1.fireImpressionEvent,
		fireClickEvent = t1.fireClickEvent
	})
	local v18 = Foundation.Hooks.useTokens()

	if not v17.hasConversation then
		return nil
	end

	local uDim = UDim.new(0, v17.pagePaddingLeft)
	local uDim2 = UDim.new(0, v17.pagePaddingRight)
	local v21 = t1.showBackground ~= false

	return React.createElement(Foundation.View, {
		BorderSizePixel = 0,
		backgroundStyle = v18.Color.None,
		Size = UDim2.new(1, 0, 0, v17.entryHeight),
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else v17.testId
	}, {
		cell = React.createElement(Foundation.View, {
			Name = "cell",
			tag = {
				["size-full"] = true,
				["bg-surface-0"] = v21
			},
			backgroundStyle = if not v21 then v18.Color.None else nil,
			Size = UDim2.fromScale(1, 1),
			selection = {
				Selectable = true
			},
			onActivated = v17.onRowActivated,
			stateLayer = if not v21 then nil else {
				affordance = Foundation.Enums.StateLayerAffordance.Background
			},
			ref = v17.rowRef
		}, {
			debugCellContainer = if not t1.debugCellValue then nil else React.createElement("Folder", {}, {
				debugCell = React.createElement("StringValue", {
					Value = t1.debugCellValue
				})
			}),
			content = React.createElement(Foundation.View, {
				tag = "row align-y-center gap-small size-full",
				Size = UDim2.fromScale(1, 1),
				padding = {
					left = uDim,
					right = uDim2
				}
			}, {
				avatar = React.createElement(Foundation.View, {
					tag = "size-1000-1000",
					LayoutOrder = 0
				}, {
					facePile = React.createElement(v14, {
						selectable = false,
						conversationId = v17.conversationId,
						onActivated = v17.onRowActivated,
						participants = v17.participants,
						localUserId = t1.localUserId
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
							titleContainer = React.createElement(Foundation.View, {
								tag = "row align-y-center gap-xxsmall size-full-0 auto-y clip",
								Name = "titleContainer",
								LayoutOrder = 1
							}, {
								title = React.createElement(Foundation.Text, {
									tag = "shrink auto-xy text-title-large text-align-x-left text-truncate-split content-default",
									Name = "title",
									LayoutOrder = 1,
									Text = v17.title
								}),
								subscriptionBadge = React.createElement(Foundation.View, {
									tag = "size-400-400",
									Name = "subscriptionBadge",
									LayoutOrder = 2,
									Visible = v17.showSubscriptionBadge
								}, {
									icon = React.createElement(Foundation.Icon, {
										name = Foundation.Enums.IconName.RobloxPlus,
										size = Foundation.Enums.IconSize.Small,
										style = v18.Color.Content.Emphasis
									})
								})
							}),
							subtitle = React.createElement(Foundation.Text, {
								tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
								LayoutOrder = 2,
								Text = v17.subtitleText
							})
						}),
						rightContent = React.createElement(Foundation.View, {
							tag = "row align-y-center size-0-full auto-x",
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.X
						}, {
							squadButton = if not v17.showSquadButton then nil else React.createElement(Foundation.View, {
								tag = "row align-x-right align-y-center auto-xy",
								LayoutOrder = 0
							}, {
								wrapper = React.createElement(SquadComponentAccessWrapper, {
									parentChannelId = v17.conversationId
								}, {
									button = React.createElement(SquadJoinButton, {
										isFullWidth = false,
										isInCard = false,
										layoutOrder = 0,
										Selectable = false,
										shouldAnimate = false,
										conversationId = v17.conversationId,
										onActivated = v17.onSquadActivated,
										squadButtonSource = SquadButtonSourceEnum.ConversationEntry,
										squadLocation = v17.squadLocation,
										testId = if not FFlagDebugAppChatEnableDomLocators or not v17.locatorTitle then nil else DomLocators.chatLandingConversationEntrySquadButton(v17.locatorTitle)
									})
								})
							}),
							timestampCluster = React.createElement(Foundation.View, {
								tag = "row align-y-center gap-xsmall auto-xy",
								Name = "timestampCluster",
								LayoutOrder = 1,
								Visible = v17.showTimestamp
							}, {
								timestamp = React.createElement(Foundation.Text, {
									tag = "auto-xy text-body-small content-default",
									Name = "timeStamp",
									LayoutOrder = 1,
									Text = v17.timestampText
								}),
								unreadDot = React.createElement(Foundation.View, {
									tag = "size-200-200 radius-circle bg-action-emphasis",
									Name = "unreadDot",
									LayoutOrder = 2,
									Visible = v17.showUnread
								})
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

return React.memo(ConversationRow)
