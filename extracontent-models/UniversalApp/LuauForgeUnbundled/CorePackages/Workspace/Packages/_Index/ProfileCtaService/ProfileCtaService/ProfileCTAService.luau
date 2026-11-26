local profileCTAStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCtaService/DataHydration").Profile.ProfileCTAStore

local createProfileCTAEventListener = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCtaService/ProfileCtaService/createProfileCTAEventListener")

local function createProfileCTAService()
	local v5 = 0
	local v6 = {}
	local v7 = profileCTAStore.get()

	local function refetchCTA(p2)
		v7.getCTA(p2, true)
	end

	local function handleCTAUpdate(p2)
		if v5 > 0 then
			v7.getCTA(p2, true)
		else
			v6[p2] = true
		end
	end

	createProfileCTAEventListener(handleCTAUpdate)

	local function enableRealTimeUpdates()
		v5 += 1
	end

	local function disableRealTimeUpdates()
		v5 -= 1

		if v5 < 0 then
			error("ProfileCTAService: disableRealTimeUpdates called more times than enableRealTimeUpdates. consumerConnectionCount: " .. tostring(v5))
		end
	end

	return {
		connectRealTimeUpdates = function()
			v5 += 1

			local flag = false

			return {
				Disconnect = function()
					if flag then
						return
					end

					flag = true
					v5 -= 1

					if v5 < 0 then
						error("ProfileCTAService: disableRealTimeUpdates called more times than enableRealTimeUpdates. consumerConnectionCount: " .. tostring(v5))
					end
				end
			}
		end,
		getProfileCTA = function(p2)
			local v8

			if v6[p2] then
				v6[p2] = nil
				v8 = true
			else
				v8 = false
			end

			return v7.getCTA(p2, v8)
		end,
		getProfileCTAs = function(list)
			local v8 = {}

			for i, item in ipairs(list) do
				if v6[item] then
					v8[item] = true
					v6[item] = nil
				else
					v8[item] = false
				end
			end

			return v7.getBatchCTAs(list, v8)
		end
	}
end

return createProfileCTAService()
