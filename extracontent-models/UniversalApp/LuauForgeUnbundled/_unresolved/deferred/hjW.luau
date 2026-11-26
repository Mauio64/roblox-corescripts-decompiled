local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useSignal = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSignal

local module = require("@luauforge/deferred/hjX")
local module2 = require("@luauforge/deferred/hka")
local module3 = require("@luauforge/bundled/gJS")

local function FormResponsiveDropdown(props, p2)
	local v5 = useSelector(module3)
	local ref = React.useRef(signal.new())
	useSignal(ref.current, props.onClose or function() end)

	if v5 then
		return React.createElement(module, {
			canApply = props.canApply,
			onApply = props.onApply,
			closePeekViewSignal = ref.current,
			totalSize = UDim2.fromScale(1, 0),
			useAutomaticSize = true
		}, {
			Container = React.createElement(Foundation.View, { tag = "auto-xy col" }, {
				Header = props.headerText and React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large padding-x-xlarge padding-bottom-xlarge",
					Text = props.headerText,
					LayoutOrder = 1
				}),
				ChildrenContainer = React.createElement(
					Foundation.View,
					{ tag = "padding-x-large auto-xy", LayoutOrder = 2 },
					props.children
				)
			})
		})
	end

	return React.createElement(module2, {
		canApply = props.canApply,
		onApply = props.onApply,
		onClose = props.onClose,
		dropdownPosition = props.dropdownPosition,
		headerText = props.headerText,
		ref = p2
	}, props.children)
end

return React.forwardRef(FormResponsiveDropdown)
