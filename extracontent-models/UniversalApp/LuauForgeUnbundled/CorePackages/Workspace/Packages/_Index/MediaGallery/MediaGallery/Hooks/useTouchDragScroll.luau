local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")

require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")

local function useTouchDragScroll(p2, callback)
	React.useEffect(function()
		local flag = false

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p3)
			local current = p2.current

			if current then
				local absolutePosition = current.AbsolutePosition
				local absoluteSize = current.AbsoluteSize

				if
					p3.Position.X >= absolutePosition.X
					and p3.Position.X <= absolutePosition.X + absoluteSize.X
					and p3.Position.Y >= absolutePosition.Y
					and p3.Position.Y <= absolutePosition.Y + absoluteSize.Y
				then
					flag = true
				end
			end
		end)

		local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
			flag = false
		end)

		local touchDragConnection = UserInputService.TouchDrag:Connect(function(p3)
			if flag then
				if p3 == Enum.SwipeDirection.Right then
					callback("Left")
				elseif p3 == Enum.SwipeDirection.Left then
					callback("Right")
				end
			end
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			touchDragConnection:Disconnect()
		end
	end, { callback, p2 })
end

return useTouchDragScroll
