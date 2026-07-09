local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local UIBlox = require(AppChatParent.UIBlox)
local SocialLibraries = require(AppChat.SocialLibraries)
local Cryo = require(AppChatParent.Cryo)
local EnumScreens = require(AppChat.EnumScreens)
local GenericDialogType = require(AppChat.Components.ChatDetails.Dialogs.GenericDialogType)
local createChatTopBar = require(AppChat.createChatTopBar)
local ModalBottomSheet = UIBlox.ModalBottomSheet
local Warning = SocialLibraries.Components.AlertViews.Warning

local function GenericButton(p1) -- line: 17
	-- upvalues: Roact (copy)
	return Roact.createElement("TextButton", {
		AnchorPoint = p1.AnchorPoint or Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		LayoutOrder = p1.LayoutOrder or 1,
		Size = p1.Size or UDim2.new(0, 200, 0, 30),
		Position = p1.Position or UDim2.new(0, 0, 0, 0),
		Text = p1.Text,
		TextColor3 = Color3.new(0, 0, 0),
		TextSize = 18,
		[Roact.Event.Activated] = p1.onActivated
	})
end

return {
	ChatLanding = function(p2) -- line: 32
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), EnumScreens (copy)
		local navigation = p2.navigation
		local v16 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 1, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p2, {
				backButtonDisabled = true,
				headerText = "Chat",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			CreateNewChat = Roact.createElement(GenericButton, {
				Text = "CreateNewChat",
				Position = UDim2.new(0.5, 0, 0, 90),
				onActivated = function() -- line: 49
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.CreateNewChat)
				end
			}),
			ChatConversation1 = Roact.createElement(GenericButton, {
				Text = "ChatConversation123",
				Position = UDim2.new(0.5, 0, 0, 150),
				onActivated = function() -- line: 56
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = 123
					})
				end
			}),
			ChatConversation2 = Roact.createElement(GenericButton, {
				Text = "ChatConversation456",
				Position = UDim2.new(0.5, 0, 0, 180),
				onActivated = function() -- line: 63
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = 456
					})
				end
			}),
			EmptyConversation = v16 and Roact.createElement(GenericButton, {
				Text = "Empty Conv",
				Position = UDim2.new(0.5, 0, 0, 220),
				onActivated = function() -- line: 70
					-- upvalues: navigation (copy)
					navigation.navigate("EmptyConversation")
				end
			})
		})
	end,
	CreateNewChat = function(p3) -- line: 77
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), EnumScreens (copy)
		local navigation = p3.navigation
		local v19 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 1, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p3, {
				headerText = "CreateNewChat",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			ChatConversation = Roact.createElement(GenericButton, {
				Text = "ChatConversation123",
				Position = UDim2.new(0.5, 0, 0, 120),
				onActivated = function() -- line: 93
					-- upvalues: v19 (copy), navigation (copy), EnumScreens (copy)
					if v19 then
						navigation.navigate(EnumScreens.ChatConversation, {
							conversationId = 123
						})

						return
					end

					navigation.replace(EnumScreens.ChatConversation, {
						conversationId = 123
					})
				end
			})
		})
	end,
	EmptyConversation = function(p4) -- line: 104
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy)
		return Roact.createElement("TextLabel", {
			BorderSizePixel = 0,
			Text = "Empty Conversation page",
			TextSize = 18,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.new(0, 0, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p4, {
				backButtonDisabled = true,
				headerText = "No Title",
				barHeight = p4.navigation.getScreenProps("topBarHeight", 0)
			}))
		})
	end,
	ChatConversation = function(p5) -- line: 122
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), EnumScreens (copy)
		local navigation = p5.navigation
		local v23 = navigation.getParam("conversationId", 0)
		local v24 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 0, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p5, {
				backButtonDisabled = v24,
				barHeight = navigation.getScreenProps("topBarHeight", 0),
				headerText = "Conversation" .. tostring(v23)
			})),
			ChatDetails = Roact.createElement(GenericButton, {
				Text = "ChatDetails",
				Position = UDim2.new(0.5, 0, 0, 120),
				onActivated = function() -- line: 140
					-- upvalues: navigation (copy), EnumScreens (copy), v23 (copy)
					navigation.navigate(EnumScreens.ChatDetails, {
						conversationId = v23
					})
				end
			})
		})
	end,
	ChatDetails = function(p6) -- line: 147
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), EnumScreens (copy)
		local navigation = p6.navigation
		local v27 = navigation.getParam("conversationId", 0)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 1)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p6, {
				barHeight = navigation.getScreenProps("topBarHeight", 0),
				headerText = "ChatDetails" .. v27
			})),
			EditChatMembers = Roact.createElement(GenericButton, {
				Text = "EditChatMembers",
				Position = UDim2.new(0.5, 0, 0, 120),
				onActivated = function() -- line: 163
					-- upvalues: navigation (copy), EnumScreens (copy), v27 (copy)
					navigation.push(EnumScreens.EditChatMembers, {
						conversationId = v27
					})
				end
			})
		})
	end,
	EditChatMembers = function(p7) -- line: 170
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), EnumScreens (copy)
		local navigation = p7.navigation
		local v30 = navigation.getParam("conversationId", 0)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 1, 1)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p7, {
				headerText = "EditChatMembers",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			ChatConversation = Roact.createElement(GenericButton, {
				Text = "Back To Conversation",
				Position = UDim2.new(0.5, 0, 0, 120),
				onActivated = function() -- line: 186
					-- upvalues: navigation (copy), EnumScreens (copy), v30 (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = v30
					})
				end
			})
		})
	end,
	ChatDetailsWithModals = function(p8) -- line: 193
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), GenericButton (copy), GenericDialogType (copy)
		local navigation = p8.navigation

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 1)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p8, {
				backButtonDisabled = true,
				headerText = "ChatDetails",
				LayoutOrder = 0,
				barHeight = navigation.getScreenProps("topBarHeight", 0),
				contentHeight = navigation.getScreenProps("contentHeight", 0)
			})),
			EditChatGroupName = Roact.createElement(GenericButton, {
				LayoutOrder = 1,
				Text = "EditChatGroupName",
				onActivated = function() -- line: 216
					-- upvalues: navigation (copy), GenericDialogType (copy)
					navigation.navigate(GenericDialogType.EditChatGroupNameDialog)
				end
			}),
			LeaveGroup = Roact.createElement(GenericButton, {
				LayoutOrder = 2,
				Text = "LeaveGroup",
				onActivated = function() -- line: 223
					-- upvalues: navigation (copy), GenericDialogType (copy)
					navigation.navigate(GenericDialogType.LeaveGroupDialog)
				end
			}),
			RemoveUser = Roact.createElement(GenericButton, {
				LayoutOrder = 3,
				Text = "RemoveUser",
				onActivated = function() -- line: 230
					-- upvalues: navigation (copy), GenericDialogType (copy)
					navigation.navigate(GenericDialogType.RemoveUserDialog)
				end
			}),
			ModalBottomSheet = Roact.createElement(GenericButton, {
				LayoutOrder = 4,
				Text = "ModalBottomSheet",
				onActivated = function() -- line: 237
					-- upvalues: navigation (copy), GenericDialogType (copy)
					navigation.navigate(GenericDialogType.ParticipantDialog)
				end
			})
		})
	end,
	EditChatGroupNameDialog = function(p9) -- line: 244
		-- upvalues: Roact (copy), Warning (copy)
		return Roact.createElement(Warning, {
			titleText = "EditChatGroupName",
			bodyText = "Change to new name?",
			onModalClose = function() -- line: 248
				-- upvalues: p9 (copy)
				p9.navigation.goBack()
			end
		})
	end,
	LeaveGroupDialog = function(p10) -- line: 254
		-- upvalues: Roact (copy), Warning (copy)
		return Roact.createElement(Warning, {
			titleText = "LeaveGroup",
			bodyText = "Leave group?",
			onModalClose = function() -- line: 258
				-- upvalues: p10 (copy)
				p10.navigation.goBack()
			end
		})
	end,
	ParticipantDialog = function(p11) -- line: 274
		-- upvalues: Roact (copy), ModalBottomSheet (copy), GenericDialogType (copy)
		return Roact.createElement(ModalBottomSheet, {
			bottomGap = 10,
			screenWidth = 400,
			showImages = false,
			onDismiss = function() -- line: 277
				-- upvalues: p11 (copy)
				p11.navigation.goBack()
			end,
			buttonModels = {
				{
					text = "ViewProfile",
					onActivated = function() -- line: 283
						-- upvalues: p11 (copy)
						p11.navigation.replace("Webview")
					end
				},
				{
					text = "ReportUser",
					onActivated = function() -- line: 289
						-- upvalues: p11 (copy)
						p11.navigation.replace("Webview")
					end
				},
				{
					text = "RemoveUser",
					onActivated = function() -- line: 295
						-- upvalues: p11 (copy), GenericDialogType (copy)
						p11.navigation.replace(GenericDialogType.RemoveUserDialog)
					end
				},
				{
					text = "Cancel",
					onActivated = function() -- line: 301
					end
				}
			}
		})
	end,
	RemoveUserDialog = function(p12) -- line: 264
		-- upvalues: Roact (copy), Warning (copy)
		return Roact.createElement(Warning, {
			titleText = "RemoveUser",
			bodyText = "Remove user?",
			onModalClose = function() -- line: 268
				-- upvalues: p12 (copy)
				p12.navigation.goBack()
			end
		})
	end,
	Webview = function(p13) -- line: 309
		-- upvalues: Roact (copy), GenericButton (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 1)
		}, {
			BackButton = Roact.createElement(GenericButton, {
				Text = "Back",
				AnchorPoint = Vector2.new(0, 0),
				onActivated = function() -- line: 318
					-- upvalues: p13 (copy)
					p13.navigation.goBack()
				end
			})
		})
	end
}
