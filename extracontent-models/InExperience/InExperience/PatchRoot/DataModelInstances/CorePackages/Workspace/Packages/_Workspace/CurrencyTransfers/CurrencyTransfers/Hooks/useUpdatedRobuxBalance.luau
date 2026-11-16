local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Promise = require(parent.Promise)

local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)
require(CurrencyTransfers.Hooks.useTransferStore)

local function useUpdatedRobuxBalance(data)
	local setRobuxBalanceAmount = data.setRobuxBalanceAmount
	local setBalanceReceivedFromApi = data.setBalanceReceivedFromApi

	React.useEffect(function()
		local flag = false

		getBalanceRequest(nil, data.getNetworkImpl()):andThen(function(p)
			if flag then
				return
			end

			setRobuxBalanceAmount(p)
			setBalanceReceivedFromApi(true)

			Promise.delay(0.5):andThen(function()
				if flag then
					return
				end

				return getBalanceRequest(nil, data.getNetworkImpl()):andThen(function(p2)
					if flag then
						return
					end

					setRobuxBalanceAmount(p2)
				end):catch(function() end)
			end):catch(function() end)
		end):catch(function() end)

		return function()
			flag = true
		end
	end, { setRobuxBalanceAmount, setBalanceReceivedFromApi })

	return SignalsReact.useSignalState(data.getRobuxBalanceAmount) or 0
end

return useUpdatedRobuxBalance
