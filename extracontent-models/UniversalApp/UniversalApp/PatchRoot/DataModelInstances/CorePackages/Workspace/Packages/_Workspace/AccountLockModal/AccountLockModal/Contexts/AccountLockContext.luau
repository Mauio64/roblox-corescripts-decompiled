local Parent = script:FindFirstAncestor("AccountLockModal").Parent
local React = require(Parent.React)
local useState = React.useState
local useMemo = React.useMemo
local useContext = React.useContext
local useCallback = React.useCallback
local Enums = require(script.Parent.Parent.Common.Enums)

require(script.Parent.Parent.Common.Types)

local GetFIntRateLimitedRefreshSec = require(script.Parent.Parent.Flags.GetFIntRateLimitedRefreshSec)
local v9 = React.createContext({})

local function AccountLockProvider(t1: {[any]: any}) -- line: 31
	-- upvalues: useState (copy), Enums (copy), useCallback (copy), GetFIntRateLimitedRefreshSec (copy), useMemo (copy), React (copy), v9 (copy)
	local v12, v13 = useState({
		timeUntilRetry = nil,
		status = Enums.AccountLockStatusEnum.Locked
	})
	local u14 = nil

	u14 = useCallback(function(p1) -- line: 38
		-- upvalues: v13 (copy), Enums (copy), GetFIntRateLimitedRefreshSec (copy), u14 (ref)
		local UnixTimestamp = DateTime.now().UnixTimestamp
		local v20 = p1.UnixTimestamp - UnixTimestamp

		if v20 > 0 then
			v13({
				status = Enums.AccountLockStatusEnum.RateLimited,
				timeUntilRetry = v20
			})
			task.spawn(function() -- line: 47
				-- upvalues: GetFIntRateLimitedRefreshSec (copy), u14 (ref), p1 (copy)
				task.wait(GetFIntRateLimitedRefreshSec())
				u14(p1)
			end)

			return
		end

		v13({
			timeUntilRetry = nil,
			status = Enums.AccountLockStatusEnum.Locked
		})
	end, { v13 })

	local v15 = useCallback(function(p2) -- line: 56
		-- upvalues: Enums (copy), u14 (ref), v13 (copy)
		local v22 = p2.retryTime and DateTime.fromIsoDate(p2.retryTime)

		if p2.status == Enums.AccountLockStatusEnum.RateLimited and v22 then
			u14(v22)

			return
		end

		if p2.status ~= Enums.AccountLockStatusEnum.RateLimited then
			v13({
				timeUntilRetry = nil,
				status = p2.status
			})

			return
		end

		v13({
			timeUntilRetry = nil,
			status = Enums.AccountLockStatusEnum.Error
		})
	end, {
		v12,
		v13
	})
	local v16 = useMemo(function() -- line: 68
		-- upvalues: v12 (copy), v15 (copy)
		return {
			state = v12,
			reducer = v15
		}
	end, {
		v12,
		v15
	})

	return React.createElement(v9.Provider, {
		value = v16
	}, t1.children)
end

return {
	Context = v9,
	Provider = AccountLockProvider,
	useAccountLockContext = function() -- line: 82
		-- upvalues: useContext (copy), v9 (copy)
		local v17 = useContext(v9)

		return {
			state = v17.state,
			reducer = v17.reducer
		}
	end
}
