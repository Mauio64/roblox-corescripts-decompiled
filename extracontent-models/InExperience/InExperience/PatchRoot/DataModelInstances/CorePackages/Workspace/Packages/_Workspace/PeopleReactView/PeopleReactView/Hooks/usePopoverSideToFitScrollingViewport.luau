local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)
local PopoverSide = Foundation.Enums.PopoverSide

local function choosePopoverSideForViewport(p1, p2, n1: number, n2: number, n3: number, n4: number, n5: number, n6: number) -- line: 16
	-- upvalues: PopoverSide (copy)
	if n5 <= 0 then
		return p1
	end

	local v19 = n5 + n6
	local v20 = n1 - n3
	local v21 = n4 - n2

	local function spaceFor(p3) -- line: 34
		-- upvalues: PopoverSide (copy), v20 (copy), v21 (copy)
		if p3 == PopoverSide.Top then
			return v20
		end

		return v21
	end
	local function fits(p4) -- line: 38
		-- upvalues: PopoverSide (copy), v20 (copy), v21 (copy), v19 (copy)
		return ((if p4 ~= PopoverSide.Top then v21 else v20)) >= v19
	end

	local v24 = if p2 == nil then p1 else p2

	if v19 <= if v24 ~= PopoverSide.Top then v21 else v20 then
		return v24
	end

	local v25 = if v24 ~= PopoverSide.Top then PopoverSide.Top else PopoverSide.Bottom

	if v19 <= if v25 ~= PopoverSide.Top then v21 else v20 then
		return v25
	end

	if v20 < v21 then
		return PopoverSide.Bottom
	end

	return PopoverSide.Top
end
local function usePopoverSideToFitScrollingViewport(b1: boolean, p5, p6, n7: number, n8: number) -- line: 55
	-- upvalues: SignalsReact (copy), GetScrollingFrameStore (copy), React (copy), choosePopoverSideForViewport (copy), Signals (copy)
	local v31 = SignalsReact.useSignalState(GetScrollingFrameStore)
	local v32, v33 = React.useState(nil)

	React.useEffect(function() -- line: 65
		-- upvalues: b1 (copy), v33 (copy), p6 (copy), v31 (copy), choosePopoverSideForViewport (copy), p5 (copy), n7 (copy), n8 (copy), Signals (copy)
		if not b1 then
			v33(nil)

			return
		end

		local function updateSide() -- line: 71
			-- upvalues: p6 (copy), v31 (copy), v33 (copy), choosePopoverSideForViewport (copy), p5 (copy), n7 (copy), n8 (copy)
			local current = p6.current

			if not current then
				return
			end

			local v40 = v31.getAbsolutePositionY(false)
			local v41 = v31.getAbsoluteSizeY(false)

			if v41 <= 0 then
				return
			end

			local AbsolutePositionY = current.AbsolutePosition.Y
			local v43 = AbsolutePositionY + current.AbsoluteSize.Y
			local v44 = v40 + v41

			v33(function(p7) -- line: 87
				-- upvalues: choosePopoverSideForViewport (copy), p5 (copy), AbsolutePositionY (copy), v43 (copy), v40 (copy), v44 (copy), n7 (copy), n8 (copy)
				return (choosePopoverSideForViewport(p5, p7, AbsolutePositionY, v43, v40, v44, n7, n8))
			end)
		end

		local v37 = Signals.createEffect(function(p8) -- line: 101
			-- upvalues: v31 (copy), updateSide (copy)
			v31.getCanvasPositionY(p8)
			v31.getAbsolutePositionY(p8)
			v31.getAbsoluteSizeY(p8)
			updateSide()
		end)
		local t1 = {}

		if p6.current then
			table.insert(t1, p6.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateSide))
			table.insert(t1, p6.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSide))
		end

		return function() -- line: 121
			-- upvalues: v37 (copy), t1 (copy)
			v37()

			for _, v47 in t1 do
				v47:Disconnect()
			end
		end
	end, {
		b1,
		p5,
		n7,
		n8,
		v31
	})

	if b1 then
		return v32 or p5
	end

	return p5
end

return usePopoverSideToFitScrollingViewport
