local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local FFlagAndroidTVExitWithB = require(Parent.SharedFlags).FFlagAndroidTVExitWithB
local u5 = ContextActionService
local u6 = UserInputService
local t1 = {}

local function bindIfNeeded() -- line: 21
	-- upvalues: t1 (copy), u5 (ref), u6 (ref)
	if #t1 == 1 then
		u5:BindCoreActionAtPriority("AndroidTVExitWithB", function(_, p2, _) -- line: 23
			-- upvalues: u6 (ref), t1 (copy)
			if p2 == Enum.UserInputState.Begin and not u6:GamepadSupports(u6:GetLastInputType(), Enum.KeyCode.ButtonSelect) then
				for _, v17 in t1 do
					v17()
				end
			end

			return Enum.ContextActionResult.Pass
		end, false, -1e999, Enum.KeyCode.ButtonB)
	end
end
local function unbindIfEmpty() -- line: 37
	-- upvalues: t1 (copy), u5 (ref)
	if #t1 == 0 then
		u5:UnbindCoreAction("AndroidTVExitWithB")
	end
end

return {
	register = function(p4: ((...any) -> ...any)) -- line: 43
		-- upvalues: FFlagAndroidTVExitWithB (copy), t1 (copy), u5 (ref), u6 (ref)
		if not FFlagAndroidTVExitWithB then
			return function() -- line: 45
			end
		end

		table.insert(t1, p4)

		if #t1 == 1 then
			u5:BindCoreActionAtPriority("AndroidTVExitWithB", function(_, p6, _) -- line: 23
				-- upvalues: u6 (ref), t1 (copy)
				if p6 == Enum.UserInputState.Begin and not u6:GamepadSupports(u6:GetLastInputType(), Enum.KeyCode.ButtonSelect) then
					for _, v22 in t1 do
						v22()
					end
				end

				return Enum.ContextActionResult.Pass
			end, false, -1e999, Enum.KeyCode.ButtonB)
		end

		return function() -- line: 49
			-- upvalues: t1 (copy), p4 (copy), u5 (ref)
			for i = #t1, 1, -1 do
				if t1[i] == p4 then
					table.remove(t1, i)

					break
				end
			end

			if #t1 == 0 then
				u5:UnbindCoreAction("AndroidTVExitWithB")
			end
		end
	end,
	setMocks = function(p8, p9) -- line: 16
		-- upvalues: u5 (ref), u6 (ref)
		u5 = p8
		u6 = p9
	end
}
