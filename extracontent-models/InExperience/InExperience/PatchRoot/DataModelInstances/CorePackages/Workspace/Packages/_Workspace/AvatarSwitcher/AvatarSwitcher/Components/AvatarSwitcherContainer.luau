local GuiService = game:GetService("GuiService")
local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useUnifiedEventListenerInExperience = require(AvatarSwitcherParent.AvatarExperienceAnalytics).useUnifiedEventListener.useUnifiedEventListenerInExperience
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
local AvatarExperienceCommon = require(AvatarSwitcherParent.AvatarExperienceCommon)
local FFlagAvatarSwitcherUiFixes = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherUiFixes
local TimeoutBanner = AvatarExperienceCommon.Components.TimeoutBanner

local function AvatarSwitcherContainer(t1: {[any]: any}) -- line: 42
	-- upvalues: useTokens (copy), useSignalState (copy), getAvatarSwitcherStore (copy), SignalsReact (copy), ExperienceAvatarSupportType (copy), useUnifiedEventListenerInExperience (copy), React (copy), TopBar (copy), Foundation (copy), TimeoutBanner (copy), OutfitsGridWithMessage (copy), PreviewPanel (copy), FFlagAvatarSwitcherUiFixes (copy), GuiService (copy), EmptyState (copy), SingleItemLayout (copy), VerticalLayout (copy), HorizontalLayout (copy), RespawnDialogContainer (copy)
	local v25 = useTokens()
	local v26 = useSignalState(getAvatarSwitcherStore)
	local v27 = useSignalState(v26.getIsEmpty)
	local v28 = SignalsReact.useSignalState(v26.getExperienceAvatarSupportType) == ExperienceAvatarSupportType.NoSupport

	useUnifiedEventListenerInExperience()
	React.useEffect(function() -- line: 51
		-- upvalues: v26 (copy)
		task.spawn(function() -- line: 52
			-- upvalues: v26 (copy)
			v26.fetchExperienceAvatarSupportType()
		end)
	end, {})

	local v29 = React.createElement(TopBar, {
		onClose = t1.toggleWindow
	})
	local v30 = React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 col gap-0"
	}, {
		TopBar = v29,
		TimeoutBanner = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 bg-surface-200"
		}, {
			Banner = React.createElement(TimeoutBanner, {
				shouldFetch = true,
				shouldNavigateOnClick = false
			})
		})
	})
	local v31 = React.createElement(OutfitsGridWithMessage)
	local v32 = React.createElement(PreviewPanel, {
		compactLayout = t1.verticalLayout
	})

	return (React.createElement("Frame", {
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v25.Color.OverMedia.OverMedia_0.Color3,
		BackgroundTransparency = if not FFlagAvatarSwitcherUiFixes then v25.Color.OverMedia.OverMedia_0.Transparency else v25.Color.OverMedia.OverMedia_0.Transparency * GuiService.PreferredTransparency
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v25.Radius.Medium)
		}),
		Layout = if not v27 then if not v28 then if not t1.verticalLayout then React.createElement(HorizontalLayout, {
			headerSlot = v30,
			leftItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge"
			}, {
				OutfitsGrid = v31
			}),
			rightItemSlot = v32
		}) else React.createElement(VerticalLayout, {
			headerSlot = v30,
			topItemSlot = v32,
			bottomItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge padding-top-xlarge"
			}, {
				OutfitsGrid = v31
			})
		}) else React.createElement(SingleItemLayout, {
			headerSlot = v30,
			contentSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge col gap-medium"
			}, {
				OutfitsGrid = v31
			})
		}, {}) else React.createElement(EmptyState, {
			headerSlot = v30
		}),
		RespawnDialogContainer = React.createElement(RespawnDialogContainer, {
			toggleWindow = t1.toggleWindow,
			getRespawnBehaviour = t1.getRespawnBehaviour,
			respawnBehaviorChangedEvent = t1.respawnBehaviorChangedEvent
		})
	}))
end

return AvatarSwitcherContainer
