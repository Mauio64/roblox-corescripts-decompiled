local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellEntrySurfaceType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")

local v5 = nil

local function createUpsellSignalStore()
	local v6 = {}

	local function getOrCreateUpsellBannerDataStore(p2)
		local upsellBannerDataStore = v6[p2]

		if upsellBannerDataStore == nil then
			local signal, v7 = Signals.createSignal(nil)
			upsellBannerDataStore = { getBannerData = signal, setBannerData = v7 }

			v6[p2] = upsellBannerDataStore
		end

		return upsellBannerDataStore
	end

	return {
		getUpsellBannerDataGetter = function(p2)
			local v7 = v6[p2]

			if v7 == nil then
				local signal, v8 = Signals.createSignal(nil)
				v7 = { getBannerData = signal, setBannerData = v8 }

				v6[p2] = v7
			end

			return v7.getBannerData
		end,
		setUpsellBannerData = function(p2, p3, p4)
			local v7 = v6[p2]

			if v7 == nil then
				local signal, v8 = Signals.createSignal(nil)
				v7 = { getBannerData = signal, setBannerData = v8 }

				v6[p2] = v7
			end

			v7.setBannerData(function(options)
				local v8 = p4 ~= nil and { isVisible = true } or Cryo.None
				local joined = Cryo.Dictionary.join(options or {}, { [p3] = v8 })

				if next(joined) == nil then
					return nil
				end

				return joined
			end)
		end
	}
end

return function()
	if v5 == nil then
		v5 = Signals.createComputed(createUpsellSignalStore)(false)
	end

	return v5
end
