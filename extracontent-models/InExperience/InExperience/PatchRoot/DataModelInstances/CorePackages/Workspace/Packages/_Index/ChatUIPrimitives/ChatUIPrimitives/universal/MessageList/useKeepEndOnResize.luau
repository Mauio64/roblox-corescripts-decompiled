local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
require(parent.ViewRecycler)

local function distanceFromEnd(data) -- 2 equivalent calls inferred from this helper
	return data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y - data.CanvasPosition.Y
end

local function useKeepEndOnResize(p, p2)
	React.useEffect(function()
		if p == nil then
			return nil
		end

		local v = p
		local v2 = v.AbsoluteWindowSize.Y
		local v3 = distanceFromEnd(v) <= 1 -- inferred equivalent call
		local thread = nil

		local canvasPositionChangedConnection = v:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if v.AbsoluteWindowSize.Y ~= v2 or thread ~= nil then
				return
			end

			v3 = distanceFromEnd(v) <= 1 -- inferred equivalent call
		end)
		local absoluteWindowSizeChangedConnection = v:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
			local y = v.AbsoluteWindowSize.Y

			if y == v2 then
				return
			end

			v2 = y

			if not v3 or thread ~= nil then
				return
			end

			thread = task.defer(function()
				thread = nil
				local current = p2.current

				if current ~= nil then
					current.scrollToEnd()
				end
			end)
		end)
		return function()
			canvasPositionChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()

			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { p, p2 })
end

return useKeepEndOnResize
