local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Dash")

local useSaveButtonProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/SaveButton/useSaveButtonProps")
local SaveButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/SaveButton/SaveButton")

local function SaveButtonContainer(p2)
	return React.createElement(SaveButton, Dash.assign(p2, useSaveButtonProps()))
end

return SaveButtonContainer
