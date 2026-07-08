local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local React = require(AvatarExperienceSaveParent.React)
local Dash = require(AvatarExperienceSaveParent.Dash)
local useSaveButtonProps = require(AvatarExperienceSave.SaveButton.useSaveButtonProps)
local SaveButton = require(AvatarExperienceSave.SaveButton.SaveButton)

local function SaveButtonContainer(p1) -- line: 10
	-- upvalues: React (copy), SaveButton (copy), Dash (copy), useSaveButtonProps (copy)
	return React.createElement(SaveButton, Dash.assign(p1, useSaveButtonProps()))
end

return SaveButtonContainer
