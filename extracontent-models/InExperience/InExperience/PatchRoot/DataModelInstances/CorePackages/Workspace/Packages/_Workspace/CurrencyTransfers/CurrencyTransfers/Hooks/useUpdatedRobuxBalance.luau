local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local Promise = require(CurrencyTransfersParent.Promise)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)

require(CurrencyTransfers.Hooks.useTransferStore)

local function useUpdatedRobuxBalance(p1) -- line: 19
	-- upvalues: React (copy), getBalanceRequest (copy), Promise (copy), SignalsReact (copy)
	local setRobuxBalanceAmount = p1.setRobuxBalanceAmount
	local setBalanceReceivedFromApi = p1.setBalanceReceivedFromApi

	React.useEffect(function() -- line: 23
		-- upvalues: getBalanceRequest (copy), setRobuxBalanceAmount (copy), setBalanceReceivedFromApi (copy), Promise (copy)
		local u11 = false

		getBalanceRequest():andThen(function(p2) -- line: 27
			-- upvalues: u11 (ref), setRobuxBalanceAmount (copy), setBalanceReceivedFromApi (copy), Promise (copy), getBalanceRequest (copy)
			if u11 then
				return
			end

			setRobuxBalanceAmount(p2)
			setBalanceReceivedFromApi(true)
			Promise.delay(0.5):andThen(function() -- line: 35
				-- upvalues: u11 (ref), getBalanceRequest (copy), setRobuxBalanceAmount (copy)
				if u11 then
					return
				end

				return getBalanceRequest():andThen(function(p3) -- line: 40
					-- upvalues: u11 (ref), setRobuxBalanceAmount (copy)
					if u11 then
						return
					end

					setRobuxBalanceAmount(p3)
				end):catch(function() -- line: 46
				end)
			end):catch(function() -- line: 48
			end)
		end):catch(function() -- line: 50
		end)

		return function() -- line: 52
			-- upvalues: u11 (ref)
			u11 = true
		end
	end, {
		setRobuxBalanceAmount,
		setBalanceReceivedFromApi
	})

	return SignalsReact.useSignalState(p1.getRobuxBalanceAmount) or 0
end

return useUpdatedRobuxBalance
