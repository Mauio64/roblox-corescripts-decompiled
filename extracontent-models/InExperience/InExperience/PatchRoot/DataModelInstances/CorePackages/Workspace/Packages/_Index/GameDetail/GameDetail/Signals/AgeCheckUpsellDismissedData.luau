local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("GameDetail").Parent
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDismissUnlockUpsell = SharedFlags.FFlagLuaAppDismissUnlockUpsell

local signal, v = Signals.createSignal(false)

local function getIsAgeCheckUpsellDismissed(p)
	return signal(p)
end

local function setAgeCheckUpsellDismissed()
	v(true)
end

local function getLocalPlayerUserId() -- 1 equivalent call inferred from this helper
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil
	return if not (userId == nil or userId <= 0) then userId else nil
end

if FFlagLuaAppDismissUnlockUpsell then
	local v2

	if Players.LocalPlayer then
		v2 = Players.LocalPlayer.UserId or nil
	else
		v2 = nil
	end

	if v2 == nil or v2 <= 0 then
		v2 = nil
	end

	Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId() -- inferred equivalent call

		if localPlayerUserId ~= v2 then
			v2 = localPlayerUserId
			v(false)
		end
	end)
end

return {
	getIsAgeCheckUpsellDismissed = getIsAgeCheckUpsellDismissed,
	setAgeCheckUpsellDismissed = setAgeCheckUpsellDismissed
}
