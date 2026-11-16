local parent = script.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)
local Rodux = require(parent2.Rodux)

local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastDismissed = require(parent.Actions.ToastDismissed)
local ToastTriggered = require(parent.Actions.ToastTriggered)
local ToastVanished = require(parent.Actions.ToastVanished)
require(parent.Types)

local v = { IsDismissed = false, ToastType = CapturesToastType.None, ToastConfig = nil }

return Rodux.createReducer(v, {
	[ToastVanished.name] = function(p, _)
		if p.ToastType == CapturesToastType.None then
			return p
		end

		return { IsDismissed = false, ToastType = CapturesToastType.None }
	end,
	[ToastDismissed.name] = function(p, _)
		if p.IsDismissed or p.ToastType == CapturesToastType.None then
			return p
		end

		return Dash.join(p, { IsDismissed = true })
	end,
	[ToastTriggered.name] = function(data, p)
		local shallowEqual = Dash.shallowEqual(data.ToastConfig, p.toastConfig)

		if data.ToastType == p.toastType and not data.IsDismissed and shallowEqual then
			return data
		end

		return { IsDismissed = false, ToastType = p.toastType, ToastConfig = p.toastConfig }
	end
})
