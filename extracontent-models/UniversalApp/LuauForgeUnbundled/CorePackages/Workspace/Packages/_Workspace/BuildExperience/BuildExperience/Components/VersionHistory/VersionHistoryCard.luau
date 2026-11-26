local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function VersionHistoryCard(props)
	local testId = props.testId or "version-history-card"
	local restore = useLocalization({
		autosaved = LocalizationStrings.VERSION_HISTORY_AUTOSAVED,
		previouslyPublished = LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED,
		published = LocalizationStrings.VERSION_HISTORY_PUBLISHED,
		restore = LocalizationStrings.VERSION_HISTORY_RESTORE
	}).restore
	local v5 = React.useCallback(function()
		props.onRestore()
	end, { props.onRestore })

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
			testId = testId
		},
		{
			Content = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium"
				},
				{
					Header = React.createElement(
						view,
						{
							LayoutOrder = 1,
							tag = "col align-x-left align-y-top gap-xxsmall size-full-0 auto-y",
							testId = `{testId}-header`
						},
						{
							Version = React.createElement(text, {
								LayoutOrder = 1,
								Text = props.versionLabel,
								tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
								testId = `{testId}-version`
							}),
							Title = React.createElement(text, {
								LayoutOrder = 2,
								Text = props.title,
								tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
								testId = `{testId}-title`
							})
						}
					),
					Slot = React.createElement(
						view,
						{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" },
						{
							Description = React.createElement(text, {
								LayoutOrder = 1,
								Text = props.description,
								tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
								testId = `{testId}-description`
							}),
							RestoreRow = React.createElement(
								view,
								{ tag = "row size-full-0 auto-y", LayoutOrder = 2 },
								{
									Restore = React.createElement(button, {
										text = restore,
										size = inputSize.Small,
										variant = buttonVariant.Standard,
										fillBehavior = fillBehavior.Fill,
										isDisabled = props.isRestoreDisabled,
										onActivated = v5,
										testId = `{testId}-restore`
									})
								}
							)
						}
					)
				}
			)
		}
	)
end

return VersionHistoryCard
