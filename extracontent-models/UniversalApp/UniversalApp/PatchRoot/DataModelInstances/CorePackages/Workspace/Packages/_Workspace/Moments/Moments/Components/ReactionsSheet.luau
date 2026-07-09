local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(MomentsParent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local abbreviateCount = Localization.abbreviateCount
local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize
local useConfiguration = require(Moments.Hooks.useConfiguration)
local t1 = {
	title = "Feature.Moments.Label.Reactions"
}

local function ReactionsSheet(t2: {[any]: any}) -- line: 35
	-- upvalues: useLocalization (copy), t1 (copy), useConfiguration (copy), React (copy), View (copy), Reaction (copy), ReactionSize (copy), FoundationText (copy), abbreviateCount (copy), LocalizationService (copy), Sheet (copy), Foundation (copy)
	local v19 = useLocalization(t1)
	local v20 = useConfiguration("android_tv_enabled", false)
	local v21 = React.useMemo(function() -- line: 39
		-- upvalues: t2 (copy), React (copy), View (copy), Reaction (copy), ReactionSize (copy), FoundationText (copy), abbreviateCount (copy), LocalizationService (copy)
		local t3 = {}

		for i, v in ipairs(t2.reactionCounts) do
			if not (v.count <= 0) then
				t3[v.reaction] = React.createElement(View, {
					tag = "row align-y-center gap-xsmall auto-xy padding-xsmall",
					LayoutOrder = i
				}, {
					Icon = React.createElement(Reaction, {
						layoutOrder = 1,
						reactionType = v.reaction,
						size = ReactionSize.XSmall
					}),
					Count = React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = "auto-xy text-body-medium content-emphasis",
						Text = abbreviateCount(v.count, LocalizationService.RobloxLocaleId)
					})
				})
			end
		end

		return t3
	end, { t2.reactionCounts })

	return React.createElement(Sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = t2.onClose,
		size = Foundation.Enums.DialogSize.Large
	}, {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-emphasis",
				Text = v19.title
			})
		}),
		Content = React.createElement(Sheet.Content, if not v20 then nil else {
			Selectable = false
		}, {
			ReactionsContainer = React.createElement(View, {
				tag = "row wrap align-y-center gap-small size-full-0 auto-y padding-bottom-large"
			}, v21)
		})
	})
end

return ReactionsSheet
