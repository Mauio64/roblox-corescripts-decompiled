local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local React = require(Parent.React)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(Parent.AppLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider

local function newNativePurchaseFinishedWithLocalPlayer() -- line: 33
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 36
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(n1: number, b1: boolean) -- line: 39
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(n1, b1)
		end
	}
end
local function newNativePurchaseFinished() -- line: 45
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 48
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(p1, n2: number, b2: boolean) -- line: 51
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(p1, n2, b2)
		end
	}
end
local function newMockLocalPlayerHasRobloxSubscription() -- line: 63
	local BindableEvent = Instance.new("BindableEvent")

	return {
		HasRobloxSubscription = false,
		GetPropertyChangedSignal = function(_, s1: string) -- line: 67
			-- upvalues: BindableEvent (copy)
			assert(s1 == "HasRobloxSubscription", "Invalid property name")

			return BindableEvent.Event
		end,
		setHasRobloxSubscription = function(t1: {[any]: any}, b3: boolean) -- line: 71
			-- upvalues: BindableEvent (copy)
			t1.HasRobloxSubscription = b3
			BindableEvent:Fire()
		end
	}
end

return {
	makeTestRoot = function(p3) -- line: 14
		-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
		return React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Child = p3
		})
	end,
	NativePurchaseFinishedWithLocalPlayer = {
		new = newNativePurchaseFinishedWithLocalPlayer
	},
	NativePurchaseFinished = {
		new = newNativePurchaseFinished
	},
	LocalPlayerHasRobloxSubscription = {
		new = newMockLocalPlayerHasRobloxSubscription
	}
}
