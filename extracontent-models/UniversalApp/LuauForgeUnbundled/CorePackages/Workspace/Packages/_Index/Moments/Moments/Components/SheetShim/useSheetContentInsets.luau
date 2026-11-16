local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/SheetShimTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/getSheetStructure")
local readSheetContentInsets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/readSheetContentInsets")

local RunService = game:GetService("RunService")

local frozen = table.freeze({ bottom = 0, right = 0 })

local function useSheetContentInsets(p2, current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)

	local v5 = React.useCallback(function(current2)
		local current3 = ref2.current

		if current3 ~= nil and current3.bottom == current2.bottom and current3.right == current2.right then
			return
		end

		ref2.current = current2

		if ref.current ~= nil then
			ref.current(current2)
		end
	end, {})
	local v6 = current ~= nil
	React.useLayoutEffect(function()
		if p2 == nil or not v6 then
			return nil
		end

		ref3.current = false

		local function sample()
			if not ref3.current then
				v5(readSheetContentInsets(p2))
			end
		end

		if not ref3.current then
			v5(readSheetContentInsets(p2))
		end

		local v7

		if p2.scroller == nil then
			v7 = p2.sheet:GetPropertyChangedSignal("Position")
		else
			v7 = p2.scroller:GetPropertyChangedSignal("CanvasPosition")
		end

		local v8 = { v7:Connect(sample), RunService.RenderStepped:Connect(sample) }

		return function()
			for k, connection in v8 do
				connection:Disconnect()
			end

			v5(frozen)
		end
	end, { p2, v6, v5 })

	return React.useCallback(function()
		ref3.current = true
		v5(frozen)
	end, { v5 })
end

return useSheetContentInsets
