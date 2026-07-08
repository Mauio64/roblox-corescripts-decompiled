local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Cryo = require(SocialUpsellParent.Cryo)
local Signals = require(SocialUpsellParent.Signals)

require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
require(SocialUpsell.Enum.SocialUpsellType)
require(SocialUpsell.Types)

local u5 = nil

local function createUpsellSignalStore() -- line: 37
	-- upvalues: Signals (copy), Cryo (copy)
	local t1 = {}

	local function getOrCreateUpsellBannerDataStore(p1) -- line: 40
		-- upvalues: t1 (copy), Signals (copy)
		local v10 = t1[p1]

		if v10 == nil then
			local v11, v12 = Signals.createSignal(nil)

			v10 = {
				getBannerData = v11,
				setBannerData = v12
			}
			t1[p1] = v10
		end

		return v10
	end

	return {
		getUpsellBannerDataGetter = function(p2) -- line: 53
			-- upvalues: t1 (copy), Signals (copy)
			local v14 = t1[p2]

			if v14 == nil then
				local v15, v16 = Signals.createSignal(nil)

				v14 = {
					getBannerData = v15,
					setBannerData = v16
				}
				t1[p2] = v14
			end

			return v14.getBannerData
		end,
		setUpsellBannerData = function(p3, p4, p5) -- line: 57
			-- upvalues: t1 (copy), Signals (copy), Cryo (copy)
			local v20 = t1[p3]

			if v20 == nil then
				local v21, v22 = Signals.createSignal(nil)

				v20 = {
					getBannerData = v21,
					setBannerData = v22
				}
				t1[p3] = v20
			end

			v20.setBannerData(function(p6) -- line: 62
				-- upvalues: p5 (copy), Cryo (copy), p4 (copy)
				local v24 = if p5 == nil then Cryo.None else {
					isVisible = true
				}
				local v25 = Cryo.Dictionary.join(p6 or {}, {
					[p4] = v24
				})

				if next(v25) == nil then
					return nil
				end

				return v25
			end)
		end
	}
end

return function() -- line: 75
	-- upvalues: u5 (ref), Signals (copy), createUpsellSignalStore (copy)
	if u5 == nil then
		u5 = Signals.createComputed(createUpsellSignalStore)(false)
	end

	return u5
end
