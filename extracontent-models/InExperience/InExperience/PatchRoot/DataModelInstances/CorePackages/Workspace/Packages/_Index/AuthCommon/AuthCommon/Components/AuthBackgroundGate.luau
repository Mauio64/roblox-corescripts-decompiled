local AuthCommon = script:FindFirstAncestor("AuthCommon")
local useAuthBackgroundContainerVariant = require(AuthCommon.Hooks.useAuthBackgroundContainerVariant)

local function AuthBackgroundGate(t1: {[any]: any}) -- line: 28
	-- upvalues: useAuthBackgroundContainerVariant (copy)
	if useAuthBackgroundContainerVariant() then
		return t1.renderTreatment()
	end

	return t1.renderLegacy()
end

return AuthBackgroundGate
