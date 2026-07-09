local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Modules = CoreGui.RobloxGui.Modules
local NativePurchaseProductTypeEnum = require(Modules.LuaApp.Enum.NativePurchaseProductTypeEnum)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local SetUserMembershipType = require(Modules.LuaApp.Actions.SetUserMembershipType)
local SetNativePurchaseResult = require(Modules.LuaApp.Actions.SetNativePurchaseResult)

require(Modules.LuaApp.Models.PremiumFeaturesApi.IAPProduct)

local PollRobuxBalance = require(Modules.LuaApp.Thunks.PollRobuxBalance)
local GetFFlagFixBuyRobuxNotChargedMessage = require(Modules.LuaApp.Flags.GetFFlagFixBuyRobuxNotChargedMessage)

local function hasPackage(t1: {[any]: any}, s1: string) -- line: 13
	for _, v in pairs(t1) do
		if s1 == v.mobileProductId then
			return true
		end
	end

	return false
end

return function(p1: ((...any) -> ...any), s2: string, p2) -- line: 22
	-- upvalues: NativePurchaseStatus (copy), SetNativePurchaseResult (copy), NativePurchaseProductTypeEnum (copy), SetUserMembershipType (copy), RunService (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy), PollRobuxBalance (copy)
	return function(p3) -- line: 23
		-- upvalues: p2 (copy), NativePurchaseStatus (copy), SetNativePurchaseResult (copy), s2 (copy), NativePurchaseProductTypeEnum (copy), SetUserMembershipType (copy), RunService (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy), PollRobuxBalance (copy), p1 (copy)
		local v19 = p3:getState()
		local LocalUserId = v19.LocalUserId
		local v21 = v19.UserRobux[v19.LocalUserId]
		local NativePurchase = v19.NativePurchase

		if p2 == NativePurchaseStatus.Failed or p2 == NativePurchaseStatus.Pending then
			return p3:dispatch(SetNativePurchaseResult(s2, NativePurchaseStatus.Failed))
		end

		if NativePurchase.productType == NativePurchaseProductTypeEnum.Subscription then
			return p3:dispatch(SetNativePurchaseResult(s2, NativePurchaseStatus.Success))
		end

		local Subscriptions = v19.IAPProducts.Subscriptions
		local v24 = s2
		local g28 = nil
		local v27 = nil

		for _, v in pairs(Subscriptions) do
			if v24 == v.mobileProductId then
				v27 = true
				g28 = true
			end

			if g28 then
				break
			end
		end

		if not g28 then
			v27 = false
		end

		g28 = false

		if v27 then
			p3:dispatch(SetUserMembershipType(LocalUserId, Enum.MembershipType.Premium))

			return p3:dispatch(SetNativePurchaseResult(s2, NativePurchaseStatus.Success))
		end

		p3:dispatch(SetNativePurchaseResult(s2, NativePurchaseStatus.Polling))

		if RunService:IsStudio() then
			return p3:dispatch(SetNativePurchaseResult(s2, NativePurchaseStatus.Success))
		end

		local Failed = NativePurchaseStatus.Failed

		if GetFFlagFixBuyRobuxNotChargedMessage() and p2 == NativePurchaseStatus.Success then
			Failed = NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase
		end

		return p3:dispatch(PollRobuxBalance(p1, tostring(LocalUserId), v21, function(n1: number?) -- line: 68
			-- upvalues: v21 (copy), NativePurchaseStatus (copy), Failed (ref), p3 (copy), SetNativePurchaseResult (copy), s2 (copy)
			local v31 = n1 ~= v21 and NativePurchaseStatus.Success or Failed

			return p3:dispatch(SetNativePurchaseResult(s2, v31))
		end)):catch(function() -- line: 72
			-- upvalues: p3 (copy), SetNativePurchaseResult (copy), s2 (copy), Failed (ref)
			return p3:dispatch(SetNativePurchaseResult(s2, Failed))
		end)
	end
end
