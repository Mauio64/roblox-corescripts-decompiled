local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local SocialLibraries = require(AppChat.SocialLibraries)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local RemoveUserDialog = require(script.Parent.RemoveUserDialog)
local t1 = {}

function RemoveUserDialogLayout(t2: {[any]: any}) -- line: 42
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), RemoveUserDialog (copy), ResponseIndicator (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = useStyle()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		RemoveUserDialog = v12.isModalVisible and React.createElement(RemoveUserDialog, v12),
		ResponseIndicator = v12.isLoading and React.createElement(ResponseIndicator, {
			soakAreaColor3 = v13.Theme.Overlay.Color,
			soakAreaTransparency = v13.Theme.Overlay.Transparency
		})
	})
end

return memo(RemoveUserDialogLayout)
