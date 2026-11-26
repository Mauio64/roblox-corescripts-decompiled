require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCards")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local getFFlagDebugAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagDebugAppChat")

local CardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/CardContainer")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessage")

local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableSocialCards
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatDomLocatorFoundationMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDomLocatorFoundationMigration")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local v5 = {
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

	for k, item in cards do
		local components = item.components

		if not components then
			continue
		end

		for k2, component in components do
			if component.type then
				table.insert(types, component.type)
			end
		end
	end

	return types
end

function LUAUFORGE_MODULE_GLOBALS_hyA_SystemMessageContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()

	local state, setState = React.useState(false)
	local v7 = React.useCallback(function()
		if getFFlagDebugAppChat() then
			setState(function(p3): boolean
				return not p3
			end)
		end
	end, { setState })

	if getFFlagEnableSocialCards() and joined.cards then
		local v8 = nil

		if FFlagDebugAppChatEnableDomLocators then
			local cardComponentTypes = getCardComponentTypes(joined.cards)

			if #cardComponentTypes > 0 then
				v8 = DomLocators.chatConversationSystemMessageCard(cardComponentTypes)
			end
		end

		return React.createElement(CardContainer, {
			cards = joined.cards,
			senderTargetId = joined.senderTargetId,
			conversationId = joined.conversationId,
			testId = v8
		})
	elseif FFlagAppChatDomLocatorFoundationMigration then
		local createElement = React.createElement
		local view = Foundation.View

		if not getFFlagDebugAppChat() then
			v7 = nil
		end

		local v9 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatConversationSystemMessage(joined.text) else nil
		return createElement(
			view,
			{
				tag = "col size-full-0 auto-y align-x-center",
				onActivated = v7,
				testId = v9
			},
			{
				DateTime = joined.showDateTime and React.createElement(module6, {
					LayoutOrder = 1,
					Text = joined.sent:GetLongRelativeTime(),
					maxWidth = 1000
				}),
				SystemMessage = React.createElement(module6, {
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
		local v8 = getFFlagDebugAppChat() and "TextButton" or "Frame"
		local v9 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			["AutomaticSize"] = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			Text = getFFlagDebugAppChat() and "" or nil
		}
		local activated = React.Event.Activated

		if not getFFlagDebugAppChat() then
			v7 = nil
		end

		v9[activated] = v7
		return createElement(v8, v9, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			DateTime = joined.showDateTime and React.createElement(module6, {
				LayoutOrder = 1,
				Text = joined.sent:GetLongRelativeTime(),
				maxWidth = 1000
			}),
			SystemMessage = React.createElement(module6, {
				LayoutOrder = 2,
				Text = joined.text,
				maxWidth = joined.parentWidth * 0.75
			}),
			Notice = state and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 3,
				Text = joined.messageId,
				TextColor3 = v6.Theme.UIDefault.Color,
				TextTransparency = v6.Theme.UIDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center
			}),
			debug = joined.debugElement or nil
		})
	end
end

return memo(LUAUFORGE_MODULE_GLOBALS_hyA_SystemMessageContainer)
