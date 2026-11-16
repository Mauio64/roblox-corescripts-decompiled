local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local Signals = require(parent.Signals)

require(CloudClientOffer.CloudClientServiceAdapter)
require(CloudClientOffer.CloudClientExperiment)

require(CloudClientOffer.Stores.GetCloudClientSessionStore.createCloudClientSessionStore)

local function getRefusalKey(kind: string, p: string) -- 1 equivalent call inferred from this helper
	return `{kind}/{p}`
end

local function createCloudClientOffer(data)
	local service = data.service
	local experiment = data.experiment
	local session = data.session
	local candidates = data.candidates

	local signal, v = Signals.createSignal(nil)
	local v2 = nil
	local v3 = nil
	local v4 = nil
	local count = 0
	local v5 = false

	local function decide(p) -- 6 equivalent calls inferred from this helper
		local v6 = v3
		v3 = nil
		v4 = nil

		if v2 ~= nil then
			v2 = nil
			v(nil)
		end

		if v6 ~= nil then
			v6(p)
		end
	end

	local function releaseHeldOffer() -- 3 equivalent calls inferred from this helper
		local v6 = v2

		if v6 ~= nil then
			service.releaseReservation(v6.reservationToken)
		end
	end

	local function tryCandidate(p: string, p2: number, count2: number)
		local function isStale() -- 3 equivalent calls inferred from this helper
			return v5 or count2 ~= count
		end

		local candidate = candidates[p2]

		if candidate == nil then
			decide({ kind = "Local" }) -- inferred equivalent call
		else
			local function tryNextCandidate() -- 3 equivalent calls inferred from this helper
				if not v5 and count2 == count then
					tryCandidate(p, p2 + 1, count2)
				end
			end
			local refusalKey = getRefusalKey(candidate.kind, p) -- inferred equivalent call
			local v6 = { kind = candidate.kind }

			if session.isPlaceRefused(refusalKey) then
				tryNextCandidate() -- inferred equivalent call
			else
				local function onReserved(reservationToken: string)
					if isStale() then -- inferred equivalent call
						service.releaseReservation(reservationToken)
						return
					end

					local v7 = { kind = candidate.kind, reservationToken = reservationToken }

					v2 = v7
					v(v7)
					local v8 = v4

					if v8 ~= nil then
						v8(v7)
					end
				end

				local function onReservationFailed(p3)
					if isStale() then -- inferred equivalent call
						return
					end

					if p3.kind == "Ineligible" then
						session.markPlaceRefused(refusalKey)
					end

					tryNextCandidate() -- inferred equivalent call
				end

				service.checkEligibility(v6):andThen(function(flag: boolean)
					if isStale() then -- inferred equivalent call
						return
					end

					if flag then
						experiment.logExposure()

						if experiment.isTreatment() then
							service.makeReservation(p, v6):andThen(onReserved, onReservationFailed)
							return
						end

						decide({ kind = "Local" }) -- inferred equivalent call
					else
						tryNextCandidate() -- inferred equivalent call
					end
				end, tryNextCandidate)
			end
		end
	end

	local function request(p: string, callback, callback2)
		if v5 or v3 ~= nil then
			return nil
		end

		count += 1
		v3 = callback
		v4 = callback2
		tryCandidate(p, 1, count)
		return count
	end

	local function cancel(p: number)
		if v5 or p ~= count or v2 ~= nil or v3 == nil then
			return
		end

		count += 1
		v3 = nil
		v4 = nil
	end

	local function accept()
		local offer = v2

		if v5 or offer == nil then
			return
		end

		decide({ kind = "Stream", offer = offer }) -- inferred equivalent call
	end

	local function decline()
		if v5 or v2 == nil then
			return
		end

		releaseHeldOffer() -- inferred equivalent call
		decide({ kind = "Local" }) -- inferred equivalent call
	end

	local function dismiss()
		if v5 or v2 == nil then
			return
		end

		releaseHeldOffer() -- inferred equivalent call
		decide({ kind = "Stay", expired = false }) -- inferred equivalent call
	end

	local connection = service.onReservationExpired(function(p: string)
		if v5 or v2 == nil or v2.reservationToken ~= p then
			return
		end

		decide({ kind = "Stay", expired = true }) -- inferred equivalent call
	end)

	local function dispose()
		v5 = true
		v3 = nil
		v4 = nil
		releaseHeldOffer() -- inferred equivalent call
		v2 = nil
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
