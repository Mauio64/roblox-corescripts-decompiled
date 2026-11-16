local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local SharedFlags = require(parent.SharedFlags)

require(Squads.Enums.SquadButtonSourceEnum)
local SquadButtonClickIntentionEnum = require(Squads.Enums.SquadButtonClickIntentionEnum)

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local RoactUtils = require(parent.RoactUtils)
local useIsTvRemoteDevice = RoactUtils.Hooks.useIsTvRemoteDevice

local dependencies = require(Squads.dependencies)
local foundation = dependencies.Foundation
local react = dependencies.React
require(parent.SquadsCore.Enums)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadState = Enums.SquadState
local Thunks = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks.leaveSquad
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local EventNames = require(parent.SquadsCore.EventNames)
local Enums2 = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums2.SquadPromptType
local Hooks = require(parent.SquadsCore.Hooks)
local useSquadState = Hooks.useSquadState

local useTokens = foundation.Hooks.useTokens

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local FFlagDebugAppChatEnableDomLocators = SharedFlags.FFlagDebugAppChatEnableDomLocators
local defineFastFlag = game:DefineFastFlag("AppChatSquadButtonColorUpdate", false)
local defineFastFlag2 = game:DefineFastFlag("AppChatSquadButtonColorVariantB", false)

local defineFastFlag3 = game:DefineFastFlag("AppChatSquadButtonColorUpdateIxpEnabled", false)

local defineFastString = game:DefineFastString("AppChatSquadButtonColorUpdateIxpLayer", "Social.AppChat")

return function(props)
	local v = useLocalization({
		joinButtonText = "Feature.Squads.Action.Join",
		startButtonText = "Feature.Squads.Action.Start",
		viewButtonText = "Feature.Squads.Action.View"
	})

	local v2 = useDispatch()
	local v3 = usePreferredInput()
	local v4 = useIsTvRemoteDevice()
	local v5 = useTokens()
	local v6 = react.useContext(SquadExternalContractContext)
	local v7 = v6.useParentChannelHasGroupUp(props.conversationId)

	local v8 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v6.useIsChatEnabled()

	local v9 = useSquadState()

	local v10 = useSelector((react.useCallback(function(p)
		if p.Squad and p.Squad.Squad then
			return p.Squad.Squad.currentSquad
		end

		return nil
	end, {})))

	local v11 = react.useMemo(function()
		return v10 and v10.parentChannelId == props.conversationId
	end, { v10, props.conversationId })

	local userIntention = react.useMemo(function()
		if v11 then
			return SquadButtonClickIntentionEnum.View
		end

		if v7 then
			return SquadButtonClickIntentionEnum.Join
		end

		return SquadButtonClickIntentionEnum.Create
	end, { v11, v7 })

	local text2 = react.useMemo(function()
		if v11 then
			return v.viewButtonText
		end

		return if v7 then v.joinButtonText else v.startButtonText
	end, { v7, v11, v.joinButtonText, v.startButtonText, v.viewButtonText })

	local v12 = react.useCallback(function()
		v6.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = props.conversationId,
			squadButtonSource = props.squadButtonSource,
			squadId = v10 and v10.squadId,
			squadLocation = props.squadLocation,
			userIntention = userIntention
		})
	end, {
		userIntention,
		v10,
		props.conversationId,
		props.squadButtonSource,
		props.squadLocation,
		v6.fireSquadAnalytics
	})

	local useCallback = react.useCallback
	local function fn()
		v12()

		if v11 or not v10 then
			props.onActivated(props.conversationId)
		else
			v2(leaveSquad(SquadPromptType.JoinAnotherSquad, v6.setSquadPrompt, function()
				props.onActivated(props.conversationId)
			end, v6.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v8))
		end
	end

	local onActivated = props.onActivated

	local setSquadPrompt = v6.setSquadPrompt
	local squadLocation = v6.squadLocation
	local v13

	if FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
		v13 = v8
	end

	local onActivated2 = useCallback(fn, {
		v10,
		v11,
		onActivated,
		v12,
		setSquadPrompt,
		squadLocation,
		v13
	})

	local v14 = userIntention == SquadButtonClickIntentionEnum.View
	local v15 = defineFastFlag2
	local v16 = not v15

	react.useEffect(function()
		if defineFastFlag3 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, {})

	local createElement = react.createElement
	local view = foundation.View
	local v17 = {
		tag = defineFastFlag and {
			["row align-x-center align-y-center gap-xsmall radius-medium"] = true,
			["bg-action-standard stroke-action-standard"] = not v14,
			["bg-action-soft-emphasis stroke-action-soft-emphasis"] = v14 and v16,
			["bg-action-emphasis stroke-action-emphasis"] = v14 and v15
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
	local automaticSize

	if props.isFullWidth then
		automaticSize = Enum.AutomaticSize.None
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	v17.AutomaticSize = automaticSize
	v17.Size = UDim2.new(props.isFullWidth and 1 or 0, 0, 0, v5.Size.Size_800)
	v17.isDisabled = v9 == SquadState.Initializing
	v17.onActivated = onActivated2
	v17.LayoutOrder = props.layoutOrder
	v17.padding = { left = UDim.new(0, v5.Padding.Small), right = UDim.new(0, v5.Padding.Small) }

	v17.selection = { Selectable = props.Selectable }
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = `{props.testId}{userIntention}`
	end

	v17.testId = testId

	local createElement2 = react.createElement
	local text = foundation.Text
	local v18 = {
		tag = defineFastFlag and {
			["auto-xy text-label-small text-no-wrap text-truncate-end"] = true,
			["content-action-standard"] = not v14,
			["content-action-soft-emphasis"] = v14 and v16,
			["content-action-emphasis"] = v14 and v15
		} or "auto-xy text-label-small content-action-standard text-truncate-end text-no-wrap",
		LayoutOrder = 2,
		Text = text2,
		testId = 0,
		padding = 0,
		sizeConstraint = 0
	}
	local testId2

	if FFlagDebugAppChatEnableDomLocators then
		testId2 = `{props.testId}{userIntention}--text`
	end

	v18.testId = testId2
	v18.padding = {
		right = UDim.new(0, v5.Padding.XXSmall)
	}
	v18.sizeConstraint = not props.isFullWidth and {
		MaxSize = Vector2.new(v5.Size.Size_2800, v5.Size.Size_800)
	} or nil
	local v19 = { TextLabel = createElement2(text, v18), SignifierImage = 0 }
	local signifierImage

	if props.shouldShowSignifier and v3 == Responsive.Input.Directional and not v4 then
		local createElement3 = react.createElement
		local icon = foundation.Icon
		local v20 = {
			LayoutOrder = 3,
			name = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX),
			size = foundation.Enums.IconSize.Small,
			style = 0
		}
		local foreground

		if defineFastFlag and v14 then
			if v15 then
				foreground = v5.Color.ActionEmphasis.Foreground
			else
				foreground = v5.Color.ActionSoftEmphasis.Foreground
			end
		else
			foreground = v5.Color.ActionStandard.Foreground
		end

		v20.style = foreground
		signifierImage = createElement3(icon, v20)
	end

	v19.SignifierImage = signifierImage
	return createElement(view, v17, v19)
end
