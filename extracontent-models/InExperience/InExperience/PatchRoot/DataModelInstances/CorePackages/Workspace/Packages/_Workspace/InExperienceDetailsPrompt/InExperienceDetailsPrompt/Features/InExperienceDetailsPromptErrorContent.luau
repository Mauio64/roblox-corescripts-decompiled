local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local DiscoveryTypes = require(parent.DiscoveryTypes)
local EnumGameDetailErrorTypes = DiscoveryTypes.EnumGameDetailErrorTypes

local function getErrorDisplayMessage(errorType: string, p) -- 1 equivalent call inferred from this helper
	if errorType == EnumGameDetailErrorTypes.ExperienceUnavailable then
		return p.experienceUnavailable
	end

	return p.noInternet
end

local function InExperienceDetailsPromptErrorContent(p)
	local v = useTokens()

	local v2 = useLocalization({
		experienceUnavailable = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		noInternet = "Feature.EmptyStatePage.Message.NoInternet"
	})

	local errorDisplayMessage = getErrorDisplayMessage(p.errorType, v2) -- inferred equivalent call

	return React.createElement(
		View,
		{
			tag = "col size-full-0 auto-y items-center gap-medium padding-bottom-large padding-top-large"
		},
		{
			Icon = React.createElement(Icon, {
				name = Enums.IconName.TriangleExclamation,
				size = v.Size.Size_1700,
				layoutOrder = 1
			}),
			Message = React.createElement(Text, {
				Text = errorDisplayMessage,
				tag = "text-body-large size-full-0 auto-y text-center text-wrap",
				layoutOrder = 2
			})
		}
	)
end

return InExperienceDetailsPromptErrorContent
