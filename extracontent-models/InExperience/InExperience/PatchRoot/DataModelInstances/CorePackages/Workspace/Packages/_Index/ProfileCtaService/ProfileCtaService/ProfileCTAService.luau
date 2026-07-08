local Parent = script:FindFirstAncestor("ProfileCtaService").Parent
local ProfileCTAStore = require(Parent.DataHydration).Profile.ProfileCTAStore
local createProfileCTAEventListener = require(script.Parent.createProfileCTAEventListener)

local function createProfileCTAService() -- line: 19
	-- upvalues: ProfileCTAStore (copy), createProfileCTAEventListener (copy)
	local n1 = 0
	local t1 = {}
	local v7 = ProfileCTAStore.get()

	local function refetchCTA(s1: string) -- line: 24
		-- upvalues: v7 (copy)
		v7.getCTA(s1, true)
	end
	local function handleCTAUpdate(s2: string) -- line: 28
		-- upvalues: n1 (ref), v7 (copy), t1 (copy)
		if n1 > 0 then
			v7.getCTA(s2, true)

			return
		end

		t1[s2] = true
	end

	createProfileCTAEventListener(handleCTAUpdate)

	local function enableRealTimeUpdates() -- line: 38
		-- upvalues: n1 (ref)
		n1 += 1
	end
	local function disableRealTimeUpdates() -- line: 42
		-- upvalues: n1 (ref)
		n1 -= 1

		if n1 < 0 then
			error("ProfileCTAService: disableRealTimeUpdates called more times than enableRealTimeUpdates. consumerConnectionCount: " .. tostring(n1))
		end
	end

	return {
		connectRealTimeUpdates = function() -- line: 53
			-- upvalues: n1 (ref)
			n1 += 1

			local u14 = false

			return {
				Disconnect = function() -- line: 59
					-- upvalues: u14 (ref), n1 (ref)
					if u14 then
						return
					end

					u14 = true
					n1 -= 1

					if n1 < 0 then
						error("ProfileCTAService: disableRealTimeUpdates called more times than enableRealTimeUpdates. consumerConnectionCount: " .. tostring(n1))
					end
				end
			}
		end,
		getProfileCTAs = function(t2: {[any]: any}) -- line: 69
			-- upvalues: t1 (copy), v7 (copy)
			local t3 = {}

			for _, v in ipairs(t2) do
				if t1[v] then
					t3[v] = true
					t1[v] = nil
				else
					t3[v] = false
				end
			end

			return v7.getBatchCTAs(t2, t3)
		end
	}
end

return (createProfileCTAService())
