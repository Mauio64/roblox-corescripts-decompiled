local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Badge = Foundation.Badge
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconPosition = Foundation.Enums.IconPosition

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SignalsReact = require(parent.SignalsReact)
local getLoadingScreenStore = require(ProgressLoading.Stores.getLoadingScreenStore)
local LoadingScreenTelemetry = require(ProgressLoading.LoadingScreenTelemetry)

local function AutoTranslateBadge(props)
	local universeId = props.universeId
	local v = useLocalization({ autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate" })

	local v2 = React.useCallback(function(p)
		local data = getLoadingScreenStore(p).getAndFetchPlayerLocalizationChoice((tostring(universeId))).data(p)
		return if data then data.IsPlayerChoiceEnabled else nil
	end, { universeId, getLoadingScreenStore })
	local current = SignalsReact.useSignalState(v2)

	local ref = React.useRef(current)
	ref.current = current
	React.useEffect(function()
		return function()
			if ref.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	if current then
		return React.createElement(View, {
			tag = "auto-xy padding-y-xlarge",
			testId = "--auto-translate-badge",
			GroupTransparency = props.transparencyBinding,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = props.positionBinding:map(function(vector2: Vector2)
				return UDim2.new(0.5, 0, 0.5, vector2.Y / 2)
			end),
			Size = UDim2.fromScale(0, 0)
		}, {
			Badge = React.createElement(Badge, {
				text = v.autoTranslate,
				variant = BadgeVariant.OverMedia,
				icon = {
					name = IconName.LanguageCharacters,
					size = IconSize.XSmall,
					position = IconPosition.Left
				}
			})
		})
	end

	return nil
end

return AutoTranslateBadge
