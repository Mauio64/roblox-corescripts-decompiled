local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local GamePlayButton = require(VirtualEvents.Parent.GamePlayButton)
local RoactServiceTags = require(VirtualEvents.Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(VirtualEvents.Parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
require(VirtualEvents.Parent.VirtualEventsState)
local useExperienceSubtitle = require(VirtualEvents.Hooks.useExperienceSubtitle)

local View = Foundation.View
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates

local function EventActionBar(props)
	local v = useTokens()
	local text

	if props.universeId then
		text = useExperienceSubtitle(props.universeId)
	end

	local v2 = usePlayButtonState(useRoactService(RoactNetworking), props.universeId or "")
	local v3 = v2.playButtonState == PlayButtonStates.Playable
		or v2.playButtonState == PlayButtonStates.PlayableWithParty

	local createElement = React.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v5 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		UpperContainer = 0,
		LowerContianer = 0
	}

	local createElement2 = React.createElement
	local v6 = { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = 1 }

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		ExperienceThumbnail = React.createElement("ImageButton", {
			Active = true,
			Size = UDim2.fromOffset(40, 40),
			BorderSizePixel = 0,
			Image = ("rbxthumb://type=GameIcon&id=%s&w=150&h=150"):format(props.universeId),
			[React.Event.Activated] = props.onExperienceTileActivated
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
		}),
		EventInfo = 0
	}

	local createElement3 = React.createElement
	local v7 = { Size = UDim2.new(1, -52, 1, 0), BackgroundTransparency = 1, LayoutOrder = 2 }

	local v8 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		ExperienceName = React.createElement(Text, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, text and 0.5 or 1),
			Text = props.experienceName,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = v.Typography.TitleLarge,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextWrapped = false
		}),
		ExperienceSubtitle = 0
	}
	local experienceSubtitle

	if text then
		experienceSubtitle = React.createElement(Text, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0.5),
			Text = text,
			textStyle = v.Color.Content.Default,
			fontStyle = v.Typography.BodyLarge,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.None,
			TextWrapped = false
		})
	end

	v8.ExperienceSubtitle = experienceSubtitle
	children.EventInfo = createElement3("Frame", v7, v8)
	v5.UpperContainer = createElement2("Frame", v6, children)
	local lowerContianer

	if props.ctaProps.button then
		local createElement4 = React.createElement
		local v9 = {
			LayoutOrder = 2,
			size = UDim2.new(1, 0, 0, 40),
			tag = { ["row gap-small wrap auto-y size-full-0"] = true, ["fill-x"] = true }
		}

		local v10 = {
			CTAButton = React.createElement(Button, {
				text = props.ctaProps.button.text,
				variant = ButtonVariant[props.ctaProps.button.variant],
				onActivated = not v3 and function() end or props.ctaProps.button.onActivated,
				fillBehavior = FillBehavior.Fill,
				size = ButtonSize.Medium,
				isDisabled = not v3
			}),
			ShareButtonWrapper = 0
		}
		local shareButtonWrapper

		if props.ctaProps.icon then
			shareButtonWrapper = React.createElement(
				"Frame",
				{ Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1 },
				{
					ShareButton = React.createElement(Button, {
						variant = ButtonVariant.Standard,
						onActivated = not v3 and function() end or props.ctaProps.icon.onActivated,
						fillBehavior = FillBehavior.Fill,
						size = ButtonSize.Medium,
						isDisabled = not v3
					}),
					ShareIcon = React.createElement(ImageSetLabel, {
						ZIndex = 2,
						Size = UDim2.fromOffset(32, 32),
						Image = Images[props.ctaProps.icon.icon],
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(4, 4)
					})
				}
			)
		end

		v10.ShareButtonWrapper = shareButtonWrapper
		lowerContianer = createElement4(View, v9, v10)
	end

	v5.LowerContianer = lowerContianer
	return createElement("Frame", v4, v5)
end

return EventActionBar
