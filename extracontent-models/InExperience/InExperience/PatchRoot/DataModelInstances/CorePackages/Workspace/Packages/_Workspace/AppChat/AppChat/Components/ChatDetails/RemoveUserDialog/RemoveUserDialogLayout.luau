local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local SocialLibraries = require(AppChat.SocialLibraries)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local RemoveUserDialog = require(script.Parent.RemoveUserDialog)

local v = {}

function RemoveUserDialogLayout(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		RemoveUserDialog = joined.isModalVisible and React.createElement(RemoveUserDialog, joined),
		ResponseIndicator = joined.isLoading and React.createElement(ResponseIndicator, {
			soakAreaColor3 = v2.Theme.Overlay.Color,
			soakAreaTransparency = v2.Theme.Overlay.Transparency
		})
	})
end

return memo(RemoveUserDialogLayout)
