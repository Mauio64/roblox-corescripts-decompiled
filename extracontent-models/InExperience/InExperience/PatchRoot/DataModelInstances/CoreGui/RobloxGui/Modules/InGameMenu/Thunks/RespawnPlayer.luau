local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local SetRespawning = require(ParentParent.Actions.SetRespawning)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)

return function(p1) -- line: 12
	-- upvalues: AvatarEditorService (copy), Players (copy), SetRespawning (copy), CloseMenu (copy), SendAnalytics (copy), Constants (copy)
	local v9 = p1:getState()

	if v9.respawn.enabled then
		AvatarEditorService:BustAvatarFetchCache()

		if v9.respawn.customCallback then
			v9.respawn.customCallback:Fire()
		else
			local Character = Players.LocalPlayer.Character

			if Character ~= nil then
				local Humanoid = Character:FindFirstChild("Humanoid")

				if Humanoid ~= nil and Humanoid:IsA("Humanoid") then
					Humanoid.Health = 0
				end
			end
		end
	end

	p1:dispatch(SetRespawning(false))
	p1:dispatch(CloseMenu)
	SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, {
		confirmed = Constants.AnalyticsConfirmedName
	})
end
