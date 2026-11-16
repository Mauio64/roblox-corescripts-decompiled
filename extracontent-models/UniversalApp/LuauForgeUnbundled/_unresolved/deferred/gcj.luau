local module = require("@luauforge/deferred/gce")
local roact = module.Roact
local text = module.Text
local uiBlox = module.UIBlox

local module2 = require("@luauforge/deferred/gck")

local module3 = require("@luauforge/deferred/gcW")

return function(data)
	local failedText = data.failedText or ""
	local sendingText = data.sendingText or ""
	local sendText = data.sendText or ""
	local sentText = data.sentText or ""
	local isLoading = data.isLoading or false

	local conversation = data.conversation
	local onSendButtonActivated = data.onSendButtonActivated

	return uiBlox.Style.withStyle(function(p2)
		local font = p2.Font

		local v5 = font.CaptionBody.RelativeSize * font.BaseSize
		local v6 = text.GetTextWidth(sendText, font.CaptionBody.Font, v5) + 14

		return roact.createElement("Frame", {
			BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = data.Visible,
			LayoutOrder = data.LayoutOrder
		}, {
			content = roact.createElement(module2, {
				style = p2,
				conversation = conversation,
				subTitleText = data.subTitleText,
				secondaryTitleText = data.secondaryTitleText,
				childWidth = v6 + 24 + 12,
				Size = UDim2.new(1, 0, 1, 0),
				isLoading = isLoading
			}, {
				rightAlignedComponent = roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
					{
						padding = roact.createElement("UIPadding", {
							PaddingRight = UDim.new(0, 12)
						}),
						layout = roact.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						sendButton = roact.createElement(module3, {
							sendText = sendText,
							sentText = sentText,
							sendingText = sendingText,
							sentStatus = data.sentStatus,
							failedText = failedText,
							isLoading = isLoading,
							conversation = conversation,
							onActivated = function()
								return onSendButtonActivated(conversation)
							end
						})
					}
				)
			})
		})
	end)
end
