local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiTabExperimentation = SocialExperiments.ExpChatPresetChatEmojiTabExperimentation

local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectIsChatWindowVisible(p)
	return p.ChatVisibility.isChatWindowEnabled.value
end

local function PresetChatEmojiTabExposureLogger(): nil
	local v = useSelector(selectIsChatWindowVisible)
	local userChatEnabled = isUserChatEnabled((SignalsReact.useSignalState(GetChatStatusStore(false).getChatStatus)))

	React.useEffect(function()
		if v and userChatEnabled then
			ExpChatPresetChatEmojiTabExperimentation.logExposure()
		end
	end, { v, userChatEnabled })

	return nil
end

return PresetChatEmojiTabExposureLogger
