local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Foundation = require(SquadsParent.Foundation)
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local React = require(SquadsParent.React)
local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local useNavigation = dependencies.useNavigation
local BuilderIcons = require(SquadsParent.BuilderIcons)
local VoicePackButton = require(script.Parent.VoicePackButton)
local Enums = Foundation.Enums
local IconSize = Enums.IconSize
local InputSize = Enums.InputSize
local t1 = {
	enableTestingTheme = false,
	closeCentralOverlayThunk = function() -- line: 32
		return {
			type = "CloseCentralOverlay"
		}
	end
}

local function SquadVoiceChangers(p1) -- line: 39
	-- upvalues: Cryo (copy), t1 (copy), useNavigation (copy), useLocalUserId (copy), useParticipant (copy), React (copy), VoicePackButton (copy), CrossExperienceVoiceManager (copy), Foundation (copy), BuilderIcons (copy), IconSize (copy), Enums (copy), InputSize (copy)
	local v20 = Cryo.Dictionary.join(t1, p1)
	local v21 = useNavigation()
	local v22 = tonumber(useLocalUserId()) or -1
	local v23 = useParticipant(v22)
	local v24 = if not v23 then nil else v23.selectedVoicePack
	local v25 = if not v23 then nil else v23.isVoiceChangerActive
	local v26 = if not v23 then nil else v23.isVoiceChangerHearMyselfActive
	local v27 = v21.getScreenProps("wideMode", false)
	local s1 = "bg-surface-0"
	local s2 = "bg-surface-0"

	if v20.enableTestingTheme then
		s1 = "bg-system-alert"
		s2 = "bg-system-warning"
	end

	local t2 = {}
	local t3 = {
		{
			name = "None"
		},
		{
			name = "Basic"
		},
		{
			name = "Chipmunk"
		},
		{
			name = "Robot"
		},
		{
			name = "HighPitchRobot"
		},
		{
			name = "Monster"
		},
		{
			name = "Dreamy"
		},
		{
			name = "Powerful"
		},
		{
			name = "Ghost"
		}
	}

	local function makeButton(p2, p3) -- line: 75
		-- upvalues: t3 (copy), v20 (copy), React (copy), VoicePackButton (copy), v25 (copy), v24 (copy), CrossExperienceVoiceManager (copy), v22 (copy)
		local v37 = t3[p2] or {
			name = "Voicepack " .. p2
		}
		local v38 = if not v20.fillListWithExtraVoicePacks then v37.name else v37.name or "Voicepack " .. p2

		return React.createElement(VoicePackButton, {
			LayoutOrder = p3,
			voicePackName = v38,
			isVoiceChangerActive = v25,
			isSelected = not not v24 and v38 == v24,
			onActivated = function() -- line: 86
				-- upvalues: CrossExperienceVoiceManager (copy), v38 (copy), v25 (copy), v22 (copy)
				CrossExperienceVoiceManager.default:setVoicePack(v38)

				if v38 == "None" and v25 then
					CrossExperienceVoiceManager.default:disableVoiceChanger(v22)

					return
				end

				if v38 ~= "None" and not v25 then
					CrossExperienceVoiceManager.default:enableVoiceChanger(v22)
				end
			end
		})
	end

	for i = 1, #t3 + (not v20.fillListWithExtraVoicePacks and 0 or 25) do
		t2["VoicePackButton_" .. i] = makeButton(i, i)
	end

	local v34 = if not v27 then React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 1
	}, {
		Title = React.createElement(Foundation.Text, {
			Text = "Choose voice pack",
			LayoutOrder = 1,
			tag = "position-center-left anchor-center-left text-align-x-left text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. s2
		}),
		CloseButton = React.createElement(Foundation.View, {
			tag = "position-center-right anchor-center-right auto-xy radius-circle bg-action-subtle padding-xsmall",
			LayoutOrder = 2,
			ZIndex = 2,
			onActivated = v20.closeSquadVoiceChangers
		}, {
			Icon = React.createElement(Foundation.Icon, {
				tag = "position-center-center anchor-center-center auto-xy",
				name = BuilderIcons.Icon.X,
				size = IconSize.Large
			})
		})
	}) else React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 1
	}, {
		Title = React.createElement(Foundation.Text, {
			Text = "Choose voice pack",
			LayoutOrder = 1,
			tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. s2
		}),
		CloseButton = React.createElement(Foundation.View, {
			tag = "position-center-left anchor-center-left auto-xy radius-circle bg-action-subtle padding-xsmall",
			ZIndex = 2,
			onActivated = v20.closeSquadVoiceChangers
		}, {
			Icon = React.createElement(Foundation.Icon, {
				tag = "position-center-center anchor-center-center auto-xy",
				name = BuilderIcons.Icon.ArrowLargeLeft,
				size = IconSize.Large
			})
		}),
		DoneButton = React.createElement(Foundation.Text, {
			Text = "Done",
			tag = "position-center-right anchor-center-right text-align-x-center text-align-y-center size-2200-0 auto-y text-label-large radius-medium padding-small text-wrap bg-action-subtle",
			LayoutOrder = 2,
			onActivated = v20.closeSquadVoiceChangers
		})
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-full col align-x-center align-y-top gap-large padding-large radius-medium stroke-emphasis " .. s1
	}, {
		TopBar = v34,
		Divider = React.createElement(Foundation.Divider, {
			LayoutOrder = 2,
			variant = Enums.DividerVariant.Default
		}),
		HearMyselfBar = React.createElement(Foundation.View, {
			LayoutOrder = 3,
			tag = {
				["size-full-0 auto-y row align-x-left align-y-center padding-left-xxlarge padding-right-xxlarge"] = true,
				["bg-system-warning"] = v20.enableTestingTheme
			}
		}, {
			HearMyselfLabel = React.createElement(Foundation.Text, {
				Text = "Hear myself",
				tag = "text-align-x-left text-align-y-center size-0-0 auto-xy fill text-label-medium padding-left-large radius-medium text-wrap bg-action-subtle",
				LayoutOrder = 1
			}),
			HearMyselfToggleHolder = React.createElement(Foundation.View, {
				tag = "row align-x-center align-y-center size-0-0 auto-xy padding-right-large",
				LayoutOrder = 2
			}, {
				HearMyselfToggle = React.createElement(Foundation.Toggle, {
					label = "",
					size = InputSize.Medium,
					onActivated = function(_: boolean) -- line: 191
						-- upvalues: v26 (copy), CrossExperienceVoiceManager (copy), v22 (copy)
						if v26 then
							CrossExperienceVoiceManager.default:disableHearMyself(v22)

							return
						end

						CrossExperienceVoiceManager.default:enableHearMyself(v22)
					end,
					isChecked = v26
				})
			})
		}),
		ButtonsView = React.createElement(Foundation.View, {
			LayoutOrder = 4,
			tag = "fill padding-left-medium padding-right-medium padding-bottom-medium radius-medium size-full-full auto-y col align-x-center align-y-top " .. s2
		}, {
			ButtonsScroller = React.createElement(Foundation.ScrollView, {
				tag = "size-full-0 fill bg-action-subtle",
				BorderSizePixel = 0,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new()
				}
			}, {
				Buttons = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y col align-x-center align-y-top padding-medium fill"
				}, t2)
			})
		}),
		BottomDoneButton = if v27 then nil else React.createElement(Foundation.Text, {
			Text = "Done",
			tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-y text-label-large radius-medium padding-small text-wrap bg-action-subtle",
			LayoutOrder = 5,
			onActivated = v20.closeSquadVoiceChangers
		})
	})
end

return SquadVoiceChangers
