local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Constants = require(InExperienceSideSheet.Common.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut
local Flags = require(InExperienceSideSheet.Flags)
local FFlagPioneerLogoutButtonLabel = Flags.FFlagPioneerLogoutButtonLabel
local GetPioneerLeaveCopy = {}

function GetPioneerLeaveCopy.getPioneerLeaveButtonKey(flag: boolean)
	if flag and not FFlagPioneerLeaveLogsOut then
		return Constants.LocalizationKeys.QuitButton
	end

	if FFlagPioneerLogoutButtonLabel and flag and FFlagPioneerLeaveLogsOut then
		return Constants.LocalizationKeys.LogoutButton
	end

	return "CoreScripts.InGameMenu.LeaveGame"
end

function GetPioneerLeaveCopy.getPioneerLeaveConfirmationKey(flag: boolean)
	if flag and not FFlagPioneerLeaveLogsOut then
		return Constants.LocalizationKeys.QuitConfirmation
	end

	if FFlagPioneerLogoutButtonLabel and flag and FFlagPioneerLeaveLogsOut then
		return Constants.LocalizationKeys.LogoutConfirmation
	end

	return "CoreScripts.InGameMenu.Prompt.ConfirmLeaveGame"
end

return GetPioneerLeaveCopy
