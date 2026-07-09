local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Rodux = require(ParentParentParent.Rodux)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastDismissed = require(ParentParent.Actions.ToastDismissed)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local ToastVanished = require(ParentParent.Actions.ToastVanished)

require(ParentParent.Types)

local t1 = {
	IsDismissed = false,
	ToastConfig = nil,
	ToastType = CapturesToastType.None
}

return Rodux.createReducer(t1, {
	[ToastVanished.name] = function(t2: {[any]: any}, _: {[any]: any}) -- line: 26
		-- upvalues: CapturesToastType (copy)
		if t2.ToastType == CapturesToastType.None then
			return t2
		end

		return {
			IsDismissed = false,
			ToastType = CapturesToastType.None
		}
	end,
	[ToastDismissed.name] = function(t4: {[any]: any}, _: {[any]: any}) -- line: 37
		-- upvalues: CapturesToastType (copy), Dash (copy)
		if t4.IsDismissed then
			return t4
		end

		if t4.ToastType == CapturesToastType.None then
			return t4
		end

		return Dash.join(t4, {
			IsDismissed = true
		})
	end,
	[ToastTriggered.name] = function(t6: {[any]: any}, p1) -- line: 51
		-- upvalues: Dash (copy)
		local v16 = Dash.shallowEqual(t6.ToastConfig, p1.toastConfig)

		if t6.ToastType == p1.toastType and (not t6.IsDismissed and v16) then
			return t6
		end

		return {
			IsDismissed = false,
			ToastType = p1.toastType,
			ToastConfig = p1.toastConfig
		}
	end
})
