local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)
local DataHydration = require(Parent.DataHydration)
local LaunchErrorLocalizationKeys = require(Parent.GameLaunch).LaunchErrorLocalizationKeys
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local InExperienceDetailsPromptPlayButton = require(script.Parent.InExperienceDetailsPromptPlayButton)
local Foundation = require(Parent.Foundation)
local Sheet = Foundation.Sheet
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local FFlagLuaAppIedpFixPlayButton = require(Parent.SharedFlags).FFlagLuaAppIedpFixPlayButton

local function InExperienceDetailsPromptActions(t1: {[any]: any}) -- line: 29
	-- upvalues: useTokens (copy), LaunchErrorLocalizationKeys (copy), useLocalization (copy), React (copy), Sheet (copy), View (copy), FFlagLuaAppIedpFixPlayButton (copy), InExperienceDetailsPromptPlayButton (copy), FoundationText (copy), DataHydration (copy), Button (copy), IconName (copy), ButtonVariant (copy), Skeleton (copy), EnumsRadius (copy)
	local v20 = useTokens()
	local v21 = if not t1.playability or (t1.playability.isPlayable or not t1.playability.playabilityStatus) then nil else LaunchErrorLocalizationKeys[t1.playability.playabilityStatus]
	local v22 = useLocalization({
		playButtonUnavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		playabilityError = v21
	})

	return React.createElement(Sheet.Actions, nil, {
		View = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y"
		}, if not FFlagLuaAppIedpFixPlayButton then if t1.playability then {
			PlayButton = React.createElement(Button, {
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				text = if not t1.playability.isPlayable then v22.playButtonUnavailable else nil,
				icon = if not t1.playability.isPlayable then IconName.CircleSlash else IconName.PlayLarge,
				variant = if not t1.playability.isPlayable then ButtonVariant.Standard else ButtonVariant.Emphasis,
				onActivated = t1.onJoin,
				isDisabled = not t1.playability.isPlayable
			}),
			Text = if t1.playability.isPlayable or not v22.playabilityError then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "text-body-small content-default text-truncate-split auto-xy",
				Text = v22.playabilityError
			})
		} else {
			PlayButton = if t1.playabilityRetrievalStatus ~= DataHydration.DataStatus.Failed then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v20.Size.Size_1000),
				radius = EnumsRadius.Medium
			}) else React.createElement(Button, {
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				icon = IconName.PlayLarge,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onJoin
			})
		} else {
			PlayButton = React.createElement(InExperienceDetailsPromptPlayButton, {
				playability = t1.playability,
				onJoin = t1.onJoin,
				rootPlaceId = t1.rootPlaceId,
				playabilityRetrievalStatus = t1.playabilityRetrievalStatus,
				playButtonUnavailableText = v22.playButtonUnavailable
			}),
			Text = if not t1.playability or (t1.playability.isPlayable or not v22.playabilityError) then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "text-body-small content-default text-truncate-split auto-xy",
				Text = v22.playabilityError
			})
		})
	})
end

return InExperienceDetailsPromptActions
