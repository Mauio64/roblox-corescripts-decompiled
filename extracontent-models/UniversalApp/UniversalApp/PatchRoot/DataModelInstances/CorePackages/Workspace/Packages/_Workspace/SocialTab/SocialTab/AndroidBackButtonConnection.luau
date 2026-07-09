local Parent = script:FindFirstAncestor("SocialTab").Parent
local AndroidTVExitButtonManager = require(Parent.RobloxAppNavigationCore).AndroidTVExitButtonManager
local FFlagAndroidTVExitWithB = require(Parent.SharedFlags).FFlagAndroidTVExitWithB

return function(p1, p2) -- line: 7
	-- upvalues: FFlagAndroidTVExitWithB (copy), AndroidTVExitButtonManager (copy)
	local u6 = nil
	local u7 = nil

	return {
		disconnect = function() -- line: 11
			-- upvalues: u6 (ref), FFlagAndroidTVExitWithB (copy), u7 (ref)
			if u6 then
				u6:Disconnect()
				u6 = nil
			end

			if FFlagAndroidTVExitWithB and u7 then
				u7()
				u7 = nil
			end
		end,
		connect = function(p3) -- line: 22
			-- upvalues: u6 (ref), FFlagAndroidTVExitWithB (copy), u7 (ref), p1 (copy), AndroidTVExitButtonManager (copy)
			if u6 then
				if u6 then
					u6:Disconnect()
					u6 = nil
				end

				if FFlagAndroidTVExitWithB and u7 then
					u7()
					u7 = nil
				end
			end

			if p1 then
				u6 = p1.ShowLeaveConfirmation:Connect(p3)
			end

			if FFlagAndroidTVExitWithB then
				u7 = AndroidTVExitButtonManager.register(p3)
			end
		end,
		showExitDialog = function() -- line: 34
			-- upvalues: p1 (copy), p2 (copy)
			if p1 and p2 then
				p1:BroadcastNotification("", p2.BACK_BUTTON_NOT_CONSUMED)
			end
		end
	}
end
