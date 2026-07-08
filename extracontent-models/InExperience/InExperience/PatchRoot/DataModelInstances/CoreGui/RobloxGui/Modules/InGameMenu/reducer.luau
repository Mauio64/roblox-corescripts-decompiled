local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.InGameMenuDependencies).Cryo
local scriptParent = script.Parent
local SetMenuOpen = require(scriptParent.Actions.SetMenuOpen)
local SetMainPageMoreMenuOpen = require(scriptParent.Actions.SetMainPageMoreMenuOpen)
local SetCurrentPage = require(scriptParent.Actions.SetCurrentPage)
local SetScreenSize = require(scriptParent.Actions.SetScreenSize)
local StartLeavingGame = require(scriptParent.Actions.StartLeavingGame)
local CancelLeavingGame = require(scriptParent.Actions.CancelLeavingGame)
local SetControlLayout = require(scriptParent.Actions.SetControlLayout)
local SetRespawning = require(scriptParent.Actions.SetRespawning)
local SetCurrentZone = require(scriptParent.Actions.SetCurrentZone)
local SetControllerBarHeight = require(scriptParent.Actions.SetControllerBarHeight)
local DecrementControllerBar = require(scriptParent.Actions.DecrementControllerBar)
local IncrementControllerBar = require(scriptParent.Actions.IncrementControllerBar)
local navigationReducer = require(script.navigationReducer)
local respawn = require(script.respawn)
local invites = require(script.invites)
local gameInfo = require(script.gameInfo)
local report = require(script.report)
local friends = require(script.friends)
local displayOptions = require(script.displayOptions)
local nativeClosePrompt = require(script.nativeClosePrompt)
local voiceState = require(scriptParent.Parent.VoiceChat.Reducers.voiceState)
local Constants = require(scriptParent.Resources.Constants)
local Controls = require(scriptParent.Resources.Controls)
local t1 = {
	[SetMenuOpen.name] = function(p1, p2) -- line: 36
		-- upvalues: Cryo (copy)
		local v31 = nil

		if not p2.isMenuOpen then
			v31 = false
		end

		return Cryo.Dictionary.join(p1, {
			isMenuOpen = p2.isMenuOpen,
			isMainPageMoreMenuOpen = v31,
			currentZone = if p1.isMenuOpen == p2.isMenuOpen then nil else 1
		})
	end,
	[SetMainPageMoreMenuOpen.name] = function(p3, p4) -- line: 49
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			isMainPageMoreMenuOpen = p4.isMainPageMoreMenuOpen
		})
	end,
	[StartLeavingGame.name] = function(p5, _) -- line: 54
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			leavingGame = true
		})
	end,
	[CancelLeavingGame.name] = function(p7, _) -- line: 59
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			leavingGame = false
		})
	end,
	[SetCurrentPage.name] = function(p9, p10) -- line: 64
		-- upvalues: Cryo (copy), Constants (copy)
		return Cryo.Dictionary.join(p9, {
			isMainPageMoreMenuOpen = false,
			menuPage = p10.newPage,
			currentZone = p10.newPage ~= Constants.InitalPageKey and 1 or 0
		})
	end,
	[SetControlLayout.name] = function(p11, p12) -- line: 72
		-- upvalues: Cryo (copy)
		local controlLayout = p12.controlLayout

		return Cryo.Dictionary.join(p11, {
			controlLayout = controlLayout
		})
	end,
	[SetScreenSize.name] = function(p13, p14) -- line: 79
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p13, {
			screenSize = p14.newScreenSize
		})
	end,
	[SetRespawning.name] = function(p15, p16) -- line: 84
		-- upvalues: Cryo (copy)
		local v47 = not p16.respawning and p15.isMainPageMoreMenuOpen

		return Cryo.Dictionary.join(p15, {
			isMainPageMoreMenuOpen = v47
		})
	end,
	[SetCurrentZone.name] = function(p17, p18) -- line: 96
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p17, {
			currentZone = p18.zone
		})
	end,
	[SetControllerBarHeight.name] = function(p19, p20) -- line: 101
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p19, {
			controllerBarHeight = p20.controllerBarHeight
		})
	end,
	[IncrementControllerBar.name] = function(p21, _) -- line: 106
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p21, {
			controllerBarCount = p21.controllerBarCount + 1
		})
	end,
	[DecrementControllerBar.name] = function(p23, _) -- line: 111
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p23, {
			controllerBarCount = p23.controllerBarCount - 1
		})
	end
}

local function reducer(p25, p26) -- line: 118
	-- upvalues: Controls (copy), Constants (copy), invites (copy), respawn (copy), gameInfo (copy), friends (copy), displayOptions (copy), nativeClosePrompt (copy), t1 (copy), navigationReducer (copy), voiceState (copy), report (copy)
	if p25 == nil then
		p25 = {
			isMenuOpen = false,
			leavingGame = false,
			currentZone = nil,
			voiceState = nil,
			recording = false,
			isMainPageMoreMenuOpen = false,
			controllerBarHeight = 0,
			controllerBarCount = 0,
			controlLayout = Controls.ControlLayouts.KEYBOARD,
			menuPage = Constants.defaultPageKey,
			invites = invites(nil, p26),
			respawn = respawn(nil, p26),
			gameInfo = gameInfo(nil, p26),
			friends = friends(nil, p26),
			displayOptions = displayOptions(nil, p26),
			screenSize = Vector2.new(0, 0),
			nativeClosePrompt = nativeClosePrompt(nil, p26)
		}
	end

	local v58 = t1[p26.type]

	if v58 ~= nil then
		p25 = v58(p25, p26)
	end

	local v59 = navigationReducer(p25, p26)

	v59.respawn = respawn(v59.respawn, p26)
	v59.invites = invites(v59.invites, p26)
	v59.voiceState = voiceState(v59.voiceState, p26)
	v59.gameInfo = gameInfo(v59.gameInfo, p26)
	v59.report = report(v59.report, p26)
	v59.friends = friends(v59.friends, p26)
	v59.displayOptions = displayOptions(v59.displayOptions, p26)
	v59.nativeClosePrompt = nativeClosePrompt(v59.nativeClosePrompt, p26)

	return v59
end

return reducer
