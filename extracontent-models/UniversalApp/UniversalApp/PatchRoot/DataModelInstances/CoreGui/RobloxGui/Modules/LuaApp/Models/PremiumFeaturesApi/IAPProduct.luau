local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetFFlagLuaAppLuaBuyRobuxPage = require(Modules.LuaApp.Flags.GetFFlagLuaAppLuaBuyRobuxPage)
local getHasQuestUserAgent = require(Modules.LuaApp.Util.getHasQuestUserAgent)
local GetFFlagLuaAppMaquettesDisableProductIdConversion = require(Modules.LuaApp.Flags.GetFFlagLuaAppMaquettesDisableProductIdConversion)
local t1 = {
	new = function() -- line: 40
		return {
			productId = 0,
			mobileProductId = "",
			robuxAmount = 0,
			requiresPremium = false,
			isSubscription = false,
			description = "",
			price = 0,
			currencySymbol = ""
		}
	end
}

function t1.mock() -- line: 53
	-- upvalues: t1 (copy)
	return (t1.new())
end
function t1.fromJsonData(t2: {[any]: any}, p1) -- line: 58
	-- upvalues: t1 (copy), GetFFlagLuaAppLuaBuyRobuxPage (copy), GetFFlagLuaAppMaquettesDisableProductIdConversion (copy), getHasQuestUserAgent (copy)
	local v8 = t1.new()

	if GetFFlagLuaAppLuaBuyRobuxPage() then
		v8.productId = t2.productId
	end

	v8.mobileProductId = p1 == Enum.Platform.Android and string.lower(t2.mobileProductId) or t2.mobileProductId

	if GetFFlagLuaAppMaquettesDisableProductIdConversion() and getHasQuestUserAgent() then
		v8.mobileProductId = t2.mobileProductId
	end

	v8.robuxAmount = t2.robuxAmount
	v8.requiresPremium = t2.isSubscriptionOnly
	v8.isSubscription = t2.premiumFeatureTypeName == "Subscription"
	v8.description = t2.description
	v8.price = t2.price.amount
	v8.currencySymbol = t2.price.currency.currencySymbol

	return v8
end

return t1
