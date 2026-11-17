local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local Promise = require(parent.Promise)

local FFlagLuaAppCloudClientSyncOfferEligibility = require(CloudClientOffer.Flags.FFlagLuaAppCloudClientSyncOfferEligibility)

local function parseReservationError(result)
	local v = tostring(result)
	local reason = string.match(v, "Ineligible:%s*(%w+)")

	if reason then
		return { kind = "Ineligible", reason = reason }
	end

	return {
		kind = "Unavailable",
		reason = string.match(v, "Unavailable:%s*(%w+)") or "Unknown"
	}
end

local function createCloudClientServiceAdapter(result)
	return {
		checkEligibility = function(p)
			return Promise.new(function(callback, callback2)
				local success, result2 = pcall(function()
					if FFlagLuaAppCloudClientSyncOfferEligibility then
						return result:CheckOfferEligibility(p.kind)
					end

					return result:CheckOfferEligibilityAsync(p.kind)
				end)

				if success then
					callback(result2 == true)
				else
					callback2(parseReservationError(result2))
				end
			end)
		end,
		makeReservation = function(p: string, p2)
			return Promise.new(function(callback, callback2)
				local v = tonumber(p)

				if v == nil then
					callback2({ kind = "Unavailable", reason = "InvalidPlaceId" })
					return
				end

				local success, result2 = pcall(function()
					return result:MakeOfferReservationAsync(v, p2.kind)
				end)

				if success and type(result2) == "string" and result2 ~= "" then
					callback(result2)
				else
					callback2(parseReservationError(result2))
				end
			end)
		end,
		releaseReservation = function(p: string)
			pcall(function()
				result:ReleaseReservation(p)
			end)
		end,
		reportDecision = function(p: string, p2: string)
			pcall(function()
				result:ReportOfferDecision(p, p2)
			end)
		end,
		onReservationExpired = function(onReservationExpired)
			local success, result2 = pcall(function()
				return result.ReservationExpired:Connect(onReservationExpired)
			end)

			if success then
				return result2
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
