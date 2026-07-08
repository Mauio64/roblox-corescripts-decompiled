local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local React = require(SquadsParent.React)
local Foundation = require(SquadsParent.Foundation)
local Cryo = require(SquadsParent.Cryo)
local useNavigation = dependencies.useNavigation
local SquadVoiceChangers = require(script.Parent.SquadVoiceChangers)
local t1 = {
	fillListWithExtraVoicePacks = false,
	enableTestingTheme = false
}

function SquadVoiceChangerOverlay(t2: {[any]: any}) -- line: 25
	-- upvalues: Cryo (copy), t1 (copy), useNavigation (copy), React (copy), Foundation (copy), SquadVoiceChangers (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)
	local v12 = useNavigation()
	local v13 = React.useCallback(function() -- line: 29
		-- upvalues: v12 (copy)
		if v12 and v12.pop then
			v12.pop()
		end
	end, { v12 })
	local v14 = v12.getScreenProps("wideMode", false)

	return React.createElement(React.Fragment, nil, {
		AbsorbInput = React.createElement(Foundation.View, {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 1,
			tag = {
				["size-full anchor-center-center position-center-center"] = true,
				["bg-action-subtle"] = not v11.enableTestingTheme,
				["bg-action-soft-emphasis"] = v11.enableTestingTheme
			},
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = v13
		}),
		OverlayContainer = React.createElement(Foundation.View, {
			BorderSizePixel = 0,
			Selectable = true,
			ZIndex = 2,
			tag = {
				["bg-action-subtle no-clip"] = true,
				["anchor-center-center position-center-center"] = v14,
				["anchor-bottom-center position-bottom-center"] = not v14
			},
			Size = if not v14 then UDim2.new(1, 0, 0.9, 0) else UDim2.new(0.75, 0, 0.9, 0),
			onActivated = function() -- line: 62
			end
		}, {
			SquadVoiceChangers = React.createElement(SquadVoiceChangers, {
				closeSquadVoiceChangers = v13,
				fillListWithExtraVoicePacks = v11.fillListWithExtraVoicePacks,
				enableTestingTheme = v11.enableTestingTheme
			})
		})
	})
end

return SquadVoiceChangerOverlay
