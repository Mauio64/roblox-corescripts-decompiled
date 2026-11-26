local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local view = Foundation.View
local icon = Foundation.Icon
local enums = Foundation.Enums
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Localization").Hooks.useLocalization

local enumGameDetailErrorTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DiscoveryTypes").EnumGameDetailErrorTypes

local function getErrorDisplayMessage(p2, p3)
	if p2 == enumGameDetailErrorTypes.ExperienceUnavailable then
		return p3.experienceUnavailable
	end

	return p3.noInternet
end

local function InExperienceDetailsPromptErrorContent(p2)
	local v5 = useTokens()

	local v6 = useLocalization({
		experienceUnavailable = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		noInternet = "Feature.EmptyStatePage.Message.NoInternet"
	})
	local v7

	if p2.errorType == enumGameDetailErrorTypes.ExperienceUnavailable then
		v7 = v6.experienceUnavailable
	else
		v7 = v6.noInternet
	end

	return React.createElement(
		view,
		{
			tag = "col size-full-0 auto-y items-center gap-medium padding-bottom-large padding-top-large"
		},
		{
			Icon = React.createElement(icon, {
				name = enums.IconName.TriangleExclamation,
				size = v5.Size.Size_1700,
				layoutOrder = 1
			}),
			Message = React.createElement(text, {
				Text = v7,
				tag = "text-body-large size-full-0 auto-y text-center text-wrap",
				layoutOrder = 2
			})
		}
	)
end

return InExperienceDetailsPromptErrorContent
