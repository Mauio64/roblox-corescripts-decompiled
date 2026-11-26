local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Promise")

local FFlagLuaAppCloudClientSyncOfferEligibility = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Flags/FFlagLuaAppCloudClientSyncOfferEligibility")

local function parseReservationError(result)
	local v5 = tostring(result)
	local v6 = string.match(v5, "Ineligible:%s*(%w+)")

	if v6 then
		return { kind = "Ineligible", reason = v6 }
	end

	return {
		kind = "Unavailable",
		reason = string.match(v5, "Unavailable:%s*(%w+)") or "Unknown"
	}
end

local function createCloudClientServiceAdapter(object)
	return {
		checkEligibility = function(p2)
			return Promise.new(function(callback, callback2)
				local success, result = pcall(function()
					if FFlagLuaAppCloudClientSyncOfferEligibility then
						return object:CheckOfferEligibility(p2.kind)
					end

					return object:CheckOfferEligibilityAsync(p2.kind)
				end)

				if success then
					callback(result == true)
				else
					callback2(parseReservationError(result))
				end
			end)
		end,
		makeReservation = function(p2, p3)
			return Promise.new(function(callback, callback2)
				local v5 = tonumber(p2)

				if v5 == nil then
					callback2({ kind = "Unavailable", reason = "InvalidPlaceId" })
					return
				end

				local success, result = pcall(function()
					return object:MakeOfferReservationAsync(v5, p3.kind)
				end)

				if success and type(result) == "string" and result ~= "" then
					callback(result)
				else
					callback2(parseReservationError(result))
				end
			end)
		end,
		releaseReservation = function(p2)
			pcall(function()
				object:ReleaseReservation(p2)
			end)
		end,
		reportDecision = function(p2, p3)
			pcall(function()
				object:ReportOfferDecision(p2, p3)
			end)
		end,
		onReservationExpired = function(onReservationExpired)
			local success, result = pcall(function()
				return object.ReservationExpired:Connect(onReservationExpired)
			end)

			if success then
				return result
			end

			return {
				Disconnect = function() end
			}
		end
	}
end

return {
	createCloudClientServiceAdapter = createCloudClientServiceAdapter,
	getCloudClientServiceAdapter = function()
		local success, result = pcall(function()
			return game:GetService("CloudClientService")
		end)

		if not success then
			result = nil
		end

		return createCloudClientServiceAdapter(result)
	end,
	parseReservationError = parseReservationError
}
