local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local React = require(parent.React)

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local function newNativePurchaseFinishedWithLocalPlayer()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		getSignal = function()
			return bindableEvent.Event
		end,
		fire = function(p: number, flag: boolean)
			bindableEvent:Fire(p, flag)
		end
	}
end

local function newNativePurchaseFinishedWithLocalPlayerV2()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		getSignal = function()
			return bindableEvent.Event
		end,
		fire = function(p: number, flag: boolean, p2: string)
			bindableEvent:Fire(p, flag, p2)
		end
	}
end

local function newNativePurchaseFinished()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		getSignal = function()
			return bindableEvent.Event
		end,
		fire = function(p, p2: number, flag: boolean)
			bindableEvent:Fire(p, p2, flag)
		end
	}
end

local function newNativePurchaseFinishedV2()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		getSignal = function()
			return bindableEvent.Event
		end,
		fire = function(p, p2: number, flag: boolean, p3: string)
			bindableEvent:Fire(p, p2, flag, p3)
		end
	}
end

local function newMockLocalPlayerHasRobloxSubscription()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		HasRobloxSubscription = false,
		GetPropertyChangedSignal = function(_, p: string)
			assert(p == "HasRobloxSubscription", "Invalid property name")
			return bindableEvent.Event
		end,
		setHasRobloxSubscription = function(p, hasRobloxSubscription: boolean)
			p.HasRobloxSubscription = hasRobloxSubscription
			bindableEvent:Fire()
		end
	}
end

return {
	makeTestRoot = function(child)
		return React.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{ Child = child }
		)
	end,
	NativePurchaseFinishedWithLocalPlayer = { new = newNativePurchaseFinishedWithLocalPlayer },
	NativePurchaseFinishedWithLocalPlayerV2 = { new = newNativePurchaseFinishedWithLocalPlayerV2 },
	NativePurchaseFinished = { new = newNativePurchaseFinished },
	NativePurchaseFinishedV2 = { new = newNativePurchaseFinishedV2 },
	LocalPlayerHasRobloxSubscription = { new = newMockLocalPlayerHasRobloxSubscription }
}
