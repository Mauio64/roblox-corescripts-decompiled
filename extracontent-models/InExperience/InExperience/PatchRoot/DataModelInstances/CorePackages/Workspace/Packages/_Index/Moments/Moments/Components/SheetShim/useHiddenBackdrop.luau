local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

require(script.Parent.getSheetStructure)

local function useHiddenBackdrop(p, flag: boolean)
	React.useLayoutEffect(function()
		local backdrop

		if not (p == nil or not flag) then
			backdrop = p.backdrop
		end

		if backdrop == nil then
			return nil
		end

		local uiGradient = Instance.new("UIGradient")
		uiGradient.Transparency = NumberSequence.new(1)
		uiGradient.Parent = backdrop
		return function()
			uiGradient:Destroy()
		end
	end, { p, flag })
end

return useHiddenBackdrop
