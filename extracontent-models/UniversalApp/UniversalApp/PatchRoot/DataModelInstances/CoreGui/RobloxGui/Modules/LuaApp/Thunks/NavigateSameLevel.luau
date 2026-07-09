local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)

local function navigateSameLevel(p1, p2) -- line: 5
	local t1 = {}

	if #p1 > 1 then
		for i = 1, #p1 - 1 do
			t1[i] = p1[i]
		end
	end

	local v8 = p1[#p1]
	local t2 = {}

	if v8 and #v8 > 1 then
		for i = 1, #v8 - 1 do
			t2[i] = v8[i]
		end

		t2[#t2 + 1] = {
			name = p2
		}
	else
		t2 = {{
			name = p2
		}}
	end

	t1[#t1 + 1] = t2

	return t2, t1
end

return function(p3, p4) -- line: 33
	-- upvalues: navigateSameLevel (copy), ResetNavigationHistory (copy)
	return function(p5) -- line: 34
		-- upvalues: navigateSameLevel (copy), p3 (copy), p4 (copy), ResetNavigationHistory (copy)
		local v14, v15 = navigateSameLevel(p3, p4)

		p5:dispatch(ResetNavigationHistory(v14, v15))
	end
end
