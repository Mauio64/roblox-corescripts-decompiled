local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFixPromptGameInviteUIMissingDisplayName = SharedFlags.FFlagFixPromptGameInviteUIMissingDisplayName

return function(data, callback)
	local inviteUser

	if data and data.InviteUser ~= 0 then
		inviteUser = data.InviteUser
	end

	local v

	if inviteUser then
		v = Constants.Triggers.DeveloperSingle
	else
		v = Constants.Triggers.DeveloperMultiple
	end

	local v2, v3 = callback(v, inviteUser)

	if not v2 then
		return nil
	end

	local v4 = {}

	if FFlagFixPromptGameInviteUIMissingDisplayName and inviteUser then
		v4.inviteUserId = inviteUser
	end

	if not (v3 and data) then
		return v4
	end

	if data.InviteMessageId ~= "" then
		v4.inviteMessageId = data.InviteMessageId
	end

	if data.InviteUser ~= 0 then
		v4.inviteUserId = data.InviteUser
	end

	if data.PromptMessage ~= "" then
		v4.promptMessage = data.PromptMessage
	end

	if data.LaunchData ~= "" then
		v4.launchData = data.LaunchData
	end

	return v4
end
