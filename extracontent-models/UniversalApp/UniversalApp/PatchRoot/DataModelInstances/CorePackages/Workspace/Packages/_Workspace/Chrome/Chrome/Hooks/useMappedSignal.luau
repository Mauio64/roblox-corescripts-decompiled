local Chrome = script:FindFirstAncestor("Chrome")
local ChromeParent = Chrome.Parent
local React = require(ChromeParent.React)
local SharedFlags = require(ChromeParent.SharedFlags)

require(Chrome.Common.Types)

local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal

return function(p1) -- line: 14
	-- upvalues: FFlagChromeActivatedMappedSignal (copy), React (copy)
	local v7 = if not FFlagChromeActivatedMappedSignal or p1 ~= nil then p1:get() else nil
	local v8, v9 = React.useState(v7)

	React.useEffect(function() -- line: 19
		-- upvalues: FFlagChromeActivatedMappedSignal (copy), p1 (copy), v9 (copy), v8 (copy)
		if FFlagChromeActivatedMappedSignal and p1 == nil then
			return
		end

		local v10 = p1
		local v11 = v10:connect(function(p2) -- line: 24
			-- upvalues: v9 (copy)
			v9(p2)
		end)

		if v8 ~= v10:get() then
			v9(v10:get())
		end

		return function() -- line: 34
			-- upvalues: v11 (copy)
			v11:disconnect()
		end
	end, { p1 })

	return v8
end
