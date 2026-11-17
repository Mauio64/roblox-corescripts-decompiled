local SocialCards = script:FindFirstAncestor("SocialCards")
local parent = SocialCards.Parent

local Foundation = require(parent.Foundation)
local Stores = require(parent.FriendsCalling.Stores)
local GetFriendsCallingStore = Stores.GetFriendsCallingStore
local React = require(parent.React)
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)
local SharedFlags = require(parent.SharedFlags)

local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local mapCallCard = require(SocialCards.Components.CallCard.mapCallCard)
local parseCallCard = require(SocialCards.Components.CallCard.parseCallCard)
local RingingIndicator = require(SocialCards.Components.CallCard.RingingIndicator)
local useCallCard = require(SocialCards.Components.CallCard.useCallCard)

local FFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration

local FriendsCallingService = game:GetService("FriendsCallingService")

local udim = UDim.new(0, 20)

local function CallCard(props)
	local v2 = useTokens()
	local v3, v4, v5 = useCallCard((React.useMemo(function()
		return parseCallCard.parseMessageCard({
			call_id = props.call_id,
			duration_seconds = props.duration_seconds,
			enable_join = props.enable_join,
			is_initiator = props.is_initiator,
			status = props.status
		})
	end, {
		props.call_id,
		props.duration_seconds,
		props.enable_join,
		props.is_initiator,
		props.status
	})))
	local callId = v3.callId
	local conversationId = props.conversationId
	local v6 = React.useCallback(function()
		GetFriendsCallingStore(false).expand()
	end, {})
	local v7 = React.useCallback(function()
		if FFlagFriendsCallingServiceLuaMigration then
			pcall(function()
				FriendsCallingService:AnswerCall(callId)
			end)
			return
		end

		local CallingService = game:GetService("CallingService")
		CallingService:AnswerIncomingCall(callId)
	end, { callId })
	local v8 = React.useCallback(function()
		if FFlagFriendsCallingServiceLuaMigration then
			local success, result = pcall(function()
				FriendsCallingService:StartCall({ conversationId = conversationId })
			end)

			if not success then
				v:debug("FriendsCallingService:StartCall failed: {}", result)
			end
		else
			local CallingService = game:GetService("CallingService")
			task.spawn(function()
				pcall(function()
					CallingService:CreateCallAsync({}, conversationId)
				end)
			end)
		end
	end, { conversationId })

	if not v5 or v4 ~= nil then
		v7 = nil
	end

	if v4 ~= nil then
		v8 = nil
	end

	if not v5 then
		v6 = nil
	end

	local v9 = mapCallCard(v3, v7, v8, v6)

	local createElement = React.createElement
	local v10 = {
		Size = UDim2.fromOffset(200, 0),
		cornerRadius = udim,
		onActivated = v9.onActivated,
		tag = "row align-y-center gap-small auto-y padding-x-medium padding-y-small bg-shift-400",
		testId = props.testId
	}
	local v11 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = v9.icon,
			size = IconSize.Large,
			style = v2.Color.Content.Muted
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v12 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v9.title,
			tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis"
		}),
		Status = 0
	}
	local status

	if v9.description ~= nil then
		local createElement3 = React.createElement

		local v13 = {
			Description = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v9.description,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default"
			}),
			Ringing = 0
		}
		local ringing

		if v9.isRinging then
			ringing = React.createElement(RingingIndicator, { LayoutOrder = 2 })
		end

		v13.Ringing = ringing
		status = createElement3(
			View,
			{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
			v13
		)
	end

	v12.Status = status
	v11.Content = createElement2(View, { LayoutOrder = 2, tag = "col fill auto-y" }, v12)
	return createElement(View, v10, v11)
end

return CallCard
