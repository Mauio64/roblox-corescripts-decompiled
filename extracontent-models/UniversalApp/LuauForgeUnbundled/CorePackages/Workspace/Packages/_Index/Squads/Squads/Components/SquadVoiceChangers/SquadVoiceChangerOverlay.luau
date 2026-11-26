local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")

local useNavigation = dependencies.useNavigation

local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadVoiceChangers/SquadVoiceChangers")

local v5 = { fillListWithExtraVoicePacks = false, enableTestingTheme = false }

function LUAUFORGE_MODULE_GLOBALS_hpG_SquadVoiceChangerOverlay(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useNavigation()
	local v7 = React.useCallback(function()
		if v6 and v6.pop then
			v6.pop()
		end
	end, { v6 })

	local screenProps = v6.getScreenProps("wideMode", false)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v9 = {
		AbsorbInput = React.createElement(Foundation.View, {
			tag = {
				["size-full anchor-center-center position-center-center"] = true,
				["bg-action-subtle"] = not joined.enableTestingTheme,
				["bg-action-soft-emphasis"] = joined.enableTestingTheme
			},
			AutoButtonColor = false,
			BorderSizePixel = 0,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = v7,
			ZIndex = 1,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changer-overlay--backdrop" or nil
		}),
		OverlayContainer = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	local v11 = if screenProps then UDim2.new(0.75, 0, 0.9, 0) else UDim2.new(1, 0, 0.9, 0)
	v9.OverlayContainer = createElement2(view, {
		tag = {
			["bg-action-subtle no-clip"] = true,
			["anchor-center-center position-center-center"] = screenProps,
			["anchor-bottom-center position-bottom-center"] = not screenProps
		},
		Size = v11,
		BorderSizePixel = 0,
		Selectable = true,
		onActivated = function() end,
		ZIndex = 2,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changer-overlay" or nil
	}, {
		SquadVoiceChangers = React.createElement(module6, {
			closeSquadVoiceChangers = v7,
			fillListWithExtraVoicePacks = joined.fillListWithExtraVoicePacks,
			enableTestingTheme = joined.enableTestingTheme
		})
	})
	return createElement(fragment, nil, v9)
end

return LUAUFORGE_MODULE_GLOBALS_hpG_SquadVoiceChangerOverlay
