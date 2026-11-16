local CoreGui = game:GetService("CoreGui")
local shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local GetFFlagXboxFixPrimaryNavABEvents = require(shell.Flags.GetFFlagXboxFixPrimaryNavABEvents)

local function contentHistory()
	local v = nil
	return {
		setLastSelectedContent = function(_, p)
			v = p
		end,
		getLastContentName = function(_)
			local success, result = pcall(function()
				if GetFFlagXboxFixPrimaryNavABEvents() then
					return v:GetId()
				end

				return v:GetName()
			end)

			if success then
				return result
			end
		end
	}
end

return contentHistory()
