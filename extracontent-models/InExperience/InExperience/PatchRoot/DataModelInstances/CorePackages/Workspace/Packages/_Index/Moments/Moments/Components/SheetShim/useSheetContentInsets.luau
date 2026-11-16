local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

require(script.Parent.SheetShimTypes)
require(script.Parent.getSheetStructure)
local readSheetContentInsets = require(script.Parent.readSheetContentInsets)

local RunService = game:GetService("RunService")

local frozen = table.freeze({ bottom = 0, right = 0 })

local function useSheetContentInsets(p, current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)

	local v = React.useCallback(function(current2)
		local current3 = ref2.current

		if current3 ~= nil and current3.bottom == current2.bottom and current3.right == current2.right then
			return
		end

		ref2.current = current2

		if ref.current ~= nil then
			ref.current(current2)
		end
	end, {})
	local v2 = current ~= nil
	React.useLayoutEffect(function()
		if p == nil or not v2 then
			return nil
		end

		ref3.current = false

		local function sample() -- 1 equivalent call inferred from this helper
			if not ref3.current then
				v(readSheetContentInsets(p))
			end
		end

		sample() -- inferred equivalent call
		local v3

		if p.scroller == nil then
			v3 = p.sheet:GetPropertyChangedSignal("Position")
		else
			v3 = p.scroller:GetPropertyChangedSignal("CanvasPosition")
		end

		local v4 = { v3:Connect(sample), RunService.RenderStepped:Connect(sample) }

		return function()
			for _, connection in v4 do
				connection:Disconnect()
			end

			v(frozen)
		end
	end, { p, v2, v })

	return React.useCallback(function()
		ref3.current = true
		v(frozen)
	end, { v })
end

return useSheetContentInsets
