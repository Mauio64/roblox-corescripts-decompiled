local v5 = { Free = "Free", RobloxSubscription = "RobloxSubscription" }

local v6 = { v5.RobloxSubscription, v5.Free }

local v7 = { robloxsubscription = v5.RobloxSubscription, free = v5.Free }

function v5.fromValue(value)
	if type(value) == "number" then
		return v6[value]
	end

	if type(value) == "string" then
		return v7[string.lower(value)]
	end

	return nil
end

return v5
