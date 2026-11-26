local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RoactUtils").Hooks.RoactRodux.useDispatch

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FFlagAmpV2WizardRetryAmp = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Flags/FFlagAmpV2WizardRetryAmp")

local function createUpsellNode(callback)
	local function UpsellNode(props)
		local props2 = props.props
		local ctx = props.ctx
		local report = props.report
		local v5 = useNavigation()
		local v6 = useDispatch()

		React.useEffect(function()
			callback({ navigation = v5, dispatch = v6 }, props2, ctx, report)
		end, FFlagAmpV2WizardRetryAmp and { props2 } or {})

		return React.createElement(loading, {
			size = iconSize.Medium,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	return UpsellNode
end

return createUpsellNode
