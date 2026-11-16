local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.SocialCards)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local memo = React.memo
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)

local CardContainer = require(script.Parent.CardContainer)
local SystemMessage = require(script.Parent.SystemMessage)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local DomLocators = require(AppChat.Utils.DomLocators)

local v = {
	cards = nil,
	text = "",
	parentWidth = 0,
	showDateTime = false,
	senderTargetId = nil
}

local function getCardComponentTypes(cards)
	local types = {}

	if not cards then
		return types
	end

	for _, item in cards do
		local components = item.components

		if not components then
			continue
		end

		for _, component in components do
			if component.type then
				table.insert(types, component.type)
			end
		end
	end

	return types
end

function SystemMessageContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()

	local state, setState = React.useState(false)
	local onActivated = React.useCallback(function()
		if getFFlagDebugAppChat() then
			setState(function(p2): boolean
				return not p2
			end)
		end
	end, { setState })

	if GetFFlagEnableSocialCards() and joined.cards then
		local testId = nil

		if FFlagDebugAppChatEnableDomLocators then
			local cardComponentTypes = getCardComponentTypes(joined.cards)

			if #cardComponentTypes > 0 then
				testId = DomLocators.chatConversationSystemMessageCard(cardComponentTypes)
			end
		end

		return React.createElement(CardContainer, {
			cards = joined.cards,
			senderTargetId = joined.senderTargetId,
			conversationId = joined.conversationId,
			testId = testId
		})
	elseif FFlagAppChatDomLocatorFoundationMigration then
		local createElement = React.createElement
		local view = Foundation.View

		if not getFFlagDebugAppChat() then
			onActivated = nil
		end

		local testId

		if FFlagDebugAppChatEnableDomLocators then
			testId = DomLocators.chatConversationSystemMessage(joined.text)
		end

		return createElement(
			view,
			{
				tag = "col size-full-0 auto-y align-x-center",
				onActivated = onActivated,
				testId = testId
			},
			{
				DateTime = joined.showDateTime and React.createElement(SystemMessage, {
					LayoutOrder = 1,
					Text = joined.sent:GetLongRelativeTime(),
					maxWidth = 1000
				}),
				SystemMessage = React.createElement(SystemMessage, {
					LayoutOrder = 2,
					Text = joined.text,
					maxWidth = joined.parentWidth * 0.75
				}),
				Notice = state and React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-small",
					LayoutOrder = 3,
					Text = joined.messageId
				}),
				debug = joined.debugElement or nil
			}
		)
	else
		local createElement = React.createElement
		local v3 = getFFlagDebugAppChat() and "TextButton" or "Frame"
		local v4 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			["AutomaticSize"] = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			Text = getFFlagDebugAppChat() and "" or nil
		}
		local activated = React.Event.Activated

		if not getFFlagDebugAppChat() then
			onActivated = nil
		end

		v4[activated] = onActivated
		return createElement(v3, v4, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			DateTime = joined.showDateTime and React.createElement(SystemMessage, {
				LayoutOrder = 1,
				Text = joined.sent:GetLongRelativeTime(),
				maxWidth = 1000
			}),
			SystemMessage = React.createElement(SystemMessage, {
				LayoutOrder = 2,
				Text = joined.text,
				maxWidth = joined.parentWidth * 0.75
			}),
			Notice = state and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 3,
				Text = joined.messageId,
				TextColor3 = v2.Theme.UIDefault.Color,
				TextTransparency = v2.Theme.UIDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center
			}),
			debug = joined.debugElement or nil
		})
	end
end

return memo(SystemMessageContainer)
