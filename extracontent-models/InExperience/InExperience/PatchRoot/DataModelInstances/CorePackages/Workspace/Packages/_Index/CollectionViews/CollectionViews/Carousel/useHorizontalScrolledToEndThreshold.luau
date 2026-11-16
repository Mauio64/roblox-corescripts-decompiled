local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)

local function useHorizontalScrolledToEndThreshold(p, p2: number?, callback, flag: boolean)
	local ref = React.useRef(false)

	React.useEffect(function()
		if not flag then
			return nil
		end

		local connections = {}
		local v

		if p.current == nil or callback == nil then
			v = false
		else
			v = p2 ~= nil
		end

		if v then
			local current = p.current

			local function checkThreshold() -- 4 equivalent calls inferred from this helper
				local v2 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p2
				local x = current.CanvasPosition.X

				if x < v2 and ref.current then
					ref.current = false
				elseif v2 < x and not ref.current then
					ref.current = true
					callback()
				end
			end
			table.insert(connections, current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
				checkThreshold() -- inferred equivalent call
			end))

			table.insert(connections, current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
				checkThreshold() -- inferred equivalent call
			end))

			table.insert(connections, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				checkThreshold() -- inferred equivalent call
			end))
			checkThreshold() -- inferred equivalent call
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p, flag, p2, callback })
end

return useHorizontalScrolledToEndThreshold
