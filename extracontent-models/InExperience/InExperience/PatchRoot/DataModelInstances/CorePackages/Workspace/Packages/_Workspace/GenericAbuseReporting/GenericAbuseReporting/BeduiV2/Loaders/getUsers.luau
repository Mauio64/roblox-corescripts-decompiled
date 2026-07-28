local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Foundation = require(GenericAbuseReportingParent.Foundation)
local Promise = require(GenericAbuseReportingParent.Promise)
local FFlagAbuseReportInExpPlayerListV3 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInExpPlayerListV3
local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)
local AccessoryType = Foundation.Enums.AccessoryType

local function appendRecentlyLeftItems(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 23
	-- upvalues: AccessoryType (copy)
	local v15 = table.clone(t3)

	table.sort(v15, function(p1, p2) -- line: 29
		return p1.username:lower() < p2.username:lower()
	end)

	for _, v in ipairs(v15) do
		if not t2[tostring(v.userId)] then
			table.insert(t1, {
				leading = {
					type = AccessoryType.Avatar,
					userId = v.userId
				},
				id = tostring(v.userId),
				label = v.displayName,
				description = v.username,
				meta = {
					username = v.username,
					displayName = v.displayName
				}
			})
		end
	end

	return t1
end
local function getUsers() -- line: 59
	-- upvalues: Promise (copy), Players (copy), LocalPlayer (copy), FFlagAbuseReportInExpPlayerListV3 (copy), AccessoryType (copy), appendRecentlyLeftItems (copy), recentlyLeftSignals (copy)
	return Promise.new(function(resolve, reject) -- line: 60
		-- upvalues: Players (copy), LocalPlayer (copy), FFlagAbuseReportInExpPlayerListV3 (copy), AccessoryType (copy), appendRecentlyLeftItems (copy), recentlyLeftSignals (copy)
		local ok, result = pcall(function() -- line: 61
			-- upvalues: Players (copy), LocalPlayer (copy), FFlagAbuseReportInExpPlayerListV3 (copy), AccessoryType (copy), appendRecentlyLeftItems (copy), recentlyLeftSignals (copy)
			local players = Players:GetPlayers()

			table.sort(players, function(p3, p4) -- line: 63
				return p3.Name:lower() < p4.Name:lower()
			end)

			local t4 = {}
			local t5 = {}

			for _, v in ipairs(players) do
				if not LocalPlayer or v.UserId ~= LocalPlayer.UserId then
					if FFlagAbuseReportInExpPlayerListV3 then
						t5[tostring(v.UserId)] = true
					end

					table.insert(t4, {
						leading = {
							type = AccessoryType.Avatar,
							userId = v.UserId
						},
						id = tostring(v.UserId),
						label = v.DisplayName,
						description = v.Name,
						meta = {
							username = v.Name,
							displayName = v.DisplayName
						}
					})
				end
			end

			if FFlagAbuseReportInExpPlayerListV3 then
				appendRecentlyLeftItems(t4, t5, recentlyLeftSignals.getRecentlyLeft())
			end

			return t4
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end

return getUsers
