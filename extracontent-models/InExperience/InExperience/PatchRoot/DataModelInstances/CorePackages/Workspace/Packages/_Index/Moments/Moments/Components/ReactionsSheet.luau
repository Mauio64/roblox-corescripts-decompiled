local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)

local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)

local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local LocalizationService = game:GetService("LocalizationService")

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount
local v

if FFlagMomentsUseSharedReactions then
	v = require(parent.Reactions.Reaction)
else
	v = MomentsCommon.Components.Reaction
end

local ReactionSize = MomentsCommon.Enums.ReactionSize

local useConfiguration = require(Moments.Hooks.useConfiguration)

local v2 = { title = "Feature.Moments.Label.Reactions" }

local function ReactionsSheet(p)
	local v3 = useLocalization(v2)
	local v4 = useConfiguration("android_tv_enabled", false)

	local v5 = React.useMemo(function()
		local children = {}

		for i, reactionCount in ipairs(p.reactionCounts) do
			if not (reactionCount.count <= 0) then
				children[reactionCount.reaction] = React.createElement(
					View,
					{
						tag = "row align-y-center gap-xsmall auto-xy padding-xsmall",
						LayoutOrder = i
					},
					{
						Icon = React.createElement(v, {
							reactionType = reactionCount.reaction,
							size = ReactionSize.XSmall,
							layoutOrder = 1
						}),
						Count = React.createElement(Text, {
							Text = abbreviateCount(reactionCount.count, LocalizationService.RobloxLocaleId),
							LayoutOrder = 2,
							tag = "auto-xy text-body-medium content-emphasis"
						})
					}
				)
			end
		end

		return children
	end, { p.reactionCounts })

	return React.createElement(
		Sheet.Root,
		{
			isOpen = true,
			onClose = p.onClose,
			preferCenterSheet = true,
			size = Foundation.Enums.DialogSize.Large
		},
		{
			Header = React.createElement(Sheet.Header, nil, {
				Title = React.createElement(Text, {
					Text = v3.title,
					tag = "auto-xy text-heading-small content-emphasis"
				})
			}),
			Content = React.createElement(Sheet.Content, v4 and { Selectable = false } or nil, {
				ReactionsContainer = React.createElement(
					View,
					{
						tag = "row wrap align-y-center gap-small size-full-0 auto-y padding-bottom-large"
					},
					v5
				)
			})
		}
	)
end

return ReactionsSheet
