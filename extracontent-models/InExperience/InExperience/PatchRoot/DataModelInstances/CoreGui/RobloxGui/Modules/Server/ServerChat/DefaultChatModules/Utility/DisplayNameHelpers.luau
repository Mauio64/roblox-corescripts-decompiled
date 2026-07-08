local Players = game:GetService("Players")
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local t1 = {
	ChattingToSelf = 1,
	NoMatches = 2,
	MultipleMatches = 3
}

return {
	CommandErrorCodes = t1,
	getUserNameFromChattedName = function(p1, p2, p3) -- line: 14
		-- upvalues: t1 (copy), Players (copy), ChatSettings (copy)
		if p2 == p1 then
			return p2, t1.ChattingToSelf
		end

		local players = Players:GetPlayers()

		for _, v in pairs(players) do
			if string.lower(v.Name) == string.lower(p1) then
				return v.Name, nil
			end
		end

		local n1 = 0
		local vName = nil

		if ChatSettings.PlayerDisplayNamesEnabled then
			for _, v in pairs(players) do
				if p2 ~= v.Name and string.lower(v.DisplayName) == string.lower(p1) then
					n1 += 1
					vName = v.Name
				end
			end
		end

		if n1 == 1 then
			return vName, nil
		end

		if n1 == 0 then
			if p3 == p1 then
				return p3, t1.ChattingToSelf
			end

			return p1, t1.NoMatches
		end

		if n1 >= 2 then
			return p1, t1.MultipleMatches
		end
	end,
	getUsersWithDisplayNameString = function(p4, p5) -- line: 56
		-- upvalues: Players (copy)
		local t2 = {}
		local s1 = ""
		local players = Players:GetPlayers()

		for _, v in pairs(players) do
			if p5 ~= v.Name and string.lower(v.DisplayName) == string.lower(p4) then
				table.insert(t2, v.Name)
			end
		end

		for k, v in pairs(t2) do
			s1 = if k == #t2 then s1 .. "@" .. v else s1 .. "@" .. v .. ", "
		end

		return s1
	end
}
