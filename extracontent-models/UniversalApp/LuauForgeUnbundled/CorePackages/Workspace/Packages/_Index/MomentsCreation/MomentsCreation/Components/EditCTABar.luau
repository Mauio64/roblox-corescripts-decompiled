local Players = game:GetService("Players")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local eventNames = MomentsCommon.Analytics.EventNames

local function fireVoiceCoachmarkFtuxEvent(p2)
	fireAnalyticsEvent(p2, {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "moments_tts_voice"
	})
end

local educationalTooltip = Foundation.EducationalTooltip
local icon = Foundation.Icon
local loading = Foundation.Loading
local text = Foundation.Text
local view = Foundation.View

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local getFFlagMomentsCoachmarkPersistence = MomentsCommon.Flags.GetFFlagMomentsCoachmarkPersistence
local getFIntMomentsCoachmarkMaxImpressions = MomentsCommon.Flags.GetFIntMomentsCoachmarkMaxImpressions
local getFIntMomentsCoachmarkAutoDismissSeconds = MomentsCommon.Flags.GetFIntMomentsCoachmarkAutoDismissSeconds

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local useCreationController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController").useCreationController

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function VoiceCoachmark(props)
	local v5 = useCreationController()
	local v6 = useLocalization({ title = props.titleKey, text = props.textKey })

	local state, setState = React.useState(function(): boolean
		return not v5.getVoiceCoachmarkDismissed(false)
	end)

	local ref = React.useRef(false)
	React.useEffect(function()
		if state and not ref.current then
			ref.current = true
			fireVoiceCoachmarkFtuxEvent(eventNames.FTUXTooltipImpression)
		end
	end, { state })

	if state then
		return React.createElement(educationalTooltip, {
			LayoutOrder = props.layoutOrder,
			isOpen = not props.hidden,
			onClose = function()
				fireVoiceCoachmarkFtuxEvent(eventNames.FTUXTooltipDismissed)
				v5.dismissVoiceCoachmark()
				setState(false)
			end,
			side = Foundation.Enums.PopoverSide.Bottom,
			align = Foundation.Enums.PopoverAlign.End,
			title = v6.title,
			text = v6.text
		}, props.children)
	end

	return props.children
end

local function PersistentToolCoachmark(props)
	local v5 = useCreationController()
	local v6 = useLocalization({ title = props.titleKey, text = props.textKey })

	local PersistentCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCommon/PersistentCoachmark")

	return React.createElement(PersistentCoachmark, {
		layoutOrder = props.layoutOrder,
		title = v6.title,
		text = v6.text,
		impressionCache = props.impressionCache,
		maxImpressions = props.maxImpressions,
		autoDismissSeconds = props.autoDismissSeconds,
		isSessionHandled = v5.getVoiceCoachmarkDismissed(false),
		onSessionHandled = v5.dismissVoiceCoachmark,
		onImpression = function()
			fireVoiceCoachmarkFtuxEvent(eventNames.FTUXTooltipImpression)
		end,
		onDismissed = function()
			fireVoiceCoachmarkFtuxEvent(eventNames.FTUXTooltipDismissed)
		end,
		side = Foundation.Enums.PopoverSide.Bottom,
		align = Foundation.Enums.PopoverAlign.End,
		hidden = props.hidden
	}, props.children)
end

return function(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()

	local isLoadingMap = props.isLoadingMap
	local isDisabledMap = props.isDisabledMap

	local v7 = v6.Size.Size_600 / v6.Size.Size_1200

	local localizationKeysByLocalizationKey = {}

	for k, tool in props.tools do
		localizationKeysByLocalizationKey[tool.cta.localizationKey] = tool.cta.localizationKey
	end

	local v8 = useLocalization(localizationKeysByLocalizationKey)

	local v9, v10 = React.useBinding(UDim2.fromScale(1, 0))

	local v11 = React.useCallback(function(p2)
		v10(UDim2.new(0, 1.5 * p2.AbsoluteSize.X, 1, 0))
	end, {})

	local coachmark = props.coachmark
	local children = {}

	for k, tool in props.tools do
		local kind = tool.kind
		local v12 = not (isLoadingMap == nil) and isLoadingMap[kind] == true
		local v13 = not (isDisabledMap == nil) and isDisabledMap[kind] == true

		local createElement = React.createElement
		local v15 = {
			LayoutOrder = tool.cta.order or k,
			onActivated = 0,
			tag = "row align-x-right align-y-center gap-medium auto-xy padding-xsmall radius-medium"
		}
		local v16

		if not v12 then
			v16 = not v13 and function()
				props.onToolSelected(kind)
			end or props.onDisabledToolActivated ~= nil and function()
				props.onDisabledToolActivated(kind)
			end or nil
		end

		v15.onActivated = v16
		local v18

		if v12 then
			if getFFlagEnableMomentTextGeneration() then
				v18 = React.createElement(view, {
					LayoutOrder = 2,
					tag = "auto-xy",
					scale = v7
				}, {
					Loading = React.createElement(loading, {
						size = Foundation.Enums.IconSize.Large
					})
				})
			else
				v18 = React.createElement(loading, {
					LayoutOrder = 2,
					size = Foundation.Enums.IconSize.Small
				})
			end
		else
			v18 = React.createElement(icon, {
				name = tool.cta.icon,
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Large
			})
		end

		local v19 = if props.showText then React.createElement(text, {
			LayoutOrder = 1,
			tag = "auto-xy text-label-medium content-emphasis",
			Text = v8[tool.cta.localizationKey]
		}) else nil
		local element = createElement(view, v15, { Icon = v18, Text = v19 })

		if coachmark == nil or coachmark.kind ~= kind then
			children["Tool_" .. kind] = element
		elseif getFFlagMomentsCoachmarkPersistence() and coachmark.impressionCache ~= nil then
			children["Tool_" .. kind] = React.createElement(PersistentToolCoachmark, {
				layoutOrder = tool.cta.order or k,
				titleKey = coachmark.titleKey,
				textKey = coachmark.textKey,
				impressionCache = coachmark.impressionCache,
				maxImpressions = coachmark.maxImpressions or getFIntMomentsCoachmarkMaxImpressions(),
				autoDismissSeconds = coachmark.autoDismissSeconds or getFIntMomentsCoachmarkAutoDismissSeconds(),
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

	return React.createElement(view, {
		tag = "position-center-right anchor-center-right size-0-full auto-x",
		Visible = not props.hidden,
		ZIndex = props.zIndex
	}, {
		GradientBackdrop = React.createElement(gradientBackdrop, {
			color3 = v6.Color.Common.Scrim.Color3,
			rotation = 180,
			size = v9
		}),
		EditCTABar = React.createElement(view, {
			tag = "col align-x-right align-y-center gap-small position-center-right anchor-center-right size-0-full auto-x",
			onAbsoluteSizeChanged = v11,
			padding = {
				left = UDim.new(0, v6.Padding.Large),
				right = UDim.new(0, v5.right + v6.Padding.Large)
			}
		}, children)
	})
end
