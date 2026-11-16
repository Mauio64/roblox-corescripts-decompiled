local ContentProvider = game:GetService("ContentProvider")

local module = require("@luauforge/bundled/fFR")
local module2 = require("@luauforge/bundled/fFm")
local module3 = require("@luauforge/bundled/fCE")
local module4 = require("@luauforge/bundled/fFu")

local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization

local textButton = require("@luauforge/bundled/fFl").App.Button.TextButton

local module5 = require("@luauforge/bundled/fFp")
local text = module5.Text
local view = module5.View
local stateLayerAffordance = module5.Enums.StateLayerAffordance
local module6 = require("@luauforge/bundled/fFs")

local getFFlagEnableLuafiedRecoveryFlow = module4.GetFFlagEnableLuafiedRecoveryFlow
local fFlagEnableLoginV2Modalization = module4.FFlagEnableLoginV2Modalization
local module7 = require("@luauforge/bundled/fFv")

local enrolledInLuafiedRecoveryExperiment = require("@luauforge/bundled/fCs").Experiments.enrolledInLuafiedRecoveryExperiment

local authButtonClick = module2.Events.authButtonClick
local eventStreamConstants = module2.EventStreamConstants

local module8 = require("@luauforge/bundled/fFq")

local v5 = { affordance = stateLayerAffordance.None }

local function NeedHelpButton(props)
	local v6 = module3.useContext(module8)
	local v7 = useDesignTokens()

	local function reportAuthButtonClick(p2, p3, p4, p5, p6, p7, p8)
		authButtonClick(p2, p3, p4, p5, p6, p7 or v6.eventOrigin, p8)
	end

	local v8 = if fFlagEnableLoginV2Modalization then module6() else false

	local v9 = v8 or props.useFoundation == true

	local v10 = module7
		and (v8 and "dialog" or props.useFoundation == true and "compactFoundation" or "fullscreen")
		or nil

	local v11 = useLocalization({ needHelpButtonText = props.textKey })

	local function onActivated()
		if props.onBeforeActivated then
			props.onBeforeActivated()
		end

		if props.originPage then
			authButtonClick(
				module.isNonEmptyString(props.originPage, "props.originPage"),
				eventStreamConstants.Button.NeedHelpLink,
				v10,
				nil,
				nil,
				v6.eventOrigin,
				nil
			)
		end

		if getFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
			v6.utils.openAccountRecovery(props.identifierAutofill or "")
			return
		end

		local v12 = ContentProvider.BaseUrl .. "login/forgot-password-or-username"
		v6.utils.openWebView(v12)
	end

	local createElement = module3.createElement
	local v13 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = module3.createElement
	local udim

	if v8 then
		udim = UDim.new(0, v7.Size.Size_100)
	elseif not v9 then
		udim = UDim.new(0, v7.Size.Size_300)
	end

	local v17 = if not v9 then UDim.new(0, v7.Size.Size_300) else nil
	local v14 = {
		UIPadding = createElement2("UIPadding", {
			PaddingTop = udim,
			PaddingBottom = v17
		}),
		UIListLayout = 0,
		Button = 0
	}

	local v18 = if v9 then module3.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left
	}) else nil
	v14.UIListLayout = v18
	local v19

	if v9 then
		v19 = module3.createElement(view, {
			Name = props.name,
			tag = "auto-xy padding-y-small",
			isDisabled = props.isDisabled,
			onActivated = onActivated,
			ref = props.contentStartRef,
			stateLayer = v5
		}, {
			Label = module3.createElement(text, {
				Text = `<u>{v11.needHelpButtonText}</u>`,
				RichText = true,
				tag = "auto-xy text-body-small content-emphasis"
			})
		})
	else
		v19 = module3.createElement(textButton, {
			text = v11.needHelpButtonText,
			isDisabled = props.isDisabled,
			onActivated = onActivated,
			verticalPadding = v7.Size.Size_400,
			fontStyle = "CaptionHeader",
			colorStyleDefault = "TextDefault",
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	v14.Button = v19
	return createElement("Frame", v13, v14)
end

return NeedHelpButton
