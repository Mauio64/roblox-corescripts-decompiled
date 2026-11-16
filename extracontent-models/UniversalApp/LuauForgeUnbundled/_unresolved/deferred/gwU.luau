local module = require("@luauforge/deferred/gwV")
local useState = module.useState
local useMemo = module.useMemo
local useContext = module.useContext
local useCallback = module.useCallback

local module2 = require("@luauforge/deferred/gwT")
require("@luauforge/deferred/gwW")
local module3 = require("@luauforge/deferred/gwX")

local context = module.createContext({})

local function AccountLockProvider(p2)
	local state, setState = useState({
		status = module2.AccountLockStatusEnum.Locked,
		timeUntilRetry = nil
	})

	local v5 = nil
	v5 = useCallback(function(p3)
		local unixTimestamp = DateTime.now().UnixTimestamp
		local v6 = p3.UnixTimestamp - unixTimestamp

		if v6 > 0 then
			setState({
				status = module2.AccountLockStatusEnum.RateLimited,
				timeUntilRetry = v6
			})

			task.spawn(function()
				task.wait(module3())
				v5(p3)
			end)
		else
			setState({
				status = module2.AccountLockStatusEnum.Locked,
				timeUntilRetry = nil
			})
		end
	end, { setState })

	local v6 = useCallback(function(p3)
		local dateTime = p3.retryTime and DateTime.fromIsoDate(p3.retryTime)

		if p3.status == module2.AccountLockStatusEnum.RateLimited and dateTime then
			v5(dateTime)
		elseif p3.status == module2.AccountLockStatusEnum.RateLimited then
			setState({
				status = module2.AccountLockStatusEnum.Error,
				timeUntilRetry = nil
			})
		else
			setState({ status = p3.status, timeUntilRetry = nil })
		end
	end, { state, setState })

	local v7 = useMemo(function()
		return { state = state, reducer = v6 }
	end, { state, v6 })

	return module.createElement(context.Provider, { value = v7 }, p2.children)
end

return {
	Context = context,
	Provider = AccountLockProvider,
	useAccountLockContext = function()
		local v5 = useContext(context)

		return { state = v5.state, reducer = v5.reducer }
	end
}
