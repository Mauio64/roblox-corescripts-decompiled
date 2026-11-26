local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local fFlagAndroidTVExitWithB = require("@luauforge/bundled/dFE").FFlagAndroidTVExitWithB

local v5 = ContextActionService
local v6 = UserInputService
local v7 = {}

local function bindIfNeeded()
	if #v7 == 1 then
		v5:BindCoreActionAtPriority("AndroidTVExitWithB", function(p2, p3, p4)
			if
				p3 == Enum.UserInputState.Begin
				and not v6:GamepadSupports(v6:GetLastInputType(), Enum.KeyCode.ButtonSelect)
			then
				for k, v8 in v7 do
					v8()
				end
			end

			return Enum.ContextActionResult.Pass
		end, false, -1e999, Enum.KeyCode.ButtonB)
	end
end

local function unbindIfEmpty()
	if #v7 == 0 then
		v5:UnbindCoreAction("AndroidTVExitWithB")
	end
end

return {
	register = function(p2)
		if not fFlagAndroidTVExitWithB then
			return function() end
		end

		table.insert(v7, p2)

		if #v7 == 1 then
			v5:BindCoreActionAtPriority("AndroidTVExitWithB", function(p3, p4, p5)
				if
					p4 == Enum.UserInputState.Begin
					and not v6:GamepadSupports(v6:GetLastInputType(), Enum.KeyCode.ButtonSelect)
				then
					for k, v8 in v7 do
						v8()
					end
				end

				return Enum.ContextActionResult.Pass
			end, false, -1e999, Enum.KeyCode.ButtonB)
		end

		return function()
			for i = #v7, 1, -1 do
				if v7[i] == p2 then
					table.remove(v7, i)
					break
				end
			end

			if #v7 == 0 then
				v5:UnbindCoreAction("AndroidTVExitWithB")
			end
		end
	end,
	setMocks = function(p2, p3)
		v5 = p2
		v6 = p3
	end
}
