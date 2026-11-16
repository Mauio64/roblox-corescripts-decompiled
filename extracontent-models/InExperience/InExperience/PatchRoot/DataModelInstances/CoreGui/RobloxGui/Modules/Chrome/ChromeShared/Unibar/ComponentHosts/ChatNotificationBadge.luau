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

local SocialExperiments = require(CorePackages.Workspace.Packages.SocialExperiments)
local ExpChatPresetChatBadgeFTUXExperimentation = SocialExperiments.ExpChatPresetChatBadgeFTUXExperimentation

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatPresetChatBadgeExperimentCleanup = SharedFlags.FFlagExpChatPresetChatBadgeExperimentCleanup

local defineFastFlag = game:DefineFastFlag("ExpChatShowPresetTooltipToNonAgeChecked2", false)

require(CorePackages.Workspace.Packages.Chrome)

local function ChatNotificationBadge(p)
	local iconHostProps = p.iconHostProps
	local v = iconHostProps.integration.id == "chat"

	local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
	local v2

	if chatWindowConfiguration == nil then
		v2 = true
	elseif chatWindowConfiguration.HorizontalAlignment == Enum.HorizontalAlignment.Left then
		v2 = chatWindowConfiguration.VerticalAlignment == Enum.VerticalAlignment.Top
	else
		v2 = false
	end

	local v3 = false
	local v4, v5

	if FFlagExpChatUseUnifiedTooltipStore then
		local chatTooltipStore = GetChatTooltipStore(false)
		v4 = SignalsReact.useSignalState(chatTooltipStore.getIsChatWindowOpen)
		local v6 = SignalsReact.useSignalState(chatTooltipStore.getActiveTooltipKey)
		local v7 = SignalsReact.useSignalState(chatTooltipStore.getIsChatInputBarVisible)
		local v8 = SignalsReact.useSignalState(chatTooltipStore.getIsScreenWideEnough)
		local v9 = v and v8 and v2
		local v10

		if v6 == "GlobalChatTooltip" then
			v10 = v9
		else
			v10 = false
		end

		local v11 = FFlagExpChatPresetChatEnabled

		if v11 then
			v11 = v6 == "PresetChatTooltip" and v9
		end

		v3 = v11

		React.useEffect(function()
			if not v then
				return
			end

			local v12

			if defineFastFlag then
				v12 = v3 and (v7 or v4)
			else
				v12 = v3 and v7
			end

			chatTooltipStore.setShouldShow("GlobalChatTooltip", v10 and v4)

			if FFlagExpChatPresetChatEnabled then
				chatTooltipStore.setShouldShow("PresetChatTooltip", v12)
			end
		end, { v, v10, v3, v7, v4, chatTooltipStore.setShouldShow })

		v5 = v10 or v3
	else
		local globalChatTooltipStore = GetGlobalChatTooltipStore(false)
		local chatStatusStore = GetChatStatusStore(false)

		v4 = SignalsReact.useSignalState(globalChatTooltipStore.getIsChatWindowOpen)
		local userChatEnabled = isUserChatEnabled((SignalsReact.useSignalState(chatStatusStore.getChatStatus)))
		local v6 = SignalsReact.useSignalState(globalChatTooltipStore.getIsGlobalChatTooltipDismissed)
		local v7 = SignalsReact.useSignalState(globalChatTooltipStore.getIsGlobalChatTooltipEligible)
		local v8 = SignalsReact.useSignalState(globalChatTooltipStore.getIsScreenWideEnough)

		local state, setState = React.useState(false)
		React.useEffect(function()
			if not GetFFlagTextChatEnableUniverseChatTabs() then
				return
			end

			if TextChatService:HasAllocatedUniverseChatContext("global") then
				setState(true)
			end

			local universeChatChannelAllocatedConnection = TextChatService.UniverseChatChannelAllocated:Connect(function(p2: string)
				if p2 == "global" then
					setState(true)
				end
			end)

			return function()
				universeChatChannelAllocatedConnection:Disconnect()
			end
		end, {})

		v5 = v and userChatEnabled and v7 and state and v2 and v8 and not v6

		local setShouldShowGlobalChatTooltip = globalChatTooltipStore.setShouldShowGlobalChatTooltip
		React.useEffect(function()
			if v then
				setShouldShowGlobalChatTooltip(v5 and v4)
			end
		end, { v, v5, v4, setShouldShowGlobalChatTooltip })
	end

	local state, setState = React.useState(false)
	React.useEffect(function()
		if v5 and v4 then
			setState(true)
		end
	end, { v5, v4 })
	local v6 = v5 and not state

	if FFlagExpChatPresetChatBadgeExperimentCleanup then
		local v7 = v6 and v3 and not v4
		React.useEffect(function()
			if v7 and ExpChatPresetChatBadgeFTUXExperimentation.isExperimentEnabled then
				ExpChatPresetChatBadgeFTUXExperimentation.logExposure()
			end
		end, { v7 })
	end

	local clone = table.clone(iconHostProps)

	if v6 and (not v3 or ExpChatPresetChatBadgeFTUXExperimentation.getShouldShowPresetChatIconBadge()) then
		clone.minBadgeCount = 1
	end

	return React.createElement(p.NotificationBadge, clone)
end

return ChatNotificationBadge
