local Shell = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local GetFFlagXboxFixPrimaryNavABEvents = require(Shell.Flags.GetFFlagXboxFixPrimaryNavABEvents)

local function contentHistory() -- line: 12
	-- upvalues: GetFFlagXboxFixPrimaryNavABEvents (copy)
	local t1 = {}
	local u5 = nil

	function t1.setLastSelectedContent(_, p2) -- line: 17
		-- upvalues: u5 (ref)
		u5 = p2
	end
	function t1.getLastContentName(_) -- line: 21
		-- upvalues: GetFFlagXboxFixPrimaryNavABEvents (copy), u5 (ref)
		local ok, result = pcall(function() -- line: 22
			-- upvalues: GetFFlagXboxFixPrimaryNavABEvents (copy), u5 (ref)
			if GetFFlagXboxFixPrimaryNavABEvents() then
				return u5:GetId()
			end

			return u5:GetName()
		end)

		if ok then
			return result
		end
	end

	return t1
end

return (contentHistory())
