local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local chrome = CoreGui:WaitForChild("RobloxGui").Modules.Chrome

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon.Stores
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarRefactor = InExperienceTopBar.Flags.FFlagTopBarRefactor
local RestyleTimer = require(CorePackages.Workspace.Packages.InExperienceCloudPlay.RestyleTimer)
local ChromeUtils = require(chrome.ChromeShared.Service.ChromeUtils)
local useObservableValue = require(chrome.ChromeShared.Hooks.useObservableValue)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local GamepadConnector

if SharedFlags.FFlagEnableConsoleExpControls and enabled then
	GamepadConnector = require(script.Parent.Parent.GamepadConnector)
end

local v

if SharedFlags.FFlagAddUILessMode and SharedFlags.FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
	v = Stores.GetUILessStore(false)
else
	v = nil
end

local computed = Signals.createComputed(function(p)
	return v ~= nil and v.getUILessModeEnabled(p) and not v.getUIVisible(p)
end)
local v2

if GamepadConnector == nil then
	v2 = ChromeUtils.ObservableValue.new(true)
else
	v2 = GamepadConnector:getShowTopBar()
end

local function TopBarRestyleTimer(props)
	local v3 = useObservableValue(props.showTopBar or v2)
	local isHidden = SignalsReact.useSignalState(computed)
	local createElement = React.createElement
	local v4 = {
		buttonSize = props.buttonSize,
		layoutOrder = props.layoutOrder,
		onAreaChanged = props.onAreaChanged,
		onAreaRemoved = props.onAreaRemoved,
		isHidden = 0
	}

	if FFlagTopBarRefactor then
		isHidden = nil
	elseif v3 == false then
		isHidden = true
	elseif props.followsUILessMode ~= true then
		isHidden = false
	end

	v4.isHidden = isHidden
	return createElement(RestyleTimer, v4)
end

return TopBarRestyleTimer
