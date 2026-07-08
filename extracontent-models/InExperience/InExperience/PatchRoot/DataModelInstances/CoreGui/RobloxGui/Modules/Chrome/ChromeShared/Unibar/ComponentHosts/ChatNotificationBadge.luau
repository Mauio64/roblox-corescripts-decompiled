local CorePackages = game:GetService("CorePackages")
local TextChatService = game:GetService("TextChatService")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local GetGlobalChatTooltipStore = ExpChat.Stores.GetGlobalChatTooltipStore
local GetChatTooltipStore = ExpChat.Stores.GetChatTooltipStore
local GetChatStatusStore = ExpChat.Stores.GetChatStatusStore
local isUserChatEnabled = ExpChat.isUserChatEnabled
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore

require(CorePackages.Workspace.Packages.Chrome)

local function ChatNotificationBadge(t1: {[any]: any}) -- line: 35
	-- upvalues: TextChatService (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), SignalsReact (copy), FFlagExpChatPresetChatEnabled (copy), React (copy), GetGlobalChatTooltipStore (copy), GetChatStatusStore (copy), isUserChatEnabled (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local iconHostProps = t1.iconHostProps
	local v17 = iconHostProps.integration.id == "chat"
	local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
	local v19 = ChatWindowConfiguration == nil or ChatWindowConfiguration.HorizontalAlignment == Enum.HorizontalAlignment.Left and ChatWindowConfiguration.VerticalAlignment == Enum.VerticalAlignment.Top
	local u20, u21, u28

	if FFlagExpChatUseUnifiedTooltipStore then
		u20 = GetChatTooltipStore(false)
		u21 = SignalsReact.useSignalState(u20.getIsChatWindowOpen)

		local v22 = SignalsReact.useSignalState(u20.getActiveTooltipKey)
		local v23 = SignalsReact.useSignalState(u20.getIsChatInputBarVisible)
		local v24 = SignalsReact.useSignalState(u20.getIsScreenWideEnough)
		local v25 = v17 and (v24 and v19)
		local v26 = v22 == "GlobalChatTooltip" and v25
		local v27 = FFlagExpChatPresetChatEnabled and (v22 == "PresetChatTooltip" and v25)

		React.useEffect(function() -- line: 62
			-- upvalues: v17 (copy), u20 (ref), v26 (copy), u21 (ref), FFlagExpChatPresetChatEnabled (copy), v27 (copy), v23 (copy)
			if not v17 then
				return
			end

			u20.setShouldShow("GlobalChatTooltip", v26 and u21)

			if FFlagExpChatPresetChatEnabled then
				u20.setShouldShow("PresetChatTooltip", v27 and v23)
			end
		end, {
			v17,
			v26,
			v27,
			v23,
			u21,
			u20.setShouldShow
		})
		u28 = v26 or v27
	else
		u20 = GetGlobalChatTooltipStore(false)

		local v29 = GetChatStatusStore(false)

		u21 = SignalsReact.useSignalState(u20.getIsChatWindowOpen)

		local v30 = SignalsReact.useSignalState(v29.getChatStatus)
		local v31 = isUserChatEnabled(v30)
		local v32 = SignalsReact.useSignalState(u20.getIsGlobalChatTooltipDismissed)
		local v33 = SignalsReact.useSignalState(u20.getIsGlobalChatTooltipEligible)
		local v34 = SignalsReact.useSignalState(u20.getIsScreenWideEnough)
		local v35, v36 = React.useState(false)

		React.useEffect(function() -- line: 97
			-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), v36 (copy)
			if not GetFFlagTextChatEnableUniverseChatTabs() then
				return
			end

			if TextChatService:HasAllocatedUniverseChatContext("global") then
				v36(true)
			end

			local connection = TextChatService.UniverseChatChannelAllocated:Connect(function(s1: string) -- line: 106
				-- upvalues: v36 (copy)
				if s1 == "global" then
					v36(true)
				end
			end)

			return function() -- line: 112
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {})
		u28 = v17 and (v31 and (v33 and (v35 and (v19 and (v34 and not v32)))))

		local setShouldShowGlobalChatTooltip = u20.setShouldShowGlobalChatTooltip

		React.useEffect(function() -- line: 126
			-- upvalues: v17 (copy), setShouldShowGlobalChatTooltip (copy), u28 (ref), u21 (ref)
			if v17 then
				setShouldShowGlobalChatTooltip(u28 and u21)
			end
		end, {
			v17,
			u28,
			u21,
			setShouldShowGlobalChatTooltip
		})
	end

	local v38, v39 = React.useState(false)

	React.useEffect(function() -- line: 134
		-- upvalues: u28 (ref), u21 (ref), v39 (copy)
		if u28 and u21 then
			v39(true)
		end
	end, {
		u28,
		u21
	})

	local v40 = table.clone(iconHostProps)

	if u28 and not v38 then
		v40.minBadgeCount = 1
	end

	return React.createElement(t1.NotificationBadge, v40)
end

return ChatNotificationBadge
