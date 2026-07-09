local CorePackages = game:GetService("CorePackages")
local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local dependencies = require(ShareTargetGame.dependencies)
local Roact = dependencies.Roact
local dependenciesText = dependencies.Text
local UIBlox = dependencies.UIBlox
local ConversationCell = require(CorePackages.Workspace.Packages.AppChat.ConversationCell)
local SendButton = require(script.Parent.SendButton)

return function(p1) -- line: 18
	-- upvalues: UIBlox (copy), dependenciesText (copy), Roact (copy), ConversationCell (copy), SendButton (copy)
	local v10 = p1.failedText or ""
	local v11 = p1.sendingText or ""
	local v12 = p1.sendText or ""
	local v13 = p1.sentText or ""
	local v14 = p1.isLoading or false
	local conversation = p1.conversation
	local onSendButtonActivated = p1.onSendButtonActivated

	return UIBlox.Style.withStyle(function(p2) -- line: 28
		-- upvalues: dependenciesText (copy), v12 (copy), Roact (copy), p1 (copy), ConversationCell (copy), conversation (copy), v14 (copy), SendButton (copy), v13 (copy), v11 (copy), v10 (copy), onSendButtonActivated (copy)
		local p2Font = p2.Font
		local v19 = p2Font.CaptionBody.RelativeSize * p2Font.BaseSize
		local v20 = dependenciesText.GetTextWidth(v12, p2Font.CaptionBody.Font, v19) + 14

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = p1.Visible,
			LayoutOrder = p1.LayoutOrder
		}, {
			content = Roact.createElement(ConversationCell, {
				style = p2,
				conversation = conversation,
				subTitleText = p1.subTitleText,
				secondaryTitleText = p1.secondaryTitleText,
				childWidth = v20 + 24 + 12,
				Size = UDim2.new(1, 0, 1, 0),
				isLoading = v14
			}, {
				rightAlignedComponent = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					padding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, 12)
					}),
					layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					sendButton = Roact.createElement(SendButton, {
						sendText = v12,
						sentText = v13,
						sendingText = v11,
						sentStatus = p1.sentStatus,
						failedText = v10,
						isLoading = v14,
						conversation = conversation,
						onActivated = function() -- line: 73
							-- upvalues: onSendButtonActivated (copy), conversation (copy)
							return onSendButtonActivated(conversation)
						end
					})
				})
			})
		})
	end)
end
