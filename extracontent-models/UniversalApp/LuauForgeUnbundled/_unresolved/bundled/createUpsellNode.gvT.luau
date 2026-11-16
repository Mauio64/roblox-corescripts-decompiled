local module = require("@luauforge/bundled/gvb")
local useNavigation = require("@luauforge/bundled/gvO").useNavigation
local useDispatch = require("@luauforge/bundled/gvU").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/gvj")
local loading = module2.Loading
local iconSize = module2.Enums.IconSize

require("@luauforge/bundled/gvc")

local function createUpsellNode(callback)
	local function UpsellNode(props)
		local props2 = props.props
		local ctx = props.ctx
		local report = props.report
		local v5 = useNavigation()
		local v6 = useDispatch()

		module.useEffect(function()
			callback({ navigation = v5, dispatch = v6 }, props2, ctx, report)
		end, {})

		return module.createElement(loading, {
			size = iconSize.Medium,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	return UpsellNode
end

return createUpsellNode
