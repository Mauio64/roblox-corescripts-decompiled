local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local React = require(ExperienceLoadingScriptParent.React)
local Foundation = require(ExperienceLoadingScriptParent.Foundation)
local Badge = Foundation.Badge
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconPosition = Foundation.Enums.IconPosition
local useLocalization = require(ExperienceLoadingScriptParent.Localization).Hooks.useLocalization
local SignalsReact = require(ExperienceLoadingScriptParent.SignalsReact)
local getLoadingScreenStore = require(ExperienceLoadingScript.Store.getLoadingScreenStore)
local LoadingScreenTelemetry = require(ExperienceLoadingScript.LoadingScreenTelemetry)

local function AutoTranslateBadge(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), React (copy), getLoadingScreenStore (copy), SignalsReact (copy), LoadingScreenTelemetry (copy), View (copy), Badge (copy), BadgeVariant (copy), IconName (copy), IconSize (copy), IconPosition (copy)
	local universeId = t1.universeId
	local v18 = useLocalization({
		autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate"
	})
	local v19 = React.useCallback(function(p1) -- line: 33
		-- upvalues: getLoadingScreenStore (copy), universeId (copy)
		local v23 = getLoadingScreenStore(p1).getAndFetchPlayerLocalizationChoice((tostring(universeId))).data(p1)

		if v23 then
			return v23.IsPlayerChoiceEnabled
		end

		return nil
	end, {
		universeId,
		getLoadingScreenStore
	})
	local v20 = SignalsReact.useSignalState(v19)
	local v21 = React.useRef(v20)

	v21.current = v20
	React.useEffect(function() -- line: 43
		-- upvalues: v21 (copy), LoadingScreenTelemetry (copy)
		return function() -- line: 44
			-- upvalues: v21 (copy), LoadingScreenTelemetry (copy)
			if v21.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	if not v20 then
		return nil
	end

	return React.createElement(View, {
		tag = "auto-xy padding-y-xlarge",
		testId = "--auto-translate-badge",
		GroupTransparency = t1.transparencyBinding,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = t1.positionBinding:map(function(vector2: Vector2) -- line: 60
			return UDim2.new(0.5, 0, 0.5, vector2.Y / 2)
		end),
		Size = UDim2.fromScale(0, 0)
	}, {
		Badge = React.createElement(Badge, {
			text = v18.autoTranslate,
			variant = BadgeVariant.OverMedia,
			icon = {
				name = IconName.LanguageCharacters,
				size = IconSize.XSmall,
				position = IconPosition.Left
			}
		})
	})
end

return AutoTranslateBadge
