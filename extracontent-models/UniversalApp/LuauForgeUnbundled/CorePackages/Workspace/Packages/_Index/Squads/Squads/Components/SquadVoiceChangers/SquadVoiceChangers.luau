local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")

local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local crossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local cryo = dependencies.Cryo
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local useNavigation = dependencies.useNavigation
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/BuilderIcons")

local VoicePackButton = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadVoiceChangers/VoicePackButton")

local enums = Foundation.Enums
local iconSize = enums.IconSize
local inputSize = enums.InputSize

local v5 = {
	enableTestingTheme = false,
	closeCentralOverlayThunk = function()
		return { type = "CloseCentralOverlay" }
	end
}

local function SquadVoiceChangers(p2)
	local joined = cryo.Dictionary.join(v5, p2)
	local v6 = useNavigation()
	local v7 = tonumber(useLocalUserId()) or -1
	local v8 = useParticipant(v7)
	local selectedVoicePack = if v8 then v8.selectedVoicePack else nil
	local isVoiceChangerActive = if v8 then v8.isVoiceChangerActive else nil
	local isVoiceChangerHearMyselfActive = if v8 then v8.isVoiceChangerHearMyselfActive else nil

	local screenProps = v6.getScreenProps("wideMode", false)
	local v9, v10

	if joined.enableTestingTheme then
		v9 = "bg-system-warning"
		v10 = "bg-system-alert"
	else
		v9 = "bg-surface-0"
		v10 = "bg-surface-0"
	end

	local v11 = {
		{ name = "None" },
		{ name = "Basic" },
		{ name = "Chipmunk" },
		{ name = "Robot" },
		{ name = "HighPitchRobot" },
		{ name = "Monster" },
		{ name = "Dreamy" },
		{ name = "Powerful" },
		{ name = "Ghost" }
	}

	local function makeButton(i, i2)
		local v13 = v11[i] or {
			name = "Voicepack " .. i
		}
		local name = if joined.fillListWithExtraVoicePacks then v13.name or "Voicepack " .. i else v13.name

		local createElement = React.createElement
		local v15 = {
			LayoutOrder = i2,
			voicePackName = name,
			isVoiceChangerActive = isVoiceChangerActive,
			isSelected = 0,
			onActivated = 0
		}
		local v16 = if selectedVoicePack then name == selectedVoicePack else false
		v15.isSelected = v16
		function v15.onActivated()
			crossExperienceVoiceManager.default:setVoicePack(name)

			if name == "None" and isVoiceChangerActive then
				crossExperienceVoiceManager.default:disableVoiceChanger(v7)
			elseif name ~= "None" and not isVoiceChangerActive then
				crossExperienceVoiceManager.default:enableVoiceChanger(v7)
			end
		end

		return createElement(VoicePackButton, v15)
	end

	local v13 = {}

	for i = 1, #v11 + (joined.fillListWithExtraVoicePacks and 25 or 0) do
		v13["VoicePackButton_" .. i] = makeButton(i, i)
	end

	local v14

	if screenProps then
		v14 = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. v9,
				Text = "Choose voice pack",
				LayoutOrder = 1,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--title" or nil
			}),
			CloseButton = React.createElement(Foundation.View, {
				tag = "position-center-left anchor-center-left auto-xy radius-circle bg-action-subtle padding-xsmall",
				ZIndex = 2,
				onActivated = joined.closeSquadVoiceChangers,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--close-button" or nil
			}, {
				Icon = React.createElement(Foundation.Icon, {
					tag = "position-center-center anchor-center-center auto-xy",
					name = BuilderIcons.Icon.ArrowLargeLeft,
					size = iconSize.Large
				})
			}),
			DoneButton = React.createElement(Foundation.Text, {
				Text = "Done",
				tag = "position-center-right anchor-center-right text-align-x-center text-align-y-center size-2200-0 auto-y text-label-large radius-medium padding-small text-wrap bg-action-subtle",
				LayoutOrder = 2,
				onActivated = joined.closeSquadVoiceChangers,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--done-button" or nil
			})
		})
	else
		v14 = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "position-center-left anchor-center-left text-align-x-left text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. v9,
				Text = "Choose voice pack",
				LayoutOrder = 1,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--title" or nil
			}),
			CloseButton = React.createElement(Foundation.View, {
				tag = "position-center-right anchor-center-right auto-xy radius-circle bg-action-subtle padding-xsmall",
				LayoutOrder = 2,
				ZIndex = 2,
				onActivated = joined.closeSquadVoiceChangers,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--close-button" or nil
			}, {
				Icon = React.createElement(Foundation.Icon, {
					tag = "position-center-center anchor-center-center auto-xy",
					name = BuilderIcons.Icon.X,
					size = iconSize.Large
				})
			})
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v15 = {
		tag = "size-full-full col align-x-center align-y-top gap-large padding-large radius-medium stroke-emphasis " .. v10,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers" or nil
	}

	local v16 = {
		TopBar = v14,
		Divider = React.createElement(Foundation.Divider, {
			variant = enums.DividerVariant.Default,
			LayoutOrder = 2
		}),
		HearMyselfBar = React.createElement(Foundation.View, {
			tag = {
				["size-full-0 auto-y row align-x-left align-y-center padding-left-xxlarge padding-right-xxlarge"] = true,
				["bg-system-warning"] = joined.enableTestingTheme
			},
			LayoutOrder = 3
		}, {
			HearMyselfLabel = React.createElement(Foundation.Text, {
				Text = "Hear myself",
				tag = "text-align-x-left text-align-y-center size-0-0 auto-xy fill text-label-medium padding-left-large radius-medium text-wrap bg-action-subtle",
				LayoutOrder = 1,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--hear-myself-label" or nil
			}),
			HearMyselfToggleHolder = React.createElement(
				Foundation.View,
				{
					tag = "row align-x-center align-y-center size-0-0 auto-xy padding-right-large",
					LayoutOrder = 2
				},
				{
					HearMyselfToggle = React.createElement(Foundation.Toggle, {
						size = inputSize.Medium,
						label = "",
						onActivated = function(p3)
							if isVoiceChangerHearMyselfActive then
								crossExperienceVoiceManager.default:disableHearMyself(v7)
							else
								crossExperienceVoiceManager.default:enableHearMyself(v7)
							end
						end,
						isChecked = isVoiceChangerHearMyselfActive,
						testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--hear-myself-toggle" or nil
					})
				}
			)
		}),
		ButtonsView = React.createElement(Foundation.View, {
			tag = "fill padding-left-medium padding-right-medium padding-bottom-medium radius-medium size-full-full auto-y col align-x-center align-y-top " .. v9,
			LayoutOrder = 4
		}, {
			ButtonsScroller = React.createElement(Foundation.ScrollView, {
				tag = "size-full-0 fill bg-action-subtle",
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new()
				},
				BorderSizePixel = 0
			}, {
				Buttons = React.createElement(
					Foundation.View,
					{
						tag = "size-full-0 auto-y col align-x-center align-y-top padding-medium fill"
					},
					v13
				)
			})
		}),
		BottomDoneButton = 0
	}

	local v17 = if not screenProps then React.createElement(Foundation.Text, {
		Text = "Done",
		tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-y text-label-large radius-medium padding-small text-wrap bg-action-subtle",
		LayoutOrder = 5,
		onActivated = joined.closeSquadVoiceChangers,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--done-button" or nil
	}) else nil
	v16.BottomDoneButton = v17
	return createElement(view, v15, v16)
end

return SquadVoiceChangers
