local AppTopBanner = script:FindFirstAncestor("AppTopBanner")
local AppTopBannerParent = AppTopBanner.Parent
local Cryo = require(AppTopBannerParent.Cryo)
local Rodux = require(AppTopBannerParent.Rodux)
local AppTopBannerType = require(AppTopBanner.Enums.AppTopBannerType)
local Constants = require(AppTopBanner.Constants)
local SetAppTopBanner = require(AppTopBanner.Actions.SetAppTopBanner)
local DisableAppTopBanner = require(AppTopBanner.Actions.DisableAppTopBanner)
local t1 = {
	isDisabled = true,
	expanded = false,
	appTopBannerContentProps = nil,
	appTopBannerContentHeight = 0,
	appTopBannerType = AppTopBannerType.None,
	onAppTopBannerClick = function() -- line: 37
	end
}

return Rodux.createReducer(t1, {
	[SetAppTopBanner.name] = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 41
		-- upvalues: Cryo (copy), Constants (copy), t1 (copy)
		local isDisabled = t2.isDisabled

		if t3.expanded then
			return (Cryo.Dictionary.join(t2, {
				expanded = t3.expanded,
				appTopBannerType = t3.appTopBannerType,
				appTopBannerContentProps = t3.appTopBannerContentProps,
				onAppTopBannerClick = t3.onAppTopBannerClick,
				appTopBannerContentHeight = t3.appTopBannerContentHeight or Constants.CONTENT_HEIGHT,
				isDisabled = isDisabled
			}))
		end

		if t2.expanded ~= t3.expanded then
			t2 = Cryo.Dictionary.join(t1, {
				isDisabled = isDisabled
			})
		end

		return t2
	end,
	[DisableAppTopBanner.name] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 61
		-- upvalues: Cryo (copy)
		if t4.isDisabled == t5.isDisabled then
			return t4
		end

		return (Cryo.Dictionary.join(t4, {
			isDisabled = not t4.isDisabled
		}))
	end
})
