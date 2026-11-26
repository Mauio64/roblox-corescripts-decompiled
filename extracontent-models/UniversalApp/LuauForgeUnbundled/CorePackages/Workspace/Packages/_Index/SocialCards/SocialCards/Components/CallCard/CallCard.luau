local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local getFriendsCallingStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/FriendsCalling/Stores").GetFriendsCallingStore
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Loggers").Logger:new("CallCard")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/SharedFlags")

local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local mapCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/mapCallCard")
local parseCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/parseCallCard")
local RingingIndicator = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/RingingIndicator")
local useCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/useCallCard")

local fFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration

local FriendsCallingService = game:GetService("FriendsCallingService")

local udim = UDim.new(0, 20)

local function CallCard(props)
	local v6 = useTokens()
	local v8, v9, v10 = useCallCard((React.useMemo(function()
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
	local callId = v8.callId
	local conversationId = props.conversationId
	local v11 = React.useCallback(function()
		getFriendsCallingStore(false).expand()
	end, {})
	local v12 = React.useCallback(function()
		if fFlagFriendsCallingServiceLuaMigration then
			pcall(function()
				FriendsCallingService:AnswerCall(callId)
			end)
			return
		end

		local CallingService = game:GetService("CallingService")
		CallingService:AnswerIncomingCall(callId)
	end, { callId })
	local v13 = React.useCallback(function()
		if fFlagFriendsCallingServiceLuaMigration then
			local success, result = pcall(function()
				FriendsCallingService:StartCall({ conversationId = conversationId })
			end)

			if not success then
				v5:debug("FriendsCallingService:StartCall failed: {}", result)
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

	if not v10 or v9 ~= nil then
		v12 = nil
	end

	if v9 ~= nil then
		v13 = nil
	end

	if not v10 then
		v11 = nil
	end

	local v15 = mapCallCard(v8, v12, v13, v11)

	local createElement = React.createElement
	local v17 = {
		Size = UDim2.fromOffset(200, 0),
		cornerRadius = udim,
		onActivated = v15.onActivated,
		tag = "row align-y-center gap-small auto-y padding-x-medium padding-y-small bg-shift-400",
		testId = props.testId
	}
	local v18 = {
		Icon = React.createElement(icon, {
			LayoutOrder = 1,
			name = v15.icon,
			size = iconSize.Large,
			style = v6.Color.Content.Muted
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v21 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = v15.title,
			tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis"
		}),
		Status = 0
	}
	local v22

	if v15.description ~= nil then
		local createElement3 = React.createElement

		local v25 = {
			Description = React.createElement(text, {
				LayoutOrder = 1,
				Text = v15.description,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default"
			}),
			Ringing = 0
		}

		local v26 = if v15.isRinging then React.createElement(RingingIndicator, {
			LayoutOrder = 2
		}) else nil
		v25.Ringing = v26
		v22 = createElement3(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			},
			v25
		)
	end

	v21.Status = v22
	v18.Content = createElement2(view, { LayoutOrder = 2, tag = "col fill auto-y" }, v21)
	return createElement(view, v17, v18)
end

return CallCard
