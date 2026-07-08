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
local AvatarExperienceFlags = require(AvatarSwitcherParent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUiFixes = AvatarExperienceFlags.FFlagAvatarSwitcherUiFixes
local FFlagAXAvatarTimeoutFlowIE = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlowIE
local TimeoutBanner = AvatarExperienceCommon.Components.TimeoutBanner

local function AvatarSwitcherContainer(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), useSignalState (copy), getAvatarSwitcherStore (copy), SignalsReact (copy), ExperienceAvatarSupportType (copy), useUnifiedEventListenerInExperience (copy), React (copy), TopBar (copy), FFlagAXAvatarTimeoutFlowIE (copy), Foundation (copy), TimeoutBanner (copy), OutfitsGridWithMessage (copy), PreviewPanel (copy), FFlagAvatarSwitcherUiFixes (copy), GuiService (copy), EmptyState (copy), SingleItemLayout (copy), VerticalLayout (copy), HorizontalLayout (copy), RespawnDialogContainer (copy)
	local v27 = useTokens()
	local v28 = useSignalState(getAvatarSwitcherStore)
	local v29 = useSignalState(v28.getIsEmpty)
	local v30 = SignalsReact.useSignalState(v28.getExperienceAvatarSupportType) == ExperienceAvatarSupportType.NoSupport

	useUnifiedEventListenerInExperience()
	React.useEffect(function() -- line: 52
		-- upvalues: v28 (copy)
		task.spawn(function() -- line: 53
			-- upvalues: v28 (copy)
			v28.fetchExperienceAvatarSupportType()
		end)
	end, {})

	local v31 = React.createElement(TopBar, {
		onClose = t1.toggleWindow
	})
	local v32 = if not FFlagAXAvatarTimeoutFlowIE then v31 else React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 col gap-0"
	}, {
		TopBar = v31,
		TimeoutBanner = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 bg-surface-200"
		}, {
			Banner = React.createElement(TimeoutBanner, {
				shouldFetch = true,
				shouldNavigateOnClick = false
			})
		})
	})
	local v33 = React.createElement(OutfitsGridWithMessage)
	local v34 = React.createElement(PreviewPanel, {
		compactLayout = t1.verticalLayout
	})

	return (React.createElement("Frame", {
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v27.Color.OverMedia.OverMedia_0.Color3,
		BackgroundTransparency = if not FFlagAvatarSwitcherUiFixes then v27.Color.OverMedia.OverMedia_0.Transparency else v27.Color.OverMedia.OverMedia_0.Transparency * GuiService.PreferredTransparency
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v27.Radius.Medium)
		}),
		Layout = if not v29 then if not v30 then if not t1.verticalLayout then React.createElement(HorizontalLayout, {
			headerHeight = if not FFlagAXAvatarTimeoutFlowIE then v27.Size.Size_1200 else nil,
			headerSlot = if not FFlagAXAvatarTimeoutFlowIE then v31 else v32,
			leftItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge"
			}, {
				OutfitsGrid = v33
			}),
			rightItemSlot = v34
		}) else React.createElement(VerticalLayout, {
			headerHeight = if not FFlagAXAvatarTimeoutFlowIE then v27.Size.Size_1200 else nil,
			headerSlot = if not FFlagAXAvatarTimeoutFlowIE then v31 else v32,
			topItemSlot = v34,
			bottomItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge padding-top-xlarge"
			}, {
				OutfitsGrid = v33
			})
		}) else React.createElement(SingleItemLayout, {
			headerHeight = if not FFlagAXAvatarTimeoutFlowIE then v27.Size.Size_1200 else nil,
			headerSlot = if not FFlagAXAvatarTimeoutFlowIE then v31 else v32,
			contentSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-x-xlarge col gap-medium"
			}, {
				OutfitsGrid = v33
			})
		}, {}) else React.createElement(EmptyState, {
			headerSlot = if not FFlagAXAvatarTimeoutFlowIE then v31 else v32
		}),
		RespawnDialogContainer = React.createElement(RespawnDialogContainer, {
			toggleWindow = t1.toggleWindow,
			getRespawnBehaviour = t1.getRespawnBehaviour,
			respawnBehaviorChangedEvent = t1.respawnBehaviorChangedEvent
		})
	}))
end

return AvatarSwitcherContainer
