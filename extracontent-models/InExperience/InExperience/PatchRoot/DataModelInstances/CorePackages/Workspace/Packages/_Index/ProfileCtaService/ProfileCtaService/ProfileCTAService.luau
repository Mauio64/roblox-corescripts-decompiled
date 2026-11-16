local parent = script:FindFirstAncestor("ProfileCtaService").Parent

local DataHydration = require(parent.DataHydration)
local ProfileCTAStore = DataHydration.Profile.ProfileCTAStore

local createProfileCTAEventListener = require(script.Parent.createProfileCTAEventListener)

local function createProfileCTAService()
	local v = 0
	local v2 = {}
	local v3 = ProfileCTAStore.get()

	local function refetchCTA(p: string) -- 1 equivalent call inferred from this helper
		v3.getCTA(p, true)
	end

	local function handleCTAUpdate(p: string)
		if v > 0 then
			refetchCTA(p) -- inferred equivalent call
		else
			v2[p] = true
		end
	end

	createProfileCTAEventListener(handleCTAUpdate)

	local function enableRealTimeUpdates() -- 1 equivalent call inferred from this helper
		v += 1
	end

	local function disableRealTimeUpdates() -- 1 equivalent call inferred from this helper
		v -= 1

		if v < 0 then
			error("ProfileCTAService: disableRealTimeUpdates called more times than enableRealTimeUpdates. consumerConnectionCount: " .. tostring(v))
		end
	end

	return {
		connectRealTimeUpdates = function()
			enableRealTimeUpdates() -- inferred equivalent call
			local flag = false

			return {
				Disconnect = function()
					if flag then
						return
					end

					flag = true
					disableRealTimeUpdates() -- inferred equivalent call
				end
			}
		end,
		getProfileCTA = function(p: string)
			local v4

			if v2[p] then
				v2[p] = nil
				v4 = true
			else
				v4 = false
			end

			return v3.getCTA(p, v4)
		end,
		getProfileCTAs = function(list)
			local v4 = {}

			for _, item in ipairs(list) do
				if v2[item] then
					v4[item] = true
					v2[item] = nil
				else
					v4[item] = false
				end
			end

			return v3.getBatchCTAs(list, v4)
		end
	}
end

return createProfileCTAService()
