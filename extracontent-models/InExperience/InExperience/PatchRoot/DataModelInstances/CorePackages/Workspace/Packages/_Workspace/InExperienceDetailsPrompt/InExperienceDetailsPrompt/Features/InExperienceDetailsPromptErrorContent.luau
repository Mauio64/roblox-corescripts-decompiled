local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local EnumGameDetailErrorTypes = require(Parent.DiscoveryTypes).EnumGameDetailErrorTypes

local function getErrorDisplayMessage(s1: string, t1: {[any]: any}) -- line: 18
	-- upvalues: EnumGameDetailErrorTypes (copy)
	if s1 == EnumGameDetailErrorTypes.ExperienceUnavailable then
		return t1.experienceUnavailable
	end

	return t1.noInternet
end
local function InExperienceDetailsPromptErrorContent(t2: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), useLocalization (copy), EnumGameDetailErrorTypes (copy), React (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy)
	local v16 = useTokens()
	local v17 = useLocalization({
		experienceUnavailable = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		noInternet = "Feature.EmptyStatePage.Message.NoInternet"
	})
	local v18 = if t2.errorType ~= EnumGameDetailErrorTypes.ExperienceUnavailable then v17.noInternet else v17.experienceUnavailable

	return React.createElement(View, {
		tag = "col size-full-0 auto-y items-center gap-medium padding-bottom-large padding-top-large"
	}, {
		Icon = React.createElement(Icon, {
			layoutOrder = 1,
			name = Enums.IconName.TriangleExclamation,
			size = v16.Size.Size_1700
		}),
		Message = React.createElement(FoundationText, {
			tag = "text-body-large size-full-0 auto-y text-center text-wrap",
			layoutOrder = 2,
			Text = v18
		})
	})
end

return InExperienceDetailsPromptErrorContent
