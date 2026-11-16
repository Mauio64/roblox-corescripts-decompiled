local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local fFlagUseSignalsForScreenGuiBlur = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForScreenGuiBlur
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getScreenGuiBlurStore

if fFlagUseSignalsForScreenGuiBlur then
	getScreenGuiBlurStore = require("@luauforge/bundled/gea").GetScreenGuiBlurStore
else
	getScreenGuiBlurStore = nil
end

local extended = Roact.PureComponent:extend("ScreenGuiWithBlurControl")

function extended.render(p2)
	local hasScreenGuiBlur = p2.props.hasScreenGuiBlur
	local blurDisplayOrder = p2.props.blurDisplayOrder
	local displayOrder = p2.props.DisplayOrder

	local v5 = hasScreenGuiBlur and blurDisplayOrder <= displayOrder and true or false

	local joined = Cryo.Dictionary.join(p2.props, {
		hasScreenGuiBlur = Cryo.None,
		blurDisplayOrder = Cryo.None,
		OnTopOfCoreBlur = v5
	})

	return Roact.createElement("ScreenGui", joined)
end

if fFlagUseSignalsForScreenGuiBlur then
	return (React.memo(function(p2)
		local screenGuiBlurStore = getScreenGuiBlurStore(false)
		local v5 = useSignalState(screenGuiBlurStore.getHasBlur)
		local v6 = useSignalState(screenGuiBlurStore.getBlurDisplayOrder)
		return Roact.createElement(
			extended,
			Cryo.Dictionary.union(p2, { hasScreenGuiBlur = v5, blurDisplayOrder = v6 })
		)
	end))
end

return (RoactRodux.connect(function(p2, p3)
	return {
		hasScreenGuiBlur = p2.ScreenGuiBlur.hasBlur,
		blurDisplayOrder = p2.ScreenGuiBlur.blurDisplayOrder
	}
end)(extended))
