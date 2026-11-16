local showPinExperienceResult = require(script.Parent.showPinExperienceResult)
local function pinExperienceAndNotify(p, p2, p3: string, callback, p4)
	local v = p4 or game:GetService("PinShortcutService")

	local onPinExperienceCompletedConnection = nil

	onPinExperienceCompletedConnection = v.OnPinExperienceCompleted:Connect(function(p5, p6: number, p7: number, p8: string)
		if onPinExperienceCompletedConnection then
			onPinExperienceCompletedConnection:Disconnect()
			onPinExperienceCompletedConnection = nil
		end

		local v2 = false
		pcall(function()
			v2 = v:ShouldShowLuaNotificationOnPinExperienceCompleted()
		end)

		if not v2 then
			return
		end

		showPinExperienceResult(callback, p5, p8, {
			onViewShortcut = v:IsRevealPinnedExperienceAvailable() and function()
				pcall(function()
					v:RevealPinnedExperience(p6)
				end)
			end or nil,
			onRetry = function()
				pinExperienceAndNotify(p6, p7, p8, callback, v)
			end
		})
	end)

	if not pcall(function()
		v:PinExperience(p, p2, p3)
	end) and onPinExperienceCompletedConnection then
		onPinExperienceCompletedConnection:Disconnect()
		onPinExperienceCompletedConnection = nil
	end
end

return pinExperienceAndNotify
