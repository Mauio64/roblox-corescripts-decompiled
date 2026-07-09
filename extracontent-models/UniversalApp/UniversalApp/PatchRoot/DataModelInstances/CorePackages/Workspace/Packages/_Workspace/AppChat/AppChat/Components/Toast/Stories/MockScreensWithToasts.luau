local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local Cryo = require(AppChatParent.Cryo)
local createChatTopBar = require(AppChat.createChatTopBar)

return {
	ChatLanding = function(p1) -- line: 11
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), EnumScreens (copy)
		local navigation = p1.navigation
		local v9 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 1, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p1, {
				backButtonDisabled = true,
				headerText = "Chat",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			CreateNewChat = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 90),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "CreateNewChat",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 34
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.CreateNewChat)
				end
			}),
			ChatConversation1 = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 150),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "ChatConversation123",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 47
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = 123
					})
				end
			}),
			ChatConversation2 = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 180),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "ChatConversation456",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 60
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = 456
					})
				end
			}),
			EmptyConversation = v9 and Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 220),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Empty Conv",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 73
					-- upvalues: navigation (copy)
					navigation.navigate("EmptyConversation")
				end
			}),
			Toast = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 280),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 86
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "This is a toast nagivated to by the ChatLanding screen"
							}
						}
					})
				end
			})
		})
	end,
	CreateNewChat = function(p2) -- line: 99
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), EnumScreens (copy)
		local navigation = p2.navigation
		local v12 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 1, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p2, {
				headerText = "CreateNewChat",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			ChatConversation = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 120),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "ChatConversation123",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 121
					-- upvalues: v12 (copy), navigation (copy), EnumScreens (copy)
					if v12 then
						navigation.navigate(EnumScreens.ChatConversation, {
							conversationId = 123
						})

						return
					end

					navigation.replace(EnumScreens.ChatConversation, {
						conversationId = 123
					})
				end
			}),
			Toast = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 250),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 138
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "This is a toast nagivated to by the CreateNewChat screen"
							}
						}
					})
				end
			})
		})
	end,
	EmptyConversation = function(p3) -- line: 151
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
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p3, {
				backButtonDisabled = true,
				headerText = "No Title",
				barHeight = p3.navigation.getScreenProps("topBarHeight", 0)
			}))
		})
	end,
	ChatConversation = function(p4) -- line: 169
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), EnumScreens (copy)
		local navigation = p4.navigation
		local v16 = navigation.getParam("conversationId", 0)
		local v17 = navigation.getScreenProps("wideMode", false)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 0, 0)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p4, {
				backButtonDisabled = v17,
				barHeight = navigation.getScreenProps("topBarHeight", 0),
				headerText = "Conversation" .. tostring(v16)
			})),
			ChatDetails = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 120),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "ChatDetails",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 193
					-- upvalues: navigation (copy), EnumScreens (copy), v16 (copy)
					navigation.navigate(EnumScreens.ChatDetails, {
						conversationId = v16
					})
				end
			}),
			Toast = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 180),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 206
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "This is a toast nagivated to by the ChatConversation screen"
							}
						}
					})
				end
			})
		})
	end,
	ChatDetails = function(p5) -- line: 219
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), EnumScreens (copy)
		local navigation = p5.navigation
		local v20 = navigation.getParam("conversationId", 0)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 1)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p5, {
				barHeight = navigation.getScreenProps("topBarHeight", 0),
				headerText = "ChatDetails" .. v20
			})),
			EditChatMembers = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 120),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "EditChatMembers",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 241
					-- upvalues: navigation (copy), EnumScreens (copy), v20 (copy)
					navigation.push(EnumScreens.EditChatMembers, {
						conversationId = v20
					})
				end
			}),
			Toast = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 180),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 254
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "This is a toast nagivated to by the ChatDetails screen"
							}
						}
					})
				end
			})
		})
	end,
	EditChatMembers = function(p6) -- line: 267
		-- upvalues: Roact (copy), createChatTopBar (copy), Cryo (copy), EnumScreens (copy)
		local navigation = p6.navigation
		local v23 = navigation.getParam("conversationId", 0)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 1, 1)
		}, {
			ChatTopBar = createChatTopBar(Cryo.Dictionary.join(p6, {
				headerText = "EditChatMembers",
				barHeight = navigation.getScreenProps("topBarHeight", 0)
			})),
			ChatConversation = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 120),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Back To Conversation",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 289
					-- upvalues: navigation (copy), EnumScreens (copy), v23 (copy)
					navigation.navigate(EnumScreens.ChatConversation, {
						conversationId = v23
					})
				end
			}),
			Toast1 = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 180),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 302
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "A Toast this is"
							}
						}
					})
				end
			}),
			Toast2 = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.Gotham,
				Position = UDim2.new(0.5, 0, 0, 210),
				Size = UDim2.new(0, 200, 0, 30),
				Text = "Show a Different Toast",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 18,
				[Roact.Event.Activated] = function() -- line: 321
					-- upvalues: navigation (copy), EnumScreens (copy)
					navigation.navigate(EnumScreens.RoactChatToast, {
						toastProps = {
							toastContent = {
								toastTitle = "This is a different toast"
							}
						}
					})
				end
			})
		})
	end
}
