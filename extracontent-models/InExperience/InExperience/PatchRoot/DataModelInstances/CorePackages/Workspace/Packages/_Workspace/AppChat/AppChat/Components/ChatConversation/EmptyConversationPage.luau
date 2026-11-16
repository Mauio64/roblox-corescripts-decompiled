local AppChat = script:FindFirstAncestor("AppChat")

local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)

local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)
local v, _ = loadFoundationCloudAsset("pictograms/chat")
local v2, _ = loadFoundationCloudAsset("pictograms/voice_chat")

local function EmptyConversationPage()
	local v3 = useTokens()
	local v4 = useIsChatUserMessagesEnabled()

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local image = Foundation.Image
	local image2 = if v4 then v2 else v
	return createElement(view, { tag = "size-full" }, {
		ChatIcon = createElement2(image, {
			Image = image2,
			imageStyle = v3.Color.Content.Emphasis,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, 320, 0, 320),
			tag = "position-center-center anchor-center-center"
		})
	})
end

return React.memo(EmptyConversationPage)
