local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)
local DataHydration = require(Parent.DataHydration)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function InExperienceDetailsPromptPlayButton(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), DataHydration (copy), React (copy), Skeleton (copy), EnumsRadius (copy), Button (copy), IconName (copy), ButtonVariant (copy)
	local v13 = useTokens()

	if not t1.rootPlaceId or not t1.playability and t1.playabilityRetrievalStatus ~= DataHydration.DataStatus.Failed then
		return React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v13.Size.Size_1000),
			radius = EnumsRadius.Medium
		})
	end

	if not t1.playability then
		return React.createElement(Button, {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			icon = IconName.PlayLarge,
			variant = ButtonVariant.Emphasis,
			onActivated = t1.onJoin
		})
	end

	return React.createElement(Button, {
		LayoutOrder = 1,
		width = UDim.new(1, 0),
		text = if not t1.playability.isPlayable then t1.playButtonUnavailableText else nil,
		icon = if not t1.playability.isPlayable then IconName.CircleSlash else IconName.PlayLarge,
		variant = if not t1.playability.isPlayable then ButtonVariant.Standard else ButtonVariant.Emphasis,
		onActivated = t1.onJoin,
		isDisabled = not t1.playability.isPlayable
	})
end

return InExperienceDetailsPromptPlayButton
