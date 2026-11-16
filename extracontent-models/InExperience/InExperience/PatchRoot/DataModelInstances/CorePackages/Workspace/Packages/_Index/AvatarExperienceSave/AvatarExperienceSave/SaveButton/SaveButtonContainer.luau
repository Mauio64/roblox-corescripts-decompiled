local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent
local React = require(parent.React)
local Dash = require(parent.Dash)

local useSaveButtonProps = require(AvatarExperienceSave.SaveButton.useSaveButtonProps)
local SaveButton = require(AvatarExperienceSave.SaveButton.SaveButton)

local function SaveButtonContainer(p)
	return React.createElement(SaveButton, Dash.assign(p, useSaveButtonProps()))
end

return SaveButtonContainer
