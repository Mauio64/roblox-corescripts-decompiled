local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local CreatorUserInfo = require(ParentParent.Components.FeedOverlay.CreatorUserInfo)
local CTASidebar = require(ParentParent.Components.FeedOverlay.CTASidebar)
local FoundationText = Foundation.Text
local View = Foundation.View
local getRelativeTimeLabel = require(ParentParent.Utils.getRelativeTimeLabel)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useRef = React.useRef
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), useRef (copy), useState (copy), useEffectOnce (copy), getRelativeTimeLabel (copy), React (copy), View (copy), CreatorUserInfo (copy), FoundationText (copy), CTASidebar (copy)
	local v16 = useTokens()
	local v17 = useRef(nil)
	local v18, v19 = useState("")
	local v20 = 2 * v16.Padding.XLarge

	useEffectOnce(function() -- line: 37
		-- upvalues: getRelativeTimeLabel (copy), t1 (copy), v19 (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v22 = getRelativeTimeLabel(t1.uploadedAtTimestamp, UnixTimestampMillis)

		v19(v22)
	end, { t1.uploadedAtTimestamp })

	return React.createElement(View, {
		LayoutOrder = 1,
		tag = "size-full-0 bg-action-subtle auto-y"
	}, {
		GradientBackdrop = React.createElement(View, {
			tag = "col size-full-0 bg-contrast",
			ZIndex = 1,
			ref = v17
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 270,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v16.Color.OverMedia.OverMedia_0.Color3),
					ColorSequenceKeypoint.new(1, v16.Color.OverMedia.OverMedia_0.Color3)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.5),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		InfoFrame = React.createElement(View, {
			tag = "align-x-center align-y-bottom padding-xlarge row position-bottom-center size-full-0 items-end bg-action-subtle anchor-bottom-center auto-y gap-medium",
			ZIndex = 2
		}, {
			PostInfo = React.createElement(View, {
				LayoutOrder = 1,
				tag = "auto-y bg-action-subtle col align-x-left align-y-top gap-medium grow",
				onAbsoluteSizeChanged = function(p1) -- line: 71
					-- upvalues: v17 (copy), v20 (copy)
					if v17.current then
						v17.current.Size = UDim2.new(1, 0, 0, p1.AbsoluteSize.Y + v20)
					end
				end
			}, {
				CreatorUserInfo = React.createElement(CreatorUserInfo, {
					layoutOrder = 1,
					creatorUserId = t1.creatorUserId
				}),
				Caption = if not t1.caption or t1.caption == "" then nil else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-medium content-contrast text-wrap text-align-x-left text-align-y-top",
					ZIndex = 2,
					Text = t1.caption
				}),
				Timestamp = if v18 == "" then nil else React.createElement(FoundationText, {
					LayoutOrder = 3,
					tag = "auto-xy content-muted text-align-x-left text-align-y-top text-body-small text-wrap",
					Text = v18
				})
			}),
			CTASidebar = React.createElement(CTASidebar, {
				layoutOrder = 2,
				additionalInfo = t1.additionalInfo,
				creatorUserId = t1.creatorUserId,
				postId = t1.postId
			})
		})
	})
end
