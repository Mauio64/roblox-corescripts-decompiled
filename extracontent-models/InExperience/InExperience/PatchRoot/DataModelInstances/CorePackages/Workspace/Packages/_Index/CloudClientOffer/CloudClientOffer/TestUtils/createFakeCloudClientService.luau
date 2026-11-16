local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local Promise = require(parent.Promise)

require(CloudClientOffer.CloudClientServiceAdapter)

local function createDeferred() -- 2 equivalent calls inferred from this helper
	local v = {}
	return Promise.new(function(resolve, reject)
		v.resolve = resolve
		v.reject = reject
	end), v
end

local function createFakeCloudClientService()
	local eligibilityChecks = {}
	local reservations = {}
	local releasedTokens = {}
	local v = {}

	return {
		adapter = {
			checkEligibility = function(p)
				local deferred, v2 = createDeferred() -- inferred equivalent call
				table.insert(eligibilityChecks, {
					kind = p.kind,
					resolve = v2.resolve,
					reject = v2.reject
				})

				return deferred
			end,
			makeReservation = function(placeId: string, p)
				local deferred, v2 = createDeferred() -- inferred equivalent call
				table.insert(reservations, {
					placeId = placeId,
					kind = p.kind,
					resolve = v2.resolve,
					reject = v2.reject
				})

				return deferred
			end,
			releaseReservation = function(p: string)
				table.insert(releasedTokens, p)
			end,
			onReservationExpired = function(callback)
				v[callback] = true
				return {
					Disconnect = function()
						v[callback] = nil
					end
				}
			end
		},
		eligibilityChecks = eligibilityChecks,
		reservations = reservations,
		releasedTokens = releasedTokens,
		getExpiredListenerCount = function()
			local count = 0

			for _ in v do
				count += 1
			end

			return count
		end,
		fireReservationExpired = function(p: string)
			for k in table.clone(v) do
				k(p)
			end
		end
	}
end

return createFakeCloudClientService
