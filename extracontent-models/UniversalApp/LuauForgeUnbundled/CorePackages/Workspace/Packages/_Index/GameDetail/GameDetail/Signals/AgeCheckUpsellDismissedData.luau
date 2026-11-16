local Players = game:GetService("Players")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Signals")

local fFlagLuaAppDismissUnlockUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagLuaAppDismissUnlockUpsell

local signal, v5 = Signals.createSignal(false)

local function getIsAgeCheckUpsellDismissed(p2)
	return signal(p2)
end

local function setAgeCheckUpsellDismissed()
	v5(true)
end

local function getLocalPlayerUserId()
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	if userId == nil or userId <= 0 then
		return nil
	end

	return userId
end

if fFlagLuaAppDismissUnlockUpsell then
	local v6 = if Players.LocalPlayer then Players.LocalPlayer.UserId or nil else nil

	if v6 == nil or v6 <= 0 then
		v6 = nil
	end

	Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if userId == nil or userId <= 0 then
			userId = nil
		end

		if userId ~= v6 then
			v6 = userId
			v5(false)
		end
	end)
end

return {
	getIsAgeCheckUpsellDismissed = getIsAgeCheckUpsellDismissed,
	setAgeCheckUpsellDismissed = setAgeCheckUpsellDismissed
}
