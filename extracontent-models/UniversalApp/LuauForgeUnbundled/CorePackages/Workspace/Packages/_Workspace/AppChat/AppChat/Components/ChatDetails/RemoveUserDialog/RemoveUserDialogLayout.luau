require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local responseIndicator = SocialLibraries.Components.ResponseIndicator
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/RemoveUserDialog")

local v5 = {}

function LUAUFORGE_MODULE_GLOBALS_hpk_RemoveUserDialogLayout(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		RemoveUserDialog = joined.isModalVisible and React.createElement(module4, joined),
		ResponseIndicator = joined.isLoading and React.createElement(responseIndicator, {
			soakAreaColor3 = v6.Theme.Overlay.Color,
			soakAreaTransparency = v6.Theme.Overlay.Transparency
		})
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hpk_RemoveUserDialogLayout)
