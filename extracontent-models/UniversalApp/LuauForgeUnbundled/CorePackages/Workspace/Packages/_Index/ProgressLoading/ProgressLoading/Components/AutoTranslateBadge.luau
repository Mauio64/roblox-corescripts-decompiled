local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local badge = Foundation.Badge
local view = Foundation.View
local badgeVariant = Foundation.Enums.BadgeVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconPosition = Foundation.Enums.IconPosition

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").Hooks.useLocalization

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")
local getLoadingScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/getLoadingScreenStore")
local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")

local function AutoTranslateBadge(props)
	local universeId = props.universeId
	local v5 = useLocalization({
		autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate"
	})

	local v6 = React.useCallback(function(p2)
		local data = getLoadingScreenStore(p2).getAndFetchPlayerLocalizationChoice((tostring(universeId))).data(p2)

		if data then
			return data.IsPlayerChoiceEnabled
		end

		return nil
	end, { universeId, getLoadingScreenStore })
	local v7 = SignalsReact.useSignalState(v6)

	local ref = React.useRef(v7)
	ref.current = v7
	React.useEffect(function()
		return function()
			if ref.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	if v7 then
		return React.createElement(view, {
			tag = "auto-xy padding-y-xlarge",
			testId = "--auto-translate-badge",
			GroupTransparency = props.transparencyBinding,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = props.positionBinding:map(function(p2)
				return UDim2.new(0.5, 0, 0.5, p2.Y / 2)
			end),
			Size = UDim2.fromScale(0, 0)
		}, {
			Badge = React.createElement(badge, {
				text = v5.autoTranslate,
				variant = badgeVariant.OverMedia,
				icon = {
					name = iconName.LanguageCharacters,
					size = iconSize.XSmall,
					position = iconPosition.Left
				}
			})
		})
	end

	return nil
end

return AutoTranslateBadge
