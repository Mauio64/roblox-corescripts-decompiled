local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)

local PopoverSide = Foundation.Enums.PopoverSide

local function choosePopoverSideForViewport(p, p2, y: number, p3: number, absolutePositionY: number, p4: number, p5: number, p6: number)
	if p5 <= 0 then
		return p
	end

	local v = p5 + p6
	local v2 = y - absolutePositionY
	local v3 = p4 - p3

	local function spaceFor(p7) -- 3 equivalent calls inferred from this helper
		return if p7 == PopoverSide.Top then v2 else v3
	end

	local function fits(p7): boolean
		return v <= spaceFor(p7) -- inferred equivalent call
	end

	if p2 ~= nil then
		p = p2
	end

	if v <= spaceFor(p) then -- inferred equivalent call
		return p
	end

	local v4

	if p == PopoverSide.Top then
		v4 = PopoverSide.Bottom
	else
		v4 = PopoverSide.Top
	end

	if v <= spaceFor(v4) then -- inferred equivalent call
		return v4
	end

	return if v2 < v3 then PopoverSide.Bottom else PopoverSide.Top
end

local function usePopoverSideToFitScrollingViewport(flag: boolean, p, p2, p3: number, p4: number)
	local v = SignalsReact.useSignalState(GetScrollingFrameStore)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not flag then
			setState(nil)
			return
		end

		local function updateSide()
			local current = p2.current

			if not current then
				return
			end

			local absolutePositionY = v.getAbsolutePositionY(false)
			local absoluteSizeY = v.getAbsoluteSizeY(false)

			if absoluteSizeY <= 0 then
				return
			end

			local y = current.AbsolutePosition.Y
			local v2 = y + current.AbsoluteSize.Y
			local v3 = absolutePositionY + absoluteSizeY

			setState(function(p5)
				return choosePopoverSideForViewport(p, p5, y, v2, absolutePositionY, v3, p3, p4)
			end)
		end

		local effect = Signals.createEffect(function(p5)
			v.getCanvasPositionY(p5)
			v.getAbsolutePositionY(p5)
			v.getAbsoluteSizeY(p5)

			updateSide()
		end)

		local connections = {}

		if p2.current then
			table.insert(connections, p2.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateSide))

			table.insert(connections, p2.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSide))
		end

		return function()
			effect()

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { flag, p, p3, p4, v })

	if flag then
		return state or p
	end

	return p
end

return usePopoverSideToFitScrollingViewport
