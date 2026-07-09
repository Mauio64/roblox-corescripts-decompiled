local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)
local v8, _ = loadFoundationCloudAsset("pictograms/chat")
local v10, _ = loadFoundationCloudAsset("pictograms/voice_chat")

local function EmptyConversationPage() -- line: 15
	-- upvalues: useTokens (copy), useIsChatUserMessagesEnabled (copy), React (copy), Foundation (copy), v10 (copy), v8 (copy)
	local v13 = useTokens()
	local v14 = useIsChatUserMessagesEnabled()

	return React.createElement(Foundation.View, {
		tag = "size-full"
	}, {
		ChatIcon = React.createElement(Foundation.Image, {
			tag = "position-center-center anchor-center-center",
			Image = if not v14 then v8 else v10,
			imageStyle = v13.Color.Content.Emphasis,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, 320, 0, 320)
		})
	})
end

return React.memo(EmptyConversationPage)
