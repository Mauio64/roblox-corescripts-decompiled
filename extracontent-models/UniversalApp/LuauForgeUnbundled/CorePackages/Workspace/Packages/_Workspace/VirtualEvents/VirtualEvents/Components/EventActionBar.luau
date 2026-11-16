local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GamePlayButton")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local useExperienceSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Hooks/useExperienceSubtitle")

local view = Foundation.View
local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local usePlayButtonState = GamePlayButton.usePlayButtonState
local playButtonStates = GamePlayButton.PlayButtonStates

local function EventActionBar(props)
	local v5 = useTokens()
	local v6 = if props.universeId then useExperienceSubtitle(props.universeId) else nil

	local v8 = usePlayButtonState(useRoactService(roactNetworking), props.universeId or "")
	local v9 = v8.playButtonState == playButtonStates.Playable
		or v8.playButtonState == playButtonStates.PlayableWithParty

	local createElement = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v12 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		UpperContainer = 0,
		LowerContianer = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

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
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		}),
		EventInfo = 0
	}

	local createElement4 = React.createElement
	local v16 = {
		Size = UDim2.new(1, -52, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v17 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		ExperienceName = React.createElement(text, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, v6 and 0.5 or 1),
			Text = props.experienceName,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = v5.Typography.TitleLarge,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextWrapped = false
		}),
		ExperienceSubtitle = 0
	}

	local v18 = if v6 then React.createElement(text, {
		LayoutOrder = 2,
		Size = UDim2.fromScale(1, 0.5),
		Text = v6,
		textStyle = v5.Color.Content.Default,
		fontStyle = v5.Typography.BodyLarge,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = false
	}) else nil
	v17.ExperienceSubtitle = v18
	children.EventInfo = createElement4("Frame", v16, v17)
	v12.UpperContainer = createElement2("Frame", v14, children)
	local v19

	if props.ctaProps.button then
		local createElement5 = React.createElement
		local v21 = {
			LayoutOrder = 2,
			size = UDim2.new(1, 0, 0, 40),
			tag = {
				["row gap-small wrap auto-y size-full-0"] = true,
				["fill-x"] = true
			}
		}

		local v22 = {
			CTAButton = React.createElement(button, {
				text = props.ctaProps.button.text,
				variant = buttonVariant[props.ctaProps.button.variant],
				onActivated = not v9 and function() end or props.ctaProps.button.onActivated,
				fillBehavior = fillBehavior.Fill,
				size = buttonSize.Medium,
				isDisabled = not v9
			}),
			ShareButtonWrapper = 0
		}
		local v23

		if props.ctaProps.icon then
			v23 = React.createElement(
				"Frame",
				{ Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1 },
				{
					ShareButton = React.createElement(button, {
						variant = buttonVariant.Standard,
						onActivated = not v9 and function() end or props.ctaProps.icon.onActivated,
						fillBehavior = fillBehavior.Fill,
						size = buttonSize.Medium,
						isDisabled = not v9
					}),
					ShareIcon = React.createElement(imageSetLabel, {
						ZIndex = 2,
						Size = UDim2.fromOffset(32, 32),
						Image = images[props.ctaProps.icon.icon],
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(4, 4)
					})
				}
			)
		end

		v22.ShareButtonWrapper = v23
		v19 = createElement5(view, v21, v22)
	end

	v12.LowerContianer = v19
	return createElement("Frame", v11, v12)
end

return EventActionBar
