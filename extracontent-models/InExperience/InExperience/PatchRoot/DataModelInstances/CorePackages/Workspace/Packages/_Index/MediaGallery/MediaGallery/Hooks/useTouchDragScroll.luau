local UserInputService = game:GetService("UserInputService")

local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)

require(MediaGallery.MediaGalleryTypes)

local function useTouchDragScroll(p, callback)
	React.useEffect(function()
		local flag = false

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p2)
			local current = p.current

			if current then
				local absolutePosition = current.AbsolutePosition
				local absoluteSize = current.AbsoluteSize

				if
					p2.Position.X >= absolutePosition.X
					and p2.Position.X <= absolutePosition.X + absoluteSize.X
					and p2.Position.Y >= absolutePosition.Y
					and p2.Position.Y <= absolutePosition.Y + absoluteSize.Y
				then
					flag = true
				end
			end
		end)

		local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
			flag = false
		end)

		local touchDragConnection = UserInputService.TouchDrag:Connect(function(p2)
			if flag then
				if p2 == Enum.SwipeDirection.Right then
					callback("Left")
				elseif p2 == Enum.SwipeDirection.Left then
					callback("Right")
				end
			end
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			touchDragConnection:Disconnect()
		end
	end, { callback, p })
end

return useTouchDragScroll
