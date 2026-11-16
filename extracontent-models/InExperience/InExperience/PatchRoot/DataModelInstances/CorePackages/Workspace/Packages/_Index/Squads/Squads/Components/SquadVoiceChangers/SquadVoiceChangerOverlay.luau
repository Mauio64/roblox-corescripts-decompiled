local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local dependencies = require(Squads.dependencies)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Cryo = require(parent.Cryo)

local useNavigation = dependencies.useNavigation

local SquadVoiceChangers = require(script.Parent.SquadVoiceChangers)

local v = { fillListWithExtraVoicePacks = false, enableTestingTheme = false }

function SquadVoiceChangerOverlay(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useNavigation()
	local v3 = React.useCallback(function()
		if v2 and v2.pop then
			v2.pop()
		end
	end, { v2 })

	local screenProps = v2.getScreenProps("wideMode", false)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v4 = {
		AbsorbInput = React.createElement(Foundation.View, {
			tag = {
				["size-full anchor-center-center position-center-center"] = true,
				["bg-action-subtle"] = not joined.enableTestingTheme,
				["bg-action-soft-emphasis"] = joined.enableTestingTheme
			},
			AutoButtonColor = false,
			BorderSizePixel = 0,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = v3,
			ZIndex = 1,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changer-overlay--backdrop" or nil
		}),
		OverlayContainer = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = {
			["bg-action-subtle no-clip"] = true,
			["anchor-center-center position-center-center"] = screenProps,
			["anchor-bottom-center position-bottom-center"] = not screenProps
		},
		Size = 0,
		BorderSizePixel = 0,
		Selectable = true,
		onActivated = 0,
		ZIndex = 2,
		testId = 0
	}
	local size

	if screenProps then
		size = UDim2.new(0.75, 0, 0.9, 0)
	else
		size = UDim2.new(1, 0, 0.9, 0)
	end

	v5.Size = size

	function v5.onActivated() end

	v5.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changer-overlay" or nil
	v4.OverlayContainer = createElement2(view, v5, {
		SquadVoiceChangers = React.createElement(SquadVoiceChangers, {
			closeSquadVoiceChangers = v3,
			fillListWithExtraVoicePacks = joined.fillListWithExtraVoicePacks,
			enableTestingTheme = joined.enableTestingTheme
		})
	})
	return createElement(fragment, nil, v4)
end

return SquadVoiceChangerOverlay
