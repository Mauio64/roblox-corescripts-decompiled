local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/CloudClientServiceAdapter")
require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/CloudClientExperiment")

require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Stores/GetCloudClientSessionStore/createCloudClientSessionStore")
local FFlagLuaAppCloudClientOfferDryRun = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Flags/FFlagLuaAppCloudClientOfferDryRun")

local FFlagLuaAppCloudClientOfferDecisionTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Flags/FFlagLuaAppCloudClientOfferDecisionTelemetry")

local function getRefusalKey(p2, p3)
	return `{p2}/{p3}`
end

local function createCloudClientOffer(data)
	local service = data.service
	local experiment = data.experiment
	local session = data.session
	local candidates = data.candidates

	local signal, v5 = Signals.createSignal(nil)
	local v6 = nil
	local v7 = nil
	local v8 = nil
	local count = 0
	local v9 = false

	local function decide(p2)
		local v10 = v7
		v7 = nil
		v8 = nil

		if v6 ~= nil then
			v6 = nil
			v5(nil)
		end

		if v10 ~= nil then
			v10(p2)
		end
	end

	local function releaseHeldOffer()
		local v10 = v6

		if v10 ~= nil then
			service.releaseReservation(v10.reservationToken)
		end
	end

	local function tryCandidate(p2, p3, count2)
		local function isStale()
			return v9 or count2 ~= count
		end

		local candidate = candidates[p3]

		if candidate == nil then
			local v10 = { kind = "Local" }
			local v11 = v7
			v7 = nil
			v8 = nil

			if v6 ~= nil then
				v6 = nil
				v5(nil)
			end

			if v11 ~= nil then
				v11(v10)
			end
		else
			local function tryNextCandidate()
				if not v9 and count2 == count then
					tryCandidate(p2, p3 + 1, count2)
				end
			end

			local formatted = `{candidate.kind}/{p2}`
			local v10 = { kind = candidate.kind }

			if session.isPlaceRefused(formatted) then
				if not v9 and count2 == count then
					tryCandidate(p2, p3 + 1, count2)
				end
			else
				local function onReserved(p4)
					if v9 or count2 ~= count then
						service.releaseReservation(p4)
						return
					end

					local v11 = { kind = candidate.kind, reservationToken = p4 }

					v6 = v11
					v5(v11)
					local v12 = v8

					if v12 ~= nil then
						v12(v11)
					end
				end

				local function onReservationFailed(p4)
					if v9 or count2 ~= count then
						return
					end

					if FFlagLuaAppCloudClientOfferDryRun and p4.kind == "Unavailable" and p4.reason == "DryRun" then
						local v11 = { kind = "Local" }
						local v12 = v7
						v7 = nil
						v8 = nil

						if v6 ~= nil then
							v6 = nil
							v5(nil)
						end

						if v12 ~= nil then
							v12(v11)
						end
					else
						if p4.kind == "Ineligible" then
							session.markPlaceRefused(formatted)
						end

						if not v9 and count2 == count then
							tryCandidate(p2, p3 + 1, count2)
						end
					end
				end

				service.checkEligibility(v10):andThen(function(p4)
					if v9 or count2 ~= count then
						return
					end

					if p4 then
						experiment.logExposure()

						if experiment.isTreatment() then
							service.makeReservation(p2, v10):andThen(onReserved, onReservationFailed)
							return
						end

						local v11 = { kind = "Local" }
						local v12 = v7
						v7 = nil
						v8 = nil

						if v6 ~= nil then
							v6 = nil
							v5(nil)
						end

						if v12 ~= nil then
							v12(v11)
						end
					elseif not v9 and count2 == count then
						tryCandidate(p2, p3 + 1, count2)
					end
				end, tryNextCandidate)
			end
		end
	end

	local function request(p2, p3, p4)
		if v9 or v7 ~= nil then
			return nil
		end

		count += 1
		v7 = p3
		v8 = p4
		tryCandidate(p2, 1, count)
		return count
	end

	local function cancel(p2)
		if v9 or p2 ~= count or v6 ~= nil or v7 == nil then
			return
		end

		count += 1
		v7 = nil
		v8 = nil
	end

	local function accept()
		local v10 = v6

		if v9 or v10 == nil then
			return
		end

		if FFlagLuaAppCloudClientOfferDecisionTelemetry then
			service.reportDecision(v10.reservationToken, "accepted")
		end

		local v11 = { kind = "Stream", offer = v10 }
		local v12 = v7
		v7 = nil
		v8 = nil

		if v6 ~= nil then
			v6 = nil
			v5(nil)
		end

		if v12 ~= nil then
			v12(v11)
		end
	end

	local function decline()
		if v9 or v6 == nil then
			return
		end

		if FFlagLuaAppCloudClientOfferDecisionTelemetry then
			service.reportDecision(v6.reservationToken, "rejected")
		end

		local v10 = v6

		if v10 ~= nil then
			service.releaseReservation(v10.reservationToken)
		end

		local v11 = { kind = "Local" }
		local v12 = v7
		v7 = nil
		v8 = nil

		if v6 ~= nil then
			v6 = nil
			v5(nil)
		end

		if v12 ~= nil then
			v12(v11)
		end
	end

	local function dismiss()
		if v9 or v6 == nil then
			return
		end

		if FFlagLuaAppCloudClientOfferDecisionTelemetry then
			service.reportDecision(v6.reservationToken, "dismissed")
		end

		local v10 = v6

		if v10 ~= nil then
			service.releaseReservation(v10.reservationToken)
		end

		local v11 = { kind = "Stay", expired = false }
		local v12 = v7
		v7 = nil
		v8 = nil

		if v6 ~= nil then
			v6 = nil
			v5(nil)
		end

		if v12 ~= nil then
			v12(v11)
		end
	end

	local connection = service.onReservationExpired(function(p2)
		local v10 = v6

		if v9 or v10 == nil or v10.reservationToken ~= p2 then
			return
		end

		local v11 = { kind = "Stay", expired = true }
		local v12 = v7
		v7 = nil
		v8 = nil

		if v6 ~= nil then
			v6 = nil
			v5(nil)
		end

		if v12 ~= nil then
			v12(v11)
		end
	end)

	local function dispose()
		v9 = true
		v7 = nil
		v8 = nil
		local v10 = v6

		if v10 ~= nil then
			service.releaseReservation(v10.reservationToken)
		end

		v6 = nil
		connection:Disconnect()
	end

	return {
		getHeldOffer = signal,
		request = request,
		cancel = cancel,
		accept = accept,
		decline = decline,
		dismiss = dismiss,
		dispose = dispose
	}
end

return createCloudClientOffer
