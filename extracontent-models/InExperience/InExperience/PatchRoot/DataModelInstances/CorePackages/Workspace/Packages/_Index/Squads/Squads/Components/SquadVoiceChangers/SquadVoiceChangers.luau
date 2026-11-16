local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Foundation = require(parent.Foundation)

local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager

local dependencies = require(Squads.dependencies)

local cryo = dependencies.Cryo
local React = require(parent.React)
local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useNavigation = dependencies.useNavigation
local BuilderIcons = require(parent.BuilderIcons)

local VoicePackButton = require(script.Parent.VoicePackButton)

local Enums = Foundation.Enums
local IconSize = Enums.IconSize
local InputSize = Enums.InputSize

local v = {
	enableTestingTheme = false,
	closeCentralOverlayThunk = function()
		return { type = "CloseCentralOverlay" }
	end
}

local function SquadVoiceChangers(p)
	local joined = cryo.Dictionary.join(v, p)
	local v2 = useNavigation()
	local v3 = tonumber(useLocalUserId()) or -1
	local v4 = useParticipant(v3)
	local selectedVoicePack

	if v4 then
		selectedVoicePack = v4.selectedVoicePack
	else
		selectedVoicePack = nil
	end

	local isVoiceChangerActive

	if v4 then
		isVoiceChangerActive = v4.isVoiceChangerActive
	else
		isVoiceChangerActive = nil
	end

	local isVoiceChangerHearMyselfActive

	if v4 then
		isVoiceChangerHearMyselfActive = v4.isVoiceChangerHearMyselfActive
	else
		isVoiceChangerHearMyselfActive = nil
	end

	local screenProps = v2.getScreenProps("wideMode", false)
	local v5, v6

	if joined.enableTestingTheme then
		v5 = "bg-system-warning"
		v6 = "bg-system-alert"
	else
		v5 = "bg-surface-0"
		v6 = "bg-surface-0"
	end

	local v7 = {
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
		local v8 = v7[i] or {
			name = "Voicepack " .. i
		}
		local name

		if joined.fillListWithExtraVoicePacks then
			name = v8.name or "Voicepack " .. i
		else
			name = v8.name
		end

		local createElement = React.createElement
		local v9 = {
			LayoutOrder = i2,
			voicePackName = name,
			isVoiceChangerActive = isVoiceChangerActive,
			isSelected = 0,
			onActivated = 0
		}
		local isSelected

		if selectedVoicePack then
			isSelected = name == selectedVoicePack
		else
			isSelected = false
		end

		v9.isSelected = isSelected
		function v9.onActivated()
			CrossExperienceVoiceManager.default:setVoicePack(name)

			if name == "None" and isVoiceChangerActive then
				CrossExperienceVoiceManager.default:disableVoiceChanger(v3)
			elseif name ~= "None" and not isVoiceChangerActive then
				CrossExperienceVoiceManager.default:enableVoiceChanger(v3)
			end
		end

		return createElement(VoicePackButton, v9)
	end

	local v8 = {}

	for i = 1, #v7 + (joined.fillListWithExtraVoicePacks and 25 or 0) do
		v8["VoicePackButton_" .. i] = makeButton(i, i)
	end

	local topBar

	if screenProps then
		topBar = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. v5,
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
					size = IconSize.Large
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
		topBar = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "position-center-left anchor-center-left text-align-x-left text-align-y-center size-full-0 auto-xy text-heading-small radius-medium " .. v5,
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
					size = IconSize.Large
				})
			})
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = "size-full-full col align-x-center align-y-top gap-large padding-large radius-medium stroke-emphasis " .. v6,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers" or nil
	}

	local v10 = {
		TopBar = topBar,
		Divider = React.createElement(Foundation.Divider, {
			variant = Enums.DividerVariant.Default,
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
						size = InputSize.Medium,
						label = "",
						onActivated = function(_: boolean)
							if isVoiceChangerHearMyselfActive then
								CrossExperienceVoiceManager.default:disableHearMyself(v3)
							else
								CrossExperienceVoiceManager.default:enableHearMyself(v3)
							end
						end,
						isChecked = isVoiceChangerHearMyselfActive,
						testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--hear-myself-toggle" or nil
					})
				}
			)
		}),
		ButtonsView = React.createElement(Foundation.View, {
			tag = "fill padding-left-medium padding-right-medium padding-bottom-medium radius-medium size-full-full auto-y col align-x-center align-y-top " .. v5,
			LayoutOrder = 4
		}, {
			ButtonsScroller = React.createElement(Foundation.ScrollView, {
				tag = "size-full-0 fill bg-action-subtle",
				scroll = { AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new() },
				BorderSizePixel = 0
			}, {
				Buttons = React.createElement(
					Foundation.View,
					{
						tag = "size-full-0 auto-y col align-x-center align-y-top padding-medium fill"
					},
					v8
				)
			})
		}),
		BottomDoneButton = 0
	}
	local bottomDoneButton

	if not screenProps then
		bottomDoneButton = React.createElement(Foundation.Text, {
			Text = "Done",
			tag = "position-center-center anchor-center-center text-align-x-center text-align-y-center size-full-0 auto-y text-label-large radius-medium padding-small text-wrap bg-action-subtle",
			LayoutOrder = 5,
			onActivated = joined.closeSquadVoiceChangers,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-changers--done-button" or nil
		})
	end

	v10.BottomDoneButton = bottomDoneButton
	return createElement(view, v9, v10)
end

return SquadVoiceChangers
