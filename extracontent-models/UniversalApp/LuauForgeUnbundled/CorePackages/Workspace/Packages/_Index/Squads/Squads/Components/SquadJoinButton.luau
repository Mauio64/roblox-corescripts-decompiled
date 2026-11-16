local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadButtonSourceEnum")
local SquadButtonClickIntentionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadButtonClickIntentionEnum")

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useIsTvRemoteDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.useIsTvRemoteDevice

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local foundation = dependencies.Foundation
local react = dependencies.React
require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadState
local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").leaveSquad
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local useSquadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useSquadState

local useTokens = foundation.Hooks.useTokens

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local fFlagDebugAppChatEnableDomLocators = SharedFlags.FFlagDebugAppChatEnableDomLocators
local defineFastFlag = game:DefineFastFlag("AppChatSquadButtonColorUpdate", false)
local defineFastFlag2 = game:DefineFastFlag("AppChatSquadButtonColorVariantB", false)

local defineFastFlag3 = game:DefineFastFlag("AppChatSquadButtonColorUpdateIxpEnabled", false)

local defineFastString = game:DefineFastString("AppChatSquadButtonColorUpdateIxpLayer", "Social.AppChat")

return function(props)
	local v5 = useLocalization({
		joinButtonText = "Feature.Squads.Action.Join",
		startButtonText = "Feature.Squads.Action.Start",
		viewButtonText = "Feature.Squads.Action.View"
	})

	local v6 = useDispatch()
	local v7 = usePreferredInput()
	local v8 = useIsTvRemoteDevice()
	local v9 = useTokens()
	local v10 = react.useContext(squadExternalContractContext)
	local v11 = v10.useParentChannelHasGroupUp(props.conversationId)

	local v12 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v10.useIsChatEnabled()

	local v13 = useSquadState()

	local v15 = useSelector((react.useCallback(function(p2)
		if p2.Squad and p2.Squad.Squad then
			return p2.Squad.Squad.currentSquad
		end

		return nil
	end, {})))

	local v16 = react.useMemo(function()
		return v15 and v15.parentChannelId == props.conversationId
	end, { v15, props.conversationId })

	local v17 = react.useMemo(function()
		if v16 then
			return SquadButtonClickIntentionEnum.View
		end

		if v11 then
			return SquadButtonClickIntentionEnum.Join
		end

		return SquadButtonClickIntentionEnum.Create
	end, { v16, v11 })

	local v18 = react.useMemo(function()
		if v16 then
			return v5.viewButtonText
		end

		if v11 then
			return v5.joinButtonText
		end

		return v5.startButtonText
	end, { v11, v16, v5.joinButtonText, v5.startButtonText, v5.viewButtonText })

	local v19 = react.useCallback(function()
		v10.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = props.conversationId,
			squadButtonSource = props.squadButtonSource,
			squadId = v15 and v15.squadId,
			squadLocation = props.squadLocation,
			userIntention = v17
		})
	end, {
		v17,
		v15,
		props.conversationId,
		props.squadButtonSource,
		props.squadLocation,
		v10.fireSquadAnalytics
	})

	local function fn()
		v19()

		if v16 or not v15 then
			props.onActivated(props.conversationId)
		else
			v6(leaveSquad(squadPromptType.JoinAnotherSquad, v10.setSquadPrompt, function()
				props.onActivated(props.conversationId)
			end, v10.squadLocation, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v12))
		end
	end

	local v22 = react.useCallback(fn, {
		v15,
		v16,
		props.onActivated,
		v19,
		v10.setSquadPrompt,
		v10.squadLocation,
		if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then v12 else nil
	})

	local v23 = v17 == SquadButtonClickIntentionEnum.View
	local v24 = defineFastFlag2
	local v25 = not v24

	react.useEffect(function()
		if defineFastFlag3 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, {})

	local createElement = react.createElement
	local view = foundation.View
	local v26 = {
		tag = defineFastFlag and {
			["row align-x-center align-y-center gap-xsmall radius-medium"] = true,
			["bg-action-standard stroke-action-standard"] = not v23,
			["bg-action-soft-emphasis stroke-action-soft-emphasis"] = v23 and v25,
			["bg-action-emphasis stroke-action-emphasis"] = v23 and v24
		} or "row align-x-center align-y-center gap-xsmall stroke-action-standard radius-medium bg-action-standard",
		AutomaticSize = 0,
		Size = 0,
		isDisabled = 0,
		onActivated = 0,
		LayoutOrder = 0,
		padding = 0,
		selection = 0,
		testId = 0
	}

	local v27 = if props.isFullWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.XY
	v26.AutomaticSize = v27
	v26.Size = UDim2.new(props.isFullWidth and 1 or 0, 0, 0, v9.Size.Size_800)
	v26.isDisabled = v13 == squadState.Initializing
	v26.onActivated = v22
	v26.LayoutOrder = props.layoutOrder
	v26.padding = {
		left = UDim.new(0, v9.Padding.Small),
		right = UDim.new(0, v9.Padding.Small)
	}

	v26.selection = { Selectable = props.Selectable }

	local v28 = if fFlagDebugAppChatEnableDomLocators then `{props.testId}{v17}` else nil
	v26.testId = v28

	local createElement2 = react.createElement
	local text = foundation.Text
	local v30 = {
		tag = defineFastFlag and {
			["auto-xy text-label-small text-no-wrap text-truncate-end"] = true,
			["content-action-standard"] = not v23,
			["content-action-soft-emphasis"] = v23 and v25,
			["content-action-emphasis"] = v23 and v24
		} or "auto-xy text-label-small content-action-standard text-truncate-end text-no-wrap",
		LayoutOrder = 2,
		Text = v18,
		testId = 0,
		padding = 0,
		sizeConstraint = 0
	}

	local v31 = if fFlagDebugAppChatEnableDomLocators then `{props.testId}{v17}--text` else nil
	v30.testId = v31
	v30.padding = {
		right = UDim.new(0, v9.Padding.XXSmall)
	}
	v30.sizeConstraint = not props.isFullWidth
		and {
			MaxSize = Vector2.new(v9.Size.Size_2800, v9.Size.Size_800)
		}
		or nil
	local v29 = { TextLabel = createElement2(text, v30), SignifierImage = 0 }
	local v32

	if props.shouldShowSignifier and v7 == Responsive.Input.Directional and not v8 then
		local createElement3 = react.createElement
		local icon = foundation.Icon
		local v33 = {
			LayoutOrder = 3,
			name = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX),
			size = foundation.Enums.IconSize.Small,
			style = 0
		}
		local foreground

		if defineFastFlag and v23 then
			foreground = if v24 then v9.Color.ActionEmphasis.Foreground else v9.Color.ActionSoftEmphasis.Foreground
		else
			foreground = v9.Color.ActionStandard.Foreground
		end

		v33.style = foreground
		v32 = createElement3(icon, v33)
	end

	v29.SignifierImage = v32
	return createElement(view, v26, v29)
end
