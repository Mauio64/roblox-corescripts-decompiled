local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local React = require(Parent.React)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(Parent.AppLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider

local function newNativePurchaseFinishedWithLocalPlayer() -- line: 39
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 42
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(n1: number, b1: boolean) -- line: 45
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(n1, b1)
		end
	}
end
local function newNativePurchaseFinishedWithLocalPlayerV2() -- line: 51
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 54
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(n2: number, b2: boolean, s1: string) -- line: 57
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(n2, b2, s1)
		end
	}
end
local function newNativePurchaseFinished() -- line: 63
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 66
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(p1, n3: number, b3: boolean) -- line: 69
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(p1, n3, b3)
		end
	}
end
local function newNativePurchaseFinishedV2() -- line: 81
	local BindableEvent = Instance.new("BindableEvent")

	return {
		getSignal = function() -- line: 84
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event
		end,
		fire = function(p2, n4: number, b4: boolean, s2: string) -- line: 87
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(p2, n4, b4, s2)
		end
	}
end
local function newMockLocalPlayerHasRobloxSubscription() -- line: 99
	local BindableEvent = Instance.new("BindableEvent")

	return {
		HasRobloxSubscription = false,
		GetPropertyChangedSignal = function(_, s3: string) -- line: 103
			-- upvalues: BindableEvent (copy)
			assert(s3 == "HasRobloxSubscription", "Invalid property name")

			return BindableEvent.Event
		end,
		setHasRobloxSubscription = function(t1: {[any]: any}, b5: boolean) -- line: 107
			-- upvalues: BindableEvent (copy)
			t1.HasRobloxSubscription = b5
			BindableEvent:Fire()
		end
	}
end

return {
	makeTestRoot = function(p4) -- line: 14
		-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
		return React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Child = p4
		})
	end,
	NativePurchaseFinishedWithLocalPlayer = {
		new = newNativePurchaseFinishedWithLocalPlayer
	},
	NativePurchaseFinishedWithLocalPlayerV2 = {
		new = newNativePurchaseFinishedWithLocalPlayerV2
	},
	NativePurchaseFinished = {
		new = newNativePurchaseFinished
	},
	NativePurchaseFinishedV2 = {
		new = newNativePurchaseFinishedV2
	},
	LocalPlayerHasRobloxSubscription = {
		new = newMockLocalPlayerHasRobloxSubscription
	}
}
