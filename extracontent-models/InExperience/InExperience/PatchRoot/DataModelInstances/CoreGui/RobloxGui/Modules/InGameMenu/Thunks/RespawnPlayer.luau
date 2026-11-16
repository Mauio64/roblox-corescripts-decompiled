local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")

local parent = script.Parent.Parent

local CloseMenu = require(parent.Thunks.CloseMenu)
local SetRespawning = require(parent.Actions.SetRespawning)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

return function(object)
	local state = object:getState()

	if state.respawn.enabled then
		AvatarEditorService:BustAvatarFetchCache()

		if state.respawn.customCallback then
			state.respawn.customCallback:Fire()
		else
			local character = Players.LocalPlayer.Character

			if character ~= nil then
				local humanoid = character:FindFirstChild("Humanoid")

				if humanoid ~= nil and humanoid:IsA("Humanoid") then
					humanoid.Health = 0
				end
			end
		end
	end

	object:dispatch(SetRespawning(false))
	object:dispatch(CloseMenu)
	SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, {
		confirmed = Constants.AnalyticsConfirmedName
	})
end
