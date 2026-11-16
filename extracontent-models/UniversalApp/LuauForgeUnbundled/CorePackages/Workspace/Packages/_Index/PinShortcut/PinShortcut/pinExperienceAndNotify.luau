local showPinExperienceResult = require("@game/CorePackages/Workspace/Packages/_Index/PinShortcut/PinShortcut/showPinExperienceResult")
local function pinExperienceAndNotify(p2, p3, p4, p5, p6)
	local v5 = p6 or game:GetService("PinShortcutService")

	local onPinExperienceCompletedConnection = nil

	onPinExperienceCompletedConnection = v5.OnPinExperienceCompleted:Connect(function(p7, p8, p9, p10)
		if onPinExperienceCompletedConnection then
			onPinExperienceCompletedConnection:Disconnect()
			onPinExperienceCompletedConnection = nil
		end

		local v6 = false
		pcall(function()
			v6 = v5:ShouldShowLuaNotificationOnPinExperienceCompleted()
		end)

		if not v6 then
			return
		end

		showPinExperienceResult(p5, p7, p10, {
			onViewShortcut = v5:IsRevealPinnedExperienceAvailable() and function()
				pcall(function()
					v5:RevealPinnedExperience(p8)
				end)
			end or nil,
			onRetry = function()
				pinExperienceAndNotify(p8, p9, p10, p5, v5)
			end
		})
	end)

	if not pcall(function()
		v5:PinExperience(p2, p3, p4)
	end) and onPinExperienceCompletedConnection then
		onPinExperienceCompletedConnection:Disconnect()
		onPinExperienceCompletedConnection = nil
	end
end

return pinExperienceAndNotify
