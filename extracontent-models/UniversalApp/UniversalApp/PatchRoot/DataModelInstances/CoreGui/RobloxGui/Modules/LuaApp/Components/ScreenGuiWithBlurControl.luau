local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local v5 = Roact.PureComponent:extend("ScreenGuiWithBlurControl")

function v5.render(p1) -- line: 9
	-- upvalues: Cryo (copy), Roact (copy)
	local hasScreenGuiBlur = p1.props.hasScreenGuiBlur
	local blurDisplayOrder = p1.props.blurDisplayOrder
	local DisplayOrder = p1.props.DisplayOrder
	local v10 = false

	if hasScreenGuiBlur and blurDisplayOrder <= DisplayOrder then
		v10 = true
	end

	local v11 = Cryo.Dictionary.join(p1.props, {
		hasScreenGuiBlur = Cryo.None,
		blurDisplayOrder = Cryo.None,
		OnTopOfCoreBlur = v10
	})

	return Roact.createElement("ScreenGui", v11)
end

return (RoactRodux.connect(function(p2, _) -- line: 28
	return {
		hasScreenGuiBlur = p2.ScreenGuiBlur.hasBlur,
		blurDisplayOrder = p2.ScreenGuiBlur.blurDisplayOrder
	}
end)(v5))
