local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local useIsChatUserMessagesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")

local loadFoundationCloudAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/loadFoundationCloudAsset")
local v5, v6 = loadFoundationCloudAsset("pictograms/chat")
local v7, v8 = loadFoundationCloudAsset("pictograms/voice_chat")

local function EmptyConversationPage()
	local v9 = useTokens()
	local v10 = useIsChatUserMessagesEnabled()

	return React.createElement(Foundation.View, { tag = "size-full" }, {
		ChatIcon = React.createElement(Foundation.Image, {
			Image = if v10 then v7 else v5,
			imageStyle = v9.Color.Content.Emphasis,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, 320, 0, 320),
			tag = "position-center-center anchor-center-center"
		})
	})
end

return React.memo(EmptyConversationPage)
