local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)

local function isGuiObjectOutOfScrollingFrameView(y: number, y2: number, p: number, absoluteSizeY: number): boolean -- 1 equivalent call inferred from this helper
	local v = p + absoluteSizeY

	return y + y2 < p or v < y
end

local function useDismissWhenOutOfView(flag: boolean, callback, p)
	local v = SignalsReact.useSignalState(GetScrollingFrameStore)

	React.useEffect(function()
		if not flag then
			return
		end

		local flag2 = false

		local function dismissIfOutOfView()
			if flag2 then
				return
			end

			local current = p.current

			if not current then
				return
			end

			local absoluteSizeY = v.getAbsoluteSizeY(false)

			if absoluteSizeY <= 0 then
				return
			end

			if isGuiObjectOutOfScrollingFrameView( -- inferred equivalent call
				current.AbsolutePosition.Y,
				current.AbsoluteSize.Y,
				v.getAbsolutePositionY(false),
				absoluteSizeY
			) then
				flag2 = true
				callback()
			end
		end

		local effect = Signals.createEffect(function(p2)
			v.getCanvasPositionY(p2)
			v.getAbsolutePositionY(p2)
			v.getAbsoluteSizeY(p2)

			dismissIfOutOfView()
		end)
		local absolutePositionChangedConnection

		if p.current then
			absolutePositionChangedConnection = p.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(dismissIfOutOfView)
		else
			absolutePositionChangedConnection = nil
		end

		return function()
			effect()

			if absolutePositionChangedConnection then
				absolutePositionChangedConnection:Disconnect()
			end
		end
	end, { flag, callback, v })
end

return useDismissWhenOutOfView
