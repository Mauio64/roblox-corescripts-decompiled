local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/getSheetStructure")

local function useHiddenBackdrop(p2, p3)
	React.useLayoutEffect(function()
		local backdrop = if not (p2 == nil or not p3) then p2.backdrop else nil

		if backdrop == nil then
			return nil
		end

		local uiGradient = Instance.new("UIGradient")
		uiGradient.Transparency = NumberSequence.new(1)
		uiGradient.Parent = backdrop
		return function()
			uiGradient:Destroy()
		end
	end, { p2, p3 })
end

return useHiddenBackdrop
