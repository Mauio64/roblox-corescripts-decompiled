local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)

local function isGuiObjectOutOfScrollingFrameView(n1: number, n2: number, n3: number, n4: number) -- line: 10
	local v13 = n3 + n4

	return n3 > n1 + n2 or v13 < n1
end
local function useDismissWhenOutOfView(b1: boolean, p1: ((...any) -> ...any), p2) -- line: 24
	-- upvalues: SignalsReact (copy), GetScrollingFrameStore (copy), React (copy), Signals (copy)
	local v17 = SignalsReact.useSignalState(GetScrollingFrameStore)

	React.useEffect(function() -- line: 27
		-- upvalues: b1 (copy), p2 (copy), v17 (copy), p1 (copy), Signals (copy)
		if not b1 then
			return
		end

		local u18 = false

		local function dismissIfOutOfView() -- line: 34
			-- upvalues: u18 (ref), p2 (copy), v17 (copy), p1 (copy)
			if u18 then
				return
			end

			local current = p2.current

			if not current then
				return
			end

			local v23 = v17.getAbsoluteSizeY(false)

			if v23 <= 0 then
				return
			end

			local AbsolutePositionY = current.AbsolutePosition.Y
			local AbsoluteSizeY = current.AbsoluteSize.Y
			local v26 = v17.getAbsolutePositionY(false)
			local v27 = v26 + v23

			if v26 > AbsolutePositionY + AbsoluteSizeY or v27 < AbsolutePositionY then
				u18 = true
				p1()
			end
		end

		local v20 = Signals.createEffect(function(p3) -- line: 62
			-- upvalues: v17 (copy), dismissIfOutOfView (copy)
			v17.getCanvasPositionY(p3)
			v17.getAbsolutePositionY(p3)
			v17.getAbsoluteSizeY(p3)
			dismissIfOutOfView()
		end)
		local connection = nil

		if p2.current then
			connection = p2.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(dismissIfOutOfView)
		end

		return function() -- line: 77
			-- upvalues: v20 (copy), connection (ref)
			v20()

			if connection then
				connection:Disconnect()
			end
		end
	end, {
		b1,
		p1,
		v17
	})
end

return useDismissWhenOutOfView
