local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo

local parent = script.Parent

local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SetMainPageMoreMenuOpen = require(parent.Actions.SetMainPageMoreMenuOpen)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)
local SetScreenSize = require(parent.Actions.SetScreenSize)
local StartLeavingGame = require(parent.Actions.StartLeavingGame)
local CancelLeavingGame = require(parent.Actions.CancelLeavingGame)
local SetControlLayout = require(parent.Actions.SetControlLayout)
local SetRespawning = require(parent.Actions.SetRespawning)
local SetCurrentZone = require(parent.Actions.SetCurrentZone)
local SetControllerBarHeight = require(parent.Actions.SetControllerBarHeight)
local DecrementControllerBar = require(parent.Actions.DecrementControllerBar)
local IncrementControllerBar = require(parent.Actions.IncrementControllerBar)

local navigationReducer = require(script.navigationReducer)
local respawn = require(script.respawn)
local invites = require(script.invites)
local gameInfo = require(script.gameInfo)
local report = require(script.report)
local friends = require(script.friends)
local displayOptions = require(script.displayOptions)
local nativeClosePrompt = require(script.nativeClosePrompt)
local voiceState = require(parent.Parent.VoiceChat.Reducers.voiceState)

local Constants = require(parent.Resources.Constants)
local Controls = require(parent.Resources.Controls)

local v = {
	[SetMenuOpen.name] = function(p, p2)
		local isMainPageMoreMenuOpen

		if not p2.isMenuOpen then
			isMainPageMoreMenuOpen = false
		end

		return Cryo.Dictionary.join(p, {
			isMenuOpen = p2.isMenuOpen,
			isMainPageMoreMenuOpen = isMainPageMoreMenuOpen,
			currentZone = p.isMenuOpen ~= p2.isMenuOpen and 1 or nil
		})
	end,
	[SetMainPageMoreMenuOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { isMainPageMoreMenuOpen = p2.isMainPageMoreMenuOpen })
	end,
	[StartLeavingGame.name] = function(p, _)
		return Cryo.Dictionary.join(p, { leavingGame = true })
	end,
	[CancelLeavingGame.name] = function(p, _)
		return Cryo.Dictionary.join(p, { leavingGame = false })
	end,
	[SetCurrentPage.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			menuPage = p2.newPage,
			isMainPageMoreMenuOpen = false,
			currentZone = p2.newPage == Constants.InitalPageKey and 0 or 1
		})
	end,
	[SetControlLayout.name] = function(p, p2)
		local controlLayout = p2.controlLayout

		return Cryo.Dictionary.join(p, { controlLayout = controlLayout })
	end,
	[SetScreenSize.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { screenSize = p2.newScreenSize })
	end,
	[SetRespawning.name] = function(p, p2)
		local isMainPageMoreMenuOpen = not p2.respawning and p.isMainPageMoreMenuOpen

		return Cryo.Dictionary.join(p, { isMainPageMoreMenuOpen = isMainPageMoreMenuOpen })
	end,
	[SetCurrentZone.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { currentZone = p2.zone })
	end,
	[SetControllerBarHeight.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { controllerBarHeight = p2.controllerBarHeight })
	end,
	[IncrementControllerBar.name] = function(p, _)
		return Cryo.Dictionary.join(p, {
			controllerBarCount = p.controllerBarCount + 1
		})
	end,
	[DecrementControllerBar.name] = function(p, _)
		return Cryo.Dictionary.join(p, {
			controllerBarCount = p.controllerBarCount - 1
		})
	end
}

local function reducer(p, p2)
	local v2 = p == nil and {
		controlLayout = Controls.ControlLayouts.KEYBOARD,
		isMenuOpen = false,
		leavingGame = false,
		currentZone = nil,
		menuPage = Constants.defaultPageKey,
		voiceState = nil,
		invites = invites(nil, p2),
		respawn = respawn(nil, p2),
		gameInfo = gameInfo(nil, p2),
		friends = friends(nil, p2),
		displayOptions = displayOptions(nil, p2),
		screenSize = Vector2.new(0, 0),
		recording = false,
		isMainPageMoreMenuOpen = false,
		nativeClosePrompt = nativeClosePrompt(nil, p2),
		controllerBarHeight = 0,
		controllerBarCount = 0
	} or p

	local v3 = v[p2.type]

	if v3 ~= nil then
		v2 = v3(v2, p2)
	end

	local v4 = navigationReducer(v2, p2)

	v4.respawn = respawn(v4.respawn, p2)
	v4.invites = invites(v4.invites, p2)
	v4.voiceState = voiceState(v4.voiceState, p2)
	v4.gameInfo = gameInfo(v4.gameInfo, p2)
	v4.report = report(v4.report, p2)
	v4.friends = friends(v4.friends, p2)
	v4.displayOptions = displayOptions(v4.displayOptions, p2)
	v4.nativeClosePrompt = nativeClosePrompt(v4.nativeClosePrompt, p2)

	return v4
end

return reducer
