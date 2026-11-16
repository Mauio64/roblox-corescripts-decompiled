local GuiService = game:GetService("GuiService")

local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local useUnifiedEventListenerInExperience = AvatarExperienceAnalytics.useUnifiedEventListener.useUnifiedEventListenerInExperience

local EmptyState = require(AvatarSwitcher.Components.EmptyState)
local VerticalLayout = require(AvatarSwitcher.Components.VerticalLayout)
local HorizontalLayout = require(AvatarSwitcher.Components.HorizontalLayout)
local SingleItemLayout = require(AvatarSwitcher.Components.SingleItemLayout)
local TopBar = require(AvatarSwitcher.Components.TopBar)
local OutfitsGridWithMessage = require(AvatarSwitcher.Components.OutfitsGridWithMessage)
local PreviewPanel = require(AvatarSwitcher.Components.PreviewPanel)
local RespawnDialogContainer = require(AvatarSwitcher.Components.Modals.RespawnDialogContainer)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUiFixes = AvatarExperienceFlags.FFlagAvatarSwitcherUiFixes
local FFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating
local TimeoutBanner = AvatarExperienceCommon.Components.TimeoutBanner

local function AvatarSwitcherContainer(props)
	local v = useTokens()
	local v2 = useSignalState(getAvatarSwitcherStore)
	local v3 = useSignalState(v2.getIsEmpty)
	local v4 = SignalsReact.useSignalState(v2.getExperienceAvatarSupportType) == ExperienceAvatarSupportType.NoSupport

	useUnifiedEventListenerInExperience()

	if FFlagAXTimeoutAcknowledgementGating then
		AvatarExperienceCommon.Hooks.useAvatarChangeAcknowledgementPrompt(true)
	end

	React.useEffect(function()
		task.spawn(function()
			v2.fetchExperienceAvatarSupportType()
		end)
	end, {})

	local element = React.createElement(TopBar, { onClose = props.toggleWindow })

	local element2 = React.createElement(Foundation.View, { tag = "auto-y size-full-0 col gap-0" }, {
		TopBar = element,
		TimeoutBanner = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 bg-surface-200"
		}, {
			Banner = React.createElement(TimeoutBanner, {
				shouldFetch = true,
				shouldNavigateOnClick = false
			})
		})
	})

	local element3 = React.createElement(OutfitsGridWithMessage)
	local element4 = React.createElement(PreviewPanel, { compactLayout = props.verticalLayout })

	local createElement = React.createElement
	local v5 = {
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v.Color.OverMedia.OverMedia_0.Color3,
		BackgroundTransparency = 0
	}
	local backgroundTransparency

	if FFlagAvatarSwitcherUiFixes then
		backgroundTransparency = v.Color.OverMedia.OverMedia_0.Transparency * GuiService.PreferredTransparency
	else
		backgroundTransparency = v.Color.OverMedia.OverMedia_0.Transparency
	end

	v5.BackgroundTransparency = backgroundTransparency

	local v6 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) }),
		Layout = 0,
		RespawnDialogContainer = 0
	}
	local layout

	if v3 then
		layout = React.createElement(EmptyState, { headerSlot = element2 })
	elseif v4 then
		layout = React.createElement(SingleItemLayout, {
			headerSlot = element2,
			contentSlot = React.createElement(
				Foundation.View,
				{ tag = "size-full-full padding-x-xlarge col gap-medium" },
				{ OutfitsGrid = element3 }
			)
		}, {})
	elseif props.verticalLayout then
		layout = React.createElement(VerticalLayout, {
			headerSlot = element2,
			topItemSlot = element4,
			bottomItemSlot = React.createElement(
				Foundation.View,
				{ tag = "size-full-full padding-x-xlarge padding-top-xlarge" },
				{ OutfitsGrid = element3 }
			)
		})
	else
		layout = React.createElement(HorizontalLayout, {
			headerSlot = element2,
			leftItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge"
			}, {
				OutfitsGrid = element3
			}),
			rightItemSlot = element4
		})
	end

	v6.Layout = layout

	v6.RespawnDialogContainer = React.createElement(RespawnDialogContainer, {
		toggleWindow = props.toggleWindow,
		getRespawnBehaviour = props.getRespawnBehaviour,
		respawnBehaviorChangedEvent = props.respawnBehaviorChangedEvent
	})
	return (createElement("Frame", v5, v6))
end

return AvatarSwitcherContainer
