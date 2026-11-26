local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")

local getBalanceRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getBalanceRequest")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local function useUpdatedRobuxBalance(data)
	local setRobuxBalanceAmount = data.setRobuxBalanceAmount
	local setBalanceReceivedFromApi = data.setBalanceReceivedFromApi

	React.useEffect(function()
		local flag = false

		getBalanceRequest(nil, data.getNetworkImpl()):andThen(function(p2)
			if flag then
				return
			end

			setRobuxBalanceAmount(p2)
			setBalanceReceivedFromApi(true)

			Promise.delay(0.5):andThen(function()
				if flag then
					return
				end

				return getBalanceRequest(nil, data.getNetworkImpl()):andThen(function(p3)
					if flag then
						return
					end

					setRobuxBalanceAmount(p3)
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
