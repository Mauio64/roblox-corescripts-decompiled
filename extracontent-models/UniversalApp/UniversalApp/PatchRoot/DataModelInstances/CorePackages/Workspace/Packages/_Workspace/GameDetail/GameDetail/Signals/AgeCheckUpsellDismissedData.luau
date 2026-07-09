local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("GameDetail").Parent
local Signals = require(Parent.Signals)
local FFlagLuaAppDismissUnlockUpsell = require(Parent.SharedFlags).FFlagLuaAppDismissUnlockUpsell
local v5, v6 = Signals.createSignal(false)

local function getLocalPlayerUserId() -- line: 23
	-- upvalues: Players (copy)
	local v11 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	if v11 == nil or v11 <= 0 then
		return nil
	end

	return v11
end

if FFlagLuaAppDismissUnlockUpsell then
	local v8 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil
	local u9 = if v8 ~= nil and not (v8 <= 0) then v8 else nil

	Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 35
		-- upvalues: Players (copy), u9 (ref), v6 (copy)
		local v12 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil
		local v13 = if v12 ~= nil and not (v12 <= 0) then v12 else nil

		if v13 ~= u9 then
			u9 = v13
			v6(false)
		end
	end)
end

return {
	getIsAgeCheckUpsellDismissed = function(p1) -- line: 15
		-- upvalues: v5 (copy)
		return v5(p1)
	end,
	setAgeCheckUpsellDismissed = function() -- line: 19
		-- upvalues: v6 (copy)
		v6(true)
	end
}
