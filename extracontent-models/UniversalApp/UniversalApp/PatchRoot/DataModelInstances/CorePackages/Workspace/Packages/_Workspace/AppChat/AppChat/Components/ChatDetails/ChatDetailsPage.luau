local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(script.Parent.Logger)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useCallback = React.useCallback
local memo = React.memo
local Images = require(AppChatParent.UIBlox).App.ImageSet.Images
local useTextSizeOffset = require(AppChatParent.UIBlox).Core.Style.useTextSizeOffset
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local SectionHeader = require(script.Parent.SectionHeader)
local GroupNameEntryCell = require(script.Parent.GroupNameEntryCell)
local AddFriendsEntry = require(script.Parent.AddFriendsEntry)
local ParticipantList = require(script.Parent.ParticipantList)
local LeaveGroupCell = require(script.Parent.LeaveGroupCell)
local TestStyle = require(AppChat.SocialLibraries).Components.TestStyle
local ConversationTypeCell = require(script.Parent.UnfilteredThreads.ConversationTypeCell)
local CreateUnfilteredChatCell = require(script.Parent.UnfilteredThreads.CreateUnfilteredChatCell)
local useIsAppChatVerticallyConstrained = require(AppChat.App.Hooks.useIsAppChatVerticallyConstrained)
local v20 = game:DefineFastFlag("AppChatDetailsPageAutomaticCanvasSize", false)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local t1 = {
	localUserId = nil,
	conversation = nil,
	conversationId = nil,
	isGroupConversation = false,
	topBarHeight = 0,
	shouldShowCreateUnfilteredChat = false,
	shouldHideGroupChatFunctionality = false,
	shouldShowAddFriends = true,
	conversationTitle = "PlaceholderTitle",
	pageHeaderText = "localizedText.ChatDetails",
	generalText = "localizedText.General",
	membersText = "localizedText.Members",
	addFriendsText = "localizedText.AddFriends",
	leaveGroupText = "localizedText.LeaveGroup",
	onlinePresenceText = "localizedText.OnlineText",
	offlinePresenceText = "localizedText.OfflineText",
	conversationTypeHeaderText = "Expressive Chat Features",
	conversationTypeText = "localizedText.ConversationTypeText",
	createUnfilteredChatText = "Create new chat without filters",
	createUnfilteredChatSubTitleText = "All members of this conversation will be invited, but some are not eligible to join.",
	LayoutOrder = 0,
	participants = {},
	navigateBack = function() -- line: 81
	end,
	onGroupNameEntryCellActivated = function(_) -- line: 96
		-- upvalues: Logger (copy)
		Logger:warning("onGroupNameEntryCellActivated was not passed to ChatDetailsPage")
	end,
	onAddFriendsCellActivated = function(_) -- line: 99
		-- upvalues: Logger (copy)
		Logger:warning("onAddFriendsCellActivated was not passed to ChatDetailsPage")
	end,
	onLeaveGroupCellActivated = function(_) -- line: 102
		-- upvalues: Logger (copy)
		Logger:warning("onLeaveGroupCellActivated was not passed to ChatDetailsPage")
	end,
	onParticipantCellActivated = function(_, _) -- line: 105
		-- upvalues: Logger (copy)
		Logger:warning("onParticipantCellActivated was not passed to ChatDetailsPage")
	end,
	onConversationTypeIconActivated = function(_) -- line: 108
		-- upvalues: Logger (copy)
		Logger:warning("onConversationTypeIconActivated was not passed to ChatDetailsPage")
	end,
	onCreateUnfilteredChatCellActivated = function(_) -- line: 111
		-- upvalues: Logger (copy)
		Logger:warning("onCreateUnfilteredChatCellActivated was not passed to ChatDetailsPage")
	end,
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = {
				None = {}
			},
			Size = {
				Size_0 = 0
			}
		}
	})
}

function ChatDetailsPage(t2: {[any]: any}) -- line: 130
	-- upvalues: Cryo (copy), t1 (copy), useTextSizeOffset (copy), useTokens (copy), useIsAppChatVerticallyConstrained (copy), Logger (copy), useCallback (copy), useIsChatUserMessagesEnabled (copy), React (copy), v20 (copy), SectionHeader (copy), GroupNameEntryCell (copy), Images (copy), AddFriendsEntry (copy), ParticipantList (copy), LeaveGroupCell (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ConversationTypeCell (copy), CreateUnfilteredChatCell (copy)
	local v33 = Cryo.Dictionary.join(t1, t2)
	local style = v33.style
	local v35 = useTextSizeOffset()
	local v36 = useTokens().Size.Size_1200 + 2 * v35
	local v37 = useIsAppChatVerticallyConstrained()
	local t3 = {
		ChatGroupHeader = {
			marginTop = style.Tokens.Size.Size_0,
			marginBottom = style.Tokens.Size.Size_0
		},
		MembersHeader = {
			marginTop = style.Tokens.Size.Size_0,
			marginBottom = style.Tokens.Size.Size_0
		},
		GroupNameEntryCell = {
			paddingBottom = style.Tokens.Size.Size_0
		}
	}
	local v39 = useCallback(function() -- line: 174
		-- upvalues: v33 (copy)
		v33.onCreateUnfilteredChatCellActivated(v33.conversation)
	end, { v33.conversation })
	local v40 = useCallback(function(_, p9, p10) -- line: 179
		-- upvalues: v33 (copy)
		if not v33.wideMode and (p9 == Enum.SwipeDirection.Right and p10 == 1) then
			v33.navigateBack()
		end
	end)
	local n1 = 0

	for _, _ in pairs(v33.participants) do
		n1 += 1
	end

	local v44 = useIsChatUserMessagesEnabled()
	local shouldShowAddFriends = v33.shouldShowAddFriends
	local v46 = ((if not shouldShowAddFriends then n1 else n1 + 1)) * v36
	local v47 = v46 + 8 * v36

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		LayoutOrder = v33.LayoutOrder,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		Transparency = style.Tokens.Color.None.Transparency,
		[React.Event.TouchSwipe] = v40,
		Selectable = false
	}, {
		ScrollingContent = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(1, 0, 0, if not v20 then v47 else 0),
			AutomaticCanvasSize = if not v20 then nil else Enum.AutomaticSize.Y,
			LayoutOrder = v33.LayoutOrder,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ChatGroupHeader = v33.isGroupConversation and React.createElement(SectionHeader, {
				LayoutOrder = 1,
				marginTop = not v37 and 20 or t3.ChatGroupHeader.marginTop,
				marginBottom = if not v37 then nil else t3.ChatGroupHeader.marginBottom,
				Text = v33.chatGroupText,
				style = v33.style
			}),
			GroupNameEntryCell = v33.isGroupConversation and React.createElement(GroupNameEntryCell, {
				LayoutOrder = 2,
				groupNameText = v33.conversationTitle,
				iconImage = Images["icons/actions/edit/edit"],
				isDisabled = v33.shouldHideGroupChatFunctionality or not v44,
				cellHeight = v36,
				paddingBottom = if not v37 then nil else t3.GroupNameEntryCell.paddingBottom,
				onActivated = function() -- line: 153
					-- upvalues: v33 (copy)
					v33.onGroupNameEntryCellActivated(v33.conversation)
				end,
				style = v33.style
			}),
			MembersHeader = React.createElement(SectionHeader, {
				LayoutOrder = 3,
				marginTop = not v37 and 14 or t3.MembersHeader.marginTop,
				marginBottom = not v37 and 8 or t3.MembersHeader.marginBottom,
				Text = v33.membersText,
				style = v33.style
			}),
			MembersFrame = React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, v46),
				BackgroundColor3 = style.Theme.BackgroundDefault.Color,
				BackgroundTransparency = style.Tokens.Color.None.Transparency
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				AddFriendsCell = if not shouldShowAddFriends then nil else React.createElement(AddFriendsEntry, {
					LayoutOrder = 1,
					Text = v33.addFriendsText,
					iconImage = Images["icons/actions/edit/add"],
					cellHeight = v36,
					onActivated = function() -- line: 157
						-- upvalues: v33 (copy)
						v33.onAddFriendsCellActivated(v33.conversation)
					end,
					style = v33.style
				}),
				ParticipantList = React.createElement(ParticipantList, {
					LayoutOrder = 2,
					childWidth = 120,
					activeParticipantId = v33.activeParticipantId,
					entries = v33.participants,
					entryHeight = v36,
					onlinePresenceText = v33.onlinePresenceText,
					offlinePresenceText = v33.offlinePresenceText,
					onEntryActivated = function(p11, p12) -- line: 165
						-- upvalues: Logger (copy), v33 (copy)
						Logger:info("onParticipantCellActivated: {}", p11.id)

						if p11.isLocalUser then
							return
						end

						v33.onParticipantCellActivated(p11.id, p12)
					end
				})
			}),
			LeaveGroupCell = v33.isGroupConversation and React.createElement(LeaveGroupCell, {
				LayoutOrder = 5,
				leaveGroupText = v33.leaveGroupText,
				iconImage = Images["icons/controls/vehicle/exit"],
				cellHeight = v36,
				onActivated = function() -- line: 161
					-- upvalues: v33 (copy)
					v33.onLeaveGroupCellActivated(v33.conversation)
				end,
				style = v33.style,
				testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsListActionButton("leaveGroup")
			}),
			ConversationTypeHeader = if not v44 then nil else React.createElement(SectionHeader, {
				LayoutOrder = 6,
				marginTop = 26,
				Text = v33.conversationTypeHeaderText,
				style = v33.style
			}),
			ConversationTypeCell = if not v44 then nil else React.createElement(ConversationTypeCell, {
				layoutOrder = 7,
				bodyText = v33.conversationTypeText,
				iconImage = Images["icons/actions/info"],
				onIconActivated = v33.onConversationTypeIconActivated,
				style = v33.style
			}),
			CreateUnfilteredChatCell = if not v44 or not v33.shouldShowCreateUnfilteredChat then nil else React.createElement(CreateUnfilteredChatCell, {
				layoutOrder = 8,
				bodyText = v33.createUnfilteredChatText,
				subTitleText = v33.createUnfilteredChatSubTitleText,
				iconImage = Images["icons/actions/edit/copy"],
				cellHeight = v36,
				isLoading = v33.isCreateUnfilteredChatLoading,
				conversationId = v33.conversationId,
				onActivated = v39,
				style = v33.style
			})
		})
	})
end

return memo(ChatDetailsPage)
