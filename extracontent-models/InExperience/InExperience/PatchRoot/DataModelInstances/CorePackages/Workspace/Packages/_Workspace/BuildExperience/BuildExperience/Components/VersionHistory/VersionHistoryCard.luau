local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function VersionHistoryCard(props)
	local testId = props.testId or "version-history-card"
	local restore = useLocalization({
		autosaved = LocalizationStrings.VERSION_HISTORY_AUTOSAVED,
		previouslyPublished = LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED,
		published = LocalizationStrings.VERSION_HISTORY_PUBLISHED,
		restore = LocalizationStrings.VERSION_HISTORY_RESTORE
	}).restore
	local onActivated = React.useCallback(function()
		props.onRestore()
	end, { props.onRestore })

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
			testId = testId
		},
		{
			Content = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium"
				},
				{
					Header = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "col align-x-left align-y-top gap-xxsmall size-full-0 auto-y",
							testId = `{testId}-header`
						},
						{
							Version = React.createElement(Text, {
								LayoutOrder = 1,
								Text = props.versionLabel,
								tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
								testId = `{testId}-version`
							}),
							Title = React.createElement(Text, {
								LayoutOrder = 2,
								Text = props.title,
								tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
								testId = `{testId}-title`
							})
						}
					),
					Slot = React.createElement(View, {
						LayoutOrder = 2,
						tag = "col gap-large size-full-0 auto-y"
					}, {
						Description = React.createElement(Text, {
							LayoutOrder = 1,
							Text = props.description,
							tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
							testId = `{testId}-description`
						}),
						RestoreRow = React.createElement(View, {
							tag = "row size-full-0 auto-y",
							LayoutOrder = 2
						}, {
							Restore = React.createElement(Button, {
								text = restore,
								size = InputSize.Small,
								variant = ButtonVariant.Standard,
								fillBehavior = FillBehavior.Fill,
								isDisabled = props.isRestoreDisabled,
								onActivated = onActivated,
								testId = `{testId}-restore`
							})
						})
					})
				}
			)
		}
	)
end

return VersionHistoryCard
