local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Foundation = require(CorePackages.Packages.Foundation)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local BuildModeLaunch = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.BuildModeLaunch)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local GetPlaytestModeStore = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon.GetPlaytestModeStore)

local ChromeUtils = require(RobloxGui.Modules.Chrome.ChromeShared.Service.ChromeUtils)
local ObservableValue = ChromeUtils.ObservableValue

local useIsPlaytestMode = require(RobloxGui.Modules.Chrome.ChromeShared.Hooks.useIsPlaytestMode)
local useObservableValue = require(RobloxGui.Modules.Chrome.ChromeShared.Hooks.useObservableValue)

local EducationalTooltip = Foundation.EducationalTooltip
local OverlayProvider = Foundation.OverlayProvider
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local ButtonVariant = Foundation.Enums.ButtonVariant

local defineFastFlag = game:DefineFastFlag("PlaytestModeDismissTooltip", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local v

if defineFastFlag then
	local Chrome = require(CorePackages.Workspace.Packages.Chrome)
	v = Chrome.Enabled()
end

local GamepadConnector

if defineFastFlag and FFlagEnableConsoleExpControls and v then
	GamepadConnector = require(script.Parent.Parent.GamepadConnector)
else
	GamepadConnector = nil
end

local defineFastFlag2 = game:DefineFastFlag("PlaytestModeTooltipExcludeBuildMode", false)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlaytestModeTooltipOncePerWeek = SharedFlags2.FFlagPlaytestModeTooltipOncePerWeek
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlaytestModeTooltipOnlyPrivateTesters = SharedFlags3.FFlagPlaytestModeTooltipOnlyPrivateTesters

local defineFastString = game:DefineFastString(
	"PlaytestModeTooltipLearnMoreUrl",
	"https://about.roblox.com/community-standards"
)
local defineFastInt = game:DefineFastInt("PlaytestModeTooltipDisplayOrder", -1)

local flag = false
local v2 = false
local v3

if defineFastFlag then
	v3 = ObservableValue.new(false)
else
	v3 = nil
end

local function getCanShow(anchorRef, flag2: boolean?, flag3: boolean, flag4: boolean?): boolean
	if
		FFlagPlaytestModeTooltipOncePerWeek and not flag3
		or FFlagPlaytestModeTooltipOnlyPrivateTesters and flag4 ~= true
		or defineFastFlag2 and BuildModeLaunch:hasBuildMode()
	then
		return false
	end

	if FFlagPlaytestModeTooltipOncePerWeek then
		if not (v2 or GetPlaytestModeStore(false).getHasTooltipCooldownExpired()) then
			return false
		end
	elseif flag then
		return false
	end

	return anchorRef ~= nil and anchorRef.current ~= nil and (not defineFastFlag or flag2 ~= false)
end

local function PlaytestModeTooltip(p)
	local v4 = useLocalization(FFlagPlaytestModeTooltipOnlyPrivateTesters and {
		title = "CoreScripts.FTUX.Heading.YouAreAnEarlyTester",
		text = "CoreScripts.FTUX.Description.WhiteMenuPreviewing",
		continueText = "CommonUI.Features.Action.OK",
		learnMoreText = "CommonUI.Features.Action.ViewDetails"
	} or {
		title = "CoreScripts.FTUX.Heading.ReadyToPlaytest",
		text = "CoreScripts.FTUX.Description.WhiteMenuPlaytestMode",
		continueText = "CommonUI.Features.Action.Continue",
		learnMoreText = "CommonUI.Features.Action.LearnMore"
	})

	local v5 = useIsPlaytestMode()
	local v6

	if FFlagPlaytestModeTooltipOnlyPrivateTesters then
		v6 = SignalsReact.useSignalState(GetPlaytestModeStore(false).getIsPrivatePlaytester)
	else
		v6 = nil
	end

	local v7

	if defineFastFlag then
		local v8

		if GamepadConnector == nil then
			v8 = v3
		else
			v8 = GamepadConnector:getShowTopBar()
		end

		v7 = useObservableValue(v8)
	else
		v7 = nil
	end

	local useState = React.useState
	local anchorRef = p.anchorRef
	local v8

	if defineFastFlag then
		v8 = v7
	end

	local state, setState = useState(getCanShow(anchorRef, v8, v5, v6))

	if FFlagPlaytestModeTooltipOncePerWeek then
		React.useEffect(function()
			if state and not v2 then
				v2 = true
				GetPlaytestModeStore(false).markTooltipSeen()
			end
		end, { state })
	end

	local v9 = React.useCallback(function()
		if FFlagPlaytestModeTooltipOncePerWeek then
			v2 = false
		else
			flag = true
		end

		setState(false)
	end, {})

	local useCallback = React.useCallback
	local function fn()
		linkingProtocol.default:openURL(defineFastString)

		if defineFastFlag then
			v9()
			return
		end

		flag = true
		setState(false)
	end

	local v10

	if defineFastFlag then
		v10 = v9
	end

	local onActivated = useCallback(fn, { v10 })

	local useEffect = React.useEffect
	local function fn2()
		local anchorRef2 = p.anchorRef
		local v11

		if defineFastFlag then
			v11 = v7
		end

		setState(getCanShow(anchorRef2, v11, v5, v6))
	end
	local anchorRef2 = p.anchorRef
	local v11

	if defineFastFlag then
		v11 = v7
	end

	local v12

	if FFlagPlaytestModeTooltipOncePerWeek then
		v12 = v5
	end

	local v13

	if FFlagPlaytestModeTooltipOnlyPrivateTesters then
		v13 = v6
	end

	useEffect(fn2, { anchorRef2, v11, v12, v13 })

	if defineFastFlag then
		React.useEffect(function()
			if state and not v7 then
				v9()
			end
		end, { state, v7 })

		React.useEffect(function()
			local connection = SettingsShowSignal:connect(function(p2)
				if p2 then
					v9()
				end
			end)

			return function()
				connection:Disconnect()
			end
		end, { v9 })
	end

	if (FFlagPlaytestModeTooltipOncePerWeek or not flag and v5) and state then
		return React.createElement(OverlayProvider, { DisplayOrder = defineFastInt }, {
			Tooltip = React.createElement(EducationalTooltip, {
				anchorRef = p.anchorRef,
				title = v4.title,
				text = v4.text,
				side = PopoverSide.Bottom,
				align = PopoverAlign.Start,
				isOpen = true,
				onClose = v9,
				actions = {
					{ text = v4.continueText, variant = ButtonVariant.Emphasis, onActivated = v9 },
					{
						text = v4.learnMoreText,
						variant = ButtonVariant.Standard,
						onActivated = onActivated
					}
				}
			})
		})
	end

	return nil
end

return React.memo(PlaytestModeTooltip)
