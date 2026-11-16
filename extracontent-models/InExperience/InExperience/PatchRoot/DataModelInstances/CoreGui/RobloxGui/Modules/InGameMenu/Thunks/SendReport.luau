local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local parent = script.Parent.Parent
local OpenReportSentDialog = require(parent.Actions.OpenReportSentDialog)

return function(p, p2, p3)
	return function(object)
		if p3 == nil then
			local state = object:getState()

			local name = state.gameInfo.name
			local description = state.gameInfo.description

			if name ~= "" then
				local v = string.format(
					"User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n",
					p2,
					name,
					tostring(game.PlaceId),
					description
				)

				coroutine.wrap(function()
					if not RunService:IsStudio() then
						Players:ReportAbuse(nil, p, v)
					end

					object:dispatch(OpenReportSentDialog())
				end)()
			end
		else
			local playerByUserId = Players:GetPlayerByUserId(p3)

			if playerByUserId then
				coroutine.wrap(function()
					Players:ReportAbuse(playerByUserId, p, p2)
					object:dispatch(OpenReportSentDialog())
				end)()
			end
		end
	end
end
