local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local GamePlayButton = require(VirtualEvents.Parent.GamePlayButton)
local RoactNetworking = require(VirtualEvents.Parent.RoactServiceTags).RoactNetworking
local useRoactService = require(VirtualEvents.Parent.RobloxAppHooks).useRoactService

require(VirtualEvents.Parent.VirtualEventsState)

local useExperienceSubtitle = require(VirtualEvents.Hooks.useExperienceSubtitle)
local View = Foundation.View
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates

local function EventActionBar(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), useExperienceSubtitle (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), PlayButtonStates (copy), React (copy), FoundationText (copy), View (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), ButtonSize (copy), ImageSetLabel (copy), Images (copy)
	local v22 = useTokens()
	local v23 = if not t1.universeId then nil else useExperienceSubtitle(t1.universeId)
	local v24 = useRoactService(RoactNetworking)
	local v25 = usePlayButtonState(v24, t1.universeId or "")
	local v26 = v25.playButtonState == PlayButtonStates.Playable or v25.playButtonState == PlayButtonStates.PlayableWithParty

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		UpperContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 40)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			ExperienceThumbnail = React.createElement("ImageButton", {
				Active = true,
				Size = UDim2.fromOffset(40, 40),
				BorderSizePixel = 0,
				Image = ("rbxthumb://type=GameIcon&id=%s&w=150&h=150"):format(t1.universeId),
				[React.Event.Activated] = t1.onExperienceTileActivated
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				})
			}),
			EventInfo = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, -52, 1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				ExperienceName = React.createElement(FoundationText, {
					LayoutOrder = 1,
					TextWrapped = false,
					Size = UDim2.fromScale(1, not v23 and 1 or 0.5),
					Text = t1.experienceName,
					textStyle = v22.Color.Content.Emphasis,
					fontStyle = v22.Typography.TitleLarge,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.SplitWord
				}),
				ExperienceSubtitle = if not v23 then nil else React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = false,
					Size = UDim2.fromScale(1, 0.5),
					Text = v23,
					textStyle = v22.Color.Content.Default,
					fontStyle = v22.Typography.BodyLarge,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.None
				})
			})
		}),
		LowerContianer = if not t1.ctaProps.button then nil else React.createElement(View, {
			LayoutOrder = 2,
			size = UDim2.new(1, 0, 0, 40),
			tag = {
				["row gap-small wrap auto-y size-full-0"] = true,
				["fill-x"] = true
			}
		}, {
			CTAButton = React.createElement(Button, {
				text = t1.ctaProps.button.text,
				variant = ButtonVariant[t1.ctaProps.button.variant],
				onActivated = not v26 and function() -- line: 132
				end or t1.ctaProps.button.onActivated,
				fillBehavior = FillBehavior.Fill,
				size = ButtonSize.Medium,
				isDisabled = not v26
			}),
			ShareButtonWrapper = if not t1.ctaProps.icon then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(40, 40)
			}, {
				ShareButton = React.createElement(Button, {
					variant = ButtonVariant.Standard,
					onActivated = not v26 and function() -- line: 144
					end or t1.ctaProps.icon.onActivated,
					fillBehavior = FillBehavior.Fill,
					size = ButtonSize.Medium,
					isDisabled = not v26
				}),
				ShareIcon = React.createElement(ImageSetLabel, {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(32, 32),
					Image = Images[t1.ctaProps.icon.icon],
					Position = UDim2.fromOffset(4, 4)
				})
			})
		})
	})
end

return EventActionBar
