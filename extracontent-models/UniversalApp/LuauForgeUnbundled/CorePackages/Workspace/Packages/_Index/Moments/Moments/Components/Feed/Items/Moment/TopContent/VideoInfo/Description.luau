local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")

local function Description(p2)
	local v5 = useTokens()
	local v6 = MomentContext.useMoment()

	local v7 = useSignalBinding(v6.store.getIsModerated)
	local animationRatio = v6.animationRatio

	local description = v6.store.getData(false).description

	if description and description ~= "" then
		return React.createElement(view, {
			LayoutOrder = p2.LayoutOrder,
			tag = "size-full-0 auto-y",
			Visible = v7:map(function(p3): boolean
				return not p3
			end)
		}, {
			DescriptionText = React.createElement(text, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left text-align-y-top text-truncate-split content-emphasis",
				Text = description,
				textStyle = animationRatio:map(function(p3)
					return getColorStyleWithTransparency(v5.Color.Content.Emphasis, p3)
				end)
			})
		})
	end

	return nil
end

return React.memo(Description)
