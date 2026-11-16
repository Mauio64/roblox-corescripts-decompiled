local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
require(SocialUpsell.Enum.SocialUpsellType)
require(SocialUpsell.Types)

local v = nil

local function createUpsellSignalStore()
	local upsellBannerDataStores = {}

	local function getOrCreateUpsellBannerDataStore(p) -- 2 equivalent calls inferred from this helper
		local upsellBannerDataStore = upsellBannerDataStores[p]

		if upsellBannerDataStore == nil then
			local signal, setBannerData = Signals.createSignal(nil)
			upsellBannerDataStore = { getBannerData = signal, setBannerData = setBannerData }

			upsellBannerDataStores[p] = upsellBannerDataStore
		end

		return upsellBannerDataStore
	end

	return {
		getUpsellBannerDataGetter = function(p)
			return getOrCreateUpsellBannerDataStore(p).getBannerData -- inferred equivalent call
		end,
		setUpsellBannerData = function(p, p2, p3)
			getOrCreateUpsellBannerDataStore(p).setBannerData(function(options) -- inferred equivalent call
				local v2 = p3 ~= nil and { isVisible = true } or Cryo.None
				local joined = Cryo.Dictionary.join(options or {}, { [p2] = v2 })
				return if next(joined) ~= nil then joined else nil
			end)
		end
	}
end

return function()
	if v == nil then
		v = Signals.createComputed(createUpsellSignalStore)(false)
	end

	return v
end
