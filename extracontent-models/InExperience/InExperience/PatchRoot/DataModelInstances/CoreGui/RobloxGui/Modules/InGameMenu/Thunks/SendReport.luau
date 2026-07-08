local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local OpenReportSentDialog = require(ParentParent.Actions.OpenReportSentDialog)

return function(p1, p2, p3) -- line: 7
	-- upvalues: Players (copy), OpenReportSentDialog (copy), RunService (copy)
	return function(p4) -- line: 8
		-- upvalues: p3 (copy), Players (copy), p1 (copy), p2 (copy), OpenReportSentDialog (copy), RunService (copy)
		if p3 ~= nil then
			local PlayerByUserId = Players:GetPlayerByUserId(p3)

			if PlayerByUserId then
				coroutine.wrap(function() -- line: 12
					-- upvalues: Players (copy), PlayerByUserId (copy), p1 (copy), p2 (copy), p4 (copy), OpenReportSentDialog (copy)
					Players:ReportAbuse(PlayerByUserId, p1, p2)
					p4:dispatch(OpenReportSentDialog())
				end)()

				return
			end
		else
			local v10 = p4:getState()
			local name = v10.gameInfo.name
			local description = v10.gameInfo.description

			if name ~= "" then
				local v13 = string.format("User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n", p2, name, tostring(game.PlaceId), description)

				coroutine.wrap(function() -- line: 31
					-- upvalues: RunService (copy), Players (copy), p1 (copy), v13 (copy), p4 (copy), OpenReportSentDialog (copy)
					if not RunService:IsStudio() then
						Players:ReportAbuse(nil, p1, v13)
					end

					p4:dispatch(OpenReportSentDialog())
				end)()
			end
		end
	end
end
