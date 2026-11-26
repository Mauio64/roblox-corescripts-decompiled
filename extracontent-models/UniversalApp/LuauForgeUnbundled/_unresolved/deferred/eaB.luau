local module = require("@luauforge/deferred/eaj")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module3 = require("@luauforge/deferred/dZm")

local module4 = require("@luauforge/deferred/eaC")
local module5 = require("@luauforge/deferred/eaF")
local text = module.Text
local view = module.View

local module6 = require("@luauforge/deferred/eaQ")

local useEffectOnce = module3.Hooks.useEffectOnce
local useRef = React.useRef
local useState = React.useState
local useTokens = module.Hooks.useTokens

return function(props)
	local v5 = useTokens()
	local v6 = useRef(nil)
	local state, setState = useState("")

	local v7 = 2 * v5.Padding.XLarge

	useEffectOnce(function()
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		setState((module6(props.uploadedAtTimestamp, unixTimestampMillis)))
	end, { props.uploadedAtTimestamp })

	local createElement = React.createElement

	local v10 = {
		GradientBackdrop = React.createElement(
			view,
			{ ref = v6, tag = "col size-full-0 bg-contrast", ZIndex = 1 },
			{
				UIGradient = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, v5.Color.OverMedia.OverMedia_0.Color3),
						ColorSequenceKeypoint.new(1, v5.Color.OverMedia.OverMedia_0.Color3)
					}),
					Rotation = 270,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.5),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}
		),
		InfoFrame = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v15 = {
		CreatorUserInfo = React.createElement(module4, {
			creatorUserId = props.creatorUserId,
			layoutOrder = 1
		}),
		Caption = 0,
		Timestamp = 0
	}

	local v16 = if props.caption and props.caption ~= "" then React.createElement(text, {
		LayoutOrder = 2,
		tag = "auto-xy text-body-medium content-contrast text-wrap text-align-x-left text-align-y-top",
		Text = props.caption,
		ZIndex = 2
	}) else nil
	v15.Caption = v16

	local v17 = if state ~= "" then React.createElement(text, {
		LayoutOrder = 3,
		tag = "auto-xy content-muted text-align-x-left text-align-y-top text-body-small text-wrap",
		Text = state
	}) else nil
	v15.Timestamp = v17
	v10.InfoFrame = createElement2(
		view,
		{
			tag = "align-x-center align-y-bottom padding-xlarge row position-bottom-center size-full-0 items-end bg-action-subtle anchor-bottom-center auto-y gap-medium",
			ZIndex = 2
		},
		{
			PostInfo = createElement3(view, {
				LayoutOrder = 1,
				onAbsoluteSizeChanged = function(p2)
					if v6.current then
						v6.current.Size = UDim2.new(1, 0, 0, p2.AbsoluteSize.Y + v7)
					end
				end,
				tag = "auto-y bg-action-subtle col align-x-left align-y-top gap-medium grow"
			}, v15),
			CTASidebar = React.createElement(module5, {
				additionalInfo = props.additionalInfo,
				creatorUserId = props.creatorUserId,
				layoutOrder = 2,
				postId = props.postId
			})
		}
	)
	return createElement(view, {
		LayoutOrder = 1,
		tag = "size-full-0 bg-action-subtle auto-y"
	}, v10)
end
