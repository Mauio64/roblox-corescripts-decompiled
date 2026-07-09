local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChatParent.SocialCards)

local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local memo = React.memo
local Cryo = require(AppChatParent.Cryo)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local CardContainer = require(script.Parent.CardContainer)
local SystemMessage = require(script.Parent.SystemMessage)
local GetFFlagEnableSocialCards = require(AppChatParent.SharedFlags).GetFFlagEnableSocialCards
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local DomLocators = require(AppChat.Utils.DomLocators)
local t1 = {
	cards = nil,
	text = "",
	parentWidth = 0,
	showDateTime = false,
	senderTargetId = nil
}

local function getCardComponentTypes(p1) -- line: 47
	local t2 = {}

	if not p1 then
		return t2
	end

	for _, v20 in p1 do
		local components = v20.components

		if components then
			for _, v23 in components do
				if v23.type then
					table.insert(t2, v23.type)
				end
			end
		end
	end

	return t2
end

function SystemMessageContainer(t3: {[any]: any}) -- line: 67
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), getFFlagDebugAppChat (copy), GetFFlagEnableSocialCards (copy), FFlagDebugAppChatEnableDomLocators (copy), getCardComponentTypes (copy), DomLocators (copy), CardContainer (copy), FFlagAppChatDomLocatorFoundationMigration (copy), Foundation (copy), SystemMessage (copy)
	local v25 = Cryo.Dictionary.join(t1, t3)
	local v26 = useStyle()
	local v27, v28 = React.useState(false)
	local v29 = React.useCallback(function() -- line: 72
		-- upvalues: getFFlagDebugAppChat (copy), v28 (copy)
		if getFFlagDebugAppChat() then
			v28(function(p2) -- line: 74
				return not p2
			end)
		end
	end, { v28 })

	if GetFFlagEnableSocialCards() and v25.cards then
		local v30 = nil

		if FFlagDebugAppChatEnableDomLocators then
			local v31 = getCardComponentTypes(v25.cards)

			if #v31 > 0 then
				v30 = DomLocators.chatConversationSystemMessageCard(v31)
			end
		end

		return React.createElement(CardContainer, {
			cards = v25.cards,
			senderTargetId = v25.senderTargetId,
			conversationId = v25.conversationId,
			testId = v30
		})
	end

	if FFlagAppChatDomLocatorFoundationMigration then
		return React.createElement(Foundation.View, {
			tag = "col size-full-0 auto-y align-x-center",
			onActivated = if not getFFlagDebugAppChat() then nil else v29,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatConversationSystemMessage(v25.text)
		}, {
			DateTime = v25.showDateTime and React.createElement(SystemMessage, {
				LayoutOrder = 1,
				maxWidth = 1000,
				Text = v25.sent:GetLongRelativeTime()
			}),
			SystemMessage = React.createElement(SystemMessage, {
				LayoutOrder = 2,
				Text = v25.text,
				maxWidth = v25.parentWidth * 0.75
			}),
			Notice = v27 and React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-small",
				LayoutOrder = 3,
				Text = v25.messageId
			}),
			debug = v25.debugElement or nil
		})
	end

	return React.createElement(not getFFlagDebugAppChat() and "Frame" or "TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = if not getFFlagDebugAppChat() then nil else "",
		[React.Event.Activated] = if not getFFlagDebugAppChat() then nil else v29
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		DateTime = v25.showDateTime and React.createElement(SystemMessage, {
			LayoutOrder = 1,
			maxWidth = 1000,
			Text = v25.sent:GetLongRelativeTime()
		}),
		SystemMessage = React.createElement(SystemMessage, {
			LayoutOrder = 2,
			Text = v25.text,
			maxWidth = v25.parentWidth * 0.75
		}),
		Notice = v27 and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v25.messageId,
			TextColor3 = v26.Theme.UIDefault.Color,
			TextTransparency = v26.Theme.UIDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center
		}),
		debug = v25.debugElement or nil
	})
end

return memo(SystemMessageContainer)
