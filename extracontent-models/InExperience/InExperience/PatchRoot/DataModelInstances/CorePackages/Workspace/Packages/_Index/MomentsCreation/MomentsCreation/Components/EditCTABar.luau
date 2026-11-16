local Players = game:GetService("Players")

local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local EventNames = MomentsCommon.Analytics.EventNames

local function fireVoiceCoachmarkFtuxEvent(p: string)
	fireAnalyticsEvent(p, {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "moments_tts_voice"
	})
end

local EducationalTooltip = Foundation.EducationalTooltip
local Icon = Foundation.Icon
local Loading = Foundation.Loading
local Text = Foundation.Text
local View = Foundation.View

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
local GetFIntMomentsCoachmarkMaxImpressions = MomentsCommon.Flags.GetFIntMomentsCoachmarkMaxImpressions
local GetFIntMomentsCoachmarkAutoDismissSeconds = MomentsCommon.Flags.GetFIntMomentsCoachmarkAutoDismissSeconds

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local CreationController = require(MomentsCreation.CreationController)
local useCreationController = CreationController.useCreationController

require(MomentsCreation.Types.CreationFlowTypes)

local function VoiceCoachmark(props)
	local v = useCreationController()
	local v2 = useLocalization({ title = props.titleKey, text = props.textKey })

	local state, setState = React.useState(function(): boolean
		return not v.getVoiceCoachmarkDismissed(false)
	end)

	local ref = React.useRef(false)
	React.useEffect(function()
		if state and not ref.current then
			ref.current = true
			fireVoiceCoachmarkFtuxEvent(EventNames.FTUXTooltipImpression)
		end
	end, { state })

	if state then
		return React.createElement(EducationalTooltip, {
			LayoutOrder = props.layoutOrder,
			isOpen = not props.hidden,
			onClose = function()
				fireVoiceCoachmarkFtuxEvent(EventNames.FTUXTooltipDismissed)
				v.dismissVoiceCoachmark()
				setState(false)
			end,
			side = Foundation.Enums.PopoverSide.Bottom,
			align = Foundation.Enums.PopoverAlign.End,
			title = v2.title,
			text = v2.text
		}, props.children)
	end

	return props.children
end

local function PersistentToolCoachmark(props)
	local v = useCreationController()
	local v2 = useLocalization({ title = props.titleKey, text = props.textKey })

	local PersistentCoachmark = require(parent.MomentsCommon.PersistentCoachmark)

	return React.createElement(PersistentCoachmark, {
		layoutOrder = props.layoutOrder,
		title = v2.title,
		text = v2.text,
		impressionCache = props.impressionCache,
		maxImpressions = props.maxImpressions,
		autoDismissSeconds = props.autoDismissSeconds,
		isSessionHandled = v.getVoiceCoachmarkDismissed(false),
		onSessionHandled = v.dismissVoiceCoachmark,
		onImpression = function()
			fireVoiceCoachmarkFtuxEvent(EventNames.FTUXTooltipImpression)
		end,
		onDismissed = function()
			fireVoiceCoachmarkFtuxEvent(EventNames.FTUXTooltipDismissed)
		end,
		side = Foundation.Enums.PopoverSide.Bottom,
		align = Foundation.Enums.PopoverAlign.End,
		hidden = props.hidden
	}, props.children)
end

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()

	local isLoadingMap = props.isLoadingMap
	local isDisabledMap = props.isDisabledMap

	local scale = v2.Size.Size_600 / v2.Size.Size_1200

	local localizationKeysByLocalizationKey = {}

	for _, tool in props.tools do
		localizationKeysByLocalizationKey[tool.cta.localizationKey] = tool.cta.localizationKey
	end

	local v3 = useLocalization(localizationKeysByLocalizationKey)

	local size, v4 = React.useBinding(UDim2.fromScale(1, 0))

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v4(UDim2.new(0, 1.5 * p.AbsoluteSize.X, 1, 0))
	end, {})

	local coachmark = props.coachmark
	local children = {}

	for k, tool in props.tools do
		local kind = tool.kind
		local v5

		if isLoadingMap == nil then
			v5 = false
		else
			v5 = isLoadingMap[kind] == true
		end

		local v6

		if isDisabledMap == nil then
			v6 = false
		else
			v6 = isDisabledMap[kind] == true
		end

		local createElement = React.createElement
		local v7 = {
			LayoutOrder = tool.cta.order or k,
			onActivated = 0,
			tag = "row align-x-right align-y-center gap-medium auto-xy padding-xsmall radius-medium"
		}
		local onActivated

		if not v5 then
			onActivated = not v6 and function()
				props.onToolSelected(kind)
			end or props.onDisabledToolActivated ~= nil and function()
				props.onDisabledToolActivated(kind)
			end or nil
		end

		v7.onActivated = onActivated
		local icon

		if v5 then
			if GetFFlagEnableMomentTextGeneration() then
				icon = React.createElement(View, { LayoutOrder = 2, tag = "auto-xy", scale = scale }, {
					Loading = React.createElement(Loading, {
						size = Foundation.Enums.IconSize.Large
					})
				})
			else
				icon = React.createElement(Loading, {
					LayoutOrder = 2,
					size = Foundation.Enums.IconSize.Small
				})
			end
		else
			icon = React.createElement(Icon, {
				name = tool.cta.icon,
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Large
			})
		end

		local text

		if props.showText then
			text = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v3[tool.cta.localizationKey]
			})
		end

		local element = createElement(View, v7, { Icon = icon, Text = text })

		if coachmark == nil or coachmark.kind ~= kind then
			children["Tool_" .. kind] = element
		elseif GetFFlagMomentsCoachmarkPersistence() and coachmark.impressionCache ~= nil then
			children["Tool_" .. kind] = React.createElement(PersistentToolCoachmark, {
				layoutOrder = tool.cta.order or k,
				titleKey = coachmark.titleKey,
				textKey = coachmark.textKey,
				impressionCache = coachmark.impressionCache,
				maxImpressions = coachmark.maxImpressions or GetFIntMomentsCoachmarkMaxImpressions(),
				autoDismissSeconds = coachmark.autoDismissSeconds or GetFIntMomentsCoachmarkAutoDismissSeconds(),
				hidden = props.hidden
			}, element)
		else
			children["Tool_" .. kind] = React.createElement(VoiceCoachmark, {
				layoutOrder = tool.cta.order or k,
				titleKey = coachmark.titleKey,
				textKey = coachmark.textKey,
				hidden = props.hidden
			}, element)
		end
	end

	return React.createElement(View, {
		tag = "position-center-right anchor-center-right size-0-full auto-x",
		Visible = not props.hidden,
		ZIndex = props.zIndex
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			color3 = v2.Color.Common.Scrim.Color3,
			rotation = 180,
			size = size
		}),
		EditCTABar = React.createElement(View, {
			tag = "col align-x-right align-y-center gap-small position-center-right anchor-center-right size-0-full auto-x",
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			padding = {
				left = UDim.new(0, v2.Padding.Large),
				right = UDim.new(0, v.right + v2.Padding.Large)
			}
		}, children)
	})
end
