local UserInputService = game:GetService("UserInputService")
local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)

require(MediaGallery.MediaGalleryTypes)

local function useTouchDragScroll(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 15
	-- upvalues: React (copy), UserInputService (copy)
	React.useEffect(function() -- line: 19
		-- upvalues: UserInputService (copy), t1 (copy), p1 (copy)
		local u8 = false
		local connection = UserInputService.TouchStarted:Connect(function(p2) -- line: 22
			-- upvalues: t1 (copy), u8 (ref)
			local current = t1.current

			if current then
				local AbsolutePosition = current.AbsolutePosition
				local AbsoluteSize = current.AbsoluteSize

				if p2.Position.X >= AbsolutePosition.X and p2.Position.X <= AbsolutePosition.X + AbsoluteSize.X and p2.Position.Y >= AbsolutePosition.Y and p2.Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
					u8 = true
				end
			end
		end)
		local connection2 = UserInputService.TouchEnded:Connect(function() -- line: 38
			-- upvalues: u8 (ref)
			u8 = false
		end)
		local connection3 = UserInputService.TouchDrag:Connect(function(p3) -- line: 42
			-- upvalues: u8 (ref), p1 (copy)
			if u8 then
				if p3 == Enum.SwipeDirection.Right then
					p1("Left")

					return
				end

				if p3 == Enum.SwipeDirection.Left then
					p1("Right")
				end
			end
		end)

		return function() -- line: 52
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		p1,
		t1
	})
end

return useTouchDragScroll
