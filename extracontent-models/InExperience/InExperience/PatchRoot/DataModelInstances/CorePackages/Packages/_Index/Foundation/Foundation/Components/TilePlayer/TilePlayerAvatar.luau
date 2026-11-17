local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Avatar = require(Foundation.Components.Avatar)
local AvatarSize = require(Foundation.Enums.AvatarSize)
require(Foundation.Enums.ControlState)
require(Foundation.Components.Types)
local UserPresence = require(Foundation.Enums.UserPresence)
local View = require(Foundation.Components.View)
local getStateLayerStyle = require(Foundation.Components.Interactable.getStateLayerStyle)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function TilePlayerAvatar(props)
	local v = useTokens()
	local size_2400 = v.Size.Size_2400

	local v2, v3 = React.useBinding(0)
	local v4, v5 = React.useBinding(1)
	local v6 = React.useMemo(function()
		return React.joinBindings({ v2, v4 }):map(function(list)
			return list[1] / list[2]
		end)
	end, {})
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3(p.AbsoluteSize.X)
	end, {})
	local onAbsoluteSizeChanged2 = React.useCallback(function(p)
		if p.AbsoluteSize.X > 0 then
			v5(p.AbsoluteSize.X / 100)
		end
	end, {})

	local v7 = props.userPresence ~= UserPresence.InExperience and 0 or v.Stroke.Thicker + v.Stroke.Standard

	local v8 = size_2400 + v7 * 2

	local createElement = React.createElement
	local v9 = { Size = UDim2.fromScale(1, 1), onAbsoluteSizeChanged = onAbsoluteSizeChanged }

	local v10 = {
		Reference = React.createElement(View, {
			Size = UDim2.fromOffset(100, 0),
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2
		}),
		AvatarContainer = React.createElement(View, {
			Size = UDim2.fromOffset(v8, v8),
			padding = UDim.new(0, v7)
		}, {
			Scale = React.createElement("UIScale", {
				Scale = v6:map(function(p: number)
					return p / v8
				end)
			}),
			Avatar = React.createElement(Avatar, {
				userId = props.userId,
				userPresence = props.userPresence,
				includeProfileFrame = props.includeProfileFrame,
				size = AvatarSize.Pictogram,
				backgroundStyle = props.backgroundStyle or v.Color.Shift.Shift_200,
				testId = `{props.testId}--avatar`
			})
		}),
		StateLayer = 0
	}
	local stateLayer

	if props.controlState then
		stateLayer = React.createElement(View, {
			tag = "size-full-full radius-circle",
			backgroundStyle = props.controlState:map(function(p)
				return getStateLayerStyle(v, nil, p)
			end),
			ZIndex = 2,
			testId = `{props.testId}--state-layer`
		})
	end

	v10.StateLayer = stateLayer
	return createElement(View, v9, v10)
end

return React.memo(TilePlayerAvatar)
