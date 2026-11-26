local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local LocalizationService = game:GetService("LocalizationService")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/Reaction") else MomentsCommon.Components.Reaction
local reactionSize = MomentsCommon.Enums.ReactionSize

local useConfiguration = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useConfiguration")

local v6 = { title = "Feature.Moments.Label.Reactions" }

local function ReactionsSheet(p2)
	local v7 = useLocalization(v6)
	local v8 = useConfiguration("android_tv_enabled", false)

	local v9 = React.useMemo(function()
		local children = {}

		for i, reactionCount in ipairs(p2.reactionCounts) do
			if not (reactionCount.count <= 0) then
				children[reactionCount.reaction] = React.createElement(
					view,
					{
						tag = "row align-y-center gap-xsmall auto-xy padding-xsmall",
						LayoutOrder = i
					},
					{
						Icon = React.createElement(v5, {
							reactionType = reactionCount.reaction,
							size = reactionSize.XSmall,
							layoutOrder = 1
						}),
						Count = React.createElement(text, {
							Text = abbreviateCount(reactionCount.count, LocalizationService.RobloxLocaleId),
							LayoutOrder = 2,
							tag = "auto-xy text-body-medium content-emphasis"
						})
					}
				)
			end
		end

		return children
	end, { p2.reactionCounts })

	return React.createElement(
		sheet.Root,
		{
			isOpen = true,
			onClose = p2.onClose,
			preferCenterSheet = true,
			size = Foundation.Enums.DialogSize.Large
		},
		{
			Header = React.createElement(sheet.Header, nil, {
				Title = React.createElement(text, {
					Text = v7.title,
					tag = "auto-xy text-heading-small content-emphasis"
				})
			}),
			Content = React.createElement(sheet.Content, v8 and { Selectable = false } or nil, {
				ReactionsContainer = React.createElement(
					view,
					{
						tag = "row wrap align-y-center gap-small size-full-0 auto-y padding-bottom-large"
					},
					v9
				)
			})
		}
	)
end

return ReactionsSheet
