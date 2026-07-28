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
local v14 = game:DefineFastFlag("ExpChatShowPresetTooltipToNonAgeChecked2", false)

require(CorePackages.Workspace.Packages.Chrome)

local function ChatNotificationBadge(t1: {[any]: any}) -- line: 38
	-- upvalues: TextChatService (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), SignalsReact (copy), FFlagExpChatPresetChatEnabled (copy), React (copy), v14 (copy), GetGlobalChatTooltipStore (copy), GetChatStatusStore (copy), isUserChatEnabled (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local iconHostProps = t1.iconHostProps
	local v18 = iconHostProps.integration.id == "chat"
	local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
	local v20 = ChatWindowConfiguration == nil or ChatWindowConfiguration.HorizontalAlignment == Enum.HorizontalAlignment.Left and ChatWindowConfiguration.VerticalAlignment == Enum.VerticalAlignment.Top
	local u21, u22, u29

	if FFlagExpChatUseUnifiedTooltipStore then
		u21 = GetChatTooltipStore(false)
		u22 = SignalsReact.useSignalState(u21.getIsChatWindowOpen)

		local v23 = SignalsReact.useSignalState(u21.getActiveTooltipKey)
		local v24 = SignalsReact.useSignalState(u21.getIsChatInputBarVisible)
		local v25 = SignalsReact.useSignalState(u21.getIsScreenWideEnough)
		local v26 = v18 and (v25 and v20)
		local v27 = v23 == "GlobalChatTooltip" and v26
		local v28 = FFlagExpChatPresetChatEnabled and (v23 == "PresetChatTooltip" and v26)

		React.useEffect(function() -- line: 65
			-- upvalues: v18 (copy), v14 (copy), v28 (copy), v24 (copy), u22 (ref), u21 (ref), v27 (copy), FFlagExpChatPresetChatEnabled (copy)
			if not v18 then
				return
			end

			local v42 = if not v14 then v28 and v24 else v28 and (v24 or u22)

			u21.setShouldShow("GlobalChatTooltip", v27 and u22)

			if FFlagExpChatPresetChatEnabled then
				u21.setShouldShow("PresetChatTooltip", v42)
			end
		end, {
			v18,
			v27,
			v28,
			v24,
			u22,
			u21.setShouldShow
		})
		u29 = v27 or v28
	else
		u21 = GetGlobalChatTooltipStore(false)

		local v30 = GetChatStatusStore(false)

		u22 = SignalsReact.useSignalState(u21.getIsChatWindowOpen)

		local v31 = SignalsReact.useSignalState(v30.getChatStatus)
		local v32 = isUserChatEnabled(v31)
		local v33 = SignalsReact.useSignalState(u21.getIsGlobalChatTooltipDismissed)
		local v34 = SignalsReact.useSignalState(u21.getIsGlobalChatTooltipEligible)
		local v35 = SignalsReact.useSignalState(u21.getIsScreenWideEnough)
		local v36, v37 = React.useState(false)

		React.useEffect(function() -- line: 107
			-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), v37 (copy)
			if not GetFFlagTextChatEnableUniverseChatTabs() then
				return
			end

			if TextChatService:HasAllocatedUniverseChatContext("global") then
				v37(true)
			end

			local connection = TextChatService.UniverseChatChannelAllocated:Connect(function(s1: string) -- line: 116
				-- upvalues: v37 (copy)
				if s1 == "global" then
					v37(true)
				end
			end)

			return function() -- line: 122
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {})
		u29 = v18 and (v32 and (v34 and (v36 and (v20 and (v35 and not v33)))))

		local setShouldShowGlobalChatTooltip = u21.setShouldShowGlobalChatTooltip

		React.useEffect(function() -- line: 136
			-- upvalues: v18 (copy), setShouldShowGlobalChatTooltip (copy), u29 (ref), u22 (ref)
			if v18 then
				setShouldShowGlobalChatTooltip(u29 and u22)
			end
		end, {
			v18,
			u29,
			u22,
			setShouldShowGlobalChatTooltip
		})
	end

	local v39, v40 = React.useState(false)

	React.useEffect(function() -- line: 144
		-- upvalues: u29 (ref), u22 (ref), v40 (copy)
		if u29 and u22 then
			v40(true)
		end
	end, {
		u29,
		u22
	})

	local v41 = table.clone(iconHostProps)

	if u29 and not v39 then
		v41.minBadgeCount = 1
	end

	return React.createElement(t1.NotificationBadge, v41)
end

return ChatNotificationBadge
