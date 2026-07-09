local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useSignal = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useSignal
local FormPeekview = require(Modules.AvatarExperience.Common.Components.FormPeekview)
local FormDropdown = require(Modules.AvatarExperience.Common.Components.FormDropdown)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)

local function FormResponsiveDropdown(t1: {[any]: any}, p1) -- line: 32
	-- upvalues: useSelector (copy), selectIsPortrait (copy), React (copy), Signal (copy), useSignal (copy), FormPeekview (copy), Foundation (copy), FormDropdown (copy)
	local v14 = useSelector(selectIsPortrait)
	local v15 = React.useRef(Signal.new())

	useSignal(v15.current, t1.onClose or function() -- line: 35
	end)

	if v14 then
		return React.createElement(FormPeekview, {
			useAutomaticSize = true,
			canApply = t1.canApply,
			onApply = t1.onApply,
			closePeekViewSignal = v15.current,
			totalSize = UDim2.fromScale(1, 0)
		}, {
			Container = React.createElement(Foundation.View, {
				tag = "auto-xy col"
			}, {
				Header = t1.headerText and React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large padding-x-xlarge padding-bottom-xlarge",
					LayoutOrder = 1,
					Text = t1.headerText
				}),
				ChildrenContainer = React.createElement(Foundation.View, {
					tag = "padding-x-large auto-xy",
					LayoutOrder = 2
				}, t1.children)
			})
		})
	end

	return React.createElement(FormDropdown, {
		canApply = t1.canApply,
		onApply = t1.onApply,
		onClose = t1.onClose,
		dropdownPosition = t1.dropdownPosition,
		headerText = t1.headerText,
		ref = p1
	}, t1.children)
end

return React.forwardRef(FormResponsiveDropdown)
