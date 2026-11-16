local parent = script:FindFirstAncestor("UserAccessStore").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

return function()
	local sessionScopedSignal, setUserAccessRestrictionDetail = createSessionScopedSignal(nil)

	return {
		getUserAccessRestrictionDetail = sessionScopedSignal,
		setUserAccessRestrictionDetail = setUserAccessRestrictionDetail,
		reset = function()
			setUserAccessRestrictionDetail(nil)
		end
	}
end
