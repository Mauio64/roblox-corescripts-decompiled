local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)

require(ChatUIPrimitives.Types)
local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)
local formatInlineIcon = require(ChatUIPrimitives.Utils.formatInlineIcon)
local resolveDisplayText = require(ChatUIPrimitives.Translation.resolveDisplayText)
local useTranslateToggle = require(ChatUIPrimitives.Translation.useTranslateToggle)
local TextChannelWindowPerfTracker = require(ChatUIPrimitives.Telemetry.TextChannelWindowPerfTracker)
local RewriteToggle = require(script.Parent.RewriteToggle)
local TranslateHitOverlay = require(script.Parent.TranslateHitOverlay)
local FFlagTCWTranslationSupport = require(ChatUIPrimitives.Flags.FFlagTCWTranslationSupport)
local FFlagExpChatLazyMountRewriteToggle = require(ChatUIPrimitives.Flags.FFlagExpChatLazyMountRewriteToggle)
local FFlagExpChatLatestUsernameWithoutRender = require(ChatUIPrimitives.Flags.FFlagExpChatLatestUsernameWithoutRender)
local useLatestUsername = require(script.Parent.useLatestUsername)
local SelectableUsername = require(script.Parent.SelectableUsername)

local IconName = Foundation.Enums.IconName
local useSignalBinding = SignalsReact.useSignalBinding

local signal = Signals.createSignal(nil)

local function noop() end

local v = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function ceilToEven(p: number) -- 1 equivalent call inferred from this helper
	local v2 = math.ceil(p)

	if v2 % 2 == 1 then
		v2 += 1
	end

	return (math.max(0, v2))
end

local function builderIconSize(p: number) -- 2 equivalent calls inferred from this helper
	return (tostring(ceilToEven(p * 3 / 4))) -- inferred equivalent call
end

local function getPresetBoltIconAttributes(p: number) -- 1 equivalent call inferred from this helper
	return { weight = "700", size = builderIconSize(p) } -- inferred equivalent call
end

local function TextLineEntry(props)
	local v2 = Foundation.Hooks.useTokens()

	local v3 = React.useMemo(function()
		local color3 = v2.DarkMode.Content.Muted.Color3
		return string.format(
			"<font color=\"rgb(%d,%d,%d)\">",
			math.round(color3.R * 255),
			math.round(color3.G * 255),
			(math.round(color3.B * 255))
		)
	end, { v2 })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local messageId = props.getMessageId(p)

			if messageId then
				return props.getMessagesMap(p)[messageId]
			end

			return nil
		end)
	end, { props.getMessageId, props.getMessagesMap })

	local v5, v6 = useStableSignal(false)

	local v7 = SignalsReact.useSignalState(props.getMessageId)
	React.useEffect(function()
		v6(false)
	end, { v7, v6 })
	React.useEffect(function()
		if v7 then
			TextChannelWindowPerfTracker.finishMessageIntervals(v7)
		end
	end, { v7 })

	local messageBinding = useSignalBinding(v4)
	local layoutOrder = useSignalBinding(props.getLayoutOrder)
	local showOriginal = SignalsReact.useSignalState(v5)

	local v8 = SignalsReact.useSignalState(v4)

	local ref = React.useRef(nil)
	local buttonRef

	if FFlagExpChatLatestUsernameWithoutRender then
		buttonRef = useLatestUsername(props.getMessageId, props.getLatestMessageId, props.reportLatestUsername)
	else
		buttonRef = ref
	end

	local useSignalState = SignalsReact.useSignalState
	local v9

	if FFlagExpChatLatestUsernameWithoutRender then
		v9 = signal
	else
		v9 = props.getLatestMessageId or signal
	end

	local v10 = useSignalState(v9)
	local v11

	if v7 == nil then
		v11 = false
	else
		v11 = v7 == v10
	end

	local reportLatestUsername = props.reportLatestUsername
	React.useEffect(function()
		if FFlagExpChatLatestUsernameWithoutRender or (reportLatestUsername == nil or not v11) then
			return
		end

		reportLatestUsername(ref.current)
		return function()
			reportLatestUsername(nil)
		end
	end, { v11, reportLatestUsername })
	local v12

	if FFlagTCWTranslationSupport then
		v12 = useTranslateToggle(v8, v7, props.isTranslationSettingEnabled == true)
	end

	local v13

	if v12 == nil then
		v13 = false
	else
		v13 = v12.isOffered
	end

	local v14

	if v12 == nil then
		v14 = false
	else
		v14 = v12.shouldShowTranslation
	end

	local v15 = React.useMemo(function()
		if not v8 or not v8.presetId or v8.presetId == "" then
			return ""
		end

		return formatInlineIcon(IconName.LightningBolt, getPresetBoltIconAttributes(v2.Typography.BodyLarge.FontSize)) -- inferred equivalent call
	end, { v8, v2 })

	local v16 = React.useMemo(function()
		if not v8 or not v8.iconName or v8.iconName == "" then
			return ""
		end

		return formatInlineIcon(v8.iconName, {
			weight = "600",
			size = builderIconSize(v2.Typography.BodyLarge.FontSize) -- inferred equivalent call
		})
	end, { v8, v2 })

	local text = React.useMemo(function()
		if not v8 then
			return ""
		end

		local v17

		if FFlagTCWTranslationSupport then
			v17 = resolveDisplayText(v8, v13 and v14)
		else
			v17 = v8.content
		end

		local prefixText = v8.prefixText or ""

		if v8.messageType == "user" then
			local v18 = v13 and "     " or ""
			local v19 = v15

			if v19 == "" then
				return `{prefixText} {v18}{v17}`
			end

			return `{prefixText} {v18}{v17} {v19}`
		end

		if v8.messageType == "system-roblox" then
			return v17
		end

		if v16 == "" then
			return v3 .. v17 .. "</font>"
		end

		return v3 .. v16 .. " " .. v17 .. "</font>"
	end, { v8, v15, v16, v3, v14, v13 })
	local v17 = v8 ~= nil
	local onToggle = React.useCallback(function()
		v6(not v5())
	end, { v5, v6 })

	local fontStyle = React.useMemo(function()
		if props.fontFace then
			return { Font = props.fontFace }
		end

		return nil
	end, { props.fontFace or false })

	local prefixText = v8 and v8.prefixText or ""
	local v18

	if props.selectableRows == true and v8 ~= nil and v8.messageType == "user" then
		v18 = prefixText ~= ""
	else
		v18 = false
	end

	local v19

	if props.selectableRows == true then
		v19 = not v18
	else
		v19 = false
	end

	local fontFace = props.fontFace

	if fontFace == nil then
		local font = v2.Typography.BodyLarge.Font

		if typeof(font) == "Font" then
			fontFace = font
		elseif typeof(font) == "EnumItem" then
			fontFace = Font.fromEnum(font)
		end
	end

	local element = React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-emphasis",
		Text = text,
		RichText = true,
		fontStyle = fontStyle,
		LayoutOrder = 1
	})

	local children = {
		rewriteToggle = React.createElement(RewriteToggle, {
			messageBinding = messageBinding,
			showOriginal = showOriginal,
			onToggle = onToggle,
			LayoutOrder = 2
		})
	}

	if FFlagExpChatLazyMountRewriteToggle and (v8 == nil or v8.wasRewritten ~= true) then
		children.rewriteToggle = nil
		children.rewriteToggleSpacer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 0),
			LayoutOrder = 2
		})
	end

	local v20 = v13 and v12 ~= nil

	if v18 or v20 then
		local createElement = React.createElement
		local v21 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		}
		local usernameSelection

		if v18 then
			usernameSelection = React.createElement(SelectableUsername, {
				prefixText = prefixText,
				fontFace = fontFace,
				textSize = v2.Typography.BodyLarge.FontSize,
				selectionCursor = props.selectionCursor,
				buttonRef = buttonRef
			})
		end

		local translateHit

		if v20 then
			translateHit = React.createElement(TranslateHitOverlay, {
				prefixText = prefixText,
				fontFace = fontFace,
				textSize = v2.Typography.BodyLarge.FontSize,
				onActivated = v12.onToggle
			})
		end

		children.messageRow = createElement("Frame", v21, {
			label = element,
			usernameSelection = usernameSelection,
			translateHit = translateHit
		})
	else
		children.label = element
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v21 = {
		tag = "col gap-xsmall size-full-0 auto-y",
		backgroundStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 1 },
		LayoutOrder = layoutOrder,
		Visible = v17,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}
	local onActivated

	if v19 then
		onActivated = noop
	end

	v21.onActivated = onActivated
	local stateLayer

	if v19 then
		stateLayer = v
	end

	v21.stateLayer = stateLayer
	v21.selection = v19 and { Selectable = v17, SelectionImageObject = props.selectionCursor } or nil
	return createElement(view, v21, children)
end

return React.memo(TextLineEntry)
