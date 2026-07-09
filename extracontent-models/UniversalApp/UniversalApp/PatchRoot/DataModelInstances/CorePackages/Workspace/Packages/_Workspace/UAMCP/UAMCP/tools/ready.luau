local utils = require(script.Parent.Parent.utils)

local function checkUniversalApp() -- line: 3
	local CoreGui = game:FindFirstChild("CoreGui")
	local t1 = {}
	local n1 = 0
	local n2 = 0

	local function check(p1, p2) -- line: 10
		-- upvalues: n2 (ref), n1 (ref), t1 (copy)
		n2 += 1

		if p2 then
			n1 += 1
			t1[#t1 + 1] = "  [OK] " .. p1

			return
		end

		t1[#t1 + 1] = "  [--] " .. p1
	end

	local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	n2 += 1

	if LuaAppScreenGui then
		n1 += 1
		t1[#t1 + 1] = "  [OK] LuaAppScreenGui exists"
	else
		t1[#t1 + 1] = "  [--] LuaAppScreenGui exists"
	end

	local v10 = LuaAppScreenGui and LuaAppScreenGui:FindFirstChild("SystemBar", true)
	local v11 = v10 and v10:FindFirstChild("RealSystemBar", true)
	local v12 = v11 and v11:FindFirstChild("PrimaryItems", true)

	n2 += 1

	if v12 then
		n1 += 1
		t1[#t1 + 1] = "  [OK] SystemBar rendered"
	else
		t1[#t1 + 1] = "  [--] SystemBar rendered"
	end

	local v13 = v12 and #v12:GetChildren() >= 3 and v12

	n2 += 1

	if v13 then
		n1 += 1
		t1[#t1 + 1] = "  [OK] Nav items populated (>=3)"
	else
		t1[#t1 + 1] = "  [--] Nav items populated (>=3)"
	end

	local v14 = LuaAppScreenGui and LuaAppScreenGui:FindFirstChild("RNAppContainer")

	n2 += 1

	if v14 then
		n1 += 1
		t1[#t1 + 1] = "  [OK] RNAppContainer exists"
	else
		t1[#t1 + 1] = "  [--] RNAppContainer exists"
	end

	local v15 = v14 and v14:FindFirstChild("NavigatorView")

	n2 += 1

	if v15 then
		n1 += 1
		t1[#t1 + 1] = "  [OK] NavigatorView exists"
	else
		t1[#t1 + 1] = "  [--] NavigatorView exists"
	end

	return ("%s (%d/%d checks passed)  [Universal App]\n%s"):format(n1 ~= n2 and "NOT_READY" or "READY", n1, n2, table.concat(t1, "\n"))
end
local function checkInExperience() -- line: 41
	local CoreGui = game:FindFirstChild("CoreGui")
	local t2 = {}
	local n3 = 0
	local n4 = 0

	local function check(p3, p4) -- line: 48
		-- upvalues: n4 (ref), n3 (ref), t2 (copy)
		n4 += 1

		if p4 then
			n3 += 1
			t2[#t2 + 1] = "  [OK] " .. p3

			return
		end

		t2[#t2 + 1] = "  [--] " .. p3
	end

	local TopBarApp = CoreGui:FindFirstChild("TopBarApp")
	local v22 = TopBarApp and TopBarApp:FindFirstChild("TopBarApp")

	n4 += 1

	if v22 then
		n3 += 1
		t2[#t2 + 1] = "  [OK] TopBarApp ScreenGui exists"
	else
		t2[#t2 + 1] = "  [--] TopBarApp ScreenGui exists"
	end

	local v23 = v22 and v22:FindFirstChild("UnibarLeftFrame")
	local v24 = v23 and v23:FindFirstChild("UnibarMenu")

	n4 += 1

	if v24 then
		n3 += 1
		t2[#t2 + 1] = "  [OK] Unibar rendered"
	else
		t2[#t2 + 1] = "  [--] Unibar rendered"
	end

	local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
	local v26 = RobloxGui and RobloxGui:FindFirstChild("SettingsClippingShield")

	n4 += 1

	if v26 then
		n3 += 1
		t2[#t2 + 1] = "  [OK] Settings menu available"
	else
		t2[#t2 + 1] = "  [--] Settings menu available"
	end

	local LocalPlayer = game:GetService("Players").LocalPlayer
	local v28 = LocalPlayer and LocalPlayer.Character

	n4 += 1

	if v28 then
		n3 += 1
		t2[#t2 + 1] = "  [OK] Player has character"
	else
		t2[#t2 + 1] = "  [--] Player has character"
	end

	return ("%s (%d/%d checks passed)  [In-Experience]\n%s"):format(n3 ~= n4 and "NOT_READY" or "READY", n3, n4, table.concat(t2, "\n"))
end

return {
	description = "Check whether the app has finished loading. Auto-detects Universal App vs In-Experience UI context. Returns READY or NOT_READY with details.",
	params = {},
	call = function(_) -- line: 81
		-- upvalues: utils (copy), checkInExperience (copy), checkUniversalApp (copy)
		if not game:FindFirstChild("CoreGui") then
			return "NOT_READY: CoreGui not found"
		end

		if utils.isInExperienceContext() then
			return checkInExperience()
		end

		return checkUniversalApp()
	end
}
