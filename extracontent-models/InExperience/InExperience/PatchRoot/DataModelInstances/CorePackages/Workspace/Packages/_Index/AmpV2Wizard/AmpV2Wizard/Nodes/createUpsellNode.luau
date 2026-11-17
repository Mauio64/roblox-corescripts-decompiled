local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

require(AmpV2Wizard.Types)
local FFlagAmpV2WizardRetryAmp = require(AmpV2Wizard.Flags.FFlagAmpV2WizardRetryAmp)

local function createUpsellNode(callback)
	local function UpsellNode(props)
		local props2 = props.props
		local ctx = props.ctx
		local report = props.report
		local navigation = useNavigation()
		local dispatch = useDispatch()

		React.useEffect(function()
			callback({ navigation = navigation, dispatch = dispatch }, props2, ctx, report)
		end, FFlagAmpV2WizardRetryAmp and { props2 } or {})

		return React.createElement(Loading, {
			size = IconSize.Medium,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	return UpsellNode
end

return createUpsellNode
